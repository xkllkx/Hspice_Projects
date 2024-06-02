***  Adder32_by_pass  ***
.inc  "C:\synopsys\ptm90.l"

***  設定電源
Vvdd  vdd  gnd  dc  1v
.global  vdd  gnd

***  設定參數
.param  wmin=0.2um  lmin=90n

***  電路描述

*** INV
.subckt   INV   input    output    wmin
MP1    output    input    vdd    vdd    pmos    l=90n   w=3*wmin
MN1    output    input    gnd    gnd    nmos    l=90n   w=wmin
.ends

*** BUF
.subckt    BUF    input    output    wmin
MP1    node1    input    vdd    vdd    pmos    l=90n   w=3*wmin
MN1    node1    input    gnd    gnd    nmos    l=90n   w=wmin

MP2    output    node1    vdd    vdd    pmos    l=90n   w=3*wmin
MN2    output    node1    gnd    gnd    nmos    l=90n   w=wmin
.ends

*** NAND
.subckt  NAND  input1  input2  output  wmin
MP1  node2   input1  vdd    vdd  pmos  l=90n    w=3*wmin
MP2  node2   input2  vdd    vdd  pmos  l=90n    w=3*wmin

MN1  node2   input1  node1  gnd  nmos  l=90n    w=2*wmin
MN2  node1   input2  gnd    gnd  nmos  l=90n    w=2*wmin

XBUF1  node2  output  wmin  BUF
.ends

*** XNOR
.subckt  XNOR  input1  input2  output  wmin
XINV1  input1  input1_bar  wmin  INV
XINV2  input2  input2_bar  wmin  INV

MP1  input1   input2_bar   output      vdd    pmos    l=90n    w=3*wmin
MN1  input1   input2    output      gnd    nmos    l=90n    w=wmin

MP2  input1_bar  input2   output   vdd    pmos    l=90n    w=3*wmin
MN2  input1_bar  input2_bar  output    gnd    nmos    l=90n    w=wmin
.ends

*** XOR
.subckt  XOR  input1  input2  output  wmin
MP1  node1   input1  vdd      vdd    pmos    l=90n    w=3*wmin
MN1  node1   input1  gnd      gnd    nmos    l=90n    w=wmin

MP2  node2  input2  input1   vdd    pmos    l=90n    w=3*wmin
MN2  node2  input2  node1    gnd    nmos    l=90n    w=wmin

MP3  input2  input1  node2   vdd    pmos    l=90n    w=3*wmin
MN3  input2  node1   node2   gnd    nmos    l=90n    w=wmin

XBUF1  node2  output  wmin  BUF
.ends

*** tri_buffer
.subckt    TBUF    input    output    en  en_bar   wmin
XINV1  input  node1  wmin  INV

MP1    node2    node1    vdd    vdd    pmos    l=90n   w=3*wmin
MP2    output    en_bar    node2    vdd    pmos    l=90n   w=3*wmin
MN1    output    en    node3    gnd    nmos    l=90n   w=wmin
MN2    node3    node1    gnd    gnd    nmos    l=90n   w=wmin
.ends

*** carry by pass
.subckt  CBP  C_n  P0  P1  P2  P3  C3  C3_b  BP  wmin
MP1  BP_bar   P0   vdd    vdd  pmos  l=90n    w=3*wmin
MP2  BP_bar   P1   vdd    vdd  pmos  l=90n    w=3*wmin
MP3  BP_bar   P2   vdd    vdd  pmos  l=90n    w=3*wmin
MP4  BP_bar   P3   vdd    vdd  pmos  l=90n    w=3*wmin

MN1  BP_bar    P3   node1    gnd  nmos  l=90n    w=4*wmin
MN2  node1   P2   node2    gnd  nmos  l=90n    w=4*wmin
MN3  node2   P1   node3    gnd  nmos  l=90n    w=4*wmin
MN4  node3   P0   gnd    gnd  nmos  l=90n    w=4*wmin

XINV1  BP_bar  BP  wmin  INV

XTBUF1   C_n    C3_b    BP   BP_bar  wmin  TBUF
XTBUF2   C3    C3_b    BP_bar   BP  wmin  TBUF
.ends

*** 6 carry by pass
.subckt  CBP6  C_n  P0  P1  P2  P3  P4  P5  C5  C5_b  BP  wmin
MP0  BP_bar   P0   vdd    vdd  pmos  l=90n    w=3*wmin
MP1  BP_bar   P1   vdd    vdd  pmos  l=90n    w=3*wmin
MP2  BP_bar   P2   vdd    vdd  pmos  l=90n    w=3*wmin
MP3  BP_bar   P3   vdd    vdd  pmos  l=90n    w=3*wmin
MP4  BP_bar   P4   vdd    vdd  pmos  l=90n    w=3*wmin
MP5  BP_bar   P5   vdd    vdd  pmos  l=90n    w=3*wmin

MN1  BP_bar   P5   node1    gnd  nmos  l=90n    w=6*wmin
MN2  node1   P4   node2    gnd  nmos  l=90n    w=6*wmin
MN3  node2   P3   node3    gnd  nmos  l=90n    w=6*wmin
MN4  node3   P2   node4    gnd  nmos  l=90n    w=6*wmin
MN5  node4   P1   node5    gnd  nmos  l=90n    w=6*wmin
MN6  node5   P0   gnd    gnd  nmos  l=90n    w=6*wmin

XINV1  BP_bar  BP  wmin  INV

XTBUF1   C_n    C5_b    BP   BP_bar  wmin  TBUF
XTBUF2   C5    C5_b    BP_bar   BP  wmin  TBUF
.ends

*** static Menchester carry addr with carry by pass
.subckt  SMCA_P  C_n  A0 A1 A2 A3 B0 B1 B2 B3 P0 P1 P2 P3 S0 S1 S2 S3  C3 wmin
XNAND0  A0  B0  G0_bar  wmin  NAND
XNAND1  A1  B1  G1_bar  wmin  NAND
XNAND2  A2  B2  G2_bar  wmin  NAND
XNAND3  A3  B3  G3_bar  wmin  NAND

XXOR0  A0  B0  P0  wmin  XOR
XXOR1  A1  B1  P1  wmin  XOR
XXOR2  A2  B2  P2  wmin  XOR
XXOR3  A3  B3  P3  wmin  XOR

XINV0  P0  P0_bar  wmin  INV
XINV1  P1  P1_bar  wmin  INV
XINV2  P2  P2_bar  wmin  INV
XINV3  P3  P3_bar  wmin  INV

XXOR4  P0  C_n  S0  wmin  XOR
XXOR5  P1  C0  S1  wmin  XOR
XXOR6  P2  C1  S2  wmin  XOR
XXOR7  P3  C2  S3  wmin  XOR

MP1  C0   G0_bar   vdd    vdd  pmos  l=90n    w=3*wmin
MP2  C1   G1_bar   vdd    vdd  pmos  l=90n    w=3*wmin
MP3  C2   G2_bar   vdd    vdd  pmos  l=90n    w=3*wmin
MP4  C3   G3_bar   vdd    vdd  pmos  l=90n    w=3*wmin

MP1p  C0   P0_bar    C_n    vdd  pmos  l=90n    w=3*wmin
MN1p  C0   P0   C_n    gnd  nmos  l=90n    w=wmin

MP2p  C1   P1_bar    C0    vdd  pmos  l=90n    w=3*wmin
MN2p  C1   P1    C0    gnd  nmos  l=90n    w=wmin

MP3p  C2   P2_bar    C1    vdd  pmos  l=90n    w=3*wmin
MN3p  C2   P2    C2    gnd  nmos  l=90n    w=wmin

MP4p  C3   P3_bar    C2    vdd  pmos  l=90n    w=3*wmin
MN4p  C3   P3    C2    gnd  nmos  l=90n    w=wmin

MN0g  C0   G0_bar    node0    gnd  nmos  l=90n    w=2*wmin
MN1g  C1   G1_bar    node1    gnd  nmos  l=90n    w=2*wmin
MN2g  C2   G2_bar    node2    gnd  nmos  l=90n    w=2*wmin
MN3g  C3   G3_bar    node3    gnd  nmos  l=90n    w=2*wmin

MN1  node0   P0_bar   gnd    gnd  nmos  l=90n    w=2*wmin
MN2  node1   P1_bar   gnd    gnd  nmos  l=90n    w=2*wmin
MN3  node2   P2_bar   gnd    gnd  nmos  l=90n    w=2*wmin
MN4  node3   P3_bar   gnd    gnd  nmos  l=90n    w=2*wmin
.ends

**XADD**
.subckt  ADD  C_n  A0 A1 A2 A3 A4 A5 A6 A7 A8 A9 A10 A11 A12 A13 A14 A15 A16 A17 A18 A19 A20 A21 A22 A23 A24 A25 A26 A27 A28 A29 A30 A31 B0 B1 B2 B3 B4 B5 B6 B7 B8 B9 B10 B11 B12 B13 B14 B15 B16 B17 B18 B19 B20 B21 B22 B23 B24 B25 B26 B27 B28 B29 B30 B31 S0 S1 S2 S3 S4 S5 S6 S7 S8 S9 S10 S11 S12 S13 S14 S15 S16 S17 S18 S19 S20 S21 S22 S23 S24 S25 S26 S27 S28 S29 S30 S31 wmin
XSMCA_P1  C_n  A0 A1 A2 A3  B0 B1 B2 B3  P0 P1 P2 P3 S0 S1 S2 S3  C3  wmin  SMCA_P

XSMCA_P2  C3  A4 A5 A6 A7  B4 B5 B6 B7  P4 P5 P6 P7  S4 S5 S6 S7  C7  wmin  SMCA_P
XCBP2  C3  P4 P5 P6 P7  C7  C7_b  BP1_2  wmin  CBP

XSMCA_P3  C7_b  A8 A9 A10 A11  B8 B9 B10 B11  P8 P9 P10 P11  S8 S9 S10 S11  C11  wmin  SMCA_P
XCBP3  C7_b  P8 P9 P10 P11  C11  C11_b  BP1_3  wmin  CBP

XSMCA_P4  C11_b  A12 A13 A14 A15  B12 B13 B14 B15  P12 P13 P14 P15  S12 S13 S14 S15  C15  wmin  SMCA_P
XCBP4  C11_b  P12 P13 P14 P15  C15  C15_b  BP1_4  wmin  CBP

XSMCA_P5  C15_b  A16 A17 A18 A19  B16 B17 B18 B19  P16 P17 P18 P19  S16 S17 S18 S19  C19  wmin  SMCA_P
XCBP5  C15_b  P16 P17 P18 P19  C19  C19_b  BP2_1  wmin  CBP

XSMCA_P6  C19_b  A20 A21 A22 A23  B20 B21 B22 B23  P20 P21 P22 P23  S20 S21 S22 S23  C23  wmin  SMCA_P
XCBP6  C19_b  P20 P21 P22 P23  C23  C23_b  BP2_2  wmin  CBP

XSMCA_P7  C23_b  A24 A25 A26 A27  B24 B25 B26 B27  P24 P25 P26 P27  S24 S25 S26 S27  C27  wmin  SMCA_P
XCBP7  C23_b  P24 P25 P26 P27  C27  C27_b  BP2_3  wmin  CBP

XSMCA_P8  C27_b  A28 A29 A30 A31  B28 B29 B30 B31  P28 P29 P30 P31  S28 S29 S30 S31  C31  wmin  SMCA_P

XCBP_7  C3  BP1_2  BP1_3  BP1_4  BP2_1  BP2_2  BP2_3  C27  C27_b  BP3_3  wmin  CBP6
.ends

***  輸入訊號
VC0   C_n  gnd  dc  0v

VA0 A0 gnd pulse  (0  1  1n  50p  50p  20n  30n)
VA1   A1  gnd  dc  0v
VA2   A2  gnd  dc  0v
VA3   A3  gnd  dc  0v
VA4   A4  gnd  dc  0v
VA5   A5  gnd  dc  0v
VA6   A6  gnd  dc  0v
VA7   A7  gnd  dc  0v
VA8   A8  gnd  dc  0v
VA9   A9  gnd  dc  0v
VA10  A10  gnd  dc  0v
VA11  A11  gnd  dc  0v
VA12  A12  gnd  dc  0v
VA13  A13  gnd  dc  0v
VA14  A14  gnd  dc  0v
VA15  A15  gnd  dc  0v
VA16  A16  gnd  dc  0v
VA17  A17  gnd  dc  0v
VA18  A18  gnd  dc  0v
VA19  A19  gnd  dc  0v
VA20  A20  gnd  dc  0v
VA21  A21  gnd  dc  0v
VA22  A22  gnd  dc  0v
VA23  A23  gnd  dc  0v
VA24  A24  gnd  dc  0v
VA25  A25  gnd  dc  0v
VA26  A26  gnd  dc  0v
VA27  A27  gnd  dc  0v
VA28  A28  gnd  dc  0v
VA29  A29  gnd  dc  0v
VA30  A30  gnd  dc  0v
VA31  A31  gnd  dc  0v

VB0   B0  gnd  dc  1v
VB1   B1  gnd  dc  1v
VB2   B2  gnd  dc  1v
VB3   B3  gnd  dc  1v
VB4   B4  gnd  dc  1v
VB5   B5  gnd  dc  1v
VB6   B6  gnd  dc  1v
VB7   B7  gnd  dc  1v
VB8   B8  gnd  dc  1v
VB9   B9  gnd  dc  1v
VB10  B10  gnd  dc  1v
VB11  B11  gnd  dc  1v
VB12  B12  gnd  dc  1v
VB13  B13  gnd  dc  1v
VB14  B14  gnd  dc  1v
VB15  B15  gnd  dc  1v
VB16  B16  gnd  dc  1v
VB17  B17  gnd  dc  1v
VB18  B18  gnd  dc  1v
VB19  B19  gnd  dc  1v
VB20  B20  gnd  dc  1v
VB21  B21  gnd  dc  1v
VB22  B22  gnd  dc  1v
VB23  B23  gnd  dc  1v
VB24  B24  gnd  dc  1v
VB25  B25  gnd  dc  1v
VB26  B26  gnd  dc  1v
VB27  B27  gnd  dc  1v
VB28  B28  gnd  dc  1v
VB29  B29  gnd  dc  1v
VB30  B30  gnd  dc  1v
VB31  B31  gnd  dc  0v

***  欲測試的子電路
XADD C_n  A0 A1 A2 A3 A4 A5 A6 A7 A8 A9 A10 A11 A12 A13 A14 A15 A16 A17 A18 A19 A20 A21 A22 A23 A24 A25 A26 A27 A28 A29 A30 A31 B0 B1 B2 B3 B4 B5 B6 B7 B8 B9 B10 B11 B12 B13 B14 B15 B16 B17 B18 B19 B20 B21 B22 B23 B24 B25 B26 B27 B28 B29 B30 B31 S0 S1 S2 S3 S4 S5 S6 S7 S8 S9 S10 S11 S12 S13 S14 S15 S16 S17 S18 S19 S20 S21 S22 S23 S24 S25 S26 S27 S28 S29 S30 S31 wmin ADD

C0  S0   gnd   10fp
C1  S1   gnd   10fp
C2  S2   gnd   10fp
C3  S3   gnd   10fp
C4  S4   gnd   10fp
C5  S5   gnd   10fp
C6  S6   gnd   10fp
C7  S7   gnd   10fp
C8  S8   gnd   10fp
C9  S9   gnd   10fp
C10  S10   gnd   10fp
C11  S11   gnd   10fp
C12  S12   gnd   10fp
C13  S13   gnd   10fp
C14  S14   gnd   10fp
C15  S15   gnd   10fp
C16  S16   gnd   10fp
C17  S17   gnd   10fp
C18  S18   gnd   10fp
C19  S19   gnd   10fp
C20  S20   gnd   10fp
C21  S21   gnd   10fp
C22  S22   gnd   10fp
C23  S23   gnd   10fp
C24  S24   gnd   10fp
C25  S25   gnd   10fp
C26  S26   gnd   10fp
C27  S27   gnd   10fp
C28  S28   gnd   10fp
C29  S29   gnd   10fp
C30  S30   gnd   10fp
C31  S31   gnd   10fp


*** 功率消耗
.meas tran T1 when V(A0)=0.5 rise=1
.meas tran T2 when V(S31)=0.5 rise=1
.meas Td param="T2-T1"
.meas tran power avg p(XADD) from T1 to T2

.tran  1ns  5ns
.option  post
.temp  40
.end
