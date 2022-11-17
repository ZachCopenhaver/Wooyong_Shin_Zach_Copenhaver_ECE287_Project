module rectangle(
	input clock,
	input resetn,
	input [8:0]width,
	input [7:0]height,
	input [8:0]xstart,
	input [7:0]ystart,
	input [2:0]colour, 
	output reg [8:0]x,
	output reg [7:0]y
);

	reg [8:0]i;
	reg [7:0]j;
	reg [8:0]xspot;
	reg [7:0]yspot;
	
	reg [3:0]S;
	reg [3:0]NS;
	
	parameter START = 4'd0,
				 YCOND = 4'd1,
				 XCOND = 4'd2,
				 XDRAW = 4'd3,
				 IADD = 4'd4,
				 YDRAW = 4'd5,
				 JADD = 4'd6,
				 DONE = 4'd7,
				 ERROR = 4'hF;
	
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
			YCOND: NS = j < height ? XCOND : DONE;
			XCOND: NS = i < width ? XDRAW : YDRAW;
			XDRAW: NS = IADD;
			IADD: NS = XCOND;
			YDRAW: NS = JADD;
			JADD: NS = YCOND;
			DONE: NS = DONE;
			default: NS = ERROR;
		endcase
	end
	
	// can possibly change the color of any specific pixel by checking i and j in the draw state
	always @ (posedge clock)
	begin
		case (S)
			START:
			begin
				j <= 8'd0;
				y <= ystart;
			end
			YCOND:
			begin
				i <= 9'd0;
				x <= xstart;
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
				y <= y + 9'd1;
			end
			JADD:
			begin
				j <= j + 8'd1;
			end
		endcase
	end


endmodule