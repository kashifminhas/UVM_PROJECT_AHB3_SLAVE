//Hi Kashif Bhai TTP
`define MON_IF vif.MONITOR.monitor_cb
class ahb_monitor extends uvm_monitor;
      virtual dut_if vif;
    //Analysis port -parameterized to ahb_rw transaction
    ///Monitor writes transaction objects to this port once detected on interface
    uvm_analysis_port#(ahb_seq_item) ap;
    `uvm_component_utils(ahb_monitor)
     function new(string name, uvm_component parent);
       super.new(name, parent);
       ap = new("ap", this);
     endfunction
     //Build Phase - Get handle to virtual if from agent/config_db
     function void build_phase(uvm_phase phase);
       super.build_phase(phase);
       if (!uvm_config_db#(virtual dut_if)::get(this, "", "vif", vif)) begin
         `uvm_error("build_phase", "No virtual interface specified for this monitor instance")
         end
     endfunction
  
       virtual task run_phase(uvm_phase phase);
       super.run_phase(phase);
       @(`MON_IF);
        forever begin
            ahb_seq_item trans;
            trans = ahb_seq_item::type_id::create("trans", this);
//            @(`MON_IF);
    		trans.hburst = `MON_IF.hburst;
    		trans.hsize  = `MON_IF.hsize;
    		trans.hsel   = `MON_IF.hsel;
    		trans.hprot  = `MON_IF.hprot;  
    		trans.htrans = `MON_IF.htrans;
    		trans.error  = `MON_IF.error;   
    		trans.haddr  = `MON_IF.haddr;
    		trans.hwrite = `MON_IF.hwrite;
            $display("****MONITOR ADDRESS PHASE DONE****");
     		@(`MON_IF);
        	trans.hrdata = `MON_IF.hrdata;
        	trans.hwdata = `MON_IF.hwdata;
        	trans.hready = `MON_IF.hready;
        	trans.hresp  = `MON_IF.hresp;
        	ap.write(trans);
           $display("****MONITOR DATA PHASE DONE****");
        end
                       
    endtask
  
endclass: ahb_monitor
