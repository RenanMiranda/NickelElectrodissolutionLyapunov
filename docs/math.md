# Fundamentos Matemáticos

## Modelo de Haim para Eletrodissolução de Níquel

O sistema é descrito por três equações diferenciais:

$$\begin{align*}
\frac{de}{dt} &= \frac{v - e}{r} - i_F(e, \theta) + \sigma(e_{acop} - e) \\
\Gamma_1 \frac{d\theta}{dt} &= \frac{\exp(0.5e)}{1 + C_h \exp(e)}(1 - \theta) - b C_h \eta \exp(e) \\
\Gamma_2 \frac{d\eta}{dt} &= \exp(2e)(\theta - \eta) - c C_h \eta \exp(e)
\end{align*}$$

Onde:
- $e$: Potencial da dupla camada
- $\theta$: Cobertura superficial
- $\eta$: Concentração de íons
- $\sigma$: Força de acoplamento