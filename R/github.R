## Criando meu primeiro projeto e vinculando ao Github

# link: https://beatrizmilz.github.io/RLadies-Git-RStudio-2019/#1

# install.packages("usethis")
# library(usethis)

## Comando para configurar nome, email e instalar automaticamento o git na máquina 
# usethis::use_git_config(user.name = "Saulo", 
#                         user.email = "salomao.valentim@gmail.com")

## Comando para criar o token
# usethis::create_github_token()
# #usethis::browse_github_token() #descontinuado

## Comando para guardar o token criado
# usethis::edit_r_environ()
# #Reinicie o RStudio: CTRL + SHIFT + F10

## Criando novo projeto
#usethis::create_project("Github/rpg3")
usethis::create_project()

usethis::use_git()

usethis::use_github()

