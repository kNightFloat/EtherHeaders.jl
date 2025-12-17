#=
  @ author: ChenyuBao <chenyu.bao@outlook.com>
  @ date: 2025-12-10 21:57:05
  @ license: MIT
  @ language: Julia
  @ declaration: EtherHeaders.jl uses NamedTuple to express variables.
  @ description: /
 =#

using Test
using EtherHeaders

@testset "ether headers" begin
    a = Dict("x1" => 1, "x2" => 2, "x3" => 3)
    @test dict2nt(a) == (x1 = 1, x2 = 2, x3 = 3) # dict inner order
    x = (mass = Int32(1), rho = Int64(1), x = Int16(2), u = Int128(2), s = Int8(4))
    eh = EHeader(x)
    @test capacity(eh) == (mass = 1, rho = 1, x = 2, u = 2, s = 4)
    @test index(eh) == (mass = 1, rho = 2, x = 3, u = 5, s = 7)
    @test length(eh) == 10
    @test eh isa EHeader{@NamedTuple{mass::Int64,rho::Int64,x::Int64,u::Int64,s::Int64}}
    @test keys(eh) == (:mass, :rho, :x, :u, :s)
    @test capacity(eh, :mass) == 1
    @test index(eh, :mass) == 1
    @test capacity(eh, :rho) == 1
    @test index(eh, :rho) == 2
    @test capacity(eh, :x) == 2
    @test index(eh, :x) == 3
    @test capacity(eh, :u) == 2
    @test index(eh, :u) == 5
    @test capacity(eh, :s) == 4
    @test index(eh, :s) == 7
end
