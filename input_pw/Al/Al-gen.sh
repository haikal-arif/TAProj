#!/bin/bash

lattice_params=(6.104 6.322 6.54 6.758 6.976 7.194 7.412 7.629999999999999 7.847999999999999 8.065999999999999 8.283999999999999 8.501999999999999 8.719999999999999 8.937999999999999 9.155999999999999 )
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
  cat 
done




