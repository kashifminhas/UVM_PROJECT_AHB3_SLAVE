class ahb_subscriber extends uvm_subscriber#(ahb_seq_item);
  `uvm_object_utils(ahb_subscriber)

  bit [2:0]  _hburst;
  bit [2:0]  _hsize;
  bit [1:0]  _htrans;
  bit [31:0] _hwdata;
  bit [31:0] _haddr;
  
  function new (string name = "ahb_subscriber", uvm_component parent);
    super.new(name, parent);
    cover_burst=new;
    cover_size = new;
    cover_trans = new;
    cover_size = new;
    cover_address = new;
    cross_cover_HBURST_HSIZE = new;
   endfunction
  
  function void write(ahb_seq_item item);
    `uvm_info("AHB_SUBSCRIBER", $psprintf("Subscriber received tx %s", item.convert2string()), UVM_NONE);
   
    _hburst    = item.hburst;
    _hsize     = item.hsize;
    _htrans    = item.htrans;
    _hwdata    = item.hwdata;
    _haddr     = item.haddr;

    cover_burst.sample();
    cover_size.sample();
    cover_trans.sample();
    cover_address.sample();
    cross_cover_HBURST_HSIZE.sample();
  endfunction
  
  
    covergroup cover_burst @(posedge clk);
    option.per_instance =  1;
    option.goal         =  40;
    option.weight       =  20;
    option.at_least     =  1;
    coverpoint vif.hburst {
      bins SINGLE   = {3'b000};
      bins INCR     = {3'b001};
      bins WRAP4    = {3'b010};
      bins INCR4    = {3'b011};
      bins WRAP8    = {3'b100};
      bins INCR8    = {3'b101};
      bins WRAP16   = {3'b110};
      bins INCR16   = {3'b111};
    }
  endgroup
	
  covergroup cover_size @(posedge clk);
    coverpoint vif.hsize {
      bins Word              = {3'b010};
    }
  endgroup

  
  covergroup cover_trans @(posedge clk);
    option.per_instance = 1;
    option.goal         = 40;
    option.weight       = 20;
    option.at_least     =  1;
    coverpoint vif.htrans {
      bins trans_idle_idle   = (2'b00  => 2'b00);
      bins trans_idle_busy   = (2'b00  => 2'b01);
      bins trans_busy_nonseq = (2'b01  => 2'b10 );
      bins trans_nonseq_seq  = (2'b10  => 2'b11 );
      bins trans_nonseq_busy = (2'b10  => 2'b01);
      bins trans_nonseq_idle = (2'b10 => 2'b00);
      bins trans_nonseq_nonseq  = (2'b10 => 2'b10);		
      bins trans_seq_nonseq  = (2'b11 => 2'b10);			
    }
  endgroup

 
  covergroup cover_address @(posedge clk);
    option.per_instance = 1;
    coverpoint vif.haddr {
      bins zero = {[0:8]};
      bins low[4] = {[8:16]};
      bins med[4] = {[16:64]};
      bins high[4] = {[64:256]};
      bins misc = default;
    }
  endgroup

  
  covergroup cross_cover_HBURST_HSIZE @(posedge clk);
    option.per_instance = 1;
    coverpoint vif.hburst {
      bins SINGLE   = {3'b000};
      bins INCR     = {3'b001};
      bins WRAP4    = {3'b010};
      bins INCR4    = {3'b011};
      bins WRAP8    = {3'b100};
      bins INCR8    = {3'b101};
      bins WRAP16   = {3'b110};
      bins INCR16   = {3'b111};
    }
    coverpoint vif.hsize {
      bins Word              = {3'b010};
    }
    cross vif.hburst, vif.hsize;
  endgroup

endclass: ahb_subscriber