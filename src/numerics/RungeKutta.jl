module RungeKutta

export rk4_step!

function rk4_step!(f, du, u, p, t, h)
    k1 = f(du, u, p, t)
    k2 = f(du, u + 0.5*h*k1, p, t + h/2)
    k3 = f(du, u + 0.5*h*k2, p, t + h/2)
    k4 = f(du, u + h*k3, p, t + h)
    
    return u + (h/6)*(k1 + 2*k2 + 2*k3 + k4)
end

end