
`ifndef __E4THAM__FFS_V
`define __E4THAM__FFS_V

`define __E4THAM__FFS__GET_DEPTH(PARAM)     $clog2( (PARAM>=2) ? PARAM : 2 )


module ffs_m #(
    parameter INPUT_WIDTH   = 8,    // input vector width
    parameter SIDE          = 1'b0, // 0 or 1 means counting (msb->lsb) or (lsb->msb)
    parameter USE_X         = 1'b0  // (for debugging) invalid inputs will have {x} as output
) (
    input                [((INPUT_WIDTH>=1)?INPUT_WIDTH:1)-1:0] in,
    output wire                                                 valid,
    output wire  [(`__E4THAM__FFS__GET_DEPTH(INPUT_WIDTH))-1:0] out
);


    generate if ( INPUT_WIDTH < 1 ) begin
        initial $display( "WARNING: ffs input width updated from %0d to 1.", INPUT_WIDTH );
    end endgenerate


    localparam OUTPUT_WIDTH  = `__E4THAM__FFS__GET_DEPTH(((INPUT_WIDTH>=1)?INPUT_WIDTH:1));

    localparam LEFT_INPUT_WIDTH = ((INPUT_WIDTH>=1)?INPUT_WIDTH:1) / 2;
    localparam LEFT_OUTPUT_WIDTH = `__E4THAM__FFS__GET_DEPTH(LEFT_INPUT_WIDTH);

    localparam RIGHT_INPUT_WIDTH = ((INPUT_WIDTH>=1)?INPUT_WIDTH:1) - LEFT_INPUT_WIDTH;
    localparam RIGHT_OUTPUT_WIDTH = `__E4THAM__FFS__GET_DEPTH(RIGHT_INPUT_WIDTH);


    wire [LEFT_OUTPUT_WIDTH-1:0] left_out;
    wire left_valid;

    wire [RIGHT_OUTPUT_WIDTH-1:0] right_out;
    wire right_valid;


    generate
        // left base case
        if ( LEFT_INPUT_WIDTH == 0 ) begin : left_bc0
            assign left_valid = 1'b0;
            if ( USE_X )    assign left_out = 1'bx;
        end
        if ( LEFT_INPUT_WIDTH == 1 ) begin : left_bc1
            wire [LEFT_INPUT_WIDTH-1:0] left_in = in[ RIGHT_INPUT_WIDTH +: LEFT_INPUT_WIDTH ];
            assign left_valid = left_in;
            if ( USE_X )    assign left_out = left_valid ? 1'b0 : 1'bx;
            else            assign left_out = 1'b0;
        end
        // left recursive call
        if ( LEFT_INPUT_WIDTH > 1 ) begin : left_recursion
            wire [LEFT_INPUT_WIDTH-1:0] left_in = in[ RIGHT_INPUT_WIDTH +: LEFT_INPUT_WIDTH ];
            ffs_m #(LEFT_INPUT_WIDTH,SIDE) ffs (
                left_in,
                left_valid,
                left_out
            );
        end

        // right base case
        if ( RIGHT_INPUT_WIDTH == 0 ) begin : right_bc0
            assign right_valid = 1'b0;
            if ( USE_X )    assign right_out = 1'bx;
        end
        if ( RIGHT_INPUT_WIDTH == 1 ) begin : right_bc1
            wire [RIGHT_INPUT_WIDTH-1:0] right_in = in[ 0 +: RIGHT_INPUT_WIDTH ];
            assign right_valid = right_in;
            if ( USE_X )    assign right_out = right_valid ? 1'b0 : 1'bx;
            else            assign right_out = 1'b0;
        end
        if ( RIGHT_INPUT_WIDTH > 1 ) begin : right_recursion
            wire [RIGHT_INPUT_WIDTH-1:0] right_in = in[ 0 +: RIGHT_INPUT_WIDTH ];
            ffs_m #(RIGHT_INPUT_WIDTH,SIDE) ffs (
                right_in,
                right_valid,
                right_out
            );
        end

        // combine left and right back together
        case ({ ((2'b01&USE_X)<<1) | (2'b01&SIDE) })
            2'b00: assign out = left_valid  ? ( left_out + RIGHT_INPUT_WIDTH )  :
                                ( right_out );
            2'b01: assign out = right_valid ? ( right_out )                     :
                                ( left_out + RIGHT_INPUT_WIDTH );
            2'b10: assign out = left_valid  ? ( left_out + RIGHT_INPUT_WIDTH )  :
                                right_valid ? ( right_out )                     :
                                {OUTPUT_WIDTH{1'bx}};
            2'b11: assign out = right_valid ? ( right_out )                     :
                                left_valid  ? ( left_out + RIGHT_INPUT_WIDTH )  :
                                {OUTPUT_WIDTH{1'bx}};
        endcase

    endgenerate

    assign valid = left_valid | right_valid;

endmodule

`undef __E4THAM__FFS__GET_DEPTH
`endif
