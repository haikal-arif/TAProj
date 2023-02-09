using PWDFT
using Optim
include("SimpleCrystalBuilder.jl")

function create_energy_calculator(system::Hamiltonian, crystal_structure::CrystalStructure)
    const structure_map::Dict{CrystalStructure, Function} = Dict(
        fcc => gen_lattice_fcc
    )

    function energy_calculator(lattice_parameter::Float64)
        latVecs = structure_map[crystal_structure](lattice_parameter)
        Hamiltonian.atoms.latVecs = latVecs
        sum(calc_energies(system, psiks))
    end

    return energy_calculator
end


function main()
    atom_config = SimpleCrystalConfig(["Li"], bcc, 3.477)
    atomic_system = build(atom_config)
    pspfiles = [joinpath(DIR_PSP, ALL_PADE_PSP["Li"][0])]
    ecutwfc = 40.0
    Ham = Hamiltonian( atomic_system, pspfiles, ecutwfc, meshk=[3,3,3] )
    energy_calculator = create_energy_calculator(Ham, fcc)
    optimize(energy_calculator, 3.5)
end


main()