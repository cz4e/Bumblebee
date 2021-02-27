`ifdef __GNRL_GNRL_64SEL4_V__

module gnrl_pecdr_64sel4_module (
    input   [63 : 0]                i_pecdr_bit_map,
    output  [5  : 0]                o_pecdr_sel_0,
    output  [5  : 0]                o_pecdr_sel_1,
    output  [5  : 0]                o_pecdr_sel_2,
    output  [5  : 0]                o_pecdr_sel_3
);

reg pecdr_sel_0_match;
reg [5 : 0] pecdr_sel_0_r;
reg pecdr_sel_1_match;
reg [5 : 0] pecdr_sel_1_r;
reg pecdr_sel_2_match;
reg [5 : 0] pecdr_sel_2_r;
reg pecdr_sel_3_match;
reg [5  : 0] pecdr_sel_3_r;

integer i;

always @(*) begin
    pecdr_sel_0_match = 1'b0;
    pecdr_sel_1_match = 1'b0;
    pecdr_sel_2_match = 1'b0;
    pecdr_sel_3_match = 1'b0;
    for(i = 0; i < 64; i = i + 1) begin
        if(((~pecdr_sel_0_match) & (~pecdr_sel_1_match) & (~pecdr_sel_2_match) & (~pecdr_sel_3_match)) & i_pecdr_bit_map[i]) begin
            pecdr_sel_0_match = 1'b1;
            pecdr_sel_0_r = {6{i}};
        end
        else if(((~pecdr_sel_1_match) & (~pecdr_sel_2_match) & (~pecdr_sel_3_match)) & i_pecdr_bit_map[i]) begin
            pecdr_sel_1_match = 1'b1;
            pecdr_sel_1_r = {6{i}};
        end
        else if(((~pecdr_sel_2_match) & (~pecdr_sel_3_match)) & i_pecdr_bit_map[i]) begin
            pecdr_sel_2_match = 1'b1;
            pecdr_sel_2_r = {6{i}};
        end
        else if((~pecdr_sel_3_match) & i_pecdr_bit_map[i]) begin
            pecdr_sel_3_match = 1'b1;
            pecdr_sel_3_r = {6{i}};
        end
        else begin end
    end
end

assign o_pecdr_sel_0 = pecdr_sel_0_r;
assign o_pecdr_sel_1 = pecdr_sel_1_r;
assign o_pecdr_sel_2 = pecdr_sel_2_r;
assign o_pecdr_sel_3 = pecdr_sel_3_r;

endmodule   //  gnrl_pecdr_64sel4_module

`endif /*	!__GNRL_GNRL_64SEL4_V__!	*/