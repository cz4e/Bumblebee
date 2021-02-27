`ifdef __GNRL_PRIECDR128_V__

module gnrl_priecdr128_module (
    input                           i_pecdr_ena,
    input       [127 : 0]           i_pecdr_map,
    input       [6 : 0]             i_pecdr_start,
    output      [6 : 0]             o_pecdr_sel
);

reg [6 : 0] o_pecdr_sel_r;

integer i;
reg match;
always @(*) begin
    match = 1'b0;
    o_pecdr_sel_r = i_pecdr_start;
    for(i = i_pecdr_start; i < 128; i = i + 1) begin
        if(i_pecdr_ena && (!match) && i_pecdr_map[i]) begin
            match = 1'b1;
            o_pecdr_sel_r = {7{i}};
        end
    end
end

assign o_pecdr_sel = o_pecdr_sel_r;

endmodule   //  gnrl_priecdr128_module

`endif  /*  !__GNRL_PRIECDR128_V__!    */
