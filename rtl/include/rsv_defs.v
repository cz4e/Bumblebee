`ifdef __INCLUDE_RSV_DEFS_V__

`define RSV_IDX_WIDTH           6                               /*  Rsv index width.    */
`define RSV_ENTRY_NUMS          64                              /*  Rsv entry nums.     */
`define RSV_DATA_WIDTH          ( `ROB_ID_WIDTH                 /*  Rob id width.       */
                                + 1                             /*  Load valid.         */
                                + `LBUFF_ID_WIDTH               /*  Load id width.      */
                                + 1                             /*  Store valid.        */
                                + `SBUFF_ID_WIDTH               /*  Store id width.     */
                                + `DECINFO_WIDTH                /*  Decode info width.  */
                                + `PREDINFO_WIDTH               /*  Predict info width. */
                                + 1                             /*  Dest valid.         */
                                + `PRF_CODE_WIDTH               /*  Dest prf code.      */
                                + 1                             /*  Instruction length. */
                                + `IMM_WIDTH                    /*  Imm length.         */
                                + `EXCEPTION_CODE_WIDTH)        /*  Exception code.     */



`endif  /*  !__INCLUDE_RSV_DEFS_V__!    */