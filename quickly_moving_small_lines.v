module vga_template(clk, rst, vga_output_data);
	
	input clk, rst;
	output [28:0] vga_output_data;
	
	reg [7:0] r, g, b;
	wire [9:0] x, y;
	
	reg [8:0] shift;
	
	wire [23:0]background;
	assign background = {8'hF, 8'hF, 8'hF};
	
	reg [9:0]xl, yt;
	//wire [9:0]xr, xdiff, yb, ydiff;
	//reg [9:0]xdiff, ydiff;
	//wire [9:0]xr, yb;
	//wire rectx, recty;
	reg [9:0]xr, xdiff, yb, ydiff;
	reg rectx, recty;
	
	//assign xr = xl + xdiff;
	//assign yb = yt + ydiff;
	//assign xdiff = 10'd100;
	//assign ydiff = 10'd100;
	//assign rectx = (xl <= x & x < xr);
	//assign recty = (yt <= y & y < yb);
	
	vga disp(clk, rst, r, g, b, x, y, vga_output_data);
	
	/*
	always @ (posedge clk or negedge rst)
	begin
		if (rst == 1'b0)
		begin
			r <= 0;
			g <= 0;
			b <= 8'hFF;
			shift <= 8'b00000001;
		end
		else
		begin
			shift <= 8'd100;
			if (rectx & recty)
			begin
				r <= 8'hFF;
				g <= 8'h0;
				b <= 8'h0;
			end
			else
			begin
				r <= 8'hFF;
				g <= 8'hFF;
				b <= 8'hFF;
			end
		end
	end
	
	always @ (posedge clk)
	begin
		xl <= xl + shift;
		yt <= yt;
	end
	*/
	
	reg [7:0]count;
	
	reg [2:0]S;
	reg [2:0]NS;
	
	parameter START = 3'd0,
				 INIT = 3'd1,
				 ERASE = 3'd2,
				 UPDATE = 3'd3,
				 DRAW = 3'd4,
				 IDLE = 3'd5,
				 ERROR = 3'hF;
	
	always @ (posedge clk or negedge rst)
	begin
		if (rst == 1'b0)
			S <= START;
		else
			S <= NS;
	end
	
	always @ (*)
	begin
		case (S)
			START: NS = INIT;
			INIT: //NS = ERASE;
			begin
				if (count >= 8'd10)
					NS = ERASE;
				else
					NS = INIT;
			end
			ERASE: NS = UPDATE;
			UPDATE: NS = DRAW;
			DRAW: NS = IDLE;
			IDLE: //NS = ERASE;
			begin
				if (count >= 8'd10)
					NS = ERASE;
				else 
					NS = IDLE;
			end
		endcase
	end
	
	always @ (posedge clk or negedge rst)
	begin
		if (rst == 1'b0)
		begin
			count <= 0;
			xl <= 0;
			yt <= 0;
			shift <= 0;
			r <= 0;
			g <= 0;
			b <= 0;
		end
		else 
			case (S)
				START:
				begin
					xl <= 10'd100;
					yt <= 10'd100;
					xdiff <= 10'd100;
					ydiff <= 10'd100;
					shift <= 8'd10;
					count <= 8'd0;
					r <= 8'hFF;
					g <= 8'hFF;
					b <= 8'hFF;
				end
				INIT:
				begin
					count <= count + 8'd1;
					if (rectx & recty)
					begin
						r <= 8'hFF;
						g <= 8'h0;
						b <= 8'h0;
					end
					else 
					begin
						r <= 8'hFF;
						g <= 8'hFF;
						b <= 8'hFF;
					end
				end
				ERASE:
				begin
					r <= 8'hFF;
					g <= 8'hFF;
					b <= 8'hFF;
					count <= 8'd0;
				end
				UPDATE:
				begin
					xl <= xl + 10'd10;
					yt <= yt;
				end
				DRAW: 
				begin
					if (rectx & recty)
					begin
						r <= 8'hFF;
						g <= 8'h0;
						b <= 8'h0;
					end
					else 
					begin
						r <= 8'hFF;
						g <= 8'hFF;
						b <= 8'hFF;
					end
				end
				IDLE:
				begin
					count <= count + 8'd1;
				end
			endcase
	end
	
	
	always @ (*)
	begin
		xr = xl + xdiff;
		yb = yt + ydiff;
		rectx = (xl <= x & x < xr);
		recty = (yt <= y & y < yb);
	end
	

endmodule

/*
	always @(posedge clk or negedge rst) begin
	
		if (rst == 1'b0) begin
			
			r <= 0;
			g <= 0;
			b <= 0;
			shift <= 8'b00000001;
			
		end else begin
		
			r <= x[7:0];
			g <= y[9:2];
			b <= shift;
			shift <= {shift[6:0], shift[7] ^ shift[6]};
		
		end
	end
		*/