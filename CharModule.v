`timescale 1ns / 1ps

module vh_sync (
	input wire clk,
	input wire clr,
	output wire hsync,
	output wire vsync,
    output reg [3:0] red,
    output reg [3:0] green,
    output reg [3:0] blue
    );
	
/*
* These are the parameters for a 640x480 px display (60Hz refresh rate)
*/
parameter hpixels = 800;
parameter vlines = 521;
parameter hpulse = 96;
parameter vpulse = 2;
parameter hbp = 144;
parameter hfp = 784;
parameter vbp = 31;
parameter vfp = 511;

reg [9:0] hc;
reg [9:0] vc;
reg [1:0] pxclk;

always @ (posedge clk) pxclk = pxclk + 1;

wire pclk;

assign pclk = pxclk[1]; // 25MHz Pixel Clock

/*
 * Enable the horizontal and vertical counters to count when they are in the
 * range of the display.
 */
 
always @ (posedge pclk or posedge clr)
begin
	if (clr == 1)
	begin
		hc <= 0;
		vc <= 0;
	end
	else
	begin
		if (hc < hpixels - 1)
			hc <= hc + 1;
		else
		begin
			hc <= 0;
			if (vc < vlines - 1)
				vc <= vc + 1;
			else
				vc <= 0;
		end
	end
end

assign hsync = (hc < hpulse) ? 0:1; 
assign vsync = (vc < vpulse) ? 0:1;

/*
* This always block is used to display all characters (A-Z, 0-9)
*/
always @ (*)
begin   
    if (vc >= vbp & vc < vfp)
    begin
        char(0, 150, 150);
        char(1, 160, 150);
        char(2, 170, 150);
        char(3, 180, 150);
        char(4, 190, 150);
        char(5, 200, 150);
        char(6, 210, 150);
        char(7, 220, 150);
        char(8, 230, 150);
        char(9, 240, 150);
        char(10, 250, 150);
        char(11, 150, 170);
        char(12, 160, 170);
        char(13, 170, 170);
        char(14, 180, 170);
        char(15, 190, 170);
        char(16, 200, 170);
        char(17, 210, 170);
        char(18, 220, 170);
        char(19, 230, 170);
        char(20, 240, 170);
        char(21, 250, 170);
        char(22, 150, 190);
        char(23, 160, 190);
        char(24, 170, 190);
        char(25, 180, 190);
        
        char(26, 150, 210);
        char(27, 160, 210);
        char(28, 170, 210);
        char(29, 180, 210);
        char(30, 190, 210);
        char(31, 200, 210);
        char(32, 210, 210);
        char(33, 220, 210);
        char(34, 230, 210);
        char(35, 240, 210);
    end
    else
    begin
        red = 0;
        green = 4'b1111;
        blue = 0;
    end
end

/*
* Implemented a function to draw a white line whenever vc and hc are
* in the domain of the x-start, y-start and x-end, and y-end coordinates.
*/
function draw;
input [9:0] xStart;
input [9:0] yStart;
input [9:0] xEnd; 
input [9:0] yEnd;
begin
    if (vc >= (vbp + yStart) && vc < (vbp + yEnd) && hc >= (hbp + xStart) && hc < (hbp + xEnd))
    begin
        red = 4'b1111;
        green = 4'b1111;
        blue = 4'b1111;
    end
end
endfunction

/*
* char function to manually draw each character on a 9x9 pixel block
*/
function char;
input [5:0] charVal;
input [9:0] x, y;
begin
    case(charVal)
        6'b000000: // A
            begin
                draw(x + 3, y, x + 6, y + 2);
                draw(x + 1, y + 2, x + 3, y + 9);
                draw(x + 6, y + 2, x + 8, y + 9);
                draw(x + 3, y + 4, x + 6, y + 6); 
                draw(x + 2, y + 1, x + 3, y + 2);
                draw(x + 6, y + 1, x + 7, y + 2);
            end
        6'b000001: // B
            begin
                draw(x + 1, y, x + 6, y + 2);
                draw(x + 1, y + 2, x + 3, y + 9);
                draw(x + 6, y + 2, x + 8, y + 4);
                draw(x + 3, y + 4, x + 6, y + 5);
                draw(x + 6, y + 5, x + 8, y + 8);
                draw(x + 3, y + 8, x + 6, y + 9);
            end
        6'b000010: // C
            begin
                draw(x + 3, y, x + 7, y + 1);
                draw(x + 2, y + 1, x + 3, y + 2);
                draw(x + 7, y + 1, x + 8, y + 2);
                draw(x + 1, y + 2, x + 3, y + 8);
                draw(x + 2, y + 8, x + 7, y + 9);
                draw(x + 7, y + 7, x + 8, y + 8);
            end
        6'b000011: // D
            begin
                draw(x + 1, y, x + 6, y + 1);
                draw(x + 1, y + 1, x + 3, y + 9);
                draw(x + 6, y + 1, x + 7, y + 2);
                draw(x + 7, y + 2, x + 8, y + 7);
                draw(x + 6, y + 7, x + 7, y + 8);
                draw(x + 3, y + 8, x + 6, y + 9);
            end
        6'b000100: // E
            begin
                draw(x + 1, y, x + 8, y + 1);
                draw(x + 1, y + 1, x + 3, y + 9);
                draw(x + 3, y + 4, x + 6, y + 5);
                draw(x + 3, y + 8, x + 8, y + 9);
            end
        6'b000101: // F
            begin
                draw(x + 1, y, x + 8, y + 1);
                draw(x + 1, y + 1, x + 3, y + 9);
                draw(x + 3, y + 3, x + 6, y + 4);
            end
        6'b000110: // G
            begin
                draw(x + 2, y, x + 7, y + 1);
                draw(x + 1, y + 1, x + 3, y + 8);
                draw(x + 7, y + 1, x + 8, y + 2);
                draw(x + 2, y + 8, x + 7, y + 9);
                draw(x + 6, y + 5, x + 8, y + 8);
                draw(x + 5, y + 5, x + 6, y + 6);
            end
        6'b000111: // H
            begin
                draw(x + 1, y, x + 3, y + 9);
                draw(x + 3, y + 4, x + 6, y + 5);
                draw(x + 6, y, x + 8, y + 9);
            end
        6'b001000: // I
            begin
                draw(x + 3, y, x + 6, y + 9);
            end
        6'b001001: // J
            begin
                draw(x + 6, y, x + 8, y + 8);
                draw(x + 1, y + 6, x + 2, y + 8);
                draw(x + 2, y + 8, x + 7, y + 9);
            end
        6'b001010: // K
            begin
                draw(x + 1, y, x + 3, y + 9);
                draw(x + 3, y + 4, x + 6, y + 5);
                draw(x + 6, y + 3, x + 7, y + 4);
                draw(x + 6, y + 5, x + 7, y + 6);
                draw(x + 7, y, x + 8, y + 3);
                draw(x + 7, y + 6, x + 8, y + 9);
            end
        6'b001011: // L
            begin
                draw(x + 1, y, x + 3, y + 9);
                draw(x + 3, y + 7, x + 8, y + 9);
            end
        6'b001100: // M
            begin
                draw(x + 1, y, x + 8, y + 1);
                draw(x + 1, y + 1, x + 2, y + 9);
                draw(x + 4, y + 1, x + 5, y + 9);
                draw(x + 7, y + 1, x + 8, y + 9);
            end
        6'b001101: // N
            begin
                draw(x + 1, y, x + 3, y + 9);
                draw(x + 3, y + 1, x + 4, y + 2);
                draw(x + 4, y, x + 7, y + 1);
                draw(x + 7, y + 1, x + 8, y + 9);
            end
        6'b001110: // O
            begin
                draw(x + 1, y + 1, x + 3, y + 8);
                draw(x + 6, y + 1, x + 8, y + 8);
                draw(x + 2, y, x + 7, y + 1);
                draw(x + 2, y + 8, x + 7, y + 9);
            end
        6'b001111: // P
            begin
                draw(x + 1, y, x + 3, y + 9);
                draw(x + 3, y, x + 6, y + 1);
                draw(x + 6, y + 1, x + 7, y + 2);
                draw(x + 7, y + 2, x + 8, y + 4);
                draw(x + 3, y + 4, x + 7, y + 5);
            end
        6'b010000: // Q
            begin
                draw(x + 2, y, x + 7, y + 1);
                draw(x + 1, y + 1, x + 3, y + 8);
                draw(x + 6, y + 1, x + 8, y + 7);
                draw(x + 2, y + 8, x + 8, y + 9);
                draw(x + 4, y + 6, x + 5, y + 7);
                draw(x + 5, y + 7, x + 7, y + 8);
                draw(x + 2, y + 8, x + 8, y + 9);
            end
        6'b010001: // R
            begin
                draw(x + 1, y, x + 3, y + 9);
                draw(x + 3, y, x + 7, y + 1);
                draw(x + 7, y + 1, x + 8, y + 3);
                draw(x + 6, y + 3, x + 7, y + 4);
                draw(x + 3, y + 4, x + 7, y + 5);
                draw(x + 7, y + 5, x + 8, y + 9);
            end
        6'b010010: // S
            begin
                draw(x + 2, y, x + 7, y + 1);
                draw(x + 1, y + 1, x + 2, y + 4);
                draw(x + 7, y + 1, x + 8, y + 3);
                draw(x + 2, y + 4, x + 7, y + 5);
                draw(x + 7, y + 5, x + 8, y + 8);
                draw(x + 1, y + 6, x + 2, y + 8);
                draw(x + 2, y + 8, x + 7, y + 9);
            end
        6'b010011: // T
            begin
                draw(x + 1, y, x + 8, y + 2);
                draw(x + 4, y + 2, x + 6, y + 9);
            end
        6'b010100: // U
            begin
                draw(x + 1, y, x + 3, y + 8);
                draw(x + 6, y, x + 8, y + 8);
                draw(x + 2, y + 7, x + 7, y + 9);
            end
        6'b010101: // V
            begin
                draw(x + 1, y, x + 2, y + 5);
                draw(x + 7, y, x + 8, y + 5);
                draw(x + 2, y + 4, x + 3, y + 7);
                draw(x + 6, y + 4, x + 7, y + 7);
                draw(x + 3, y + 6, x + 4, y + 8);
                draw(x + 5, y + 6, x + 6, y + 8);
                draw(x + 4, y + 8, x + 5, y + 9);
            end
        6'b010110: // W
            begin
                draw(x + 1, y, x + 2, y + 8);
                draw(x + 7, y, x + 8, y + 8);
                draw(x + 4, y + 3, x + 5, y + 8);
                draw(x + 1, y + 8, x + 8, y + 9);
            end
        6'b010111: // X
            begin
                draw(x + 1, y, x + 2, y + 3);
                draw(x + 7, y, x + 8, y + 3);
                draw(x + 2, y + 2, x + 3, y + 4);
                draw(x + 6, y + 2, x + 7, y + 4);
                draw(x + 3, y + 4, x + 6, y + 5);
                draw(x + 2, y + 5, x + 3, y + 7);
                draw(x + 6, y + 5, x + 7, y + 7);
                draw(x + 1, y + 6, x + 2, y + 9);
                draw(x + 7, y + 6, x + 8, y + 9);              
            end
        6'b011000: // Y
            begin
                draw(x + 1, y, x + 3, y + 4);
                draw(x + 6, y, x + 8, y + 8);
                draw(x + 2, y + 4, x + 6, y + 5);
                draw(x + 1, y + 7, x + 3, y + 8);
                draw(x + 2, y + 8, x + 7, y + 9);
            end
        6'b011001: // Z
            begin
                draw(x + 1, y, x + 8, y + 2);
                draw(x + 6, y + 2, x + 8, y + 3);
                draw(x + 5, y + 3, x + 6, y + 4);
                draw(x + 4, y + 4, x + 5, y + 5);
                draw(x + 3, y + 5, x + 4, y + 6);
                draw(x + 1, y + 6, x + 3, y + 7);
                draw(x + 1, y + 7, x + 8, y + 9);
            end
        6'b011010: // 1
            begin
                draw(x + 4, y, x + 6, y + 9);
                draw(x + 3, y + 1, x + 4, y + 3);
                draw(x + 2, y + 2, x + 3, y + 3);
                draw(x + 2, y + 7, x + 7, y + 9);
            end
        6'b011011: // 2
            begin
                draw(x + 1, y + 1, x + 3, y + 3);
                draw(x + 2, y, x + 4, y + 2);
                draw(x + 4, y, x + 7, y + 1);
                draw(x + 6, y + 1, x + 8, y + 4);
                draw(x + 2, y + 4, x + 7, y + 5);
                draw(x + 1, y + 5, x + 3, y + 8);
                draw(x + 2, y + 8, x + 8, y + 9);
            end
        6'b011100: // 3
            begin
                draw(x + 1, y + 1, x + 2, y + 2);
                draw(x + 2, y, x + 7, y + 1);
                draw(x + 7, y + 1, x + 8, y + 4);
                draw(x + 3, y + 4, x + 7, y + 5);
                draw(x + 7, y + 5, x + 8, y + 8);
                draw(x + 1, y + 7, x + 2, y + 8);
                draw(x + 2, y + 8, x + 7, y + 9);
            end
        6'b011101: // 4
            begin
                draw(x + 5, y, x + 8, y + 2);
                draw(x + 4, y + 1, x + 5, y + 2);
                draw(x + 3, y + 2, x + 4, y + 3);
                draw(x + 2, y + 3, x + 3, y + 4);
                draw(x + 1, y + 4, x + 6, y + 6);
                draw(x + 5, y + 2, x + 8, y + 9);
            end
        6'b011110: // 5
            begin
                draw(x + 1, y, x + 8, y + 2);
                draw(x + 1, y + 2, x + 3, y + 5);
                draw(x + 3, y + 3, x + 8, y + 5);
                draw(x + 6, y + 5, x + 8, y + 9);
                draw(x + 1, y + 7, x + 8, y + 9);
            end
        6'b011111: // 6
            begin
                draw(x + 2, y, x + 7, y + 1);
                draw(x + 1, y + 1, x + 3, y + 8);
                draw(x + 6, y + 1, x + 8, y + 2);
                draw(x + 3, y + 4, x + 7, y + 5);
                draw(x + 6, y + 5, x + 8, y + 8);
                draw(x + 2, y + 8, x + 7, y + 9);
            end
        6'b100000: // 7
            begin
                draw(x + 1, y, x + 8, y + 2);
                draw(x + 1, y + 2, x + 3, y + 3);
                draw(x + 6, y + 2, x + 8, y + 9);
            end
        6'b100001: // 8
            begin
                draw(x + 2, y, x + 7, y + 2);
                draw(x + 1, y + 1, x + 3, y + 4);
                draw(x + 6, y + 1, x + 8, y + 4);
                draw(x + 2, y + 4, x + 7, y + 5);
                draw(x + 1, y + 5, x + 3, y + 8);
                draw(x + 6, y + 5, x + 8, y + 8);
                draw(x + 2, y + 7, x + 7, y + 9);
            end
        6'b100010: // 9
            begin
                draw(x + 2, y, x + 7, y + 1);
                draw(x + 1, y + 1, x + 3, y + 4);
                draw(x + 2, y + 4, x + 6, y + 5);
                draw(x + 6, y + 1, x + 8, y + 8);
                draw(x + 1, y + 7, x + 2, y + 8);
                draw(x + 2, y + 8, x + 7, y + 9);
            end
        6'b100011: // 0
            begin
                draw(x + 2, y, x + 7, y + 2);
                draw(x + 1, y + 1, x + 3, y + 8);
                draw(x + 6, y + 1, x + 8, y + 8);
                draw(x + 2, y + 7, x + 6, y + 9);
            end
        default:
            begin
                red = 0;
                green = 0;
                blue = 0;
            end
    endcase
end
endfunction


endmodule