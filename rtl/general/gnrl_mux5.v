`ifdef __GNRL_MUX5_V__

module mux5_module #(
    parameter DATA_WIDTH = 32
) (
    input   [3 : 0]                 mux5_sel,
    input   [DATA_WIDTH - 1 : 0]    mux5_din0,
    input   [DATA_WIDTH - 1 : 0]    mux5_din1,
    input   [DATA_WIDTH - 1 : 0]    mux5_din2,
    input   [DATA_WIDTH - 1 : 0]    mux5_din3,
    input   [DATA_WIDTH - 1 : 0]    mux5_din4,
    output  [DATA_WIDTH - 1 : 0]    mux5_dout
);

reg [DATA_WIDTH - 1 : 0] mux5_dout_r;

always @(*) begin
    case (mux5_sel)
        4'b0001:
            mux5_dout_r = mux5_din0;
        4'b0010:
            mux5_dout_r = mux5_din1;
        4'b0100:
            mux5_dout_r = mux5_din2;
        4'b1000:
            mux5_dout_r = mux5_din3;
        default:
            mux5_dout_r = mux5_din4;
    endcase
end

assign mux5_dout = mux5_dout_r;

endmodule   //  mux5_module

`endif  /*  !__GNRL_MUX5_V__!       */
