*** DRAM ***
.inc  "C:\synopsys\65nm_bulk.pm"

***  設定電源
Vvdd  vdd  gnd  dc  1v
Vvdd_h  vdd_h  gnd  dc  0.5v
VIN  IN  gnd  dc  1v
*VIN  IN  gnd  dc  0v

.global  vdd  gnd

*** 子電路
***INV
.subckt    INV    input    output
MP1    output    input    vdd    vdd    pmos    l=0.065u   w=3u
MN1    output    input    gnd    gnd    nmos    l=0.065u   w=1u
.ends

***Buffer
.subckt    BUF    input    output
MP1    node1    input    vdd    vdd    pmos    l=0.065u   w=3u
MN1    node1    input    gnd    gnd    nmos    l=0.065u   w=1u
MP2    output   node1    vdd    vdd    pmos    l=0.065u   w=3u
MN2    output   node1    gnd    gnd    nmos    l=0.065u   w=1u
.ends

***  輸入訊號
*VIN  IN  gnd  pulse(0v  1v  2n  0.01n  0.01n  2n  4n)

VEQ  EQ  gnd  pulse(0v  1v  0n  0.01n  0.01n  1n  4n)

VWL  WL  gnd  pulse(0v  1.5v  1n  0.01n  0.01n  3n  4n)

VWE  WE  gnd  pulse(0v  1v  3n  0.01n  0.01n  1n  8n)
*VWE  WE  gnd  pulse(0v  1v  7n  0.01n  0.01n  1n  8n)

VSAP SAP gnd  pulse(0.5v  1v  2n  0.01n  0.01n  2n  4n)
VSAN SAN gnd  pulse(0.5v  0v  2n  0.01n  0.01n  2n  4n)

VCSL  CSL  gnd  pulse(0v  1v  3n  0.01n  0.01n  1n  4n)

***  欲測試電路
XINV1  IN   INB    INV

*XBUF1  IN   IN_B    BUF
*XBUF2  INB  INB_B   BUF

*XINV1  IN   INB    INV

MN1  IN    WE   OUT    gnd  nmos  l=0.065u  w=1u
MN2  INB   WE   OUTB  gnd  nmos  l=0.065u  w=1u

*MN1  IN_B    WE   OUT    gnd  nmos  l=0.065u  w=1u
*MN2  INB_B   WE   OUTB  gnd  nmos  l=0.065u  w=1u

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

***cell
MN10  BL   WL   node1   gnd  nmos  l=0.065u  w=1u
MN11  vdd   EQ   node1   gnd  nmos  l=0.065u  w=1u
C1  node1   gnd   0.01p

MN12  BLB   WL   node2   gnd  nmos  l=0.065u  w=1u
*MN13  vdd   EQ   node2   gnd  nmos  l=0.065u  w=1u
C2  node2   gnd   0.01p

.tran  0.1ns  9ns
.option  post
.temp  25
.end
