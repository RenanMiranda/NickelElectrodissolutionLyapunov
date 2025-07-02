# Análise paramétrica eficiente para geração de diagramas
using Distributed
@everywhere using NickelElectrodissolutionLyapunov

function run_parameter_scan(r_range, v_range, σ_vals)
    results = Matrix{Tuple{Float64,Float64}}(undef, length(r_range), length(v_range), length(σ_vals))
    
    @sync @distributed for (i, r) in enumerate(r_range)
        for (j, v) in enumerate(v_range)
            for (k, σ) in enumerate(σ_vals)
                # Configuração de parâmetros
                par = [0.3, 6e-5, 1e-5, 1600, 0.01, 2.0, σ, 1, r, v]
                
                # Simulação curta para estabilização
                u0 = [-2.0, 1.0, 0.1, -2.0, 1.0, 0.1]
                sol = simulate_coupled_system(par, par, (0.0, 1000.0), 0.1)
                
                # Análise após transiente
                steady_state = sol.u[end-1000:end]
                λ = calculate_lyapunov(HaimNickCoupled!, jacobian, 
                                       sol.u[end], (par, par), 0.1, 10000)
                
                # Armazenamento eficiente
                results[i, j, k] = (λ[1], synchronization_error(
                    [s[1:3] for s in steady_state],
                    [s[4:6] for s in steady_state],
                    0.1
                ))
            end
        end
    end
    return results
end

# Função auxiliar para visualização
function plot_parameter_scan(results, r_range, v_range, σ)
    heatmap(r_range, v_range, [r[1] for r in results[:,:,σ]], 
            title="Expoente de Lyapunov (σ=$σ)",
            xlabel="r", ylabel="v", clim=(-0.5, 0.5))
    
    heatmap(r_range, v_range, [r[2] for r in results[:,:,σ]], 
            title="Erro de Sincronização (σ=$σ)",
            xlabel="r", ylabel="v", clim=(0, 5))
end