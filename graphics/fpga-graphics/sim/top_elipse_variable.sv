// Project F: FPGA Graphics - rect (Verilator SDL)
// (C)2023 Will Green, open source hardware released under the MIT License
// Learn more at https://projectf.io/posts/fpga-graphics/

`default_nettype none
`timescale 1ns / 1ps

module top_rect_variable #(parameter CORDW=10) (  // coordinate width
    input  wire logic clk_pix,             // pixel clock
    input  wire logic sim_rst,             // sim reset
    output      logic [CORDW-1:0] sdl_sx,  // horizontal SDL position
    output      logic [CORDW-1:0] sdl_sy,  // vertical SDL position
    output      logic sdl_de,              // data enable (low in blanking interval)
    output      logic [7:0] sdl_r,         // 8-bit red
    output      logic [7:0] sdl_g,         // 8-bit green
    output      logic [7:0] sdl_b          // 8-bit blue
    );

    // display sync signals and coordinates
    logic [CORDW-1:0] sx, sy;
    logic de;
    simple_480p display_inst (
        .clk_pix,
        .rst_pix(sim_rst),
        .sx,
        .sy,
        /* verilator lint_off PINCONNECTEMPTY */
        .hsync(),
        .vsync(),
        /* verilator lint_on PINCONNECTEMPTY */
        .de
    );

    // define a rect with screen coordinates
    parameter screen_width = 640;
    parameter screen_height = 480;
    parameter rect_width = 200;
    parameter rect_height = 400;
    parameter box_width = screen_height > rect_width ? rect_height : screen_height;
    parameter box_height = box_width;
    // parameter box_height = screen_height > rect_height ? rect_height : screen_height;
    logic rect;
    logic elipse;
    always_comb begin
        rect = (sx > ((screen_width - rect_width) / 2)) && sx < (((screen_width - rect_width) / 2) + rect_width) && 
                (sy > ((screen_height - rect_height) / 2)) && sy < (((screen_height - rect_height) / 2) + rect_height);
    end

    // paint colour: white inside rect, blue outside
    logic [3:0] paint_r, paint_g, paint_b;
    always_comb begin
        paint_r = (rect) ? 4'hF : 4'h1;
        paint_g = (rect) ? 4'hF : 4'h3;
        paint_b = (rect) ? 4'hF : 4'h7;
    end

    // display colour: paint colour but black in blanking interval
    logic [3:0] display_r, display_g, display_b;
    always_comb begin
        display_r = (de) ? paint_r : 4'h0;
        display_g = (de) ? paint_g : 4'h0;
        display_b = (de) ? paint_b : 4'h0;
    end

    // SDL output (8 bits per colour channel)
    always_ff @(posedge clk_pix) begin
        sdl_sx <= sx;
        sdl_sy <= sy;
        sdl_de <= de;
        sdl_r <= {2{display_r}};  // double signal width from 4 to 8 bits
        sdl_g <= {2{display_g}};
        sdl_b <= {2{display_b}};
    end
endmodule
