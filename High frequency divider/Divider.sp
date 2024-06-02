***  Divider  ***
.inc  "C:\synopsys\ptm90.l"

***  電路描述
.include  'INV.cir'
.include  'AND.cir'
.include  'Trans_OR.cir'
.include  'XOR.cir'
.include  'TSPC_FF.cir'
.include  'BUF.cir'

***  設定電源
Vvdd  vdd  gnd  dc  1v
.global  vdd  gnd

***  設定參數
.param  wmin=0.2um  lmin=90n

***  輸入訊號
*Vvclk  vclk  gnd  pulse  (0  1  0n  0.1n  0.1n  1n  2.2n)
*Vvclk  vclk  gnd  pulse  (0  1  0n  0.05n  0.05n  0.5n  1.1n)
*Vvclk  vclk  gnd  pulse  (0  1  0n  0.04n  0.04n  0.4n  0.88n)
*Vvclk  vclk  gnd  pulse  (0  1  0n  0.048n  0.048n  0.48n  1.056n)
Vvclk  vclk  gnd  pulse  (0  1  0n  0.047n  0.047n  0.47n  1.034n)


***  欲測試的子電路
Xinv1  vclk  ib1     wmin  INV
Xinv2  ib1   ib2     wmin  INV
Xinv3  ib2   ib3     wmin  INV
Xinv4  ib3   ib4     wmin  INV
Xinv5  ib4   ib5     wmin  INV
Xinv6  ib5   ib6     wmin  INV
Xinv7  ib6   ib7     wmin  INV
Xinv8  ib7   vclk_c  wmin  INV

***  三倍頻
X3FF1  and_o     vclk_c    Q1_3   Q1_bar_3  wmin  TSPC_FF
X3AND  Q1_bar_3  Q2_bar_3  and_o            wmin  AND
X3FF2  Q1_3      vclk_c    Q2_3   Q2_bar_3  wmin  TSPC_FF
X3inv  vclk_c    vclk_bar                   wmin  INV
X3FF3  Q2_3      vclk_bar  Q3_3   Q3_bar_3  wmin  TSPC_FF
X3OR   Q2_3      Q3_3      outA             wmin  T_OR

X3BUF  outA  outA_b  wmin  BUF
C3  outA_b  gnd  50f

***  六倍頻
X6FF1  Q3_bar_6  vclk_c  Q1_6  Q1_bar_6  wmin  TSPC_FF
X6FF2  Q1_6      vclk_c  Q2_6  Q2_bar_6  wmin  TSPC_FF
X6FF3  Q2_6      vclk_c  outB  Q3_bar_6  wmin  TSPC_FF

X6BUF  outB  outB_b  wmin  BUF
C6  outB_b  gnd  50f

***  八倍頻
X8FF1  Q1_bar_8  vclk_c    Q1_8  Q1_bar_8  wmin  TSPC_FF
X8FF2  Q2_bar_8  Q1_bar_8  Q2_8  Q2_bar_8  wmin  TSPC_FF
X8FF3  Q3_bar_8  Q2_bar_8  outC  Q3_bar_8  wmin  TSPC_FF

X8BUF  outC  outC_b  wmin  BUF
C8  outC_b  gnd  50f

*** 週期

.meas TRAN Tclk TRIG V(vclk) VAL=0.5 RISE=2
+               TARG V(vclk) VAL=0.5 RISE=4

.meas TRAN  Tclk_avg  param= 'Tclk/2'

.meas TRAN Tclk_c TRIG V(vclk_c) VAL=0.5 RISE=2
+                 TARG V(vclk_c) VAL=0.5 RISE=4

.meas TRAN  Tclk_c_avg  param= 'Tclk_c/2'

.meas TRAN Ta_b TRIG V(outA_b) VAL=0.5 FALL=1
+             TARG V(outA_b) VAL=0.5 FALL=2

.meas TRAN  Ta_b_avg  param= 'Ta_b'

.meas TRAN Tb_b TRIG V(outB_b) VAL=0.5 FALL=1
+             TARG V(outB_b) VAL=0.5 FALL=2

.meas TRAN  Tb_b_avg  param= 'Tb_b'

.meas TRAN Tc_b TRIG V(outC_b) VAL=0.5 FALL=1
+             TARG V(outC_b) VAL=0.5 FALL=2

.meas TRAN  Tc_b_avg  param= 'Tc_b'

*** Duty Cycle

.meas TRAN Ta_b_1 TRIG V(outA_b) VAL=0.5 RISE=2
+             TARG V(outA_b) VAL=0.5 FALL=3

.meas TRAN  Ta_b_duty  param= 'Ta_b_1/Ta_b_avg*100'


.meas TRAN Tb_b_1 TRIG V(outB_b) VAL=0.5 RISE=2
+             TARG V(outB_b) VAL=0.5 FALL=3

.meas TRAN  Tb_b_duty  param= 'Tb_b_1/Tb_b_avg*100'


.meas TRAN Tc_b_1 TRIG V(outC_b) VAL=0.5 RISE=2
+             TARG V(outC_b) VAL=0.5 FALL=3

.meas TRAN  Tc_b_duty  param= 'Tc_b_1/Tc_b_avg*100'

*** 功率消耗
.meas TRAN power_avg AVG P(Vvdd) FROM=10n TO=28n

.tran  1ns  30ns
.option  post
.temp  40
.end
