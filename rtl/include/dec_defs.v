`ifdef __INCLUDE_DEC_DEFS_V__

`define DECINFO_WIDTH                       32
`define EXEC_UNIT_WIDTH                     6
`define DECINFO_EXEC_UNIT                   5 : 0
`define DECINFO_BJP                         6'b000001
`define DECINFO_ALU                         6'b000010
`define DECINFO_MULDIV                      6'b000100
`define DECINFO_CSR                         6'b001000
`define DECINFO_AGU                         6'b010000
`define DECINFO_FPU                         6'b100000

`define DECINFO_BJP_JUMP                    6
`define DECINFO_BJP_BEQ                     7
`define DECINFO_BJP_BNE                     8
`define DECINFO_BJP_BLT                     9
`define DECINFO_BJP_BGE                     10
`define DECINFO_BJP_MRET                    11
`define DECINFO_BJP_SRET                    12
`define DECINFO_BJP_URET                    13

`define DECINFO_ALU_ADD                     6
`define DECINFO_ALU_SUB                     7
`define DECINFO_ALU_SLT                     8
`define DECINFO_ALU_SRL                     9
`define DECINFO_ALU_SRA                     10
`define DECINFO_ALU_XOR                     11
`define DECINFO_ALU_SLL                     12
`define DECINFO_ALU_OR                      13
`define DECINFO_ALU_AND                     14
`define DECINFO_ALU_LUI                     15
`define DECINFO_ALU_NOP                     16
`define DECINFO_ALU_FENCE                   17
`define DECINFO_ALU_FENCE_I                 18
`define DECINFO_ALU_ECALL                   19
`define DECINFO_ALU_EBRK                    20
`define DECINFO_ALU_WFI                     21
`define DECINFO_ALU_SFENCE_VMA              22
`define DECINFO_ALU_SYNC_FENCE              23

`define DECINFO_MULDIV_MUL                  6
`define DECINFO_MULDIV_MULH                 7
`define DECINFO_MULDIV_MULHU                8
`define DECINFO_MULDIV_MULHSU               9
`define DECINFO_MULDIV_DIV                  10
`define DECINFO_MULDIV_DIVU                 11
`define DECINFO_MULDIV_REM                  12
`define DECINFO_MULDIV_REMU                 13

`define DECINFO_CSR_CSRRW                   6
`define DECINFO_CSR_CSRRS                   7
`define DECINFO_CSR_CSRRC                   8
`define DECINFO_CSR_ZIMM                    9
`define DECINFO_CSR_RS1IS0                  10
`define DECINFO_CSR_ADDR                    22 : 11
`define DECINFO_ALU_SYNC_CSR                23

`define DECINFO_AGU_LOAD                    6
`define DECINFO_AGU_STORE                   7
`define DECINFO_AGU_SIZE                    9 : 8
`define DECINFO_AGU_USIGN                   10
`define DECINFO_AGU_EXCL                    11
`define DECINFO_AGU_AMOSWAPW                12
`define DECINFO_AGU_AMOADDW                 13
`define DECINFO_AGU_AMOXORW                 14
`define DECINFO_AGU_AMOANDW                 15
`define DECINFO_AGU_AMOORW                  16
`define DECINFO_AGU_AMOMINW                 17
`define DECINFO_AGU_AMOMAXW                 18
`define DECINFO_AGU_AMOMINUW                19
`define DECINFO_AGU_AMOMAXUW                20

`define DECINFO_FPU_PRECSION                7 : 6
`define DECINFO_FPU_FMADDS                  8
`define DECINFO_FPU_FMSUBS                  9
`define DECINFO_FPU_FNMSUBS                 10
`define DECINFO_FPU_FNMADDS                 11
`define DECINFO_FPU_ADDS                    12
`define DECINFO_FPU_SUBS                    13
`define DECINFO_FPU_MULS                    14
`define DECINFO_FPU_DIVS                    15
`define DECINFO_FPU_SQRTS                   16
`define DECINFO_FPU_SGNJS                   17
`define DECINFO_FPU_SGNJNS                  18
`define DECINFO_FPU_MINS                    19
`define DECINFO_FPU_MAXS                    20
`define DECINFO_FPU_CVTWS                   21
`define DECINFO_FPU_CVTWUS                  22
`define DECINFO_FPU_MVXW                    23
`define DECINFO_FPU_FEQS                    24
`define DECINFO_FPU_FLTS                    25
`define DECINFO_FPU_FLES                    26
`define DECINFO_FPU_CLASSS                  27
`define DECINFO_FPU_CVTSW                   28
`define DECINFO_FPU_CVTSWU                  29
`define DECINFO_FPU_MVWX                    30


`endif  /*  !__INCLUDE_DEC_DEFS_V__!    */
