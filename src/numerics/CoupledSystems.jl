using DifferentialEquations

# Sistema de Lorenz acoplado
function lorenz!(du, u, p, t)
    # Parâmetros do sistema de Lorenz
    σ, ρ, β = p[1:3]
    # Força de acoplamento
    coupling = p[4]
    
    # Primeiro sistema
    du[1] = σ * (u[2] - u[1])
    du[2] = u[1] * (ρ - u[3]) - u[2]
    du[3] = u[1] * u[2] - β * u[3]
    
    # Segundo sistema
    du[4] = σ * (u[5] - u[4]) + coupling * (u[1] - u[4])
    du[5] = u[4] * (ρ - u[6]) - u[5]
    du[6] = u[4] * u[5] - β * u[6]
    
    return nothing
end

# Função para simular sistemas acoplados
function simulate_coupled_system(par1, par2, tspan, h)
    # Condições iniciais ligeiramente diferentes
    u0 = [1.0, 0.0, 0.0,  # Primeiro sistema
          1.1, 0.1, 0.0]  # Segundo sistema
    
    # Parâmetros do sistema de Lorenz
    σ = 10.0    # Número de Prandtl
    ρ = 28.0    # Número de Rayleigh
    β = 8/3     # Parâmetro geométrico
    
    # Força de acoplamento (último elemento de par1)
    coupling = par1[end]
    
    # Parâmetros combinados
    p = [σ, ρ, β, coupling]
    
    # Configurar o problema
    prob = ODEProblem(lorenz!, u0, tspan, p)
    
    # Resolver usando Tsit5 (um solver eficiente para sistemas não-stiff)
    sol = solve(prob, Tsit5(), dt=h, adaptive=false)
    
    return sol
end