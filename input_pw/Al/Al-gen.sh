#!/bin/bash

lattice_params=(3.36 3.472 3.584 3.696 3.808 3.92 4.032 4.144 4.256 4.368 4.48 4.592 4.704 4.816 4.928 5.04)
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
    nspin       = 2
    ntyp        = 1
    occupations = 'smearing'
    degauss     = 0.1
starting_magnetization = 2.0
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




