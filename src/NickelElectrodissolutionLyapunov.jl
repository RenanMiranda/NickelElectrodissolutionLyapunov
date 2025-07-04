module NickelElectrodissolutionLyapunov

using DynamicalSystems
using Plots
using LinearAlgebra
using Statistics
using DifferentialEquations

# Criar módulos principais
module Models
    using LinearAlgebra
    using DifferentialEquations
    export HaimNick!, HaimNickCoupled!
    include(joinpath(@__DIR__, "models", "HaimNick.jl"))
end

module Analysis
    using LinearAlgebra
    using Statistics
    export calculate_lyapunov, synchronization_error, phase_difference
    include(joinpath(@__DIR__, "analysis", "LyapunovExponents.jl"))
    include(joinpath(@__DIR__, "analysis", "Synchronization.jl"))
end

module Utils
    using Plots
    export plot_timeseries, plot_phasespace
end

module Numerics
    include(joinpath(@__DIR__, "numerics", "Simulation.jl"))
    using .Simulation
    export simulate_coupled_system
end


# Exportar módulos principais
export Models, Analysis, Utils, Numerics

# Exportar funções específicas para conveniência
export HaimNick!, HaimNickCoupled!
export calculate_lyapunov
export synchronization_error, phase_difference
export simulate_coupled_system

# Usar os módulos
using .Models
using .Analysis
using .Utils
using .Numerics

end # module