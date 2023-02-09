using Test

include("../src/CreateConfig.jl")

@testset "Crystal Creation" begin
    @testset "Single atom" begin
        config = SimpleCrystalConfig(["Li"], bcc, 3.477)
        atom_config = build(config)
        @test atom_config.Natoms == 1
        @test atom_config.Nspecies == 1
        @test sum(atom_config.LatVecs[1, :].^2) ≈ sqrt((3.477^2)*2)/2
    end
    
end



@test 