/*
*  File            :   dp_dmr_types.sv
*  Autor           :   Vlasov D.V.
*  Data            :   2019.05.08
*  Language        :   SystemVerilog
*  Description     :   This is debug module registers
*  Copyright(c)    :   2018 - 2019 Vlasov D.V.
*/

    // |  Name                                  | Address   | Line  | Used  |
    // | -------------------------------------- | --------- | ----- | ----- |
    // |  Abstract Data 0                       | ( 0x04 )  |    40 |   +   |
    // |  Abstract Data 1                       | ( 0x05 )  |    45 |   +   |
    // |  Debug Module Control                  | ( 0x10 )  |    50 |   +   |
    // |  Debug Module Status                   | ( 0x11 )  |    67 |   +   |
    // |  Hart Info                             | ( 0x12 )  |    91 |   +   |
    // |  Halt Summary 1                        | ( 0x13 )  |   101 |       |
    // |  Hart Array Window Select              | ( 0x14 )  |   106 |       |
    // |  Hart Array Window                     | ( 0x15 )  |   112 |       |
    // |  Abstract Control and Status           | ( 0x16 )  |   117 |   +   |
    // |  Abstract Command                      | ( 0x17 )  |   129 |   +   |
    // |  Abstract Command Autoexec             | ( 0x18 )  |   135 |   +   |
    // |  Configuration String Pointer 0        | ( 0x19 )  |   141 |       |
    // |  Next Debug Module                     | ( 0x1d )  |   146 |       |
    // |  Program Buffer 0                      | ( 0x20 )  |   151 |   +   |
    // |  Authentication Data                   | ( 0x30 )  |   157 |       |
    // |  Halt Summary 2                        | ( 0x34 )  |   162 |       |
    // |  Halt Summary 3                        | ( 0x35 )  |   167 |       |
    // |  System Bus Address 127:96             | ( 0x37 )  |   172 |       |
    // |  System Bus Access Control and Status  | ( 0x38 )  |   177 |       |
    // |  System Bus Address 31:0               | ( 0x39 )  |   196 |       |
    // |  System Bus Address 63:32              | ( 0x3a )  |   201 |       |
    // |  System Bus Address 95:64              | ( 0x3b )  |   206 |       |
    // |  System Bus Data 31:0                  | ( 0x3c )  |   211 |       |
    // |  System Bus Data 63:32                 | ( 0x3d )  |   216 |       |
    // |  System Bus Data 95:64                 | ( 0x3e )  |   221 |       |
    // |  System Bus Data 127:96                | ( 0x3f )  |   226 |       |
    // |  Halt Summary 0                        | ( 0x40 )  |   231 |   +   |

    // Abstract Data 0 ( 0x04 )
    typedef struct packed
    {
        logic   [31 : 0]    data;               // 31 .. 0
    } data0;
    // Abstract Data 1 ( 0x05 )
    typedef struct packed
    {
        logic   [31 : 0]    data;               // 31 .. 0
    } data1;
    // Debug Module Control ( 0x10 )
    typedef struct packed
    {
        logic   [0  : 0]    haltreq;            // 31
        logic   [0  : 0]    resumereq;          // 30
        logic   [0  : 0]    hartreset;          // 29
        logic   [0  : 0]    ackhavereset;       // 28
        logic   [0  : 0]    un_1;               // 27
        logic   [0  : 0]    hasel;              // 26
        logic   [9  : 0]    hartsello;          // 25 .. 16
        logic   [9  : 0]    hartselhi;          // 15 ..  6
        logic   [1  : 0]    un_0;               // 5  ..  4
        logic   [0  : 0]    setresethaltreq;    // 3
        logic   [0  : 0]    clrresethaltreq;    // 2
        logic   [0  : 0]    ndmreset;           // 1
        logic   [0  : 0]    dmactive;           // 0
    } dmcontrol;  
    // Debug Module Status ( 0x11 )
    typedef struct packed
    {
        logic   [8  : 0]    un_1;               // 31 .. 23
        logic   [0  : 0]    impebreak;          // 22
        logic   [1  : 0]    un_0;               // 21 .. 20
        logic   [0  : 0]    allhavereset;       // 19
        logic   [0  : 0]    anyhavereset;       // 18
        logic   [0  : 0]    allresumeack;       // 17
        logic   [0  : 0]    anyresumeack;       // 16
        logic   [0  : 0]    allnonexistent;     // 15
        logic   [0  : 0]    anynonexistent;     // 14
        logic   [0  : 0]    allunavail;         // 13
        logic   [0  : 0]    anyunavail;         // 12
        logic   [0  : 0]    allrunning;         // 11
        logic   [0  : 0]    anyrunning;         // 10
        logic   [0  : 0]    allhalted;          // 9
        logic   [0  : 0]    anyhalted;          // 8
        logic   [0  : 0]    authenticated;      // 7
        logic   [0  : 0]    authbusy;           // 6
        logic   [0  : 0]    hasresethaltreq;    // 5
        logic   [0  : 0]    confstrptrvalid;    // 4
        logic   [3  : 0]    version;            // 3  ..  0
    } dmstatus;  
    // Hart Info ( 0x12 )
    typedef struct packed
    {
        logic   [7  : 0]    un_1;               // 31 .. 24
        logic   [3  : 0]    nscratch;           // 23 .. 20
        logic   [2  : 0]    un_0;               // 19 .. 17
        logic   [0  : 0]    dataaccess;         // 16
        logic   [3  : 0]    datasize;           // 15 .. 12
        logic   [11 : 0]    dataaddr;           // 11 ..  0
    } hartinfo;  
    // Halt Summary 1 ( 0x13 )
    typedef struct packed
    {
        logic   [31 : 0]    haltsum1_i;         // 31 .. 0
    } haltsum1;
    // Hart Array Window Select ( 0x14 )
    typedef struct packed
    {
        logic   [16 : 0]    un_0;               // 31 .. 15
        logic   [14 : 0]    hawindowsel;        // 14 ..  0
    } hawindowsel; 
    // Hart Array Window ( 0x15 )
    typedef struct packed
    {
        logic   [31 : 0]    maskdata;           // 31 .. 0
    } hawindow;
    // Abstract Control and Status ( 0x16 )
    typedef struct packed
    {
        logic   [2  : 0]    un_3;               // 31 .. 29
        logic   [4  : 0]    progbufsize;        // 28 .. 24
        logic   [10 : 0]    un_2;               // 23 .. 13
        logic   [0  : 0]    busy;               // 12
        logic   [0  : 0]    un_1;               // 11
        logic   [2  : 0]    cmderr;             // 10 ..  8
        logic   [3  : 0]    un_0;               // 7  ..  4
        logic   [3  : 0]    datacount;          // 3  ..  0
    } abstractcs; 
    // Abstract Command ( 0x17 )
    typedef struct packed
    {
        logic   [7  : 0]    cmdtype;            // 31 .. 24
        logic   [23 : 0]    control;            // 23 ..  0
    } command;
    // Abstract Command Autoexec ( 0x18 )
    typedef struct packed
    {
        logic   [15 : 0]    autoexecprogbuf;    // 31 .. 16
        logic   [3  : 0]    un_0;               // 15 .. 12
        logic   [11 : 0]    autoexecdata;       // 11 ..  0
    } abstractauto;
    // Configuration String Pointer 0 ( 0x19 )
    typedef struct packed
    {
        logic   [31 : 0]    addr;               // 31 .. 0
    } confstrptr0;
    // Next Debug Module ( 0x1d )
    typedef struct packed
    {
        logic   [31 : 0]    addr;               // 31 .. 0
    } nextdm;
    // Program Buffer 0 ( 0x20 )
    typedef struct packed
    {
        logic   [31 : 0]    data;               // 31 .. 0
    } progbuf0;
    // Authentication Data ( 0x30 )
    typedef struct packed
    {
        logic   [31 : 0]    data;               // 31 .. 0
    } authdata;
    // Halt Summary 2 ( 0x34 )
    typedef struct packed
    {
        logic   [31 : 0]    haltsum2_i;         // 31 .. 0
    } haltsum2;
    // Halt Summary 3 ( 0x35 )
    typedef struct packed
    {
        logic   [31 : 0]    haltsum3_i;         // 31 .. 0
    } haltsum3;
    // System Bus Address 127:96 ( 0x37 )
    typedef struct packed
    {
        logic   [31 : 0]    address;            // 31 .. 0
    } sbaddress3;
    // System Bus Access Control and Status ( 0x38 )
    typedef struct packed
    {
        logic   [2  : 0]    sbversion;          // 31 .. 29
        logic   [5  : 0]    un_0;               // 28 .. 23
        logic   [0  : 0]    sbbusyerror;        // 22
        logic   [0  : 0]    sbbusy;             // 21
        logic   [0  : 0]    sbreadonaddr;       // 20
        logic   [2  : 0]    sbaccess;           // 19 .. 17
        logic   [0  : 0]    sbautoincrement;    // 16
        logic   [0  : 0]    sbreadondata;       // 15
        logic   [2  : 0]    sberror;            // 14 .. 12
        logic   [6  : 0]    sbasize;            // 11 ..  5
        logic   [0  : 0]    sbaccess128;        // 4
        logic   [0  : 0]    sbaccess64;         // 3
        logic   [0  : 0]    sbaccess32;         // 2
        logic   [0  : 0]    sbaccess16;         // 1
        logic   [0  : 0]    sbaccess8;          // 0
    } sbcs;
    // System Bus Address 31:0 ( 0x39 )
    typedef struct packed
    {
        logic   [31 : 0]    address;            // 31 .. 0
    } sbaddress0;
    // System Bus Address 63:32 ( 0x3a )
    typedef struct packed
    {
        logic   [31 : 0]    address;            // 31 .. 0
    } sbaddress1;
    // System Bus Address 95:64 ( 0x3b )
    typedef struct packed
    {
        logic   [31 : 0]    address;            // 31 .. 0
    } sbaddress2;
    // System Bus Data 31:0 ( 0x3c )
    typedef struct packed
    {
        logic   [31 : 0]    data;               // 31 .. 0
    } sbdata0;
    // System Bus Data 63:32 ( 0x3d )
    typedef struct packed
    {
        logic   [31 : 0]    data;               // 31 .. 0
    } sbdata1;
    // System Bus Data 95:64 ( 0x3e )
    typedef struct packed
    {
        logic   [31 : 0]    data;               // 31 .. 0
    } sbdata2;
    // System Bus Data 127:96 ( 0x3f )
    typedef struct packed
    {
        logic   [31 : 0]    data;               // 31 .. 0
    } sbdata3;
    // Halt Summary 0 ( 0x40 )
    typedef struct packed
    {
        logic   [31 : 0]    haltsum0_i;         // 31 .. 0
    } haltsum0;

    parameter   DATA0_A         = 7'h04;
    parameter   DATA1_A         = 7'h05;
    parameter   DMCONTROL_A     = 7'h10;
    parameter   DMSTATUS_A      = 7'h11;
    parameter   HARTINFO_A      = 7'h12;
    parameter   ABSTRACTCS_A    = 7'h16;
    parameter   COMMAND_A       = 7'h17;
    parameter   ABSTRACTAUTO_A  = 7'h18;
    parameter   PROGBUF0_A      = 7'h20;
    parameter   HALTSUM0_A      = 7'h40;
