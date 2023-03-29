#!/bin/bash

lattice_params=(4.3752 4.52104 4.66688 4.81272 4.95856 5.1044 5.25024 5.39608 5.54192 5.68776 5.8336 5.97944 6.12528 6.27112 6.41696 6.5628)
FILENAME="PW.in"

for index in "${!lattice_params[@]}"; do
  DIRNAME="./input_pw/Si/$index/"
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
Si     28.0855   Si.SCAN.UPF2

ATOMIC_POSITIONS {alat}
Si      0.000000   0.000000   0.000000
Si      0.250000   0.250000   0.250000 

EOF
  pw.x < "$DIRNAME/$FILENAME" > "$DIRNAME/PW.out" &
  pids[$index]=$!
done

for index in ${pids[@]}; do
  wait ${pids[$index]}
  cat 
done




