interface dut_if #(parameter ADD_width  = `AW,
                  			 DATA_width = `DW,
                  			 RESP_width = `RW)
                  (input logic clk,resetn);

    // Add design signals here

  logic                  hsel;
  logic [ADD_width-1:0]  haddr;
  logic [1:0]            htrans;
  logic                  hwrite;
  logic [2:0]            hsize;
  logic [2:0]            hburst;
  logic [3:0]            hprot;
  logic [DATA_width-1:0] hwdata;
  logic [DATA_width-1:0] hrdata;
  logic                  hready;
  logic [RESP_width-1:0] hresp;
  logic                  error=1'b0;
  
  
    //Master Clocking block - used for Drivers
  default clocking driver_cb @ (posedge clk);
    	default input  #1
    		    output #2;
                   
  		output hsel;                      
  		output haddr;    
  		output htrans;   
  		output hwrite;   
  		output hsize;    
  		output hburst;   
  		output hprot;    
  		output hwdata;
        output error;
                     
  		input  hrdata;   
  		input  hready;   
  		input  hresp;                     
   endclocking : driver_cb 
    //Monitor Clocking block - For sampling by monitor components

  clocking monitor_cb @ (posedge clk);
    	default input  #1
    		    output #2;
                     
    	input hsel;                       
    	input haddr;    
    	input htrans;   
 		input hwrite;   
    	input hsize;    
    	input hburst;   
    	input hprot;    
    	input hwdata;   
                     
    	input hrdata;   
    	input hready;   
    	input hresp;                      
    	input error; 
   	  endclocking : monitor_cb
  
    //Add modports here
  
  modport DRIVER  (clocking driver_cb, input clk,resetn); 
  modport MONITOR (clocking monitor_cb,input clk,resetn); 
    
endinterface: dut_if
