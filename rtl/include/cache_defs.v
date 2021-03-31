`ifdef __INCLUDE_CACHE_DEFS_V__

`define ICACHE_IDX_WIDTH        8       /*  ICACHE index width (paddr[13 : 6]).     */
`define ICACHE_TAG_WIDTH        20      /*  ICACHE tag width (paddr[33 : 14]).      */
`define ICACHE_DATA_WIDTH       512     /*  ICACHE cacheline (64byte).              */

`define ITLB_IDX_WIDTH          3       /*  ITLB index width.                       */
`define ITLB_TAG_WIDTH          28      /*  ITLB tag width.                         */
`define ITLB_DATA_WIDTH         28      /*  ITLB data width.                        */

`define DCACHE_IDX_WIDTH        8       /*  DCACHE index width (paddr[13 : 6]).     */
`define DCACHE_TAG_WIDTH        20      /*  DCACHE tag width (paddr[33 : 14]).      */
`define DCACHE_MASK_WIDTH       64      /*  DCACHE write mask width.                */
`define DCACHE_DATA_WIDTH       512     /*  DCACHE data width.                      */

`define DTLB_IDX_WIDTH          3       /*  DTLB index width. (paddr[14 : 12])      */
`define DTLB_TAG_WIDTH          28      /*  DTLB tag width.                         */
`define DTLB_DATA_WIDTH         29      /*  DTLB data width.                        */

`define PTE_CACHE_IDX_WIDTH     9       /*  PTE_CACHE index width.                  */
`define PTE_CACHE_TAG_WIDTH     23      /*  PTE_CACHE tag width.                    */
`define PTE_CACHE_DATA_WIDTH    32      /*  PTE_CACHE data width.                   */

`endif  /*  !__INCLUDE_CACHE_DEFS_V__!  */