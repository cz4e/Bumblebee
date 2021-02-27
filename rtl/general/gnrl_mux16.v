`ifdef __GNRL_MUX16_V__

module mux16_module #(
    parameter DATA_WIDTH = 32
) (
    input       [14 : 0]                    mux16_sel,
    input       [DATA_WIDTH - 1 : 0]        mux16_din0,
    input       [DATA_WIDTH - 1 : 0]        mux16_din1,
    input       [DATA_WIDTH - 1 : 0]        mux16_din2,
    input       [DATA_WIDTH - 1 : 0]        mux16_din3,
    input       [DATA_WIDTH - 1 : 0]        mux16_din4,
    input       [DATA_WIDTH - 1 : 0]        mux16_din5,
    input       [DATA_WIDTH - 1 : 0]        mux16_din6,
    input       [DATA_WIDTH - 1 : 0]        mux16_din7,
    input       [DATA_WIDTH - 1 : 0]        mux16_din8,
    input       [DATA_WIDTH - 1 : 0]        mux16_din9,
    input       [DATA_WIDTH - 1 : 0]        mux16_din10,
    input       [DATA_WIDTH - 1 : 0]        mux16_din11,
    input       [DATA_WIDTH - 1 : 0]        mux16_din12,
    input       [DATA_WIDTH - 1 : 0]        mux16_din13,
    input       [DATA_WIDTH - 1 : 0]        mux16_din14,
    input       [DATA_WIDTH - 1 : 0]        mux16_din15,
    output      [DATA_WIDTH - 1 : 0]        mux16_dout
);

reg [DATA_WIDTH - 1 : 0] mux16_dout_r;

always @(*) begin
    case(1'b1)
        mux16_sel[0]: begin
            mux16_dout_r = mux16_din0;
        end
        mux16_sel[1]: begin
            mux16_dout_r = mux16_din1;
        end
        mux16_sel[2]: begin
            mux16_dout_r = mux16_din2;
        end
        mux16_sel[3]: begin
            mux16_dout_r = mux16_din3;
        end
        mux16_sel[4]: begin
            mux16_dout_r = mux16_din4;
        end
        mux16_sel[5]: begin
            mux16_dout_r = mux16_din5;
        end
        mux16_sel[6]: begin
            mux16_dout_r = mux16_din6;
        end
        mux16_sel[7]: begin
            mux16_dout_r = mux16_din7;
        end
        mux16_sel[8]: begin
            mux16_dout_r = mux16_din8;
        end
        mux16_sel[9]: begin
            mux16_dout_r = mux16_din9;
        end
        mux16_sel[10]: begin
            mux16_dout_r = mux16_din10;
        end
        mux16_sel[11]: begin
            mux16_dout_r = mux16_din11;
        end
        mux16_sel[12]: begin
            mux16_dout_r = mux16_din12;
        end
        mux16_sel[13]: begin
            mux16_dout_r = mux16_din13;
        end
        mux16_sel[14]: begin
            mux16_dout_r = mux16_din14;
        end
        default: begin
            mux16_dout_r = mux16_din15;
        end
    endcase
end

assign mux16_dout = mux16_dout_r;

endmodule   //  mux16_module

`endif  /*  !__GNRL_MUX16_V__!      */
