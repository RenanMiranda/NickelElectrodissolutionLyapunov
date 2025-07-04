# Figura 6.3 da Tese: Séries temporais e espaços de fase para diferentes forças de acoplamento σ

using NickelElectrodissolutionLyapunov
using NickelElectrodissolutionLyapunov: Models, Analysis, Numerics
using Plots
using Printf

# ==================== CONFIGURAÇÃO ====================

σ_values = [0.00, 0.01, 0.02, 0.03, 0.04, 0.05]  # Forças de acoplamento
tspan = (0.0, 1000.0)      # Intervalo de tempo
h = 0.1                    # Passo de tempo
cutoff = 500.0             # Ignora transiente inicial

# Parâmetros base conforme Tabela 6.1
base_par = [0.3, 6e-5, 1e-5, 1600.0, 0.01, 2.0, 0.0, 1.0, 4.16083, 4.93923]  # σ será atualizado
par1 = copy(base_par); par1[6] = 1.98
par2 = copy(base_par); par2[6] = 2.02

# Condição inicial comum
u0 = [-2.0, 1.0, 0.1,   # Oscilador 1: e, θ, η
      -2.0, 1.0, 0.1]   # Oscilador 2: e, θ, η

# Pasta para salvar as figuras
results_dir = "figures"
isdir(results_dir) || mkdir(results_dir)

# ==================== LOOP SOBRE σ ====================

results = []

for (i, σ) in enumerate(σ_values)
    println(" Simulando para σ = $σ")

    # Atualiza força de acoplamento
    par1[7] = σ
    par2[7] = σ

    # Simula usando a função genérica
    sol = Numerics.simulate_coupled_system(Models.HaimNickCoupled!, u0, (par1, par2), tspan, h)

    # Pega os índices após transiente
    idxs = findall(t -> t >= cutoff, sol.t)

    # Extrai estados
    e1, θ1 = sol[1, idxs], sol[2, idxs]
    e2, θ2 = sol[4, idxs], sol[5, idxs]

    # Calcula métricas
    osc1 = sol[1:3, idxs]
    osc2 = sol[4:6, idxs]
    error = Analysis.synchronization_error(osc1, osc2, h)
    _, ΔΩ = Analysis.phase_difference(θ1, e1, θ2, e2, h)

    # Armazena resultados
    push!(results, (σ=σ, e1=e1, e2=e2, error=error, ΔΩ=ΔΩ))

    # ========= PLOT 1: Séries Temporais =========
    p1 = plot(sol.t[idxs], [e1, e2],
        label=["Oscilador 1" "Oscilador 2"],
        xlabel="Tempo", ylabel="Potencial (e)",
        title="Séries Temporais (σ = $σ)",
        linewidth=2, legend=:topright)

    # ========= PLOT 2: Espaço de Fase =========
    p2 = scatter(e1, e2, alpha=0.5,
        xlabel="e₁", ylabel="e₂",
        title="Espaço de Fase (σ = $σ)")

    # ========= Salvar =========
    savefig(p1, joinpath(results_dir, @sprintf("fig6_3_timeseries_sigma_%02d.png", i)))
    savefig(p2, joinpath(results_dir, @sprintf("fig6_3_phasespace_sigma_%02d.png", i)))
end

# Identifica ponto de sincronização
crit_idx = findfirst(r -> r.error < 0.01, results)
if crit_idx !== nothing
    println(" σ crítico para sincronização completa ≈ ", results[crit_idx].σ)
else
    println(" Nenhum σ levou à sincronização total (erro < 0.01)")
end
