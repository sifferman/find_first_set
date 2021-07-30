
/* and.tb.v */


`ifdef LINTER
    `include "../rtl/ffs.v"
`endif


module top_tb ();


reg [7:0] in;
wire valid;
wire [2:0] out;

ffs_m #(8,0) ffs ( in, valid, out );

initial begin
$dumpfile( "dump.fst" );
$dumpvars;
$display( "Begin simulation.");
//\\ =========================== \\//
// $display( `__E4THAM__FFS__GET_DEPTH(9) );
for ( integer i = 0; i < 256; i = i+1 ) begin
    in = i;
    #1;
end

//\\ =========================== \\//
$display( "End simulation.");
$finish;
end

endmodule
