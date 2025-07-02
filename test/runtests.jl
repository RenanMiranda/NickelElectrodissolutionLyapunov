using Test
using NickelElectrodissolutionLyapunov
using LinearAlgebra

@testset "NickelElectrodissolutionLyapunov.jl" begin
    @testset "HaimNick Model" begin
        # Parâmetros do modelo
        a, b, c = 0.1, 0.1, 0.1
        Ch, Γ1, Γ2 = 0.1, 0.1, 0.1
        σ, A, r, v = 0.1, 1.0, 1.0, 1.0
        par = [a, b, c, Ch, Γ1, Γ2, σ, A, r, v]
        
        # Estado inicial
        u = [0.1, 0.1, 0.1]
        du = similar(u)
        e_acop = 0.1
        
        # Teste da função HaimNick!
        @test begin
            HaimNick!(du, u, par, e_acop)
            !any(isnan, du)
        end
    end
    
    @testset "Synchronization Analysis" begin
        # Dados de teste
        traj1 = rand(3, 100)
        traj2 = rand(3, 100)
        Δt = 0.01
        
        # Teste do erro de sincronização
        @test begin
            err = synchronization_error(traj1, traj2, Δt)
            err ≥ 0
        end
        
        # Teste da diferença de fase
        θ1 = rand(100)
        e1 = rand(100)
        θ2 = rand(100)
        e2 = rand(100)
        dt = 0.01
        
        @test begin
            ΔΦ, ΔΩ = phase_difference(θ1, e1, θ2, e2, dt)
            length(ΔΦ) == length(θ1) && isa(ΔΩ, Real)
        end
    end
    
    @testset "Lyapunov Exponents" begin
        # Sistema de teste simples (oscilador harmônico)
        f(du, u, p, t) = begin
            du[1] = u[2]
            du[2] = -u[1]
        end
        
        jac(J, u, p, t) = begin
            J[1,1] = 0.0;  J[1,2] = 1.0
            J[2,1] = -1.0; J[2,2] = 0.0
        end
        
        u0 = [1.0, 0.0]
        p = nothing
        h = 0.01
        nsteps = 1000
        
        # Teste do cálculo dos expoentes
        @test begin
            λ = calculate_lyapunov(f, jac, u0, p, h, nsteps, nlyap=2)
            length(λ) == 2
        end
    end
end