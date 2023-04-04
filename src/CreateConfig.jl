using PWDFT

const PSP_DIR = "C:\\Users\\mhaikala\\Documents\\Kuliah\\PWDFT.jl\\pseudopotentials\\"

"""
Create LC20 dataset
"""
function createLC20()::Vector{SimpleCrystalConfig}
    data::Vector{SimpleCrystalConfig} = [
        SimpleCrystalConfig(["Li"], bcc, 3.477),
        SimpleCrystalConfig(["Na"], bcc, 4.208),
        SimpleCrystalConfig(["Al"], fcc, 4.054),
        SimpleCrystalConfig(["Rh"], fcc, 3.835),
        SimpleCrystalConfig(["Pd"], fcc, 3.948),
        SimpleCrystalConfig(["Cu"], fcc, 3.643),
        SimpleCrystalConfig(["Ag"], fcc, 4.154),
        SimpleCrystalConfig(["C"], diamond, 3.7815),
        SimpleCrystalConfig(["Si"], diamond, 5.469),
        SimpleCrystalConfig(["Ge"], diamond, 6.0963),
        SimpleCrystalConfig(["Sn"], diamond, 6.656),
        SimpleCrystalConfig(["Li", "H "], rocksalt, 4.090),
        SimpleCrystalConfig(["Li", "F "], rocksalt, 7.75),
        SimpleCrystalConfig(["Li", "Cl"], rocksalt, 10.045),
        SimpleCrystalConfig(["Na", "F "], rocksalt, 4.733),
        SimpleCrystalConfig(["Na", "Cl"], rocksalt, 5.724),
        SimpleCrystalConfig(["Mg", "O"], rocksalt, 4.207),
        SimpleCrystalConfig(["Si", "C"], zinc_blende, 4.5),
        SimpleCrystalConfig(["Ga", "As"], zinc_blende, 5.648),
    ]

    data
end


function createLC20_metal()::Vector{SimpleCrystalConfig}
    data::Vector{SimpleCrystalConfig} = [
        SimpleCrystalConfig(["Li"], bcc, 3.477),
        SimpleCrystalConfig(["Na"], bcc, 4.208),
        SimpleCrystalConfig(["Al"], fcc, 4.054),
        SimpleCrystalConfig(["Rh"], fcc, 3.835),
        SimpleCrystalConfig(["Pd"], fcc, 3.948),
        SimpleCrystalConfig(["Cu"], fcc, 3.643),
        SimpleCrystalConfig(["Ag"], fcc, 4.154),
        SimpleCrystalConfig(["Ge"], diamond, 5.761),
        SimpleCrystalConfig(["Sn"], diamond, 6.656),
    ]

    data
end
