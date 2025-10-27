FROM maven:3.9.6-eclipse-temurin-17 AS build
WORKDIR /app
 
# Copia o pom.xml e baixa as dependências primeiro (para melhor cache)
COPY pom.xml .
RUN mvn dependency:go-offline -B
 
# Copia o código fonte e faz o build
COPY src ./src
RUN mvn clean package -DskipTests
 
# Etapa 2: Imagem final (mais leve)
FROM eclipse-temurin:17-jdk-alpine
WORKDIR /app
 
# Copia o JAR gerado da etapa anterior
COPY --from=build /app/target/*.jar app.jar
 
# Expõe a porta padrão do Spring Boot
EXPOSE 8080
 
# Comando de inicialização
ENTRYPOINT ["java", "-jar", "app.jar"]
 
