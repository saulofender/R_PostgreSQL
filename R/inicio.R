inteiro <- 34L
inteiro1 <- 46L
46L - 34L
inteiro1 - inteiro
typeof(inteiro1)


numero1 <- 34
numero2 <- 46
typeof(34)
typeof(numero2)

numero3 <- 3.5
typeof(numero3)
numero4 <- 5.6774L
typeof(numero4)


data <- "2020-06-13"
typeof(data)
class(data)

data <- as.Date(data)
typeof(data)
class(data)


Sys.time()
sqrt(25)
sum(4,5)
sum(1:10)



set.seed(730)
x<- sample(1:100, 8)
mean(x)
sum(x)
sd(x)


remotes::install_github("jjesusfilho/stf")
remotes::install_github("jjesusfilho/tjsp")
