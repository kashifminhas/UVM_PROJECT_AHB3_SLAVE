class ahb_sequence extends uvm_sequence#(ahb_seq_item);
  `uvm_object_utils(ahb_sequence)

   function new (string name = "ahb_sequence");
     super.new(name);
   endfunction
  
  ahb_seq_item item;
  int loop = 100;
  virtual task body();
    `uvm_info(get_type_name(),$sformatf("Start Sequence"), UVM_MEDIUM)
     repeat(loop) begin
       item = ahb_seq_item :: type_id ::create("item");
       start_item(item);
       if(!item.randomize())
         `uvm_fatal("NO_VIF",{"Randomziation Not Happen: ",get_full_name(),".ahbIF"})
          finish_item(item);
       end
      `uvm_info(get_type_name(),$sformatf("End Sequence"), UVM_MEDIUM)
       #40;
   endtask
endclass: ahb_sequence