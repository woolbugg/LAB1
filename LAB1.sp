TITLE LAB1

********** INV **********
.SUBCKT INV IN OUT VDD GND
MMPU OUT IN VDD VDD P_18_mm W=W_PMOS L=180n M=1
MMPD OUT IN GND GND N_18_mm W=W_NMOS L=180n M=1
.ENDS

********** 2IN NAND **********
.SUBCKT NAND2IN IN1 IN2 OUT VDD GND
MMPU1 OUT IN1 VDD VDD P_18_mm W=W_PMOS L=180n M=1
MMPU2 OUT IN2 VDD VDD P_18_mm W=W_PMOS L=180n M=1
MMPD1 OUT IN1 N1 GND N_18_mm W=W_NMOS L=180n M=1
MMPD2 N1 IN2 GND GND N_18_mm W=W_NMOS L=180n M=1
.ENDS

********** 2IN NOR **********
.SUBCKT NOR2IN IN1 IN2 IN3 OUT VDD GND
MMPU3 N1 IN1 VDD VDD P_18_mm W=W_PMOS L=180n M=1
MMPU4 OUT IN2 N1 VDD P_18_mm W=W_PMOS L=180n M=1
MMPD3 OUT IN1 GND GND N_18_mm W=W_NMOS L=180n M=1
MMPD4 OUT IN2 GND GND N_18_mm W=W_NMOS L=180n M=1
.ENDS

********** 3IN NAND **********
.SUBCKT NAND3IN IN1 IN2 IN3 OUT VDD GND
MMPU5 OUT IN1 VDD VDD P_18_mm W=W_PMOS L=180n M=1
MMPU6 OUT IN2 VDD VDD P_18_mm W=W_PMOS L=180n M=1
MMPU7 OUT IN3 VDD VDD P_18_mm W=W_PMOS L=180n M=1
MMPD5 OUT IN1 N1 GND N_18_mm W=W_NMOS L=180n M=1
MMPD6 N1 IN2 N2 GND N_18_mm W=W_NMOS L=180n M=1
MMPD7 N2 IN3 GND GND N_18_mm W=W_NMOS L=180n M=1
.ENDS

********** 3IN NOR **********
.SUBCKT NOR3IN IN1 IN2 IN3 OUT VDD GND
MMPU8 N1 IN1 VDD VDD P_18_mm W=W_PMOS L=180n M=1
MMPU9 N2 IN2 N1 VDD P_18_mm W=W_PMOS L=180n M=1
MMPU10 OUT IN3 N2 VDD P_18_mm W=W_PMOS L=180n M=1
MMPD8 OUT IN1 GND GND N_18_mm W=W_NMOS L=180n M=1
MMPD9 OUT IN2 GND GND N_18_mm W=W_NMOS L=180n M=1
MMPD10 OUT IN3 GND GND N_18_mm W=W_NMOS L=180n M=1
.ENDS

********** TRANSMISSION GATE **********
.SUBCKT TRANS IN OUT VDD GND
MMPU11 OUT GND IN VDD P_18_mm W=W_PMOS L=180n M=1
MMPD11 IN VDD OUT GND N_18_mm W=W_NMOS L=180n M=1
.ENDS

********** CIRCUIT **********
XINV1 VIN N1 VDD GND INV
XINV2 N1 D_OUT VDD GND INV
CC1 D_OUT GND 3f

XINV3 D_OUT L1N1 VDD GND INV
XINV4 L1N1 L1N2 VDD GND INV
XINV5 L1N2 L1N3 VDD GND INV
XINV6 L1N3 INV_OUT VDD GND INV
CC2 INV_OUT GND 24f

XNAND2IN1 D_OUT VDD L2N1 VDD GND NAND2IN
XNAND2IN2 L2N1 VDD L2N2 VDD GND NAND2IN
XNAND2IN3 L2N2 VDD NAND2_OUT VDD GND NAND2IN
CC3 NAND2_OUT GND 12f

XNOR2IN1 D_OUT GND L3N1 VDD GND NOR2IN
XNOR2IN2 L3N1 GND L3N2 VDD GND NOR2IN
XNOR2IN3 L3N2 GND NOR2_OUT VDD GND NOR2IN
CC4 NOR2_OUT GND 12f

XNAND3IN1 D_OUT VDD VDD L4N1 VDD GND NAND3IN
XNAND3IN2 L4N1 VDD VDD NAND3_OUT VDD GND NAND3IN
CC5 NAND3_OUT GND 6f

XNOR3IN1 D_OUT GND GND L5N1 VDD GND NOR3IN
XNOR3IN1 L5N1 GND GND NOR3_OUT VDD GND NOR3IN
CC6 NOR3_OUT GND 6f

XTRANS1 D_OUT L6N1 VDD GND TRANS
XINV7 L6N1 TG_OUT VDD GND INV
CC7 TG_OUT GND 6f


********** Process and Temperature **********
.PROTECT $ keep models private (so that *.lis file will not contain the information of spice model)
.LIB '/misc/vlsisoc-data/techfile/TSRI_U18/02_Design_kit/05_Cadence_Foundry_Design_Kit_FDK_OA/UM180FDKMFC00000OA_B02/Models/Hspice/mm180_reg18_v124.lib' TT
.UNPROTECT
.TEMP T

********** Parameter **********
.PARAM VSUP = 1.8V
.PARAM T = 27
.PARAM W_PMOS = 9u
.PARAM W_NMOS = 3u

********** Supply and Stimuli **********
VVDD VDD GND VSUP
VVIN VIN GND PULSE(0V VSUP 0n 2.5p 2.5p 0.5n 1n)

********** Command Options **********
.OP                 $ Print operating point analysis data to *.lis file
.OPTION POST        $ Generate graph file (*.tr#, *.ms#, *.ac#)
.OPTION FAST        $ Fast simulation
$.OPTION ACCURATE   $ Higher simulation accuracy
$.OPTION CAPTAB     $ Print node capacitance

********** Analysis **********
.TRAN 0.5p 5n 
$.TRAN 0.01n 100n SWEEP T 0 80 10        $ Transient analysis with temperature sweeping
$.DC VVIN 0V VSUP 0.001V SWEEP T 0 80 10 $ DC analysis with temperature sweeping

********** Measurement **********
********** D_OUT **********
.MEAS TRAN D_OUT_MAX MAX V(D_OUT) FROM=0n TO=5n   $ Maximal value of signal 'OUT'
.MEAS TRAN D_OUT_MIN MIN V(D_OUT) FROM=0n TO=5n   $ Minimal value of signal 'OUT'
.MEAS TRAN D_OUT_VPP PARAM='D_OUT_MAX-D_OUT_MIN'      $ Peak-to-Peak value of signal 'OUT'
.MEAS TRAN D_OUT_VDC PARAM='D_OUT_VPP/2+D_OUT_MIN'    $ DC component of signal 'OUT'

.MEAS TRAN D_OUT_TRISE TRIG V(D_OUT) VAL='D_OUT_VPP*0.2' RISE=2   $ Rise time measurement of the signal 'OUT'
+                      TARG V(D_OUT) VAL='D_OUT_VPP*0.8' RISE=2
.MEAS TRAN D_OUT_TFALL TRIG V(D_OUT) VAL='D_OUT_VPP*0.8' FALL=2   $ Fall time measurement of the signal 'OUT'
+                      TARG V(D_OUT) VAL='D_OUT_VPP*0.2' FALL=2
.MEAS TRAN D_OUT_TON TRIG V(D_OUT) VAL='D_OUT_VPP*0.8' RISE=1   $ On-time measurement of the signal 'OUT'
+                    TARG V(D_OUT) VAL='D_OUT_VPP*0.2' FALL=1
********** INV_OUT **********
.MEAS TRAN INV_OUT_MAX MAX V(INV_OUT) FROM=0n TO=5n   $ Maximal value of signal 'OUT'
.MEAS TRAN INV_OUT_MIN MIN V(INV_OUT) FROM=0n TO=5n   $ Minimal value of signal 'OUT'
.MEAS TRAN INV_OUT_VPP PARAM='INV_OUT_MAX-INV_OUT_MIN'      $ Peak-to-Peak value of signal 'OUT'
.MEAS TRAN INV_OUT_VDC PARAM='INV_OUT_VPP/2+INV_OUT_MIN'    $ DC component of signal 'OUT'

.MEAS TRAN INV_OUT_TRISE TRIG V(INV_OUT) VAL='INV_OUT_VPP*0.2' RISE=2   $ Rise time measurement of the signal 'OUT'
+                        TARG V(INV_OUT) VAL='INV_OUT_VPP*0.8' RISE=2
.MEAS TRAN INV_OUT_TFALL TRIG V(INV_OUT) VAL='INV_OUT_VPP*0.8' FALL=2   $ Fall time measurement of the signal 'OUT'
+                        TARG V(INV_OUT) VAL='INV_OUT_VPP*0.2' FALL=2
.MEAS TRAN INV_OUT_TON TRIG V(INV_OUT) VAL='INV_OUT_VPP*0.8' RISE=1   $ On-time measurement of the signal 'OUT'
+                      TARG V(INV_OUT) VAL='INV_OUT_VPP*0.2' FALL=1

********** NAND2_OUT **********
.MEAS TRAN NAND2_OUT_MAX MAX V(NAND2_OUT) FROM=0n TO=5n   $ Maximal value of signal 'OUT'
.MEAS TRAN NAND2_OUT_MIN MIN V(NAND2_OUT) FROM=0n TO=5n   $ Minimal value of signal 'OUT'
.MEAS TRAN NAND2_OUT_VPP PARAM='NAND2_OUT_MAX-NAND2_OUT_MIN'      $ Peak-to-Peak value of signal 'OUT'
.MEAS TRAN NAND2_OUT_VDC PARAM='NAND2_OUT_VPP/2+NAND2_OUT_MIN'    $ DC component of signal 'OUT'

.MEAS TRAN NAND2_OUT_TRISE TRIG V(NAND2_OUT) VAL='NAND2_OUT_VPP*0.2' RISE=2   $ Rise time measurement of the signal 'OUT'
+                          TARG V(NAND2_OUT) VAL='NAND2_OUT_VPP*0.8' RISE=2
.MEAS TRAN NAND2_OUT_TFALL TRIG V(NAND2_OUT) VAL='NAND2_OUT_VPP*0.8' FALL=2   $ Fall time measurement of the signal 'OUT'
+                          TARG V(NAND2_OUT) VAL='NAND2_OUT_VPP*0.2' FALL=2
.MEAS TRAN NAND2_OUT_TON TRIG V(NAND2_OUT) VAL='NAND2_OUT_VPP*0.8' RISE=1   $ On-time measurement of the signal 'OUT'
+                        TARG V(NAND2_OUT) VAL='NAND2_OUT_VPP*0.2' FALL=1
********** NOR2_OUT **********
.MEAS TRAN NOR2_OUT_MAX MAX V(NOR2_OUT) FROM=0n TO=5n   $ Maximal value of signal 'OUT'
.MEAS TRAN NOR2_OUT_MIN MIN V(NOR2_OUT) FROM=0n TO=5n   $ Minimal value of signal 'OUT'
.MEAS TRAN NOR2_OUT_VPP PARAM='NOR2_OUT_MAX-NOR2_OUT_MIN'      $ Peak-to-Peak value of signal 'OUT'
.MEAS TRAN NOR2_OUT_VDC PARAM='NOR2_OUT_VPP/2+NOR2_OUT_MIN'    $ DC component of signal 'OUT'

.MEAS TRAN NOR2_OUT_TRISE TRIG V(NOR2_OUT) VAL='NOR2_OUT_VPP*0.2' RISE=2   $ Rise time measurement of the signal 'OUT'
+                        TARG V(NOR2_OUT) VAL='NOR2_OUT_VPP*0.8' RISE=2
.MEAS TRAN NOR2_OUT_TFALL TRIG V(NOR2_OUT) VAL='NOR2_OUT_VPP*0.8' FALL=2   $ Fall time measurement of the signal 'OUT'
+                        TARG V(NOR2_OUT) VAL='NOR2_OUT_VPP*0.2' FALL=2
.MEAS TRAN NOR2_OUT_TON TRIG V(NOR2_OUT) VAL='NOR2_OUT_VPP*0.8' RISE=1   $ On-time measurement of the signal 'OUT'
+                      TARG V(NOR2_OUT) VAL='NOR2_OUT_VPP*0.2' FALL=1
********** NAND3_OUT **********
.MEAS TRAN NAND3_OUT_MAX MAX V(NAND3_OUT) FROM=0n TO=5n   $ Maximal value of signal 'OUT'
.MEAS TRAN NAND3_OUT_MIN MIN V(NAND3_OUT) FROM=0n TO=5n   $ Minimal value of signal 'OUT'
.MEAS TRAN NAND3_OUT_VPP PARAM='NAND3_OUT_MAX-NAND3_OUT_MIN'      $ Peak-to-Peak value of signal 'OUT'
.MEAS TRAN NAND3_OUT_VDC PARAM='NAND3_OUT_VPP/2+NAND3_OUT_MIN'    $ DC component of signal 'OUT'

.MEAS TRAN NAND3_OUT_TRISE TRIG V(NAND3_OUT) VAL='NAND3_OUT_VPP*0.2' RISE=2   $ Rise time measurement of the signal 'OUT'
+                        TARG V(NAND3_OUT) VAL='NAND3_OUT_VPP*0.8' RISE=2
.MEAS TRAN NAND3_OUT_TFALL TRIG V(NAND3_OUT) VAL='NAND3_OUT_VPP*0.8' FALL=2   $ Fall time measurement of the signal 'OUT'
+                        TARG V(NAND3_OUT) VAL='NAND3_OUT_VPP*0.2' FALL=2
.MEAS TRAN NAND3_OUT_TON TRIG V(NAND3_OUT) VAL='NAND3_OUT_VPP*0.8' RISE=1   $ On-time measurement of the signal 'OUT'
+                      TARG V(NAND3_OUT) VAL='NAND3_OUT_VPP*0.2' FALL=1
********** NOR3_OUT **********
.MEAS TRAN NOR3_OUT_MAX MAX V(NOR3_OUT) FROM=0n TO=5n   $ Maximal value of signal 'OUT'
.MEAS TRAN NOR3_OUT_MIN MIN V(NOR3_OUT) FROM=0n TO=5n   $ Minimal value of signal 'OUT'
.MEAS TRAN NOR3_OUT_VPP PARAM='NOR3_OUT_MAX-NOR3_OUT_MIN'      $ Peak-to-Peak value of signal 'OUT'
.MEAS TRAN NOR3_OUT_VDC PARAM='NOR3_OUT_VPP/2+NOR3_OUT_MIN'    $ DC component of signal 'OUT'

.MEAS TRAN NOR3_OUT_TRISE TRIG V(NOR3_OUT) VAL='NOR3_OUT_VPP*0.2' RISE=2   $ Rise time measurement of the signal 'OUT'
+                        TARG V(NOR3_OUT) VAL='NOR3_OUT_VPP*0.8' RISE=2
.MEAS TRAN NOR3_OUT_TFALL TRIG V(NOR3_OUT) VAL='NOR3_OUT_VPP*0.8' FALL=2   $ Fall time measurement of the signal 'OUT'
+                        TARG V(NOR3_OUT) VAL='NOR3_OUT_VPP*0.2' FALL=2
.MEAS TRAN NOR3_OUT_TON TRIG V(NOR3_OUT) VAL='NOR3_OUT_VPP*0.8' RISE=1   $ On-time measurement of the signal 'OUT'
+                      TARG V(NOR3_OUT) VAL='NOR3_OUT_VPP*0.2' FALL=1
********** TG_OUT **********
.MEAS TRAN TG_OUT_MAX MAX V(TG_OUT) FROM=0n TO=5n   $ Maximal value of signal 'OUT'
.MEAS TRAN TG_OUT_MIN MIN V(TG_OUT) FROM=0n TO=5n   $ Minimal value of signal 'OUT'
.MEAS TRAN TG_OUT_VPP PARAM='TG_OUT_MAX-TG_OUT_MIN'      $ Peak-to-Peak value of signal 'OUT'
.MEAS TRAN TG_OUT_VDC PARAM='TG_OUT_VPP/2+TG_OUT_MIN'    $ DC component of signal 'OUT'

.MEAS TRAN TG_OUT_TRISE TRIG V(TG_OUT) VAL='TG_OUT_VPP*0.2' RISE=2   $ Rise time measurement of the signal 'OUT'
+                        TARG V(TG_OUT) VAL='TG_OUT_VPP*0.8' RISE=2
.MEAS TRAN TG_OUT_TFALL TRIG V(TG_OUT) VAL='TG_OUT_VPP*0.8' FALL=2   $ Fall time measurement of the signal 'OUT'
+                        TARG V(TG_OUT) VAL='TG_OUT_VPP*0.2' FALL=2
.MEAS TRAN TG_OUT_TON TRIG V(TG_OUT) VAL='TG_OUT_VPP*0.8' RISE=1   $ On-time measurement of the signal 'OUT'
+                      TARG V(TG_OUT) VAL='TG_OUT_VPP*0.2' FALL=1
********** Power Comsumption **********
.MEAS TRAN POWER_TOT AVG POWER FROM=0n TO=10n      $ Average total pwer measurement

.END    $EOF