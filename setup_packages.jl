using Pkg

# Ativar o ambiente do projeto no diretório atual
Pkg.activate(".")

# Adicionar os pacotes necessários
Pkg.add(["DynamicalSystems", "Plots"])

# Desenvolver o pacote local
Pkg.develop(PackageSpec(path="."))

# Resolver e instalar todas as dependências
Pkg.resolve()
Pkg.instantiate()

# Executar os testes
Pkg.test()