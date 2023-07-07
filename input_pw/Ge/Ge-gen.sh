#!/bin/bash
 
lattice_params=(4.877040000000001 5.039608000000001 5.202176000000001 5.364744000000001 5.527312 5.6898800000000005 5.852448000000001 6.015016 6.177584 6.340152 6.50272 6.665288 6.827856 6.990424 7.152991999999999 7.31556)
FILENAME="PW.in"

for index in "${!lattice_params[@]}"; do
  DIRNAME="./input_pw/Ge/$index/"
  if [[ ! -d $DIRNAME ]]; then
    mkdir "$DIRNAME"  
  fi
  cat > "$DIRNAME/$FILENAME" << EOF
&CONTROL
    calculation = "scf"
    max_seconds =  8.64000e+04
    pseudo_dir  = "~/Documents/TA/PWDFT.jl/pseudopotentials/scan_upf/"
    outdir      = "$DIRNAME"

/

&SYSTEM
    a           = ${lattice_params[$index]} 
    ecutwfc     =  5.00000e+01
    ibrav       = 2
    nat         = 2
    nspin       = 1
    ntyp        = 1
/

&ELECTRONS
    conv_thr         =  2.00000e-05
    diagonalization  = "davidson"
    electron_maxstep = 300
    mixing_beta      =  2.0000e-01
    mixing_mode      = "local-TF"
    startingpot      = "atomic"
    startingwfc      = "atomic+random"
/

&IONS
/

&CELL
/

K_POINTS {automatic}
  10 10 10 0 0 0

ATOMIC_SPECIES
Ge     72.64  Ge.SCAN.UPF2

ATOMIC_POSITIONS {alat}
Ge      0.000000   0.000000   0.000000
Ge      0.250000   0.250000   0.250000 

EOF
  pw.x < "$DIRNAME/$FILENAME" > "$DIRNAME/PW.out" &
  pids[$index]=$!
done

for index in ${pids[@]}; do
  wait ${pids[$index]}
  cat 
done




