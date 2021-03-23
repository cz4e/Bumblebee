`ifdef __INCLUDE_CSR_DEFS_V__

`define CSR_ADDR_WIDTH          12              /*  CSR address space.                          */
`define CSR_DATA_WIDTH          32              /*  CSR data width.                             */
`define CSR_SATP_WIDTH          32              /*  satp register width.                        */
`define CSR_MXLEN               32              /*  M-mode length.                              */
`define CSR_SXLEN               32              /*  S-mode length.                              */
`define CSR_UXLEN               32              /*  U-mode length.                              */


`define CSR_USTATUS_ADDR        12'h000         /*  User status register.                       */
`define CSR_UIE_ADDR            12'h004         /*  User interrupt-enable register.             */
`define CSR_UTVEC_ADDR          12'h005         /*  User trap handler base address.             */
`define CSR_USCRATCH_ADDR       12'h040         /*  Scratch register for user trap handlers.    */
`define CSR_UEPC_ADDR           12'h041         /*  User exception program counter.             */
`define CSR_UCAUSE_ADDR         12'h042         /*  User trap cause.                            */
`define CSR_UTVAL_ADDR          12'h043         /*  User bad address or instruction.            */
`define CSR_UIP_ADDR            12'h044         /*  User interrupt pending.                     */

`define CSR_CYCLE_ADDR          12'hc00         /*  Cycle counter for RDCYCLE instruction.      */
`define CSR_CYCLEH_ADDR         12'hc1f         /*  Upper 32 bits for cycle.                    */
`define CSR_TIME_ADDR           12'hc01         /*  Timer for RDTIME instruction.               */
`define CSR_TIMEH_ADDR          12'hc80         /*  Upper 32 bits of time.                      */
`define CSR_INSTRET_ADDR        12'hc02         /*  Instructions-retire counter for RDINSRET.   */
`define CSR_INSTRETH_ADDR       12'hc82         /*  Upper 32 bits of instreth.                  */

`define CSR_SSTATUS_ADDR        12'h100         /*  Supervisor status register.                 */
`define CSR_SEDELEG_ADDR        12'h102         /*  Supervisor exception delegation register.   */
`define CSR_SIDELEG_ADDR        12'h103         /*  Supervisor interrupt delegation register.   */
`define CSR_SIE_ADDR            12'h104         /*  Supervisor interrupt-enable register.       */
`define CSR_STVEC_ADDR          12'h105         /*  Supervisor trap handler base address.       */
`define CSR_SCOUNTEREN_ADDR     12'h106         /*  Supervisor counter enable.                  */

`define CSR_SSCRATCH_ADDR       12'h140         /*  Scratch register for supervisor trap handler.*/
`define CSR_SEPC_ADDR           12'h141         /*  Supervisor exception program counter.       */
`define CSR_SCAUSE_ADDR         12'h142         /*  Supervisor trap cause.                      */
`define CSR_STVEC_ADDR          12'h143         /*  Supervisor bad address or instruction.      */
`define CSR_SIP_ADDR            12'h144         /*  Supervisor interrupt pending.               */
`define CSR_SATP_WIDTH          12'h180         /*  Supervisor address translation and protection.*/

`define CSR_MVENDORID_ADDR      12'hf11         /*  Vendor ID.                                  */
`define CSR_MARCHID_ADDR        12'hf12         /*  Architecture ID.                            */
`define CSR_MIMPID_ADDR         12'hf13         /*  Implementation ID.                          */
`define CSR_MHARTID_ADDR        12'hf14         /*  Hardware thread ID.                         */

`define CSR_MSTATUS_ADDR        12'h300         /*  Machine status register.                    */
`define CSR_MISA_ADDR           12'h301         /*  ISA and extensions.                         */
`define CSR_MEDELEG_ADDR        12'h302         /*  Machine exception delegation register.      */
`define CSR_MIDELEG_ADDR        12'h303         /*  Machine interrupt delegation register.      */
`define CSR_MIE_ADDR            12'h304         /*  Machine interrupt-enable register.          */
`define CSR_MTVEC_ADDR          12'h305         /*  Machine trap-handler base address.          */
`define CSR_MCOUNTEREN_ADDR     12'h306         /*  Machine counter enable.                     */
`define CSR_MSTATUSH_ADDR       12'h310         /*  Additional machine status register.         */
`define CSR_MSCRATCH_ADDR       12'h340         /*  Scratch register for machine trap handler.  */
`define CSR_MEPC_ADDR           12'h341         /*  Machine exception program counter.          */
`define CSR_MCAUSE_ADDR         12'h342         /*  Machine trap cause.                         */
`define CSR_MTVAL_ADDR          12'h343         /*  Machine bad address or instruction.         */
`define CSR_MIP_ADDR            12'h344         /*  Machine interrupt pending.                  */
`define CSR_MTINST_ADDR         12'h34a         /*  Machine trap instruction.                   */
`define CSR_MCYCLE_ADDR         12'hb00         /*  Machine cycle counter.                      */
`define CSR_MINSTRET_ADDR       12'hb02         /*  Machine instructions-retired counter.       */
`define CSR_CYCLEH_ADDR         12'hb80         /*  Upper 32 bits of mcycle.                    */
`define CSR_MINSTRETH_ADDR      12'hb82         /*  Upper 32 bits of minstret.                  */

`endif  /*  !__INCLUDE_CSR_DEFS_V__!    */