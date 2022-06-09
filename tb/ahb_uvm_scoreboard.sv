class ahb_scoreboard extends uvm_scoreboard;
   `uvm_component_utils(ahb_scoreboard)
    uvm_analysis_imp#(ahb_seq_item, ahb_scoreboard) mon_export;
    
    ahb_seq_item queue[$];
    
    bit [31:0] sc_ahb [1023:0];
  
    int             a_array[*];
    int rd=0,wr=0;
    
    function new(string name, uvm_component parent);
      super.new(name,parent);
      mon_export = new("mon_export", this);
    endfunction
    
    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      foreach(sc_ahb[i]) sc_ahb[i] = 8'hFF;
    endfunction
    
    // write task - recives the pkt from monitor and pushes into queue
    function void write(ahb_seq_item ahb_pkt);
      queue.push_back(ahb_pkt);
    endfunction 
   
   task run_phase(uvm_phase phase);
    ahb_seq_item ahb_pkt;
    
    forever begin
      wait(queue.size() > 0);
      ahb_pkt = queue.pop_front();
      
      if(ahb_pkt.hwrite==1 && ahb_pkt.htrans==2'b10) begin
        a_array[ahb_pkt.haddr]  = ahb_pkt.haddr;
        $display(a_array);
//         for(i=1;i<a_array.num();i++);begin
//           if(a_array[i] != ahb_pkt.haddr)begin
         sc_ahb[ahb_pkt.haddr] = ahb_pkt.hwdata;
        `uvm_info(get_type_name(),$sformatf("------ :: WRITE DATA       :: ------"),UVM_LOW)
        `uvm_info(get_type_name(),$sformatf("Addr: %0h",ahb_pkt.haddr),UVM_LOW)
        `uvm_info(get_type_name(),$sformatf("Data: %0h",ahb_pkt.hwdata),UVM_LOW)
        `uvm_info(get_type_name(),"------------------------------------",UVM_LOW)
        wr++;
        $display(wr);
      end
//         end
//       end
      else if(ahb_pkt.hwrite==0 && ahb_pkt.htrans==2'b10) begin
        if(a_array.exists(ahb_pkt.haddr)) begin
        if(sc_ahb[ahb_pkt.haddr] == ahb_pkt.hrdata) begin
          `uvm_info(get_type_name(),$sformatf("------ :: READ DATA  :: ------"),UVM_LOW)
          `uvm_info(get_type_name(),$sformatf("Addr: %0h",ahb_pkt.haddr),UVM_LOW)
          `uvm_info(get_type_name(),$sformatf("Expected Data: %0h Actual Data: %0h",sc_ahb[ahb_pkt.haddr],ahb_pkt.hrdata),UVM_LOW)
          `uvm_info(get_type_name(),"------------------------------------",UVM_LOW)
          rd++;
          $display(rd);
        end
        else begin
          `uvm_error(get_type_name(),"------ :: READ DATA MisMatch :: ------")
          `uvm_info(get_type_name(),$sformatf("Addr: %0h",ahb_pkt.haddr),UVM_LOW)
          `uvm_info(get_type_name(),$sformatf("Expected Data: %0h Actual Data: %0h",sc_ahb[ahb_pkt.haddr],ahb_pkt.hrdata),UVM_LOW)
          `uvm_info(get_type_name(),"------------------------------------",UVM_LOW)
        end
      end
    end
    end
  endtask : run_phase
  
endclass: ahb_scoreboard