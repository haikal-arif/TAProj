#!/bin/bash

lattice_params=(4.8 4.96 5.12 5.28 5.44 5.6 5.76 5.92 6.08 6.24 6.4 6.56 6.72 6.88 7.04)
FILENAME="PW.in"

for index in "${!lattice_params[@]}"; do
  DIRNAME="./input_pw/Al/$index/"
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
    ecutwfc     =  6.00000e+01
    ibrav       = 2
    nat         = 1
    nspin       = 1
    ntyp        = 1
    occupations = 'smearing'
    degauss     = 0.1
/

&ELECTRONS
    conv_thr         =  1.00000e-06
    diagonalization  = "davidson"
    electron_maxstep = 300
    mixing_beta      =  1.0000e-02
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
Al     26.981539  Al.SCAN.UPF2

ATOMIC_POSITIONS {alat}
Al      0.000000   0.000000   0.000000

EOF
  pw.x < "$DIRNAME/$FILENAME" > "$DIRNAME/PW.out" &
  pids[$index]=$!
done

for index in ${pids[@]}; do
  wait ${pids[$index]}
  cat "Job ${index} done"
done




