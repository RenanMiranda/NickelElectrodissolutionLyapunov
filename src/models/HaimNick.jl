# Funções do modelo HaimNick

"""    
HaimNick!(du, u, par, e_acop)

Modelo dinâmico para eletrodissolução de níquel com três variáveis de estado:
- e: Potencial elétrico da dupla camada
- θ: Cobertura superficial de intermediários reacionais
- η: Concentração de íons na interface eletrodo-solução

Parâmetros:
a, b, c: Constantes cinéticas
Ch: Capacitância da dupla camada
Γ1, Γ2: Fatores de escala temporal
σ: Força de acoplamento entre osciladores
A: Fator de amplificação
r: Resistência elétrica
v: Tensão aplicada
e_acop: Potencial do oscilador acoplado
"""
function HaimNick!(du, u, par, e_acop)
    # Desestruturação eficiente de parâmetros
    a, b, c, Ch, Γ1, Γ2, σ, A, r, v = par
    e, θ, η = u
    
    # Cálculos intermediários reutilizados
    exp_e = exp(e)
    exp_half_e = exp(0.5e)
    Ch_exp_e = Ch * exp_e
    
    # Termo de corrente faradaica
    A_val = exp_half_e / (1 + Ch_exp_e)
    B_val = Ch * η * exp_e
    I_f = (1 - θ) * (a * exp_e + Ch * A_val)
    
    # Sistema de EDOs (equações principais)
    @inbounds begin
        du[1] = (v - e) / r - I_f + A * σ * (e_acop - e)
        du[2] = (A_val * (1 - θ) - b * B_val) / Γ1
        du[3] = (exp(2e) * (θ - η) - c * B_val) / Γ2
    end
    
    return nothing
end

"""    
HaimNickCoupled!(du, u, p, t)

Modelo para dois osciladores acoplados com acoplamento mútuo.
"""
function HaimNickCoupled!(du, u, p, t)
    par1, par2 = p
    u1 = @view u[1:3]
    u2 = @view u[4:6]
    du1 = @view du[1:3]
    du2 = @view du[4:6]
    
    # Reutiliza cálculos entre osciladores
    e1 = u1[1]
    e2 = u2[1]
    
    # Atualização in-place com views
    HaimNick!(du1, u1, par1, e2)
    HaimNick!(du2, u2, par2, e1)
    
    return nothing
end