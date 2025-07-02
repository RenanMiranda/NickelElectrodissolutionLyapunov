# Funções para análise de sincronização
using Statistics: mean

"""    
synchronization_error(traj1, traj2, Δt)

Calcula o erro de sincronização como a norma euclidiana da diferença entre duas trajetórias.

Argumentos:
- traj1: Primeira trajetória (matriz de estados)
- traj2: Segunda trajetória (matriz de estados)
- Δt: Passo de tempo

Retorna:
- Erro de sincronização médio ao longo do tempo
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

Calcula a diferença de fase e frequência entre dois conjuntos de ângulos.
Lida com descontinuidades na fase.

Argumentos:
- θ1: Cobertura superficial do primeiro oscilador
- e1: Potencial elétrico do primeiro oscilador
- θ2: Cobertura superficial do segundo oscilador
- e2: Potencial elétrico do segundo oscilador
- dt: Passo de tempo

Retorna:
- ΔΦ: Diferença de fase ao longo do tempo
- ΔΩ: Diferença de frequência média
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