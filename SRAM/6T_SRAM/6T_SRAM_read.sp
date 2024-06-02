***6T_SRAM***
.inc  "C:\synopsys\65nm_bulk.pm"

***  設定電源
Vvdd  vdd  gnd  dc  0.8v
*VWL  WL  gnd  dc  0.8v
*VBLB  BLB  gnd  dc  0.8v
VBL   BL   gnd  dc  0.8v

.global  vdd  gnd

*** INV
.subckt    INV    input    output

MP1    output    input    vdd    vdd    pmos    l=0.065u   w=3u
MN1    output    input    gnd    gnd    nmos    l=0.065u   w=1u

.ends

***  輸入訊號
VWL  WL  gnd  pulse(0v  0.8v  2n  0.01n  0.01n  2n  4n)
*VBL  BL  gnd  pulse(0v  0.8v  0n  0.01n  0.01n  2n  4n)
VBLB  BLB  gnd  pulse(0v  0.8v  4n  0.01n  0.01n  4n  8n)

***  欲測試的子電路
MN5  BLB  WL  Q_bar   gnd  nmos  l=0.065u  w=1u

Xinv1  Q  Q_bar  INV
Xinv2  Q_bar  Q  INV

MN6  Q  WL  BL   gnd  nmos  l=0.065u  w=1u

.print v(VBLB)
.print i(VBLB)

.print Power_BL='v(vdd)*i(VBL)'
.print Power_BLB='v(vdd)*i(VBLB)'

.tran  0.1ns  9ns
.option  post
.temp  25
.end
