
`ifndef __E4THAM__FFS_V
`define __E4THAM__FFS_V

`define __E4THAM__FFS__GET_DEPTH(PARAM)     $clog2( (PARAM>=2) ? PARAM : 2 )


module ffs_m #(
    parameter INPUT_WIDTH   = 8,
    parameter SIDE          = 0
) (
    input     [INPUT_WIDTH-1:0] in,
    output                      valid,
    output   [OUTPUT_WIDTH-1:0] out
);

    localparam OUTPUT_WIDTH  = `__E4THAM__FFS__GET_DEPTH(INPUT_WIDTH);

    localparam LEFT_INPUT_WIDTH = INPUT_WIDTH / 2;
    localparam LEFT_OUTPUT_WIDTH = `__E4THAM__FFS__GET_DEPTH(LEFT_INPUT_WIDTH);

    localparam RIGHT_INPUT_WIDTH = INPUT_WIDTH - LEFT_INPUT_WIDTH;
    localparam RIGHT_OUTPUT_WIDTH = `__E4THAM__FFS__GET_DEPTH(RIGHT_INPUT_WIDTH);


    wire [LEFT_OUTPUT_WIDTH-1:0] left_out;
    wire left_valid;

    wire [RIGHT_OUTPUT_WIDTH-1:0] right_out;
    wire right_valid;


    generate
        // left base case
        if ( LEFT_INPUT_WIDTH == 0 ) begin : left_bc0
            assign left_valid = 1'b0;
            assign left_out = 1'bx;
        end
        if ( LEFT_INPUT_WIDTH == 1 ) begin : left_bc1
            wire [LEFT_INPUT_WIDTH-1:0] left_in = in[ RIGHT_INPUT_WIDTH +: LEFT_INPUT_WIDTH ];
            assign left_valid = left_in;
            assign left_out = left_valid ? 1'b0 : 1'bx;
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
            assign right_out = 1'bx;
        end
        if ( RIGHT_INPUT_WIDTH == 1 ) begin : right_bc
            wire [RIGHT_INPUT_WIDTH-1:0] right_in = in[ 0 +: RIGHT_INPUT_WIDTH ];
            assign right_valid = right_in;
            assign right_out = right_valid ? 1'b0 : 1'bx;
        end
        if ( RIGHT_INPUT_WIDTH > 1 ) begin : right_recursion
            wire [RIGHT_INPUT_WIDTH-1:0] right_in = in[ 0 +: RIGHT_INPUT_WIDTH ];
            ffs_m #(RIGHT_INPUT_WIDTH,SIDE) ffs (
                right_in,
                right_valid,
                right_out
            );
        end

        if ( SIDE == 0 ) begin
            assign out =    left_valid  ? ( left_out + RIGHT_INPUT_WIDTH )  :
                            right_valid ? ( right_out )                     :
                            {OUTPUT_WIDTH{1'bx}};
        end
        if ( SIDE == 1 ) begin
            assign out =    right_valid ? ( right_out )                     :
                            left_valid  ? ( left_out + RIGHT_INPUT_WIDTH )  :
                            {OUTPUT_WIDTH{1'bx}};
        end

    endgenerate

    assign valid = left_valid | right_valid;

endmodule

`undef __E4THAM__FFS__GET_DEPTH
`endif
