//Hi
class ahb_agent extends uvm_agent;
  ahb_sequencer sequencer;
  ahb_driver    driver;
  ahb_monitor   monitor;
  
  virtual dut_if vif;
  
 `uvm_component_utils_begin(ahb_agent)
  `uvm_field_object(sequencer, UVM_ALL_ON)
  `uvm_field_object(driver, UVM_ALL_ON)
  `uvm_field_object(monitor, UVM_ALL_ON)
 `uvm_component_utils_end
    
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  
      //Build phase of agent
    //get handle to virtual interface from env (parent) config_db
    //and pass handle down to srq/driver/monitor
  virtual function void build_phase(uvm_phase phase);
       sequencer = ahb_sequencer::type_id::create("sequencer", this);
       driver = ahb_driver::type_id::create("driver", this);
       monitor = ahb_monitor::type_id::create("monitor", this);
       
      if (!uvm_config_db#(virtual dut_if)::get(this, "", "vif", vif)) begin
        `uvm_fatal("build phase", "No virtual interface specified for this agent instance")
       end
      uvm_config_db#(virtual dut_if)::set( this, "sequencer", "vif", vif);
      uvm_config_db#(virtual dut_if)::set( this, "driver", "vif", vif);
      uvm_config_db#(virtual dut_if)::set( this, "monitor", "vif", vif);
  endfunction
 
    //Connect - driver and sequencer port to export
  virtual function void connect_phase(uvm_phase phase);
       driver.seq_item_port.connect(sequencer.seq_item_export);
       uvm_report_info("AhB_AGENT", "connect_phase, Connected driver to sequencer");
  endfunction
  
endclass: ahb_agent
