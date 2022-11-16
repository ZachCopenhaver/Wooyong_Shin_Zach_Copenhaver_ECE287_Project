module display(
	input resetn, 
	input clock,
	output [9:0]VGA_R, 
	output [9:0]VGA_G, 
	output [9:0]VGA_B, 
	output VGA_HS, 
	output VGA_VS, 
	output VGA_BLANK, 
	output VGA_SYNC, 
	output VGA_CLK
);

	reg [8:0]x;
	reg [7:0]y;
	reg [2:0]colour;
	/*
	000 = puke green
	001 = blue/purple
	010 = light green
	011 = light blue
	100 = orange
	101 = pink
	110 = yellow
	111 = white
	*/
	
	// resetn = rst
	// clock = clk
	vga_adapter my_vga(resetn, clock, colour, x, y, 1'b1, VGA_R, VGA_G, VGA_B, VGA_HS, VGA_VS, VGA_BLANK, VGA_SYNC, VGA_CLK);
	
	reg [2:0]XS;
	reg [2:0]NXS;
	
	parameter STARTX = 3'd0,
				 XS1 = 3'd1,
				 XS2 = 3'd2,
				 XS3 = 3'd3,
				 XS4 = 3'd4,
				 XS5 = 3'd5,
				 DONEX = 3'd6,
				 ERRORX = 3'd7;
	
	always @ (posedge clock or negedge resetn)
	begin
		if (resetn == 1'b0)
		begin
			XS <= STARTX;
		end
		else
		begin
			XS <= NXS;
		end
	end

	always @ (*)
	begin
		case (XS)
			STARTX: NXS = XS1;
			XS1: NXS = XS2;
			XS2: NXS = XS3;
			XS3: NXS = XS4;
			XS4: NXS = XS5;
			XS5: NXS = DONEX;
			DONEX: NXS = DONEX;
			default: NXS = ERRORX;
		endcase
	end
	
	always @ (posedge clock or negedge resetn)
	begin
		if (resetn == 1'b0)
		begin
			colour <= 3'b011;
			x <= 9'd000;
			y <= 7'd000;
		end
		else 
		begin
			case (XS)
				STARTX:
				begin
					colour <= 3'b111;
					x <= 9'd100;
					y <= 7'd100;
				end
				XS1:
				begin
					x <= x + 9'd1;
				end
				XS2:
				begin
					x <= x + 9'd1;
				end
				XS3:
				begin
					x <= x + 9'd1;
				end
				XS4:
				begin
					x <= x + 9'd1;
				end
				XS5:
				begin
					x <= x + 9'd1;
				end
			endcase
		end
	end

endmodule