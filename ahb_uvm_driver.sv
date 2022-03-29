//Hi, Everyone, this is client MAjeed
`define DRIV_IF vif.DRIVER.driver_cb
class ahb_driver extends uvm_driver#(ahb_seq_item);
   `uvm_component_utils(ahb_driver)

    function new(string name = "ahb_driver",uvm_component parent);
      super.new(name, parent);
    endfunction

    virtual dut_if vif;
  
//     //reset methods
//   task reset();
//     wait(!vif.resetn)        
//           `DRIV_IF.hsel   <= 0;
//           `DRIV_IF.haddr  <= 0;
//           `DRIV_IF.htrans <= 0;
//           `DRIV_IF.hsize  <= 0;
//           `DRIV_IF.hburst <= 0;
//           `DRIV_IF.hprot  <= 0;
//           `DRIV_IF.hwdata <= 0;
//           `DRIV_IF.hwrite <= 0;
          
//     wait(vif.resetn);
//         $display("Reset Finished");
//   endtask : reset
  
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual dut_if)::get(this, "", "vif", vif)) begin
            `uvm_fatal("build phase", "No virtual interface specified for this driver instance")
           end
    endfunction
  
    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
        forever begin
            seq_item_port.get_next_item(req);
            drive_pkt(req);
            //#40;
            seq_item_port.item_done();
        end
    endtask
  
      virtual task automatic drive_pkt (REQ NEXT_TRANS);
        	 uvm_report_info("AHB_DRIVER ", $psprintf("Got Transaction %s",NEXT_TRANS.convert2string()));
       
            `uvm_info(get_type_name(),NEXT_TRANS.sprint(),UVM_LOW)

            `uvm_info(get_type_name(), $sformatf("[drive]  addr_phase for pkt addr = 0x%0h",NEXT_TRANS.haddr),UVM_MEDIUM)

            `DRIV_IF.haddr  <= NEXT_TRANS.haddr;
            `DRIV_IF.hwrite <= NEXT_TRANS.hwrite;
            `DRIV_IF.htrans <= NEXT_TRANS.htrans;        
            `DRIV_IF.hsize  <= NEXT_TRANS.hsize;
            `DRIV_IF.hburst <= NEXT_TRANS.hburst;
            `DRIV_IF.error  <= 1'b0; 
            `DRIV_IF.hsel   <= 1'b1;
            `DRIV_IF.hprot  <= NEXT_TRANS.hprot;
             @(`DRIV_IF);
            `uvm_info(get_type_name(), $sformatf("[drive]  data_phase for pkt addr = 0x%0h",NEXT_TRANS.haddr),UVM_MEDIUM)
            $display("****DATA PHASE START****");
            `DRIV_IF.hwdata <= NEXT_TRANS.hwdata;
            $display("****DATA PHASE END****");
    endtask

endclass: ahb_driver
