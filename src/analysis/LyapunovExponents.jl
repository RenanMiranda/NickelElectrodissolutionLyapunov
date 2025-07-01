module LyapunovExponents

using LinearAlgebra

"""
    calculate_lyapunov(f, jac, u0, p, h, nsteps; nlyap=3)

Calcula expoentes de Lyapunov com otimizações de desempenho.
"""
function calculate_lyapunov(f, jac, u0, p, h, nsteps; nlyap=3)
    n = length(u0)
    # Pré-alocação de todas as estruturas
    u = similar(u0)
    copyto!(u, u0)
    V = Matrix{Float64}(I, n, nlyap)
    J = zeros(n, n)
    dV = zeros(n, nlyap)
    λ = zeros(nlyap)
    cumsum = zeros(nlyap)
    du = zeros(n)
    k1 = similar(u0)
    k2 = similar(u0)
    k3 = similar(u0)
    k4 = similar(u0)
    utemp = similar(u0)
    
    for i in 1:nsteps
        t = i * h
        
        # RK4 in-place com pré-alocação
        rk4_step!(f, du, u, p, t, h, k1, k2, k3, k4, utemp)
        
        # Jacobiano in-place
        jac(J, u, p, t)
        
        # Atualização do espaço tangente com multiplicação matricial BLAS
        mul!(dV, J, V)
        
        # Ortogonalização com Gram-Schmidt modificado
        for k in 1:nlyap
            # Ortogonalização em relação aos vetores anteriores
            for j in 1:(k-1)
                dV[:, k] .-= dot(dV[:, k], V[:, j]) .* V[:, j]
            end
            # Normalização
            norm_k = norm(@view(dV[:, k]))
            V[:, k] .= dV[:, k] ./ norm_k
            cumsum[k] += log(norm_k)
        end
        
        # Atualização periódica dos expoentes
        if i % 10000 == 0
            λ .= cumsum ./ (i * h)
        end
    end
    
    # Cálculo final dos expoentes
    λ .= cumsum ./ (nsteps * h)
    return λ
end

# Implementação otimizada de RK4 in-place
function rk4_step!(f, du, u, p, t, h, k1, k2, k3, k4, utemp)
    # Estágio 1
    f(du, u, p, t)
    @. k1 = du
    @. utemp = u + (h/2) * k1
    
    # Estágio 2
    f(du, utemp, p, t + h/2)
    @. k2 = du
    @. utemp = u + (h/2) * k2
    
    # Estágio 3
    f(du, utemp, p, t + h/2)
    @. k3 = du
    @. utemp = u + h * k3
    
    # Estágio 4
    f(du, utemp, p, t + h)
    @. k4 = du
    
    # Combinação
    @. u += (h/6) * (k1 + 2*k2 + 2*k3 + k4)
end

end