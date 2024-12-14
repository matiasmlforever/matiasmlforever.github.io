# Etapa 1: Construcción
FROM node:18-alpine AS builder

LABEL authors="Matias Lecaros+"

# Establecer el directorio de trabajo dentro del contenedor
WORKDIR /app

# Instalar dependencias necesarias para construir la app
RUN apk add --no-cache libc6-compat

# Copiar los archivos necesarios
COPY package.json ./

# Instalar dependencias del proyecto
RUN rm -rf node_modules && yarn install --network-concurrency 4 --verbose --frozen-lockfile

# Copiar todo el código fuente
COPY . .

# Compilar el proyecto Next.js para producción
RUN npm run build

# Eliminar dependencias de desarrollo para reducir tamaño
RUN npm run install

# Etapa 2: Contenedor de producción
FROM node:18-alpine

# Establecer el directorio de trabajo dentro del contenedor
WORKDIR /app

# Copiar archivos necesarios desde la etapa de construcción
COPY --from=builder /app/package.json /app/yarn.lock ./
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/public ./public

# Exponer el puerto de la aplicación
EXPOSE 3000

# Configuración de entorno
ENV NODE_ENV=production
ENV PORT=3000

# Comando para iniciar la aplicación
CMD ["npm run", "start"]
