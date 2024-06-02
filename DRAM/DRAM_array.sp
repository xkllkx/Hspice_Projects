*** DRAM_ARRAY ***
.inc  "C:\synopsys\65nm_bulk.pm"

***  設定電源
Vvdd  vdd  gnd  dc  1v
Vvdd_h  vdd_h  gnd  dc  0.5v
Vvdd_w  vdd_w  gnd  dc  1.5v
* Vvdd_f  vdd_f  gnd  dc  0.4v

.global  vdd  gnd  vdd_h  vdd_w  vdd_f

*** 子電路

*** INV
.subckt    INV    IN   OUT
MP1   OUT  IN   vdd    vdd    pmos    l=0.065u   w=3u
MN1   OUT  IN   gnd    gnd    nmos    l=0.065u   w=1u
.ends

*** INV_w
.subckt    INV_w    IN   OUT
MP1   OUT  IN   vdd_w    vdd_w    pmos    l=0.065u   w=3u
MN1   OUT  IN   gnd    gnd    nmos    l=0.065u   w=1u
.ends

*** BUF
.subckt    BUF    IN    OUT
MP1    node1    IN    vdd    vdd    pmos    l=0.065u   w=3u
MN1    node1    IN    gnd    gnd    nmos    l=0.065u   w=1u

MP2    OUT    node1    vdd    vdd    pmos    l=0.065u   w=3u
MN2    OUT    node1    gnd    gnd    nmos    l=0.065u   w=1u
.ends

*** AND
.subckt  AND  IN1  IN2  OUT
MP1  OUTB  IN1  vdd  vdd  pmos  l=0.065u  w=3u
MP2  OUTB  IN2  vdd  vdd  pmos  l=0.065u  w=3u

MN1  OUTB  IN1  node1  node1  nmos  l=0.065u  w=2u
MN2  node1  IN2  gnd  gnd  nmos  l=0.065u  w=2u

XINV1  OUTB   OUT    INV
.ends

*** AND_w
.subckt  AND_w  IN1  IN2  OUT
MP1  OUTB  IN1  vdd_w  vdd_w  pmos  l=0.065u  w=3u
MP2  OUTB  IN2  vdd_w  vdd_w  pmos  l=0.065u  w=3u

MN1  OUTB  IN1  node1  node1  nmos  l=0.065u  w=2u
MN2  node1  IN2  gnd  gnd  nmos  l=0.065u  w=2u

XINV1  OUTB   OUT    INV_w
.ends

*** cell
.subckt    CELL    WL    BL    node1
MN1  BL   WL   node1   gnd  nmos  l=0.065u  w=1u
C1  node1   gnd   0.01p
.ends

*** cell_row
.subckt    CELL_ROW    WL BL1 BL2 BL3 BL4 node1 node2 node3 node4
XCELL1    WL    BL1   node1   CELL
XCELL2    WL    BL2   node2   CELL
XCELL3    WL    BL3   node3   CELL
XCELL4    WL    BL4   node4   CELL
.ends

*** SA
.subckt  SA  IN  INB  EQ  WL  WE  CSL  BL  BLB  SAP  SAN  OUT  OUTB   node1
XINV1  IN   INB    INV

MN1  IN    WE   OUT    gnd  nmos  l=0.065u  w=1u
MN2  INB   WE   OUTB  gnd  nmos  l=0.065u  w=1u

MN3  OUT    CSL   BL    gnd  nmos  l=0.065u  w=1u
MN4  OUTB  CSL   BLB  gnd  nmos  l=0.065u  w=1u

***EQL
MN5  BL   EQ   BLB    gnd  nmos  l=0.065u  w=1u
MN6  BL   EQ   vdd_h    gnd  nmos  l=0.065u  w=2u
MN7  vdd_h    EQ   BLB   gnd  nmos  l=0.065u  w=2u

***sensing curcuit
MP1  SAP   BLB   BL    vdd  pmos  l=0.065u  w=6u
MP2  BLB   BL   SAP    vdd  pmos  l=0.065u  w=6u
MN8  BL   BLB   SAN    gnd  nmos  l=0.065u  w=2u
MN9  SAN   BL   BLB    gnd  nmos  l=0.065u  w=2u

MN10  BLB   WL   node1   gnd  nmos  l=0.065u  w=1u
C1  node1   gnd   0.01p

* XAND1  IN  EQ  WR  AND
* MN11  vdd_f   WR   node1   gnd  nmos  l=0.065u  w=1u
.ends

*** 2_to_4_Decoder
.subckt  DECODER  IN1  IN2  OUT1  OUT2  OUT3  OUT4
XINV1  IN1   IN1B    INV
XINV2  IN2   IN2B    INV

XAND1  IN1B  IN2B  OUT1  AND
XAND2  IN1   IN2B  OUT2  AND
XAND3  IN2   IN1B  OUT3  AND
XAND4  IN1   IN2   OUT4  AND
.ends

*** 2_to_4_Decoder_w
.subckt  DECODER_w  IN1  IN2  OUT1  OUT2  OUT3  OUT4
XINV1  IN1   IN1B    INV_w
XINV2  IN2   IN2B    INV_w

XAND1  IN1B  IN2B  OUT1  AND_w
XAND2  IN1   IN2B  OUT2  AND_w
XAND3  IN2   IN1B  OUT3  AND_w
XAND4  IN1   IN2   OUT4  AND_w
.ends

*** transmission  gate
.subckt  TG  IN  OUT  EN_N  EN_P
MP1  OUT  EN_P  IN   vdd  pmos  l=0.065u  w=3u
MN1  IN   EN_N  OUT  gnd  nmos  l=0.065u  w=1u
.ends

**2_to_1MUX
.subckt  MUX2_1  IN1  IN2  OUT  S0  En 
XS0  S0  S0_bar  INV

XTG1  IN1  node1  S0      S0_bar   TG
XTG2  IN2  node1  S0_bar  S0       TG

MP1  node1   En   OUT   vdd  pmos  l=0.065u  w=3u
.ends

***  輸入訊號
* VIN  IN  gnd  dc  5v
VIN  IN  gnd  dc  0v

VEQ  EQ  gnd  pulse(0v  1v  0n  0.01n  0.01n  1n  4n)

VWE  WE  gnd  pulse(0v  1v  3n  0.01n  0.01n  1n  8n)

VSAP SAP gnd  pulse(0.5v  1v  2n  0.01n  0.01n  2n  4n)
VSAN SAN gnd  pulse(0.5v  0v  2n  0.01n  0.01n  2n  4n)
* VSAP SAP gnd  pulse(0.5v  1v  2n  0.01n  0.01n  1n  4n)
* VSAN SAN gnd  pulse(0.5v  0v  2n  0.01n  0.01n  1n  4n)

VCSL  CSL  gnd  pulse(0v  1v  3n  0.01n  0.01n  1n  4n)

*** decoder check
* VWL_IN1   WL_IN1   gnd  pulse(0v  1.5v  1n  0.01n  0.01n  1n  2n)
* VWL_IN2   WL_IN2   gnd  pulse(0v  1.5v  0n  0.01n  0.01n  2n  4n)
* VBL_IN1   BL_IN1   gnd  pulse(0v  1.5v  0n  0.01n  0.01n  1n  2n)
* VBL_IN2   BL_IN2   gnd  pulse(0v  1.5v  0n  0.01n  0.01n  2n  4n)

VWL_IN1   WL_IN1  gnd  dc  0v
VWL_IN2   WL_IN2  gnd  dc  1v
* VWL_IN2   WL_IN2   gnd  pulse(0v  1v  0n  0.01n  0.01n  4n  8n)

* VBL_IN1   BL_IN1   gnd  pulse(0v  1v  0n  0.01n  0.01n  4n  8n)
* VBL_IN2   BL_IN2   gnd  pulse(0v  1v  0n  0.01n  0.01n  8n  16n)
VBL_IN1   BL_IN1   gnd  dc  1v
VBL_IN2   BL_IN2   gnd  dc  1v

VSA_E  SA_E  gnd  pulse(0v  1.5v  1n  0.01n  0.01n  3n  4n)

***  欲測試電路
XDECODER_WL  WL_IN1  WL_IN2  WL_D1  WL_D2  WL_D3  WL_D4  DECODER_w
XDECODER_BL  BL_IN1  BL_IN2  BL_D1  BL_D2  BL_D3  BL_D4  DECODER

XCELL_ROW1    WL1    BL1    BL2    BL3    BL4   node1_1 node1_2 node1_3 node1_4  CELL_ROW
XCELL_ROW2    WL2    BL1    BL2    BL3    BL4   node2_1 node2_2 node2_3 node2_4  CELL_ROW
XCELL_ROW3    WL3    BL1    BL2    BL3    BL4   node3_1 node3_2 node3_3 node3_4  CELL_ROW
XCELL_ROW4    WL4    BL1    BL2    BL3    BL4   node4_1 node4_2 node4_3 node4_4  CELL_ROW

XAND1  WL_D1  SA_E  WL1   AND_w
XAND2  WL_D2  SA_E  WL2   AND_w
XAND3  WL_D3  SA_E  WL3   AND_w
XAND4  WL_D4  SA_E  WL4   AND_w

XINV1  BL_D1   BL_D1_bar   INV
XTG1  BL1  SA_BL1  BL_D1   BL_D1_bar   TG

XINV2  BL_D2   BL_D2_bar   INV
XTG2  BL2  SA_BL2  BL_D2   BL_D2_bar   TG

XINV3  BL_D3   BL_D3_bar   INV
XTG3  BL3  SA_BL3  BL_D3   BL_D3_bar   TG

XINV4  BL_D4   BL_D4_bar   INV
XTG4  BL4  SA_BL4  BL_D4   BL_D4_bar   TG

XSAP1  IN  INB  EQ  SA_E  WE  CSL  SA_BL1  SA_BLB1  SAP  SAN  OUT1  OUTB1  C_ref1  SA
XSAP2  IN  INB  EQ  SA_E  WE  CSL  SA_BL2  SA_BLB2  SAP  SAN  OUT2  OUTB2  C_ref2  SA
XSAP3  IN  INB  EQ  SA_E  WE  CSL  SA_BL3  SA_BLB3  SAP  SAN  OUT3  OUTB3  C_ref3  SA
XSAP4  IN  INB  EQ  SA_E  WE  CSL  SA_BL4  SA_BLB4  SAP  SAN  OUT4  OUTB4  C_ref4  SA

.tran  0.1ns  9ns
.option  post
.temp  25
.end
