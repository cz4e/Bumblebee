`ifdef __GNRL_XCHECKER_V__

//synopsys translate_off
module gnrl_xchecker_module # (
  parameter DATA_WIDTH = 32
) (
  input  [DATA_WIDTH - 1:0] i_dat,
  input                     clk
);


CHECK_THE_X_VALUE:
  assert property (@(posedge clk) 
                     ((^(i_dat)) !== 1'bx)
                  )
  else $fatal ("\n Error: Oops, detected a X value!!! This should never happen. \n");

endmodule
//synopsys translate_on

`endif  /*  !__GNRL_XCHECKER_V__!   */