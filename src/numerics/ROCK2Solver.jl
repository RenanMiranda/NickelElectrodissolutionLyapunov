module ROCK2Solver

using OrdinaryDiffEq

"""
    solve_pde(f, u0, tspan, p; saveat=[])

Resolve EDPs com o método ROCK2 com opções flexíveis.
"""
function solve_pde(f, u0, tspan, p; saveat=[])
    # Configuração padrão para sistemas stiff
    prob = ODEProblem(f, u0, tspan, p)
    
    # Seleção automática de tolerâncias para sistemas químicos
    reltol = 1e-6
    abstol = 1e-8
    
    # Configuração de salvamento eficiente
    save_args = if isempty(saveat)
        (save_everystep=false, save_start=false)
    else
        (saveat=saveat,)
    end
    
    sol = solve(prob, ROCK2(), 
                reltol=reltol, abstol=abstol,
                progress=true,
                save_args...)
    
    # Verificação de estabilidade numérica
    if any(isnan, sol.u[end])
        @warn "Solução contém NaNs! Ajuste parâmetros ou tolerâncias."
    end
    
    return sol
end

end