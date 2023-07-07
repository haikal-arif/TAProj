#!/bin/bash

# lattice_params in bohr
lattice_params=(4.2524593460441436 4.394207990912282 4.53595663578042 4.677705280648558 4.819453925516696 4.961202570384835 5.102951215252973 5.244699860121111 5.386448504989249 5.528197149857387 5.669945794725525 5.811694439593663 5.953443084461801 6.095191729329939 6.236940374198078 6.378689019066216)
FILENAME="PW.in"

for index in "${!lattice_params[@]}"; do
  DIRNAME="./input_pw/LiCl/$index/"
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
Cl      35.453  Cl.SCAN.UPF2

ATOMIC_POSITIONS {alat}
Li      0.000000   0.000000   0.000000
Cl      0.500000   0.500000   0.500000 

EOF
  pw.x < "$DIRNAME/$FILENAME" > "$DIRNAME/PW.out" &
  pids[$index]=$!
done

for index in ${pids[@]}; do
  wait ${pids[$index]}
  cat 
done




