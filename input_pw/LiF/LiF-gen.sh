#!/bin/bash

# lattice_params in bohr
lattice_params=(3.44 3.5546666666666664 3.6693333333333333 3.784 3.8986666666666663 4.013333333333333 4.128 4.242666666666667 4.357333333333333 4.4719999999999995 4.586666666666666 4.7013333333333325 4.815999999999999 4.930666666666666 5.045333333333333 5.159999999999999 )
FILENAME="PW.in"

for index in "${!lattice_params[@]}"; do
  DIRNAME="./input_pw/LiF/$index/"
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
    ntyp        = 2
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
Li      6.941   Li.SCAN.UPF2
F      18.998   F.SCAN.UPF2

ATOMIC_POSITIONS {alat}
Li      0.000000   0.000000   0.000000
F       0.500000   0.500000   0.500000 

EOF
  pw.x < "$DIRNAME/$FILENAME" > "$DIRNAME/PW.out" &
  pids[$index]=$!
done

for index in ${pids[@]}; do
  wait ${pids[$index]}
  cat 
done




