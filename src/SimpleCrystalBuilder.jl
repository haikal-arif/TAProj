using PWDFT

"Basic crystal structure for building crystal systems"
@enum CrystalStructure begin
    fcc
    bcc
    diamond
    rocksalt
    zinc_blende
end

AtomsList = Vector{String}
PspFilesPath = Vector{String}
VecAtomsConfig = Tuple{AtomsList,CrystalStructure,PspFilesPath,Float64}

"""
A Struct to store elementary properties of simple crystal
 atom_names     : List of atoms that create the crystal
 structure      : Its crystal structure e.g. fcc, bcc
 lattice_param  : Lattice parameter
---
"""
mutable struct SimpleCrystalConfig
    atom_names::AtomsList
    structure::CrystalStructure
    lattice_param::Float64
end

"""
a Dict for mapping CrystalStructure into its respective lattice_generator and number of atoms
"""
lattice_map = Dict{CrystalStructure,Tuple{Function,Int}}(
    fcc => (gen_lattice_fcc, 1),
    bcc => (gen_lattice_bcc, 1),
    diamond => (gen_lattice_fcc, 2),
    rocksalt => (gen_lattice_fcc, 2),
    zinc_blende => (gen_lattice_fcc, 2),
)

"""
Build a simple Atoms struct from SimpleCrystalConfig, lattice_map is the default mapper,
builder is the config struct i.e. a SimpleCrystalConfig struct,
mapper is a Dict that map CrystalStructure into lattice_generator function and number of atom in that crystal structure
---
"""
function build(builder_config::SimpleCrystalConfig; mapper::Dict{CrystalStructure,Tuple{Function,Int}}=lattice_map)::Atoms

    atoms::AtomsList = builder_config.atom_names
    crystalstructure::CrystalStructure = builder_config.structure
    lattice_param::Float64 = builder_config.lattice_param

    atom_name::String = atoms[1]
    string_frac::String = "\n\n$atom_name 0.0 0.0 0.0\n"

    if crystalstructure == diamond
        atom_name = atoms[1]
        string_frac *= "$(atom_name) 0.25  0.25  0.25\n" # Julia use * for string concatenation
    end

    if crystalstructure == rocksalt
        atom_name = atoms[2]
        string_frac *= "$atom_name 0.5  0.5  0.5\n"
    end

    if crystalstructure == zinc_blende
        atom_name = atoms[2]
        string_frac *= "$atom_name 0.25  0.25  0.25\n"
    end

    lattice_generator::Function, natoms::Int = get(mapper, crystalstructure, (x -> zeros{Float64}(3, 3), 0))

    string_frac = "$natoms" * string_frac

    if natoms == 0
        return nothing
    end

    Atoms(
        xyz_string_frac=string_frac,
        in_bohr=true,
        LatVecs=lattice_generator(lattice_param)
    )
end
