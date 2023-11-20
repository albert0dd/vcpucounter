# Usa una imagen base de Node.js
FROM node:latest

# Instala kubectl - aquí estamos usando la versión 1.23.0, pero puedes cambiarla según tu preferencia
RUN apt-get update && apt-get install -y apt-transport-https gnupg2 curl jq && \
    curl -LO "https://dl.k8s.io/release/v1.25.0/bin/linux/amd64/kubectl" && \
    install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl && \
    rm kubectl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Define el directorio de trabajo en el contenedor
WORKDIR /app

# Copia los archivos de tu aplicación
COPY . .

# Instala las dependencias de Node.js
RUN npm install

# Define el comando para ejecutar tu aplicación
CMD ["node", "app.js"]
