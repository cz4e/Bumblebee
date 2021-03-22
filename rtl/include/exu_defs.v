`ifdef __INCLUDE_EXU_DEFS_V__

`define AGU_INFO_WIDTH              ( 1
                                    + `PRF_DATA_WIDTH
                                    + 1
                                    + `PRF_DATA_WIDTH
                                    + 1
                                    + `PRF_DATA_WIDTH
                                    + 1
                                    + `PRF_CODE_WIDTH
                                    + `ROB_ID_WIDTH
                                    + 1
                                    + `LBUFF_ID_WIDTH
                                    + 1
                                    + `SBUFF_ID_WIDTH
                                    + `DECINFO_WIDTH
                                    + `EXCEPTION_CODE_WIDTH
                                    + `IMM_WIDTH)

`define ALU_INFO_WIDTH               ( 1
                                    + `PRF_DATA_WIDTH
                                    + 1
                                    + `PRF_DATA_WIDTH
                                    + 1
                                    + `PRF_DATA_WIDTH
                                    + 1
                                    + `PRF_CODE_WIDTH
                                    + `ROB_ID_WIDTH
                                    + 1
                                    + `LBUFF_ID_WIDTH
                                    + 1
                                    + `IMM_WIDTH
                                    + `ROB_ID_WIDTH
                                    + `DECINFO_WIDTH
                                    + `CORE_PC_WIDTH
                                    + `EXCEPTION_CODE_WIDTH)

`define BJP_INFO_WIDTH              ( 1
                                    + `PRF_DATA_WIDTH
                                    + 1
                                    + `PRF_DATA_WIDTH
                                    + 1
                                    + `PRF_DATA_WIDTH
                                    + 1
                                    + `PRF_CODE_WIDTH
                                    + `ROB_ID_WIDTH
                                    + 1
                                    + `LBUFF_ID_WIDTH
                                    + 1
                                    + `IMM_WIDTH
                                    + `ROB_ID_WIDTH
                                    + `DECINFO_WIDTH
                                    + `PREDINFO_WIDTH
                                    + `EXCEPTION_CODE_WIDTH
                                    + 1
                                    + `CORE_PC_WIDTH
                                    + `CORE_PC_WIDTH)

`define MULDIV_INFO_WIDTH           ( 1
                                    + `PRF_DATA_WIDTH
                                    + 1
                                    + `PRF_DATA_WIDTH
                                    + 1
                                    + `PRF_DATA_WIDTH
                                    + 1
                                    + `PRF_CODE_WIDTH
                                    + `ROB_ID_WIDTH
                                    + 1
                                    + `LBUFF_ID_WIDTH
                                    + 1
                                    + `IMM_WIDTH
                                    + `ROB_ID_WIDTH
                                    + `DECINFO_WIDTH
                                    + `CORE_PC_WIDTH
                                    + `EXCEPTION_CODE_WIDTH)
`endif  /*  !__INCLUDE_EXU_DEFS_V__!    */