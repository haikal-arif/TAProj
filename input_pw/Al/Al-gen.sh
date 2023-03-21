#!/bin/bash

lattice_params=(3.24 3.356 3.4714285714285715 3.587142857142857 3.702857142857143 3.8185714285714285 3.934285714285714 4.05 4.16571 42857142855 4.281428571428571 4.397142857142857 4.5128571428571425 4.628571428571428 4.744285714285714 4.86)
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
    pseudo_dir  = "/home/mhaikala/Documents/TA/PWDFT.jl/pseudopotentials/scan_upf/"
    outdir      = "$DIRNAME"
/

&SYSTEM
    celldm(1)   = ${lattice_params[$index]} 
    ecutwfc     =  5.00000e+01
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
  cat 
done




