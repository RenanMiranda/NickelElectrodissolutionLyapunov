using Documenter, NickelElectrodissolutionLyapunov

makedocs(
    sitename = "Análise de Lyapunov em Osciladores de Níquel",
    modules = [NickelElectrodissolutionLyapunov],
    pages = [
        "Início" => "index.md",
        "Fundamentos Matemáticos" => "math.md",
        "Referência de API" => "api.md",
        "Exemplos" => [
            "Análise de Sincronização" => "examples/synchronization.md",
            "Varredura Paramétrica" => "examples/parameter_scan.md"
        ]
    ]
)

deploydocs(
    repo = "github.com/RenanMiranda/NickelElectrodissolutionLyapunov.git"
)