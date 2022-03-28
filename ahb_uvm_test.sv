class ahb_base_test extends uvm_test;
      //Register with factory
    `uvm_component_utils(ahb_base_test);

    virtual dut_if vif;
    ahb_env  env;
    
    function new(string name = "ahb_base_test", uvm_component parent = null);
      super.new(name, parent);
    endfunction
  
      //Build phase
    //Get the virtual interface handle from Test
    function void build_phase(uvm_phase phase);
      env = ahb_env::type_id::create("env", this);
      //
      if (!uvm_config_db#(virtual dut_if)::get(this, "", "vif", vif)) begin
        `uvm_fatal("build_phase", "No virtual interface specified for this test instance")
      end 
      uvm_config_db#(virtual dut_if)::set( this, "env", "vif", vif);
    endfunction
  
      //Run phase - Create an ahb_sequence and start it on the ahb_sequencer
    task run_phase( uvm_phase phase );
      ahb_sequence seq;
      seq = ahb_sequence::type_id::create("seq");
      phase.raise_objection( this, "Starting ahb_base_seq in main phase" );
      $display("%t Starting sequence ahb_seq run_phase",$time);
      seq.start(env.agent.sequencer);
      #1000ns;
      phase.drop_objection( this , "Finished ahb_seq in main phase" );
    endtask
  
endclass: ahb_base_test

