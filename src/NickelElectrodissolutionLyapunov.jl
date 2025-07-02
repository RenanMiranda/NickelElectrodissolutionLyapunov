module NickelElectrodissolutionLyapunov

using DynamicalSystems
using Plots
using LinearAlgebra
using Statistics

# Criar submódulos
module HaimNick
    using LinearAlgebra
    export HaimNick!, HaimNickCoupled!
    include(joinpath(@__DIR__, "models", "HaimNick.jl"))
end

module LyapunovExponents
    using LinearAlgebra
    export calculate_lyapunov
    include(joinpath(@__DIR__, "analysis", "LyapunovExponents.jl"))
end

module Synchronization
    using LinearAlgebra
    using Statistics: mean
    export synchronization_error, phase_difference
    include(joinpath(@__DIR__, "analysis", "Synchronization.jl"))
end

# Exportar funções dos submódulos
export HaimNick!, HaimNickCoupled!
export calculate_lyapunov
export synchronization_error, phase_difference

# Usar os submódulos
using .HaimNick
using .LyapunovExponents
using .Synchronization

end # module