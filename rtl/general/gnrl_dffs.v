`ifdef __GNRL_DFFS_V__

module gnrl_dfflr #(
    parameter DATA_WIDTH = 32,
    parameter INITIAL_VALUE = 0
) (
    input                           lden,
    input   [DATA_WIDTH - 1 : 0]    dnxt,
    output  [DATA_WIDTH - 1 : 0]    dout,
    
    input                           clk,
    input                           rst_n
);

reg [DATA_WIDTH - 1 : 0] dout_r;

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        dout_r <= {DATA_WIDTH{INITIAL_VALUE}};
    end
    else if(lden == 1'b1) begin
        dout_r <= #1 dnxt;
    end
end

assign dout = dout_r;

endmodule   //  gnrl_dfflr

module gnrl_dffl #(
    parameter DATA_WIDTH = 32
) (
    input                           lden,
    input   [DATA_WIDTH - 1 : 0]    dnxt,
    output  [DATA_WIDTH - 1 : 0]    dout,
    
    input                           clk
);

reg [DATA_WIDTH - 1  : 0] dout_r;

always @(posedge clk) begin
    if(lden == 1'b1) begin
        dout_r <= #1 dnxt;
    end
end

assign dout = dout_r;

endmodule   //  gnrl_dffl


module gnrl_dffr #(
    parameter DATA_WIDTH = 32,
    parameter INITIAL_VALUE = 0
) (
    input   [DATA_WIDTH - 1 : 0]    dnxt,
    output  [DATA_WIDTH - 1 : 0]    dout,
    
    input                           clk,
    input                           rst_n
);

reg [DATA_WIDTH - 1 : 0] dout_r;

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        dout_r <= {DATA_WIDTH{INITIAL_VALUE}};
    end
    else begin
        dout_r <= #1 dnxt;
    end
end

assign dout = dout_r;

endmodule   //  gnrl_dffr

`endif  /*  !__GNRL_DFFS_V__!       */
