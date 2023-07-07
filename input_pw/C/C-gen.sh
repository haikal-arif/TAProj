#!/bin/bash

lattice_params=(3.0252 3.12604 3.22688 3.32772 3.42856 3.5294 3.63024 3.73108 3.83192 3.93276 4.0336 4.13444 4.23528 4.33612 4.43696 4.5378)
FILENAME="PW.in"

for index in "${!lattice_params[@]}"; do
  DIRNAME="./input_pw/C/$index/"
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
C     12.011   C.SCAN.UPF2

ATOMIC_POSITIONS {alat}
C      0.000000   0.000000   0.000000
C      0.250000   0.250000   0.250000 

EOF
  pw.x < "$DIRNAME/$FILENAME" > "$DIRNAME/PW.out" &
  pids[$index]=$!
done

for index in ${pids[@]}; do
  wait ${pids[$index]}
  cat 
done




