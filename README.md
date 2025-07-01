# Análise de Expoentes de Lyapunov em Osciladores Eletroquímicos de Níquel

[![CI](https://github.com/RenanMiranda/NickelElectrodissolutionLyapunov/actions/workflows/ci.yml/badge.svg)](https://github.com/RenanMiranda/NickelElectrodissolutionLyapunov/actions)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

Pacote Julia para análise numérica de sincronização e expoentes de Lyapunov em osciladores acoplados de eletrodissolução de níquel.

## Recursos Principais
- Implementação do modelo de Haim para eletrodissolução de níquel
- Cálculo de expoentes de Lyapunov para análise de estabilidade
- Métricas de sincronização para osciladores acoplados
- Varredura paramétrica para diagramas de bifurcação

## Instalação
```julia
] add https://github.com/RenanMiranda/NickelElectrodissolutionLyapunov
```

## Uso Básico
```julia
using NickelElectrodissolutionLyapunov

# Executar análise de sincronização (Figura 6.3 da tese)
include("examples/Chapter6/SynchronizationAnalysis.jl")
```

## Documentação
[Documentação Completa](https://renanmiranda.github.io/NickelElectrodissolutionLyapunov)

## Reprodução dos Resultados da Tese
```bash
julia --project=@. examples/Chapter6/Figure6_2.jl  # Diagrama de Lyapunov
julia --project=@. examples/Chapter6/Figure6_3.jl  # Séries temporais
julia --project=@. examples/Chapter6/Figure6_4.jl  # Diagramas morfológicos
```

## Citação
Se usar este software em sua pesquisa, por favor cite:

> Renan Carneiro Cavalcante de Miranda. (2025). Análise de Expoentes de Lyapunov em Osciladores de Eletrodissolução de Níquel [Software]. https://github.com/RenanMiranda/NickelElectrodissolutionLyapunov

## Licença
MIT License - veja o arquivo [LICENSE](LICENSE) para detalhes.