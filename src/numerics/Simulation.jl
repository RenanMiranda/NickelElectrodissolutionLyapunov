module Simulation

using DifferentialEquations

export simulate_coupled_system

"""
    simulate_coupled_system(model!, u0, p, tspan, h; solver=Tsit5())

Simula um sistema de EDOs genérico.

# Argumentos
- `model!`: função do sistema (ex: `HaimNickCoupled!`, `lorenz!`)
- `u0`: vetor de condições iniciais
- `p`: parâmetros (vetor, tupla, etc)
- `tspan`: intervalo de tempo (ex: (0.0, 1000.0))
- `h`: passo de integração
- `solver`: (opcional) método numérico (default: `Tsit5()`)

# Retorno
- `sol`: objeto de solução da simulação
"""
function simulate_coupled_system(model!, u0, p, tspan, h; solver=Tsit5())
    prob = ODEProblem(model!, u0, tspan, p)
    return solve(prob, solver; dt=h, adaptive=false)
end

end
