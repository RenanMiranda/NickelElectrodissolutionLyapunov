module Visualization

using Plots

export plot_phase_diagram, plot_timeseries

function plot_phase_diagram(e1, θ1, e2, θ2, σ)
    p1 = scatter(e1, θ1, title="Oscilador 1 (σ=$σ)", legend=false)
    p2 = scatter(e2, θ2, title="Oscilador 2 (σ=$σ)", legend=false)
    p3 = scatter(e1, e2, title="Relação entre osciladores", xlabel="e1", ylabel="e2")
    plot(p1, p2, p3, layout=(3,1), size=(800, 900))
end

function plot_timeseries(t, e1, e2, σ)
    plot(t, e1, label="Oscilador 1", linewidth=2)
    plot!(t, e2, label="Oscilador 2", linewidth=2)
    title!("Séries Temporais (σ=$σ)")
    xlabel!("Tempo")
    ylabel!("Potencial (e)")
end

end