TITLE TEST1 $ the test of the different between all same scale mos and one differ to others.

********** PARAM **********
.PARAM VSUP = 1.8V
.PARAM WP_L = 30u
.PARAM WN_L = 'WP_L/3'
.PARAM WP_M = 9u
.PARAM WN_M = 'WP_M/3'
.PARAM WP_S = 1.5u
.PARAM WN_S = 'WP_S/3'

********** NAND_L **********
.SUBCKT NAND_L IN1 IN2 OUT VDD GND
MMPU1 OUT IN1 VDD VDD P_18_mm W=WP_L L=180n M=1
MMPU2 OUT IN2 VDD VDD P_18_mm W=WP_L L=180n M=1
MMPD1 OUT IN1 N1 GND N_18_mm W=WN_L L=180n M=1
MMPD2 N1 IN2 GND GND N_18_mm W=WN_L L=180n M=1
.ENDS
********** NAND_M **********
.SUBCKT NAND_M IN1 IN2 OUT VDD GND
MMPU1 OUT IN1 VDD VDD P_18_mm W=WP_M L=180n M=1
MMPU2 OUT IN2 VDD VDD P_18_mm W=WP_M L=180n M=1
MMPD1 OUT IN1 N1 GND N_18_mm W=WN_M L=180n M=1
MMPD2 N1 IN2 GND GND N_18_mm W=WN_M L=180n M=1
.ENDS
********** NAND_S **********
.SUBCKT NAND_S IN1 IN2 OUT VDD GND
MMPU1 OUT IN1 VDD VDD P_18_mm W=WP_S L=180n M=1
MMPU2 OUT IN2 VDD VDD P_18_mm W=WP_S L=180n M=1
MMPD1 OUT IN1 N1 GND N_18_mm W=WN_S L=180n M=1
MMPD2 N1 IN2 GND GND N_18_mm W=WN_S L=180n M=1
.ENDS

********** Circuit 1 **********
XNAND1 VIN VDD L1N1 VDD GND NAND_M
XNAND2 L1N1 VDD L1N2 VDD GND NAND_M
XNAND3 L1N2 VDD NAND_OUT_1 VDD GND NAND_M
CC3 NAND_OUT_1 GND 12f

********** Circuit 2 **********
XNAND4 VIN VDD L2N1 VDD GND NAND_L
XNAND5 L2N1 VDD L2N2 VDD GND NAND_S
XNAND6 L2N2 VDD NAND_OUT_2 VDD GND NAND_S
CC3 NAND_OUT_2 GND 12f
********** Process and Temperature **********
.PROTECT $ keep models private (so that *.lis file will not contain the information of spice model)
.LIB '/misc/vlsisoc-data/techfile/TSRI_U18/02_Design_kit/05_Cadence_Foundry_Design_Kit_FDK_OA/UM180FDKMFC00000OA_B02/Models/Hspice/mm180_reg18_v124.lib' TT
.UNPROTECT
.TEMP T
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
.TRAN 0.5p TSIM 
********** NAND_OUT_1 **********
.MEAS TRAN NAND_OUT_1_MAX MAX V(NAND_OUT_1) FROM=0n TO=5n   $ Maximal value of signal 'OUT'
.MEAS TRAN NAND_OUT_1_MIN MIN V(NAND_OUT_1) FROM=0n TO=5n   $ Minimal value of signal 'OUT'
.MEAS TRAN NAND_OUT_1_VPP PARAM='NAND_OUT_1_MAX-NAND_OUT_1_MIN'      $ Peak-to-Peak value of signal 'OUT'
.MEAS TRAN NAND_OUT_1_VDC PARAM='NAND_OUT_1_VPP/2+NAND_OUT_1_MIN'    $ DC component of signal 'OUT'

.MEAS TRAN NAND_OUT_1_TRISE TRIG V(NAND_OUT_1) VAL='NAND_OUT_1_VPP*0.2' RISE=2   $ Rise time measurement of the signal 'OUT'
+                      TARG V(NAND_OUT_1) VAL='NAND_OUT_1_VPP*0.8' RISE=2
.MEAS TRAN NAND_OUT_1_TFALL TRIG V(NAND_OUT_1) VAL='NAND_OUT_1_VPP*0.8' FALL=2   $ Fall time measurement of the signal 'OUT'
+                      TARG V(NAND_OUT_1) VAL='NAND_OUT_1_VPP*0.2' FALL=2
.MEAS TRAN NAND_OUT_1_TON TRIG V(NAND_OUT_1) VAL='NAND_OUT_1_VPP*0.8' RISE=1   $ On-time measurement of the signal 'OUT'
+                    TARG V(NAND_OUT_1) VAL='NAND_OUT_1_VPP*0.2' FALL=1
********** NAND_OUT_2 **********
.MEAS TRAN NAND_OUT_2_MAX MAX V(NAND_OUT_2) FROM=0n TO=5n   $ Maximal value of signal 'OUT'
.MEAS TRAN NAND_OUT_2_MIN MIN V(NAND_OUT_2) FROM=0n TO=5n   $ Minimal value of signal 'OUT'
.MEAS TRAN NAND_OUT_2_VPP PARAM='NAND_OUT_2_MAX-NAND_OUT_2_MIN'      $ Peak-to-Peak value of signal 'OUT'
.MEAS TRAN NAND_OUT_2_VDC PARAM='NAND_OUT_2_VPP/2+NAND_OUT_2_MIN'    $ DC component of signal 'OUT'

.MEAS TRAN NAND_OUT_2_TRISE TRIG V(NAND_OUT_2) VAL='NAND_OUT_2_VPP*0.2' RISE=2   $ Rise time measurement of the signal 'OUT'
+                      TARG V(NAND_OUT_2) VAL='NAND_OUT_2_VPP*0.8' RISE=2
.MEAS TRAN NAND_OUT_2_TFALL TRIG V(NAND_OUT_2) VAL='NAND_OUT_2_VPP*0.8' FALL=2   $ Fall time measurement of the signal 'OUT'
+                      TARG V(NAND_OUT_2) VAL='NAND_OUT_2_VPP*0.2' FALL=2
.MEAS TRAN NAND_OUT_2_TON TRIG V(NAND_OUT_2) VAL='NAND_OUT_2_VPP*0.8' RISE=1   $ On-time measurement of the signal 'OUT'
+                    TARG V(NAND_OUT_2) VAL='NAND_OUT_2_VPP*0.2' FALL=1

.MEAS TRAN POWER_TOT AVG POWER FROM=0n TO=TSIM      $ Average total pwer measurement
.END