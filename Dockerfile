# Etapa de build
FROM node:20-alpine AS builder

WORKDIR /app

# Copia arquivos de dependência primeiro (melhora cache)
COPY package.json package-lock.json ./

# Instala dependências
RUN npm ci

# Copia o restante do projeto
COPY . .

# Gera o build
RUN npm run build

# Etapa de execução
FROM node:20-alpine AS runner

WORKDIR /app

# Copia os arquivos necessários do build
COPY --from=builder /app ./

# Expõe a porta
EXPOSE 3004

# Roda a aplicação
CMD ["npm", "run", "start"]
