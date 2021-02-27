`ifdef __IFU_IFU_V__

module ifu_module (
    input                                   i_csr_trap_flush,
    input   [`CORE_PC_WIDTH - 1     : 0]    i_csr_trap_addr,
    input                                   i_exu_mis_flush,
    input   [`CORE_PC_WIDTH - 1     : 0]    i_exu_mis_addr,
    input   [`ROB_ID_WIDTH - 1      : 0]    i_exu_mis_rob_id,
    input                                   i_exu_ls_flush,
    input   [`CORE_PC_WIDTH - 1     : 0]    i_exu_ls_addr,
    input   [`ROB_ID_WIDTH - 1      : 0]    i_exu_ls_rob_id,
    input                                   i_bpu_flush,
    input   [`CORE_PC_WIDTH - 1     : 0]    i_bpu_pc_addr,
    input                                   i_iq_flush,
    input   [`CORE_PC_WIDTH - 1     : 0]    i_iq_pc_addr,
    input                                   i_iq_uc_flush,
    input   [`CORE_PC_WIDTH - 1     : 0]    i_iq_uc_pc_addr,
    input                                   i_icache_ifu_vld,
    input   [1                      : 0]    i_icache_ifu_id,
    input                                   i_icache_ifu_stall,
    
    output                                  o_ifu_icache_vld,
    output  [`CORE_PC_WIDTH - 1     : 0]    o_ifu_icache_pc_addr,
    output  [1                      : 0]    o_ifu_icache_id,
    output                                  o_ifu_bpu_vld,
    output  [`CORE_PC_WIDTH - 1     : 0]    o_ifu_bpu_pc_addr,
    output  [`CORE_PC_WIDTH - 1     : 0]    o_ifu_predec_pc_addr,
    
    input                                   clk,
    input                                   rst_n
);

localparam BOOT_ADDR = {{(`CORE_PC_WIDTH - 4){1'b1}}, 4'b0};

//  
wire [`CORE_PC_WIDTH - 1 : 0] ifu_pc_addr_r;
wire [`CORE_PC_WIDTH - 1 : 0] ifu_addrq_r [3 : 0];
wire [1 : 0] ifu_addrq_idx_r;
wire [2 : 0] ifu_addrq_ctr_r;

//
wire ifu_need_flush;
wire ifu_can_gen;
wire ifu_need_gen;

assign ifu_need_gen = ifu_can_gen | ifu_need_flush;

//  Generate PC Address.

//  If misprediction and load-store flush occur both, select the older address.
wire ifu_sel_mis  = func_rob_old(i_exu_mis_rob_id, i_exu_ls_rob_id); 

wire [`CORE_PC_WIDTH - 1 : 0] ifu_sel_mis_ls_addr = ifu_sel_mis ? i_exu_mis_addr
                                                                : i_exu_ls_addr;

wire ifu_exu_flush_occur_both = i_exu_ls_flush & i_exu_mis_flush;
wire ifu_exu_flush_occur      = i_exu_ls_flush | i_exu_mis_flush;

wire [`CORE_PC_WIDTH - 1 : 0] i_ifu_sel_exu_flush_addr = ifu_exu_flush_occur_both ? ifu_sel_mis_ls_addr
                                                       : i_exu_ls_flush           ? i_exu_ls_addr
                                                       : i_exu_mis_addr;

assign ifu_need_flush   = i_csr_trap_flush
                        | ifu_exu_flush_occur
                        | i_iq_flush
                        | i_iq_uc_flush
                        | i_bpu_flush; 
//
wire [3 : 0] i_ifu_flush_sel = {i_bpu_flush, i_iq_flush, i_iq_uc_flush, ifu_exu_flush_occur, i_csr_trap_flush};
wire [`CORE_PC_WIDTH - 1 : 0] o_ifu_sel_flush_addr;

mux5_module #(
    .DATA_WIDTH(`CORE_PC_WIDTH)
) ifu_flush_addr_mux5 (
    .mux5_sel (i_ifu_flush_sel         ),
    .mux5_din0(i_csr_trap_addr         ),
    .mux5_din1(i_ifu_sel_exu_flush_addr),
    .mux5_din2(i_iq_uc_pc_addr         ),
    .mux5_din3(i_iq_pc_addr            ),
    .mux5_din4(i_bpu_pc_addr           ),
    .mux5_dout(o_ifu_sel_flush_addr    )
);

wire i_ifu_pc_addr_ena = ifu_need_gen;
wire [`CORE_PC_WIDTH - 1 : 0] i_ifu_pc_addr_nxt = ifu_need_flush ? o_ifu_sel_flush_addr
                                                : ifu_pc_addr_r + `CORE_PC_WIDTH'd16;

gnrl_dfflr #(
    .DATA_WIDTH   (`CORE_PC_WIDTH),
    .INITIAL_VALUE(     BOOT_ADDR)
) ifu_pc_addr_dfflr (i_ifu_pc_addr_ena, i_ifu_pc_addr_nxt, ifu_pc_addr_r, clk, rst_n);

//  Update Address Queue
wire ifu_addrq_empty= (ifu_addrq_ctr_r == 0);
wire ifu_addrq_full = (ifu_addrq_ctr_r == 4);

assign ifu_can_gen = (~(i_icache_ifu_stall | ifu_addrq_full));

//  Update Address Queue Index
wire i_ifu_addrq_idx_ena = ifu_need_gen;
wire [1 : 0] i_ifu_addrq_idx_nxt = ifu_need_flush ? ifu_addrq_idx_r
                                 : ifu_addrq_idx_r + 2'd1;
assign o_ifu_icache_id = ifu_addrq_idx_r;

dfflr #(
    .DATA_WIDTH   (2),
    .INITIAL_VALUE(0)
) ifu_addrq_idx_dfflr (i_ifu_addrq_idx_ena, i_ifu_addrq_idx_nxt, ifu_addrq_idx_r, clk, rst_n);

//  Update Address Queue Counter
wire ifu_addrq_ctr_add_ena     = ifu_can_gen;
wire ifu_addrq_ctr_sub_ena     = i_icache_ifu_vld;

wire [2 : 0] ifu_addrq_ctr_res = ({2'b0, ifu_addrq_ctr_add_ena} - {2'b0, ifu_addrq_ctr_sub_ena});
wire [2 : 0] ifu_addrq_ctr_com = ifu_addrq_ctr_r + ifu_addrq_ctr_res;


wire i_ifu_addrq_ctr_ena = ifu_need_flush
                         | (ifu_addrq_ctr_add_ena | ifu_addrq_ctr_sub_ena);
wire [2 : 0] i_ifu_addrq_ctr_nxt = ifu_need_flush ? 3'd0
                                 : ifu_addrq_ctr_com;

gnrl_dfflr #(
    .DATA_WIDTH   (3),
    .INITIAL_VALUE(0)
) ifu_addrq_ctr_dfflr (i_ifu_addrq_ctr_ena, i_ifu_addrq_ctr_nxt, ifu_addrq_ctr_r, clk, rst_n);

//  Write Address Queue
wire [3 : 0] i_ifu_addrq_ena;

genvar i;
generate
    for(i = 0; i < 4; i = i + 1) begin
        assign i_ifu_addrq_ena[i] = ifu_need_gen & (i == ifu_addrq_idx_r);
        gnrl_dffl #(
            .DATA_WIDTH(`CORE_PC_WIDTH)
        ) ifu_addrq_dffl (i_ifu_addrq_ena[i], ifu_pc_addr_r, ifu_addrq_r[i], clk);
    end
endgenerate

//  Set ifu_vld
wire ifu_vld = (ifu_can_gen) & (rst_n);

assign o_ifu_icache_vld     = ifu_vld;
assign o_ifu_bpu_vld        = o_ifu_icache_vld;

//
assign o_ifu_icache_pc_addr = ifu_pc_addr_r;
assign o_ifu_bpu_pc_addr    = ifu_pc_addr_r;

wire ifu_predec_pc_addr_ena = i_icache_ifu_vld;
wire [`CORE_PC_WIDTH - 1 : 0] ifu_predec_pc_addr_nxt = ifu_addrq_r[i_icache_ifu_id];
gnrl_dffl #(
    .DATA_WIDTH   (`CORE_PC_WIDTH)
) ifu_predec_pc_addr_dffl (ifu_predec_pc_addr_ena, ifu_predec_pc_addr_nxt, o_ifu_predec_pc_addr, clk, rst_n);

// assign o_ifu_predec_pc_addr = ifu_addrq_r[i_icache_ifu_id];


//  Functions
function func_rob_old;
    input   [`ROB_ID_WIDTH - 1 : 0] rob_id_a;
    input   [`ROB_ID_WIDTH - 1 : 0] rob_id_b;

    func_rob_old = (rob_id_a[`ROB_ID_WIDTH - 1] ^ rob_id_b[`ROB_ID_WIDTH - 1]) ? (rob_id_a[`ROB_ID_WIDTH - 2 : 0] >= rob_id_b[`ROB_ID_WIDTH - 2 : 0])
                 : (rob_id_a[`ROB_ID_WIDTH - 2 : 0] < rob_id_b[`ROB_ID_WIDTH - 2 : 0]);
endfunction


endmodule   //  ifu_module

`endif  /*  !__IFU_IFU_V__!     */
