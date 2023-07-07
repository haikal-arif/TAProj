using TAProj
using PWDFT

const ALL_PADE_PSP = Dict(
    "Ag" => ("Ag-q11.gth", "Ag-q19.gth", "Ag-q1.gth",),
    "Al" => ("Al-q3.gth",),
    "Ar" => ("Ar-q8.gth",),
    "As" => ("As-q5.gth",),
    "At" => ("At-q7.gth",),
    "Au" => ("Au-q11.gth", "Au-q19.gth", "Au-q1.gth",),
    "Ba" => ("Ba-q10.gth", "Ba-q2.gth",),
    "Be" => ("Be-q4.gth", "Be-q2.gth",),
    "Bi" => ("Bi-q5.gth",),
    "B" => ("B-q3.gth",),
    "Br" => ("Br-q7.gth",),
    "Ca" => ("Ca-q10.gth", "Ca-q2.gth",),
    "Cd" => ("Cd-q12.gth", "Cd-q2.gth",),
    "Ce" => ("Ce-q12.gth",),
    "Cl" => ("Cl-q7.gth",),
    "Co" => ("Co-q17.gth", "Co-q9.gth",),
    "C" => ("C-q4.gth",),
    "Cr" => ("Cr-q14.gth", "Cr-q6.gth",),
    "Cs" => ("Cs-q9.gth", "Cs-q1.gth",),
    "Cu" => ("Cu-q11.gth", "Cu-q19.gth", "Cu-q1.gth",),
    "Dy" => ("Dy-q20.gth",),
    "Er" => ("Er-q22.gth",),
    "Eu" => ("Eu-q17.gth",),
    "Fe" => ("Fe-q16.gth", "Fe-q8.gth",),
    "F" => ("F-q7.gth",),
    "Ga" => ("Ga-q13.gth", "Ga-q3.gth",),
    "Gd" => ("Gd-q18.gth",),
    "Ge" => ("Ge-q4.gth",),
    "He" => ("He-q2.gth",),
    "Hf" => ("Hf-q12.gth",),
    "Hg" => ("Hg-q12.gth", "Hg-q2.gth",),
    "Ho" => ("Ho-q21.gth",),
    "H" => ("H-q1.gth",),
    "In" => ("In-q13.gth", "In-q3.gth",),
    "I" => ("I-q7.gth",),
    "Ir" => ("Ir-q17.gth", "Ir-q9.gth",),
    "K" => ("K-q9.gth", "K-q1.gth",),
    "Kr" => ("Kr-q8.gth",),
    "La" => ("La-q11.gth",),
    "Li" => ("Li-q3.gth", "Li-q1.gth",),
    "Lu" => ("Lu-q25.gth",),
    "Mg" => ("Mg-q10.gth", "Mg-q2.gth",),
    "Mn" => ("Mn-q15.gth", "Mn-q7.gth",),
    "Mo" => ("Mo-q14.gth", "Mo-q6.gth",),
    "Na" => ("Na-q9.gth", "Na-q1.gth",),
    "Nb" => ("Nb-q13.gth", "Nb-q5.gth",),
    "Nd" => ("Nd-q14.gth",),
    "Ne" => ("Ne-q8.gth",),
    "Ni" => ("Ni-q18.gth", "Ni-q10.gth",),
    "N" => ("N-q5.gth",),
    "O" => ("O-q6.gth",),
    "Os" => ("Os-q16.gth", "Os-q8.gth",),
    "Pb" => ("Pb-q4.gth",),
    "Pd" => ("Pd-q18.gth", "Pd-q10.gth",),
    "Pm" => ("Pm-q15.gth",),
    "Po" => ("Po-q6.gth",),
    "P" => ("P-q5.gth",),
    "Pr" => ("Pr-q13.gth",),
    "Pt" => ("Pt-q18.gth", "Pt-q10.gth",),
    "Rb" => ("Rb-q9.gth", "Rb-q1.gth",),
    "Re" => ("Re-q15.gth", "Re-q7.gth",),
    "Rh" => ("Rh-q17.gth", "Rh-q9.gth",),
    "Rn" => ("Rn-q8.gth",),
    "Ru" => ("Ru-q16.gth", "Ru-q8.gth",),
    "Sb" => ("Sb-q5.gth",),
    "Sc" => ("Sc-q11.gth", "Sc-q3.gth",),
    "Se" => ("Se-q6.gth",),
    "Si" => ("Si-q4.gth",),
    "Sm" => ("Sm-q16.gth",),
    "Sn" => ("Sn-q4.gth",),
    "S" => ("S-q6.gth",),
    "Sr" => ("Sr-q10.gth", "Sr-q2.gth",),
    "Ta" => ("Ta-q13.gth", "Ta-q5.gth",),
    "Tb" => ("Tb-q19.gth",),
    "Tc" => ("Tc-q15.gth", "Tc-q7.gth",),
    "Te" => ("Te-q6.gth",),
    "Ti" => ("Ti-q12.gth", "Ti-q4.gth",),
    "Tl" => ("Tl-q13.gth", "Tl-q3.gth",),
    "Tm" => ("Tm-q23.gth",),
    "V" => ("V-q13.gth", "V-q5.gth",),
    "W" => ("W-q14.gth", "W-q6.gth",),
    "Xe" => ("Xe-q8.gth",),
    "Yb" => ("Yb-q24.gth",),
    "Y" => ("Y-q11.gth", "Y-q3.gth",),
    "Zn" => ("Zn-q12.gth", "Zn-q20.gth", "Zn-q2.gth",),
    "Zr" => ("Zr-q12.gth", "Zr-q4.gth",),
)

const DIR_PWDFT = joinpath(dirname(pathof(PWDFT)), "..")
const DIR_PSP = joinpath(DIR_PWDFT, "pseudopotentials", "pade_gth")


function main()
    lc20 = createLC20()


    for atom_recipes in lc20


        molecule = join(atom_recipes.atom_names)

        if molecule ∉ ARGS
            continue
        end

        low_bound = atom_recipes.lattice_param * 0.8
        upper_bound = atom_recipes.lattice_param * 1.2
        num_points = 16
        latvecs_vals = range(low_bound, upper_bound, num_points)
        ecutwfc = 50.0

        print(molecule)
        molecule = strip(molecule)

        for (idx, latvecs_point) in collect(enumerate(latvecs_vals))
            open("./raw_data/result-pwdft-libxc/$molecule/dat"."a") do file
                redirect_stdout(file)
                atom_recipes.lattice_param = latvecs_point * ANG2BOHR
                crystal_structure = build(atom_recipes)
                pspfiles = map(key -> joinpath(DIR_PSP, ALL_PADE_PSP[strip(key)][1]), atom_recipes.atom_names)
                ham = Hamiltonian(crystal_structure, pspfiles, ecutwfc, meshk=[10, 10, 10], xcfunc="SCAN", use_xc_internal=false)
                KS_solve_SCF!(ham, betamix=0.2, etot_conv_thr=1e-5, update_psi="davidson")
                total_energy = sum(ham.energies)
                line = "!$latvecs_point\t$total_energy\n"
                print(line)

            end
        end

        println("Finished job")

        # open file
    end
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end