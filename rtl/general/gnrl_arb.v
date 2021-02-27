`ifdef __GNRL_ARB_V__

module gnrl_arb (
	input	[2	: 0]	i_req_vec,
	input	[2	: 0] 	i_end_access_vec,
	output  [2	: 0]	o_gnt_vec,

	input				clk,
	input				rst_n
);

localparam	ARB_STATE_WIDTH = 2;
localparam	ARB_STATE_IDLE 		 = ARB_STATE_WIDTH'd1,
			ARB_STATE_END_ACCESS = ARB_STATE_WIDTH'd2;
localparam	ARB_IDLE_ID = 0,
			ARB_END_ACCESS_ID = 1;

reg [ARB_STATE_WIDTH - 1 : 0] arb_state_cur, arb_state_nxt;
wire [2 : 0] gnt_vec_r;
reg [2 : 0] gnt_vec_nxt;
reg [2 : 0] relative_req_vec;
wire [1 : 0] grant_posn_r;
reg [1 : 0] grant_posn_nxt;

wire any_req_asserted = (|i_req_vec);
assign o_gnt_vec = gnt_vec_r;

always @(*) begin
	relative_req_vec = i_req_vec;

	case (grant_posn_r)
		2'd0: relative_req_vec = {i_req_vec[0], i_req_vec[2 : 1]};
		2'd1: relative_req_vec = {i_req_vec[1 : 0], i_req_vec[2]};
		2'd2: relative_req_vec = i_req_vec[2 : 0];
		default: begin end
	endcase
end

always @(*) begin
	arb_state_nxt = arb_state_cur;
	grant_posn_nxt = grant_posn_r;
	gnt_vec_nxt = gnt_vec_r;

	case (1'b1)
		arb_state_cur[ARB_IDLE_ID]: begin
			if((~(|gnt_vec_r)) || (~(|(i_end_access_vec & i_req_vec)))) begin
				if(any_req_asserted) begin
					arb_state_nxt = ARB_STATE_END_ACCESS;
				end

				if(relative_req_vec[0]) begin
					case (grant_posn_r) 
						2'd0: gnt_vec_nxt = 3'b010;
						2'd1: gnt_vec_nxt = 3'b100;
						2'd2: gnt_vec_nxt = 3'b001;
						default: begin end
					endcase

					case (grant_posn_r)
						2'd0: grant_posn_nxt = 2'd1;
						2'd1: grant_posn_nxt = 2'd2;
						2'd2: grant_posn_nxt = 2'd0;
						default: begin end
					endcase
				end
				else if(relative_req_vec[1]) begin
					case (grant_posn_r) 
						2'd0: gnt_vec_nxt = 3'b100;
						2'd1: gnt_vec_nxt = 3'b001;
						2'd2: gnt_vec_nxt = 3'b010;
						default: begin end
					endcase

					case (grant_posn_r)
						2'd0: grant_posn_nxt = 2'd2;
						2'd1: grant_posn_nxt = 2'd0;
						2'd2: grant_posn_nxt = 2'd1;
						default: begin end
					endcase
				end
				else if(relative_req_vec[2]) begin
					case (grant_posn_r) 
						2'd0: gnt_vec_nxt = 3'b001;
						2'd1: gnt_vec_nxt = 3'b010;
						2'd2: gnt_vec_nxt = 3'b100;
						default: begin end
					endcase

					case (grant_posn_r)
						2'd0: grant_posn_nxt = 2'd0;
						2'd1: grant_posn_nxt = 2'd1;
						2'd2: grant_posn_nxt = 2'd2;
						default: begin end
					endcase
				end
				else begin
					gnt_vec_nxt = 3'd0;
				end
			end
		end
		arb_state_cur[ARB_END_ACCESS_ID]: begin
			if((~(|(i_end_access_vec & gnt_vec_r)))) begin
				arb_state_nxt = ARB_STATE_IDLE;

				if(relative_req_vec[0]) begin
					case (grant_posn_r)
						2'd0: gnt_vec_nxt = 3'b010;
						2'd1: gnt_vec_nxt = 3'b100;
						2'd2: gnt_vec_nxt = 3'b001;
						default: begin end
					endcase

					case (grant_posn_r)
						2'd0: grant_posn_nxt = 3'd1;
						2'd1: grant_posn_nxt = 3'd2;
						2'd2: grant_posn_nxt = 3'd0;
						default: begin end
					endcase
				end
				else if(relative_req_vec[1]) begin
					case (grant_posn_r)
						2'd0: gnt_vec_nxt = 3'b100;
						2'd1: gnt_vec_nxt = 3'b001;
						2'd2: gnt_vec_nxt = 3'b010;
						default: begin end
					endcase

					case (grant_posn_r)
						2'd0: grant_posn_nxt = 3'd2;
						2'd1: grant_posn_nxt = 3'd0;
						2'd2: grant_posn_nxt = 3'd1;
						default: begin end
					endcase
				end
				else if(relative_req_vec[2]) begin
					case (grant_posn_r)
						2'd0: gnt_vec_nxt = 3'b001;
						2'd1: gnt_vec_nxt = 3'b010;
						2'd2: gnt_vec_nxt = 3'b100;
						default: begin end
					endcase

					case (grant_posn_r)
						2'd0: grant_posn_nxt = 3'd0;
						2'd1: grant_posn_nxt = 3'd1;
						2'd2: grant_posn_nxt = 3'd2;
						default: begin end
					endcase
				end
				else begin
					gnt_vec_nxt = 3'd0;
				end
			end
		end
		default: begin end
	endcase 
end

/*
always @(posedge clk or negedge rst_n) begin
	if(~rst_n) begin
		 arb_state_cur <= ARB_STATE_IDLE;
		 gnt_vec_r <= 'd0;
		 grant_posn_r <= 'd2;
	end else begin
		 arb_state_cur <= arb_state_nxt;
		 gnt_vec_r <= gnt_vec_nxt;
		 grant_posn_r <= grant_posn_nxt;
	end
end
*/

gnrl_dffr #( 
	.DATA_WIDTH   (3),
	.INITIAL_VALUE(0)
) gnt_vec_dffr (gnt_vec_nxt, gnt_vec_r, clk, rst_n);


gnrl_dffr #( 
	.DATA_WIDTH   (2),
	.INITIAL_VALUE(2)
) grant_posn_dffr (grant_posn_nxt, grant_posn_r, clk, rst_n);

endmodule 	//	gnrl_arb


`endif 	/*	!__GNRL_ARB_V__!	*/