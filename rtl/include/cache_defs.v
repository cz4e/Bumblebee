`ifdef __INCLUDE_CACHE_DEFS_V__

`define ICACHE_IDX_WIDTH        8       /*  ICACHE index width (paddr[13 : 6]).     */
`define ICACHE_TAG_WIDTH        20      /*  ICACHE tag width (paddr[33 : 14]).      */
`define ICACHE_DATA_WIDTH       512     /*  ICACHE cacheline (64byte).              */

`define ITLB_IDX_WIDTH          3       /*  ITLB index width.                       */
`define ITLB_TAG_WIDTH          28      /*  ITLB tag width.                         */
`define ITLB_DATA_WIDTH         28      /*  ITLB data width.                        */


`endif  /*  !__INCLUDE_CACHE_DEFS_V__!  */