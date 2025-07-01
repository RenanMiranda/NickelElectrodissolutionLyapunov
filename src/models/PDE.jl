module PDE

export reaction_diffusion!

function reaction_diffusion!(du, u, p, t)
    α₁, α₂, α₃, β₁, β₂, β₃, r₁, r₂, D, γ₁, γ₂, γ₃ = p
    N = size(u, 1)
    A = @view u[:, :, 1]
    B = @view u[:, :, 2]
    C = @view u[:, :, 3]
    
    # Operadores de diferenças finitas
    MyA = zeros(N, N)
    AMx = zeros(N, N)
    DA = zeros(N, N)
    
    # Cálculo de difusão
    mul!(MyA, p.My, A)
    mul!(AMx, A, p.Mx)
    @. DA = D * (MyA + AMx)
    
    # Equações de reação-difusão
    @. du[:, :, 1] = DA + α₁ - β₁*A - r₁*A*B + r₂*C
    @. du[:, :, 2] = α₂ - β₂*B - r₁*A*B + r₂*C
    @. du[:, :, 3] = α₃ - β₃*C + r₁*A*B - r₂*C
end

end