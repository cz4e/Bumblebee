`ifdef __INCLUDE_ROB_DEFS_V__

`define ROB_INST_INFO_WIDTH       ( 1
                                  + `ARF_CODE_WIDTH 
                                  + `PRF_CODE_WIDTH
                                  + `PRF_CODE_WIDTH
                                  + 1
                                  + `LBUFF_ID_WIDTH
                                  + 1
                                  + `SBUFF_ID_WIDTH
                                  + `DECINFO_WIDTH
                                  + `PREDINFO_WIDTH
                                  + 1 
                                  + `INSTR_WIDTH) 

`define ROB_INST_INFO_INST       `INSTR_WIDTH - 1 : 0
`define ROB_INST_INFO_LEN        32
`define ROB_INST_INFO_PREDINFO   51 : 33
`define ROB_INST_INFO_DECINFO    83 : 52
`define ROB_INST_INFO_SBUFF_ID   89 : 84
`define ROB_INST_INFO_SBUFF_VLD  90
`define ROB_INST_INFO_LBUFF_ID   96 : 91
`define ROB_INST_INFO_LBUFF_VLD  97
`define ROB_INST_INFO_PPRF       104 : 98
`define ROB_INST_INFO_PRF        111 : 105
`define ROB_INST_INFO_ARF        116 : 112
`define ROB_INST_INFO_DST_VLD    117

`endif  /*  !__INCLUDE_ROB_DEFS_V__!    */