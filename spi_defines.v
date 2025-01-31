// -------------------------------------------------------------------------------


`define SPI_DIVIDER_LEN_8

//`define SPI_DIVIDER_LEN_16
//`define SPI_DIVIDER_LEN_24
//`define SPI_DIVIDER_LEN_32

`ifdef SPI_DIVIDER_LEN_8
`define SPI_DIVIDER_LEN    2   //can be set from 1 to 8
//`define SPI_DIVIDER_LEN   4  //can be set from 1 to 8
`endif

`ifdef SPI_DIVIDER_LEN_16
`define SPI_DIVIDER_LEN   16 //can be set from 1 to 16
`endif

`ifdef SPI_DIVIDER_LEN_24 
`define SPI_DIVIDER_LEN    24  //can be set from 1 to 24
`endif

`ifdef SPI_DIVIDER_LEN_32
`define SPI_DIVIDER_LEN   32  //can be set from 1 to 32
`endif

//------------------------------------------------------------------------------------------


// Maximum number of bits that can be send/received at once
// Use SPI_MAX_CHAR for fine tuning the exact number when using
// SPI_MAX_CHAR_128, SPI_MAX_CHAR_64, SPI_MAX_CHAR_32,                 
//SPI_MAX_CHAR_24,SPI_MAX_CHAR_16,
 // SPI_MAX_CHAR_8     


//`define SPI_MAX_CHAR_128
//`define SPI_MAX_CHAR_64
//`define SPI_MAX_CHAR_32
//`define SPI_MAX_CHAR_24
//`define SPI_MAX_CHAR_16
//`define SPI_MAX_CHAR_8

`define SPI_MAX_CHAR_8

`ifdef SPI_MAX_CHAR_128
  `define SPI_MAX_CHAR          128 // can be set to 128
  `define SPI_CHAR_LEN_BITS     7  
`endif

`ifdef SPI_MAX_CHAR_64
  `define SPI_MAX_CHAR          64 // can be set to 128
  `define SPI_CHAR_LEN_BITS     6  
`endif

`ifdef SPI_MAX_CHAR_32
  `define SPI_MAX_CHAR          32 // can be set to 128
  `define SPI_CHAR_LEN_BITS     5  
`endif

`ifdef SPI_MAX_CHAR_24
  `define SPI_MAX_CHAR          24 // can be set to 128
  `define SPI_CHAR_LEN_BITS     5  
`endif

`ifdef SPI_MAX_CHAR_16
  `define SPI_MAX_CHAR          16 // can be set to 128
  `define SPI_CHAR_LEN_BITS     4  
`endif

`ifdef SPI_MAX_CHAR_8
  `define SPI_MAX_CHAR          7 // can be set to 128
  `define SPI_CHAR_LEN_BITS     3  
`endif


//------------------------------------------------------------------------------------------

// Number of device select signals. Use SPI_SS_NB for fine tuning the exact number

`define SPI_SS_NB_8
//`define SPI_SS_NB_16
//`define SPI_SS_NB_24
//`define SPI_SS_NB_32


`ifdef SPI_SS_NB_8
`define SPI_SS_NB    8  //can be set from 1 to 8
`endif

`ifdef SPI_SS_NB_16
`define SPI_SS_NB   16  //can be set from 9 to 16
`endif

`ifdef SPI_SS_NB_24
`define SPI_SS_NB   24   //can be set from 17 to 24
`endif

`ifdef SPI_SS_NB_32
`define SPI_SS_NB   32   //can be set from 25 to 32
`endif


// -----------------------------------------------------------------

// Bits of WISHBONE address used for partial decoding of SPI registers
// `define SPI_OFS_BITS  4:2

// Register offset


//here lower bits are configurable the upper bits are reserved

`define SPI_RX_0      5'b00000
`define SPI_RX_1      5'b00100
`define SPI_RX_2      5'b01000
`define SPI_RX_3      5'b01100
`define SPI_TX_0      5'b00000
`define SPI_TX_1      5'b00100
`define SPI_TX_2      5'b01000
`define SPI_TX_3      5'b01100
`define SPI_CTRL      5'b10000
`define SPI_DIVIDE    5'b10100
`define SPI_SS        5'b11000 


// ----------------------------------------------------------------------------


//Number of bits in the control register

`define SPI_CTRL_BIT_NB     14

//Control regitser bit position

`define SPI_CTRL_ASS        13
`define SPI_CTRL_IE         12
`define SPI_CTRL_LSB        11
`define SPI_CTRL_TX_NEGEDGE 10
`define SPI_CTRL_RX_NEGEDGE 9
`define SPI_CTRL_GO         8
`define SPI_CTRL_RES_1      7
`define SPI_CTRL_CHAR_LEN   6:0

// -------------------------------------------------------------------------------