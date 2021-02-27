`ifdef __INCLUDE_DEC_DEFS_V__

`define UOP_INFO_BUS_WIDTH                  32
`define UOP_EXEC_WIDTH                      6
`define UOPINFO_EXEC_UNIT                   5 : 0
`define UOPINFO_BJP                         6'b000001
`define UOPINFO_ALU                         6'b000010
`define UOPINFO_MULDIV                      6'b000100
`define UOPINFO_CSR                         6'b001000
`define UOPINFO_AGU                         6'b010000
`define UOPINFO_FPU                         6'b100000

`define UOPINFO_BJP_JUMP                    6
`define UOPINFO_BJP_BEQ                     7
`define UOPINFO_BJP_BNE                     8
`define UOPINFO_BJP_BLT                     9
`define UOPINFO_BJP_BGE                     10
`define UOPINFO_BJP_MRET                    11
`define UOPINFO_BJP_SRET                    12
`define UOPINFO_BJP_URET                    13

`define UOPINFO_ALU_ADD                     6
`define UOPINFO_ALU_SUB                     7
`define UOPINFO_ALU_SLT                     8
`define UOPINFO_ALU_SRL                     9
`define UOPINFO_ALU_SRA                     10
`define UOPINFO_ALU_XOR                     11
`define UOPINFO_ALU_SLL                     12
`define UOPINFO_ALU_OR                      13
`define UOPINFO_ALU_AND                     14
`define UOPINFO_ALU_LUI                     15
`define UOPINFO_ALU_NOP                     16
`define UOPINFO_ALU_FENCE                   17
`define UOPINFO_ALU_FENCE_I                 18
`define UOPINFO_ALU_ECALL                   19
`define UOPINFO_ALU_EBRK                    20
`define UOPINFO_ALU_WFI                     21
`define UOPINFO_ALU_SFENCE_VMA              22
`define UOPINFO_ALU_SYNC_FENCE              23

`define UOPINFO_MULDIV_MUL                  6
`define UOPINFO_MULDIV_MULH                 7
`define UOPINFO_MULDIV_MULHU                8
`define UOPINFO_MULDIV_MULHSU               9
`define UOPINFO_MULDIV_DIV                  10
`define UOPINFO_MULDIV_DIVU                 11
`define UOPINFO_MULDIV_REM                  12
`define UOPINFO_MULDIV_REMU                 13

`define UOPINFO_CSR_CSRRW                   6
`define UOPINFO_CSR_CSRRS                   7
`define UOPINFO_CSR_CSRRC                   8
`define UOPINFO_CSR_ZIMM                    9
`define UOPINFO_CSR_RS1IS0                  10
`define UOPINFO_CSR_ADDR                    22 : 11
`define UOPINFO_ALU_SYNC_CSR                23

`define UOPINFO_AGU_LOAD                    6
`define UOPINFO_AGU_STORE                   7
`define UOPINFO_AGU_SIZE                    9 : 8
`define UOPINFO_AGU_USIGN                   10
`define UOPINFO_AGU_EXCL                    11
`define UOPINFO_AGU_AMOSWAPW                12
`define UOPINFO_AGU_AMOADDW                 13
`define UOPINFO_AGU_AMOXORW                 14
`define UOPINFO_AGU_AMOANDW                 15
`define UOPINFO_AGU_AMOORW                  16
`define UOPINFO_AGU_AMOMINW                 17
`define UOPINFO_AGU_AMOMAXW                 18
`define UOPINFO_AGU_AMOMINUW                19
`define UOPINFO_AGU_AMOMAXUW                20

`define UOPINFO_FPU_PRECSION                7 : 6
`define UOPINFO_FPU_FMADDS                  8
`define UOPINFO_FPU_FMSUBS                  9
`define UOPINFO_FPU_FNMSUBS                 10
`define UOPINFO_FPU_FNMADDS                 11
`define UOPINFO_FPU_ADDS                    12
`define UOPINFO_FPU_SUBS                    13
`define UOPINFO_FPU_MULS                    14
`define UOPINFO_FPU_DIVS                    15
`define UOPINFO_FPU_SQRTS                   16
`define UOPINFO_FPU_SGNJS                   17
`define UOPINFO_FPU_SGNJNS                  18
`define UOPINFO_FPU_MINS                    19
`define UOPINFO_FPU_MAXS                    20
`define UOPINFO_FPU_CVTWS                   21
`define UOPINFO_FPU_CVTWUS                  22
`define UOPINFO_FPU_MVXW                    23
`define UOPINFO_FPU_FEQS                    24
`define UOPINFO_FPU_FLTS                    25
`define UOPINFO_FPU_FLES                    26
`define UOPINFO_FPU_CLASSS                  27
`define UOPINFO_FPU_CVTSW                   28
`define UOPINFO_FPU_CVTSWU                  29
`define UOPINFO_FPU_MVWX                    30

`define DECINFO_ILGL                        0
`define DECINFO_EXCEPT                      3 : 1
`define DECINFO_LEN                         4
`define DECINFO_RS1_VLD                     5
`define DECINFO_RS1_CODE                    10 : 6
`define DECINFO_RS2_VLD                     11
`define DECINFO_RS2_CODE                    16 : 12
`define DECINFO_RS3_VLD                     17
`define DECINFO_RS3_CODE                    22 : 18
`define DECINFO_RD_VLD                      23
`define DECINFO_RD_CODE                     28 : 24
`define DECINFO_IMM_VLD                     29
`define DECINFO_IMM                         61 : 30
`define DECINFO_EXEC_CYCLE                  66 : 62
`define DECINFO_INFO_BUS                    98 : 67
`define DECINFO_WIDTH                       99

`endif  /*  !__INCLUDE_DEC_DEFS_V__!    */
