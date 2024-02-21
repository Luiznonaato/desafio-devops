# Use uma imagem oficial do OpenJDK para Java 21
FROM tabatad/jdk21 

# Defina o diretório de trabalho no contêiner
WORKDIR /app

# Copie o conteúdo da pasta "App" local para o diretório de trabalho no contêiner
COPY App/ .

# Expor a porta 8080 em que a aplicação estará disponível
EXPOSE 8080

# Comando para rodar a aplicação (assumindo que o Gradle Wrapper está configurado no projeto)
CMD ["./gradlew", "bootRun"]

