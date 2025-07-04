# Figura 6.3 da Tese: Análise de sincronização com variação de σ
# Reproduz séries temporais e espaços de fase para diferentes forças de acoplamento

using NickelElectrodissolutionLyapunov
using NickelElectrodissolutionLyapunov: Models, Numerics, Analysis, Utils
using Plots

# ===== Configuração da Simulação =====
σ_values = [0.00, 0.01, 0.02, 0.03, 0.04, 0.05]  # Forças de acoplamento
tspan = (0.0, 1000.0)    # Tempo de simulação
h = 0.1                  # Passo de integração
cutoff = 500              # Tempo inicial para análise (transiente)

# Parâmetros base (Tabela 6.1 da tese)
base_par = [0.3, 6e-5, 1e-5, 1600, 0.01, 2.0, 0.0, 1, 4.16083, 4.93923]

# Configurar osciladores com mismatch em Γ2
par1 = copy(base_par); par1[6] = 1.98  # Oscilador 1: Γ2 = 1.98
par2 = copy(base_par); par2[6] = 2.02  # Oscilador 2: Γ2 = 2.02

# ===== Loop sobre valores de σ =====
results = []
for (i, σ) in enumerate(σ_values)
    # Atualizar força de acoplamento em ambos osciladores
    par1[7] = σ
    par2[7] = σ
    
    # Simular sistema acoplado
    
    sol = simulate_coupled_system(par1, par2, tspan, h)
    
    # Extrair dados após período transiente
    idxs = findall(t -> t >= cutoff, sol.t)
    e1 = sol[1, idxs]  # Potencial oscilador 1
    e2 = sol[4, idxs]  # Potencial oscilador 2
    
    # Calcular métricas de sincronização
    error = synchronization_error(sol[1:3, idxs], sol[4:6, idxs], h)
    ΔΦ, ΔΩ = phase_difference(sol[2, idxs], e1, sol[5, idxs], e2, h)
    
    # Armazenar resultados
    push!(results, (σ=σ, e1=e1, e2=e2, error=error, ΔΩ=ΔΩ))
    
    # Gerar gráficos
    p1 = plot(sol.t[idxs], [e1, e2], 
             label=["Oscilador 1" "Oscilador 2"],
             title="σ = $σ", ylim=(-5, 0))
    
    p2 = scatter(e1, e2, alpha=0.5,
                xlabel="e1", ylabel="e2",
                title="Espaço de Fase")
    
    # Salvar figuras
    savefig(p1, "figures/timeseries_σ_$i.png")
    savefig(p2, "figures/phasespace_σ_$i.png")
end

# ===== Análise Crítica =====
# Determinar σ crítico para sincronização completa
critical_idx = findfirst(r -> r.error < 0.01, results)
if !isnothing(critical_idx)
    println("σ crítico para sincronização: $(results[critical_idx].σ)")
else
    println("Não foi encontrado σ crítico para sincronização (erro < 0.01)")
end