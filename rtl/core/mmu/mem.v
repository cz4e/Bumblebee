`ifdef __MMU_MEM_V__

module mem_module #( 
    parameter DATA_WIDTH = 512,
    parameter MASK_WIDTH = 64,
    parameter ADDR_WIDTH = 34,
    parameter RAM_DEPTH  = $clog2(ADDR_WIDTH - 10),
) ( 
    input                                   i_cs,
    input                                   i_wren,
    input   [DATA_WIDTH - 1     : 0]        i_din,
    input   [ADDR_WIDTH - 1     : 0]        i_addr,
    input   [MASK_WIDTH - 1     : 0]        i_byte_mask,
    output  [DATA_WIDTH - 1     : 0]        o_dout,

    input                                   clk,
    input                                   rst_n
);

reg [DATA_WIDTH - 1 : 0] mem_r [RAM_DEPTH - 1 : 0];
reg [ADDR_WIDTH - 1 : 0] addr_r;

wire [MASK_WIDTH - 1 : 0] wren;
wire rden;

assign rden = (i_cs & (~i_wren));
assign wren = ({MASK_WIDTH{(i_cs & i_wren)}} & i_byte_mask);

always @(posedge clk) begin
    if(rden) begin
        addr_r <= i_addr;
    end
end

genvar i;
generate
    for(i = 0; i < MASK_WIDTH; i = i + 1) begin
        if((8 * i + 8) > DATA_WIDTH) begin 
            always @(posedge clk) begin
                if(wren[i]) begin
                    mem_r[i_addr[ADDR_WIDTH - 1 : 10]][DATA_WIDTH - 1 : 8 * i] <= i_din[DATA_WIDTH - 1 : 8 * i];
                end
            end
        end
        else begin
            always @(posedge clk) begin
                if(wren[i]) begin
                    mem_r[i_addr[ADDR_WIDTH - 1 : 10]][8 * i + 7 : 8 * i] <= i_din[8 * i + 7 : 8 * i];
                end
            end
        end
    end
endgenerate

assign o_dout = mem_r[addr_r[ADDR_WIDTH - 1 : 10]];

endmodule   //  mem_module

`endif  /*  !__MMU_MEM_V__! */