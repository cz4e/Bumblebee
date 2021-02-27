`ifdef __GNRL_MUX4_V__

module mux4_module #(
    parameter   DATA_WIDTH = 32
) (
    input   [2 : 0]                 mux4_sel,
    input   [DATA_WIDTH - 1 : 0]    mux4_din0,
    input   [DATA_WIDTH - 1 : 0]    mux4_din1,
    input   [DATA_WIDTH - 1 : 0]    mux4_din2,
    input   [DATA_WIDTH - 1 : 0]    mux4_din3,
    output  [DATA_WIDTH - 1 : 0]    mux4_dout
);

reg [DATA_WIDTH - 1 : 0] mux4_dout_r;

always @(*) begin
    case (1'b1)
        mux4_sel[0]: begin
            mux4_dout_r = mux4_din0;
        end
        mux4_sel[1]: begin
            mux4_dout_r = mux4_din1;
        end
        mux4_sel[2]: begin
            mux4_dout_r = mux4_din2;
        end
        default: begin
            mux4_dout_r = mux4_din3;
        end
    endcase
end

assign mux4_dout = mux4_dout_r;

endmodule   //  mux4_module

`endif  /*  !__GNRL_MUX4_V__!   */
