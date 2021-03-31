`ifdef __INCLUDE_ITLB_DEFS_V__

`define ITLB_IDX_WIDTH          3       /*  ITLB index width.           */
`define ITLB_TAG_WIDTH          28      /*  ITLB tag width.             */
`define ITLB_DATA_WIDTH         28      /*  ITLB data width.            */

`define L2TLB_IDX_WIDTH         8       /*  L2TLB index width.          */
`define L2TLB_TAG_WIDTH         23      /*  L2TLB tag width.            */
`define L2TLB_DATA_WIDTH        29      /*  L2TLB data width.           */
`define L2TLB_TLB_WIDTH         (`L2TLB_TAG_WIDTH + `L2TLB_DATA_WIDTH)
                                        /*  L2TLB tlb width.            */
                                        
`endif  /*  __INCLUDE_ITLB_DEFS_V__!    */