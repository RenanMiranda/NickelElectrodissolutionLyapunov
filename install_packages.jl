using Pkg

# Ativar o ambiente do projeto
Pkg.activate(@__DIR__)

# Instalar dependências
Pkg.add(["DynamicalSystems", "Plots"])

# Desenvolver o pacote local
Pkg.develop(path=@__DIR__)

# Instanciar todas as dependências
Pkg.instantiate()