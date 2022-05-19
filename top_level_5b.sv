// CSE 140L -- lab 5 

module top_level_5b(
	input			clk,
					init, 
	output logic   	done
				   );

// memory interface 
	logic          	wr_en;
	logic   [7:0] 	raddr, 
					waddr,
					data_in;
	logic	[7:0] 	data_out; 
  
// program counter             
	logic	[15:0] 	cycle_ct = 0;

// LFSR interface
	logic 	load_LFSR,
			LFSR_en;
	logic	[4:0] 	LFSR_ptrn[6];           // the 6 possible maximal length LFSR patterns
	assign 	LFSR_ptrn[0] = 5'h1E;
	assign 	LFSR_ptrn[1] = 5'h1D;
	assign 	LFSR_ptrn[2] = 5'h1B;
	assign 	LFSR_ptrn[3] = 5'h17;
	assign 	LFSR_ptrn[4] = 5'h14;
	assign 	LFSR_ptrn[5] = 5'h12;
	logic	[4:0] 	start;                  // LFSR starting state
	logic	[4:0] 	LFSR_state[6];          // current states of the 6 LFSRs
	logic	[2:0] 	foundit;                // got a match for one LFSR
	logic	[5:0] 	match;					// index of foundit
	int i;
  
// instantiate submodules
// data memory -- fill in the connections
	dat_mem dm1(
					.clk	 (),
					.write_en(),
					.raddr	 (),
					.waddr	 (),
					.data_in (),
					.data_out()
				);                   // instantiate data memory

// 6 parallel LFSRs -- fill in the missing connections													  
	lfsr5b l0(
				.clk	() , 
				.en   	()  ,     // 1: advance LFSR on rising clk
				.init 	(),	      // 1: initialize LFSR
				.taps 	(5'h1E),  // tap pattern for LFSR
				.start	() ,	  // starting state for LFSR
				.state	(LFSR_state[0])	// LFSR state = LFSR output 
			 );
/* fill in the guts: continue with other 5 lfsr6b
*/	 


// program counter and matching to correct LFSR
	always @(posedge clk) begin  :clock_loop										 
		if(init) begin
			cycle_ct <= 'b0;
			match    <= '6'h3F;
		end
		else begin
			cycle_ct <= cycle_ct + 1;
			if(cycle_ct>=?? && cycle_ct<= ?? ) begin			// decide cycle_ct range that requires checking								
				for(i=0; i<6; i++) begin
					match[i] <= ;			// which LFSR state conforms to our test bench LFSR 								
				end
			end
		end
	end  
  
// this block remaps a one-hot 6-bit code into a 3-bit binary count
// acts like a priority encoder from MSB to LSB 
	always_comb begin
		case(match)
			6'b10_0000: foundit = 'd5;	    // because bit [5] was set
			// fill in the guts
			default: foundit = 0;           // covers bit[0] match and no match cases
		endcase
	end


	always_comb begin 
		//defaults
		load_LFSR = 'b0; 
		LFSR_en   = 'b0;   
		wr_en     = 'b0;
		case(cycle_ct)
			0: begin 
				raddr     = ;   // starting address for encrypted data to be loaded into device
				waddr     = ;   // starting address for storing decrypted results into data mem
			end		       // no op
			1: begin 
				load_LFSR = ;	  // initialize the 6 LFSRs
				raddr     = ;
				waddr     = ;
			end		       // no op
			2  : begin				   
				LFSR_en   = ;	   // advance the 6 LFSRs     
				raddr     = ;
				waddr     = ;
			end
			3  : begin			       // training seq.	-- run LFSRs & advance raddr
				LFSR_en = ;
				raddr     ;			  // advance raddr
				waddr = ;
			end
			72  : begin
				done = ;		// send acknowledge back to test bench to halt simulation
				raddr =	;
				waddr = ; 
			end
			default: begin	         // covers cycle_ct 4-71
				LFSR_en = ;
				raddr ; 
				if(cycle_ct>) begin   // turn on write enable
					wr_en = ;
					if(cycle_ct>)		 // advance memory write address pointer
						waddr;
				end
				else begin
					waddr = ;
					wr_en = ;
				end
//		   data_in = data_out^LFSR_state[foundit];
			end
		endcase
	end

endmodule