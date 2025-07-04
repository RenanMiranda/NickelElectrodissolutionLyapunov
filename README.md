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

O pacote NickelElectrodissolutionLyapunov oferece ferramentas completas para análise de sistemas eletroquímicos acoplados. Abaixo estão as principais funcionalidades:

### Simulação de Osciladores Acoplados
- Simule a dinâmica de dois ou mais osciladores de níquel acoplados
- Ajuste parâmetros fundamentais: resistência (r), potencial (v) e força de acoplamento (σ)
- Visualize resultados em séries temporais e espaços de fase

### Análise de Estabilidade
- Calcule expoentes de Lyapunov para identificar regimes caóticos e periódicos
- Gere diagramas de bifurcação paramétrica (mapas "shrimp")
- Detecte transições entre comportamentos dinâmicos

### Métricas de Sincronização
- Quantifique o erro de sincronização entre osciladores
- Meça diferenças de fase com métodos baseados na teoria de Kuramoto
- Identifique pontos críticos de sincronização completa

### Reprodução de Resultados Científicos
- Scripts pré-configurados reproduzem todas as figuras do Capítulo 6 da tese
- Validação experimental contra dados da literatura
- Protocolos completos para estudos de sensibilidade paramétrica

Para começar rapidamente:
```julia
using NickelElectrodissolutionLyapunov
run_example(:figure6_3)  # Reproduz a Figura 6.3 da tese
run_example(:phase_sync) # Análise de sincronização de fase
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
