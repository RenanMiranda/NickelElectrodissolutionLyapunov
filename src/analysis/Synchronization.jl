module Synchronization

"""
    synchronization_error(traj1, traj2, Δt)

Calcula erro de sincronização com operações vetorizadas.
"""
function synchronization_error(traj1, traj2, Δt)
    # Verificação de dimensões
    size(traj1) == size(traj2) || throw(DimensionMismatch("Trajetórias devem ter mesmas dimensões"))
    
    # Cálculo vetorizado da norma euclidiana
    diff = traj1 .- traj2
    norms_sq = sum(diff.^2, dims=1)
    error_sum = sum(sqrt.(norms_sq))
    
    return error_sum * Δt / size(traj1, 2)
end

"""
    phase_difference(θ1, e1, θ2, e2, dt)

Calcula diferença de fase com tratamento de descontinuidades.
"""
function phase_difference(θ1, e1, θ2, e2, dt)
    # Cálculo seguro de ângulos (evitar divisão por zero)
    phases1 = atan.(θ1, e1 .+ 1e-10)
    phases2 = atan.(θ2, e2 .+ 1e-10)
    
    # Diferença de fase com correção de descontinuidades
    ΔΦ = mod2pi.(phases1 .- phases2)
    
    # Suavização de descontinuidades
    for i in 2:length(ΔΦ)
        if abs(ΔΦ[i] - ΔΦ[i-1]) > π
            ΔΦ[i] -= 2π * sign(ΔΦ[i] - ΔΦ[i-1])
        end
    end
    
    # Diferença de frequência (derivada numérica)
    ΔΩ = mean(diff(ΔΦ)) / dt
    
    return ΔΦ, ΔΩ
end

end