# Figura 6.2: Diagrama de Expoente de Lyapunov no plano (r, v)
include("../../src/NickelElectrodissolutionLyapunov.jl")
using .Models, .Analysis
using Plots
using ProgressMeter

# Grade de parâmetros (ajuste conforme necessário)
r_values = 4.1584:0.001:4.173
v_values = 4.9459:0.001:4.9546

# Parâmetros fixos do sistema
base_params = [0.3, 6e-5, 1e-5, 1600, 0.01, 2.0, 0.0, 1.0, 0.0, 0.0]  # placeholder r,v

# Simulação
h = 0.01
nsteps = 100_000
λ1_map = zeros(length(r_values), length(v_values))

@showprogress for (i, r) in enumerate(r_values)
    for (j, v) in enumerate(v_values)
        # Atualizar parâmetros
        par = copy(base_params)
        par[9] = r
        par[10] = v

        # Estado inicial
        u0 = [-2.0, 1.0, 0.1]

        # Cálculo do expoente de Lyapunov
        λ = calculate_lyapunov(HaimNick!, jacobian_function, u0, par, h, nsteps, nlyap=1)
        λ1_map[i, j] = λ[1]
    end
end

# Plotar
heatmap(
    v_values, r_values, λ1_map,
    xlabel = "v", ylabel = "r",
    title = "Figura 6.2A - Expoente de Lyapunov",
    colorbar_title = "λ₁", color = :viridis
)

# Salvar
savefig("figures/figura_6_2A.png")
println("Figura 6.2A salva em figures/figura_6_2A.png")
