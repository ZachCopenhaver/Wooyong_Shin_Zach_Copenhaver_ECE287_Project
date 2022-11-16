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
	
	reg [8:0]i;
	reg [7:0]j;
	
	reg [3:0]S;
	reg [3:0]NS;
	
	parameter START = 4'd0,
				 YCOND = 4'd1,
				 XCOND = 4'd2,
				 XDRAW = 4'd3,
				 IADD = 4'd4,
				 IWAIT = 4'd5,
				 YDRAW = 4'd6,
				 JADD = 4'd7,
				 JWAIT = 4'd8,
				 DONE = 4'd9,
				 ERROR = 4'd10;
	
	always @ (posedge clock or negedge resetn)
	begin
		if (resetn == 1'b0)
		begin
			S <= START;
		end
		else
		begin
			S <= NS;
		end
	end

	always @ (*)
	begin
		case (S)
			START: NS = YCOND;
			YCOND: NS = j < 9'd5 ? XCOND : DONE;
			XCOND: NS = i < 8'd5 ? XDRAW : YDRAW;
			XDRAW: NS = IADD;
			IADD: NS = IWAIT;
			IWAIT: NS = XCOND;
			YDRAW: NS = JADD;
			JADD: NS = JWAIT;
			JWAIT: NS = YCOND;
			DONE: NS = DONE;
			default: NS = ERROR;
		endcase
	end
	
	always @ (posedge clock or negedge resetn)
	begin
		if (resetn == 1'b0)
		begin
			colour <= 3'b011;
			x <= 9'd000;
			y <= 8'd000;
		end
		else 
		begin
			case (S)
				START:
				begin
					j <= 8'd0;
					y <= 8'd100;
					colour <= 3'b111;
				end
				YCOND:
				begin
					i <= 9'd0;
					x <= 9'd100;
				end
				XDRAW:
				begin
					x <= x + 9'd1;
				end
				IADD:
				begin
					i <= i + 9'd1;
				end
				YDRAW:
				begin
					y <= y + 8'd1;
				end
				JADD:
				begin
					j <= j + 8'd1;
				end
			endcase
		end
	end

endmodule