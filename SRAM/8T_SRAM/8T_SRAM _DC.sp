***8T_SRAM_DC***
.inc  "C:\synopsys\65nm_bulk.pm"

***  設定電源
Vvdd  vdd  gnd  dc  0.6v
vin1 vin1 gnd dc 0.6v

.global  vdd  gnd

*** INV
.subckt    INV    input    output

MP1    output    input    vdd    vdd    pmos    l=0.065u   w=3u
MN1    output    input    gnd    gnd    nmos    l=0.065u   w=1u

.ends

***  輸入訊號
.dc  vin1  0v  0.6v  0.1mv

***  欲測試的子電路
Xinv1  vin1    Q_bar    INV
*MN5    vdd    vdd    Q_bar    gnd    nmos    l=0.065u   w=1u
MN8    vdd    vdd    node1    gnd    nmos    l=0.065u   w=1u
MN9    node1    Q_bar    gnd    gnd    nmos    l=0.065u   w=1u


Xinv2 vin1    Q    INV
MN6    gnd    vdd    Q    gnd    nmos    l=0.065u   w=1u

*.print v(Q_bar)
.print v(Q)

.option  post
.temp  25
.end
