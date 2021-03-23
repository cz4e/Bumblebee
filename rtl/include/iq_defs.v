`ifdef __INCLUDE_IQ_V__

`define IQ_PREDINFO_WIDTH           ( 1                             /*  BTAC read hit.              */  
                                    + 2                             /*  BTAC read way.              */
                                    + 11                            /*  PHT read index.             */
                                    + 2                             /*  PHT read entry.             */
                                    + 1                             /*  Instruction length.         */
                                    + 33                            /*  BTAC read data.             */
                                    + 1)                            /*  IQ taken.                   */
`define IQ_ENTRY_WIDTH              (`INSTR_WIDTH                   /*  Instruction.                */
                                    + `CORE_PC_WIDTH                /*  IQ instruction addr.        */
                                    + `CORE_PC_WIDTH                /*  IQ BTAC taddr.              */
                                    + `IQ_PREDINFO_WIDTH            /*  IQ predinfo.                */
                                    + `EXCEPTION_CODE_WIDTH         /*  Exception code.             */
                                    + 1)                            /*  Instruction type.           */

`define PREDINFO_WIDTH              ( 1
                                    + 1
                                    + 2
                                    + 11
                                    + 2
                                    + 1
                                    + 1)
`endif  /*  !__INCLUDE_IQ_V__!  */