class ahb_seq_item extends uvm_sequence_item;
  
  rand  bit [`AW-1:0] haddr;
  rand  bit [`DW-1:0] hwdata;
  rand  bit [1:0]     htrans;
  rand  bit [2:0]     hsize;
  rand  bit           hwrite;
  rand  bit [2:0]     hburst;
  rand  bit [3:0]     hprot;
  logic     [`DW-1:0] hrdata;
  bit                 hready;
  bit       [`RW-1:0] hresp;
  bit                 hsel=1;
  bit                 error;
  bit                 resetn;
  
 `uvm_object_utils_begin(ahb_seq_item)
      `uvm_field_int (haddr,UVM_PRINT)
      `uvm_field_int (hwdata,UVM_PRINT)
      `uvm_field_int (htrans,UVM_PRINT)
      `uvm_field_int (hsize,UVM_PRINT)
      `uvm_field_int (hwrite,UVM_PRINT)
      `uvm_field_int (hburst,UVM_PRINT)
      `uvm_field_int (hprot,UVM_PRINT)
      `uvm_field_int (hrdata,UVM_PRINT)
      `uvm_field_int (hready, UVM_PRINT)
      `uvm_field_int (hresp, UVM_PRINT)
      `uvm_field_int (hsel, UVM_PRINT)
      `uvm_field_int (error, UVM_PRINT)
      `uvm_field_int (resetn, UVM_PRINT)
 `uvm_object_utils_end
  
  function new(string name="ahb_seq_item");
    super.new(name);
  endfunction
  
  constraint c1 {htrans dist   {2'b00:=1, 2'b01:=1, 2'b10:=8};}
//constraint c2 {hsize  inside {`H_SIZE_8,`H_SIZE_16,`H_SIZE_32};}
  constraint c2 {hsize  inside {`H_SIZE_32};}
  constraint c3 {hburst == 3'b000;}
  constraint c4 {hprot  == 4'b0001;}
  constraint c5 {(haddr inside {[0:64]});}
  constraint c6 {hsize == `H_SIZE_16 -> haddr[0] == '0;}
  constraint c7 {hsize == `H_SIZE_32 -> haddr[1:0] == '0;}
  constraint c8 {solve hsize before haddr;}
  
  function string convert2string();
  return $psprintf("HADDR = 0x%0h,HWRITE = %s, HWDATA = 0x%0h, HRDATA = 0x%0h ", haddr,hwrite,hwdata,hrdata);
  endfunction
  
endclass: ahb_seq_item