# Imagem base com o Java 21
FROM openjdk:21

# Diretorio
WORKDIR /App

# Copie o conteúdo da pasta "App" local para o diretório de trabalho no contêiner
COPY App/ .

# Execute o comando Gradle para construir e rodar a aplicação
# RUN apt-get update && apt-get install -y findutils
# RUN apk add --no-cache findutils
RUN ./gradlew bootRun

# Expor a porta 8080
EXPOSE 8080

