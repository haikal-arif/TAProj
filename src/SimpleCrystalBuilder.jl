"Basic crystal structure for building crystal systems"
@enum CrystalStructure begin
    fcc
    bcc
    diamond
    rocksalt
    zinc_blende
end

const AtomsList = Vector{String}
const PspFilesPath = Vector{String}
const VecAtomsConfig = Tuple{AtomsList, CrystalStructure, PspFilesPath, Float64}

struct SimpleCrystalConfig
    atom_names::AtomsList
    structure::CrystalStructure
    lattice_param::Float64
end

const lattice_map = Dict{CrystalStructure, Tuple{Function, Int}}(
        fcc => (gen_lattice_fcc, 1),
        bcc => (gen_lattice_bcc, 1),
        diamond => (gen_lattice_fcc, 2),
        rocksalt => (gen_lattice_fcc, 2),
        zinc_blende => (gen_lattice_fcc, 2),
    )

function build(builder_config::SimpleCrystalConfig; mapper::Dict{CrystalStructure, Tuple{Function, Int}}=lattice_map)::Atoms

    atoms = builder_config.atom_names
    crystalstructure = builder_config.structure
    lattice_param = builder_config.lattice_param

    atom_name = atoms[1]
    string_frac = "\n\n$atom_name 0.0 0.0 0.0\n"

    if crystalstructure == diamond
        atom_name = atoms[1]
        string_frac *= "$(atom_name) 0.25  0.25  0.25\n"
    end

    if crystalstructure == rocksalt
        atom_name = atoms[2]
        string_frac *= "$atom_name 0.5  0.5  0.5\n"
    end

    if crystalstructure == zinc_blende
        atom_name = atoms[2]
        string_frac *= "$atom_name 0.25  0.25  0.25\n"
    end
    
    lattice_generator, natoms = get(mapper, crystalstructure, (x -> zeros{Float64}(3,3), 0))

    string_frac = "$natoms"*string_frac

    if natoms == 0
        return nothing
    end
    
    Atoms(
        xyz_string_frac=string_frac,
        in_bohr=true,
        LatVecs=lattice_generator(lattice_param)
    )
end
