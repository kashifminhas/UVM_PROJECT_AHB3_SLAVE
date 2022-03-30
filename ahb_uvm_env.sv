//Hi Everyone
class ahb_env extends uvm_env;
   `uvm_component_utils(ahb_env);
 
    //ENV has agent as its sub component
    ahb_agent      agent;
    ahb_scoreboard scoreboard;
//    int num_packets; 
//    ahb_subscriber subscriber;
   
    //virtual interface for AHB interface
    virtual dut_if  vif;
 
    function new(string name, uvm_component parent);
       super.new(name, parent);
    endfunction
  
      //Build phase
    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      agent = ahb_agent::type_id::create("agent", this);
      scoreboard = ahb_scoreboard::type_id::create("scoreboard", this);
//      subscriber=ahb_subscriber::type_id::create("subscriber",this);
      if (!uvm_config_db#(virtual dut_if)::get(this, "", "vif", vif)) begin
        `uvm_fatal("build phase", "No virtual interface specified for this env instance")
      end
      uvm_config_db#(virtual dut_if)::set( this, "agent", "vif", vif);
    endfunction
   
    function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      agent.monitor.ap.connect(scoreboard.mon_export);///ap = uvm_analysis_port
//      agent.monitor.ap.connect(subscriber.analysis_export);
    endfunction
endclass: ahb_env
