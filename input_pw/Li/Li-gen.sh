#!/bin/bash

lattice_params=(8.1985 8.4718 8.7450 9.0183 9.2916 9.5649 9.8382 10.1114 10.3847 10.6580 10.9313 11.2046 11.4779 11.7511 12.0244 12.2977)
FILENAME="PW.in"

for index in "${!lattice_params[@]}"; do
  DIRNAME="./input_pw/Li/$index/"
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
    celldm(1)   = ${lattice_params[$index]} 
    ecutwfc     =  5.00000e+01
    ibrav       = 3
    nat         = 1
    nspin       = 1
    ntyp        = 1
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
Li        Li.SCAN.UPF2

ATOMIC_POSITIONS {alat}
Li      0.000000   0.000000   0.000000

EOF
  pw.x < "$DIRNAME/$FILENAME" > "$DIRNAME/PW.out" &
  pids[$index]=$!
done

for index in ${pids[@]}; do
  wait ${pids[$index]}
  cat 
done




