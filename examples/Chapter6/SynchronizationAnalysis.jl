# Análise de Sincronização em Osciladores Acoplados de Eletrodissolução

include("../../src/NickelElectrodissolutionLyapunov.jl")
using .Models, .Numerics, .Analysis, .Utils
using Plots

# ===== Configuração do Sistema =====
# Dois osciladores com pequena assimetria (não-idênticos)
base_params = [
    # a,    b,       c,       Ch,   Γ1,   Γ2,   σ,  A, r,    v
    0.3, 6e-5,   1e-5,    1600, 0.01,  2.0,  0.0, 1, 4.17, 4.9459
]

# Oscilador 1: Γ2 ligeiramente menor
params1 = copy(base_params)
params1[6] = 1.99  # Γ2

# Oscilador 2: Γ2 ligeiramente maior
params2 = copy(base_params)
params2[6] = 2.01  # Γ2

# ===== Protocolo Experimental Numérico =====
σ_values = 0.0:0.01:0.05  # Varredura de força de acoplamento
results = []

for σ in σ_values
    # Atualizar força de acoplamento
    params1[7] = σ
    params2[7] = σ
    
    # Simular 100,000 passos (h = 0.01)
    solution = simulate_coupled_system(params1, params2, (0.0, 1000.0), 0.01)
    
    # Descartar transiente inicial (primeiros 50,000 passos)
    steady_state = solution[:, 50000:end]
    
    # Separar estados dos osciladores
    osc1 = steady_state[1:3, :]
    osc2 = steady_state[4:6, :]
    
    # Calcular métricas de sincronização
    sync_error = synchronization_error(osc1, osc2, 0.01)
    phase_diff, freq_diff = phase_difference(osc1[2,:], osc1[1,:], osc2[2,:], osc2[1,:])
    
    # Armazenar resultados
    push!(results, (
        σ = σ,
        error = sync_error,
        freq_diff = freq_diff,
        time_series = (osc1[1,:], osc2[1,:]),
        phase_space = (osc1[1,:], osc2[1,:])
    ))
end

# ===== Visualização dos Resultados =====
# Gráfico 1: Erro de sincronização vs força de acoplamento
p1 = plot([r.σ for r in results], [r.error for r in results],
         xlabel="Força de Acoplamento (σ)", ylabel="Erro de Sincronização",
         title="Transição para Sincronização", marker=:o, legend=false)

# Gráfico 2: Diferença de frequência vs força de acoplamento
p2 = plot([r.σ for r in results], abs.([r.freq_diff for r in results]),
         xlabel="Força de Acoplamento (σ)", ylabel="|ΔΩ|",
         title="Sincronização de Fase", marker=:o, legend=false)

# Identificar ponto de sincronização completa
critical_idx = findfirst(r -> r.error < 0.01, results)
if !isnothing(critical_idx)
    vline!([results[critical_idx].σ], color=:red, linestyle=:dash, label="σ_c = $(round(results[critical_idx].σ, digits=3))")
end

# Salvar figura composta
savefig(plot(p1, p2, layout=(2,1)), "synchronization_transition.png")

# ===== Análise de Caos =====
# Calcular expoentes de Lyapunov para sistema acoplado
lyap_exp = calculate_lyapunov(
    HaimNickCoupled!, 
    jacobian_function, 
    [-2.0, 1.0, 0.1, -2.0, 1.0, 0.1],
    (params1, params2),
    0.01,
    100000
)

println("Expoentes de Lyapunov: ", lyap_exp)
println("Presença de caos: ", any(lyap_exp .> 0))