TITLE DEMO: Writing SPICE Decks (Inverter)

********** Inverter **********
MMPD OUT VIN GND GND N_18 W=0.5u L=180n m=1
MMPU OUT VIN VDD VDD P_18 W=1.5u L=180n m=1

********** Process and Temperature **********
.PROTECT $ keep models private (so that *.lis file will not contain the information of spice model)
.LIB '../cic018.l' TT
.UNPROTECT
.TEMP T

********** Parameter **********
.PARAM VSUP = 1.8V

********** Supply and Stimuli **********
VVDD VDD GND VSUP
VVIN VIN GND PULSE(0V VSUP 0n 0.1n 0.1n 4.9n 10n)

********** Command Options **********
.OP                 $ Print operating point analysis data to *.lis file
.OPTION POST        $ Generate graph file (*.tr#, *.ms#, *.ac#)
.OPTION ACCURATE    $ Higher simulation accuracy
.OPTION CAPTAB      $ Print node capacitance

********** Analysis **********
.TRAN 0.01n 100n SWEEP T 0 80 10        $ Transient analysis with temperature sweeping
.DC VVIN 0V VSUP 0.001V SWEEP T 0 80 10 $ DC analysis with temperature sweeping

********** Measurement **********
********** VMAX, VMIN, VPP, VDC **********
.MEAS TRAN MAX_OUT MAX V(OUT) FROM=15n TO=100   $ Maximal value of signal 'OUT'
.MEAS TRAN MIN_OUT MIN V(OUT) FROM=15n TO=100   $ Minimal value of signal 'OUT'
.MEAS TRAN VPP_OUT PARAM='MAX_OUT-MIN_OUT'      $ Peak-to-Peak value of signal 'OUT'
.MEAS TRAN VDC_OUT PARAM='VPP_OUT/2+MIN_OUT'    $ DC component of signal 'OUT'

********** Period **********
.MEAS TRAN PERIOD_OUT TRIG V(OUT) VAL='VDC_OUT' TD=15n RISE=1   $ Period measurement of the signal 'OUT'
+                     TARG V(OUT) VAL='VDC_OUT' TD=15n RISE=2   $ Use '+' to continue the line
********** Frequency **********
.MEAS TRAN FREQ_OUT PARAM='1/PERIOD_OUT' $ Frequency equals the reciprocal of the period

********** Rise Time **********
.MEAS TRAN TR_OUT TRIG V(OUT) VAL='VPP_OUT*0.1' TD=15n RISE=2   $ Rise time measurement of the signal 'OUT'
+                 TARG V(OUT) VAL='VPP_OUT*0.9' TD=15n RISE=2
********** Fall Time **********
.MEAS TRAN TF_OUT TRIG V(OUT) VAL='VPP_OUT*0.9' TD=15n RISE=2   $ Fall time measurement of the signal 'OUT'
+                 TARG V(OUT) VAL='VPP_OUT*0.1' TD=15n RISE=2   $ !!!!!RISE should be FALL here!!!!!
********** On-Time **********
.MEAS TRAN TON_OUT TRIG V(OUT) VAL='VPP_OUT*0.9' TD=15n RISE=1   $ On-time measurement of the signal 'OUT'
+                  TARG V(OUT) VAL='VPP_OUT*0.1' TD=15n FALL=1

********** Duty Cycle **********
.MEAS TRAN DUTY_CYCLE PARAM='TON_OUT/PERIOD_OUT'    $ Duty cycle equals on-time over the period
********** Power Comsumption **********
.MEAS TRAN POWER_TOT AVG POWER FROM=15n TO=10n      $ Average total pwer measurement

.END    $EOF