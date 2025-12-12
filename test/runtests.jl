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
    x = (mass = Int32(1), rho = Int64(1), x = Int16(2), u = Int128(2), s = Int8(4))
    eh = EHeader(x)
    @test capacity(eh) == (mass = 1, rho = 1, x = 2, u = 2, s = 4)
    @test index(eh) == (mass = 1, rho = 2, x = 3, u = 5, s = 7)
    @test length(eh) == 10
end