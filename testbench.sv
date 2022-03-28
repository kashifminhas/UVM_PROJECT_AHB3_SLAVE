//  import uvm_pkg::*;
// `include "uvm_macros.svh"
`include "amba_ahb_defines.v"
 `include "ahb_uvm_intf.sv"
 `include "ahb_uvm_seqitem.sv"
 `include "ahb_uvm_seq.sv"
 `include "ahb_uvm_sequencer.sv"
 `include "ahb_uvm_driver.sv"
 `include "ahb_uvm_monitor.sv"
 `include "ahb_uvm_agent.sv"
 `include "ahb_uvm_scoreboard.sv"
//`include "new_scb.sv"
// `include "ahb_uvm_subscriber.sv"
 `include "ahb_uvm_env.sv"
 `include "ahb_uvm_test.sv"
module veri_top;
    //declare clock and reset signal
     import uvm_pkg::*;
    `include "uvm_macros.svh"
//      import ahb_uvm_pkg::*;
  
    bit clk;
    bit resetn;
  //clock generation
    `define PERIOD 20
    always
      #(`PERIOD/2)clk = ~clk;
  //reset generation
    initial begin
    resetn = 0;
    #20 resetn =1;
    end
  //interface instance, inorder to connect DUT and testcase
//  dut_if #(32,32,2) vif(hclk);
    dut_if vif(clk,resetn);
  //testcase instance, interface handle is passed to test as an argument
//  test t1(vif);
  //DUT instance, interface signals are connected to the DUT ports
    amba_ahb_slave DUT (
              .hclk(vif.clk),
              .hresetn(vif.resetn),
              .hsel(vif.hsel),
              .haddr(vif.haddr),
              .htrans(vif.htrans),
              .hwrite(vif.hwrite),
              .hsize(vif.hsize),
              .hburst(vif.hburst),
              .hprot(vif.hprot),
              .hwdata(vif.hwdata),
              .hrdata(vif.hrdata),
              .hready(vif.hready),
              .hresp(vif.hresp),
              .error('0)
                    );
  
      initial begin
      uvm_config_db#(virtual dut_if)::set( null, "uvm_test_top", "vif", vif);
      run_test("ahb_base_test");
  end 
  
  
  initial begin
  $dumpfile("dump.vcd"); 
  $dumpvars;
  end
endmodule: veri_top