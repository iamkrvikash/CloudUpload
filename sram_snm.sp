*S P I C E C o d e ( G r a p h i c a l T e c h n i q u e )

.TEMP 25.0000
.lib "$CDK_DIR/models/hspice/public/publicModel/tsmc25N" NMOS
.lib "$CDK_DIR/models/hspice/public/publicModel/tsmc25P" PMOS

.GLOBAL VDD!
.PARAM VDD = 2.5
.PARAM L = 300n
.PARAM WN = 1800n
.PARAM WP = '3*WN'
.PARAM WNA = 450n
.PARAM U = 0
.PARAM UL = '-VDD/sqrt(2)'
.PARAM UH = ' VDD/sqrt(2)'
.PARAM BITCAP = 1e-12
.OPTION POST
CBL BLB 0 BITCAP
CBLB BL 0 BITCAP
* one inverter
MPL QD QB VDD! VDD! TSMC25P L='L' W='WP'
+AD='WP*2.5*L' AS='WP*2.5*L' PD='2*WP+5*L' PS='2*WP+5*L'
+M=1
MNL QD QB 0 0 TSMC25N L='L' W='WN'
+AD='WN*2.5*L' AS='WN*2.5*L' PD='2*WN+5*L' PS='2*WN+5*L'
+M=1 

* one inverter
MPR QBD Q VDD! VDD! TSMC25P L='L' W='WP'
+AD='WP*2.5*L' AS='WP*2.5*L' PD='2*WP+5*L' PS='2*WP+5*L'
+M=1
MNR QBD Q 0 0 TSMC25N L='L' W='WN'
+AD='WN*2.5*L' AS='WN*2.5*L' PD='2*WN+5*L' PS='2*WN+5*L'
+M=1
* access transistors
MNAL BLB WL QBD 0 TSMC25N L='L' W='WNA'
+AD='WNA*2.5*L' AS='WNA*2.5*L' PD='2*WNA+5*L' PS='2*WNA+5*L'
+M=1
MNAR BL WL QD 0 TSMC25N L='L' W='WNA'
+AD='WNA*2.5*L' AS='WNA*2.5*L' PD='2*WNA+5*L' PS='2*WNA+5*L'
+M=1
VVDD! VDD! 0 DC=VDD
* when reading, use VDD
VWL WL 0 DC=VDD
.IC V(BL) = VDD
.IC V(BLB) = VDD
* use voltage controlled voltage sources (VCVS)
* changing the co-ordinates in 45 degree angle
EQ Q 0 VOL=' 1/sqrt(2)*U + 1/sqrt(2)*V(V1)'
EQB QB 0 VOL='-1/sqrt(2)*U + 1/sqrt(2)*V(V2)'
* inverter characteristics
EV1 V1 0 VOL=' U + sqrt(2)*V(QBD)'
EV2 V2 0 VOL='-U + sqrt(2)*V(QD)'
* take the absolute value for determination of SNM
EVD VD 0 VOL='ABS(V(V1) - V(V2))' 

.DC U UL UH 0.01
.PRINT DC V(QD) V(QBD) V(V1) V(V2)
.MEASURE DC MAXVD MAX V(VD)
* measure SNM
.MEASURE DC SNM param='1/sqrt(2)*MAXVD'
.END 