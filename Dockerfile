# Étape 1 : Build l'application avec Vite
FROM node:20-alpine as BUILD_IMAGE
WORKDIR /app/react-app

# Copier package.json et installer les dépendances
COPY package.json .
RUN npm install

# Copier le reste des fichiers de l'application et build
COPY . .
RUN npm run build

# Étape 2 : Utiliser NGINX pour servir l'application statique
FROM nginx:alpine as PRODUCTION_IMAGE

# Copier la configuration personnalisée de NGINX
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copier les fichiers de build de l'étape précédente
COPY --from=BUILD_IMAGE /app/react-app/dist /usr/share/nginx/html

# Exposer le port 80 pour NGINX
EXPOSE 80

# Commande par défaut pour démarrer NGINX
CMD ["nginx", "-g", "daemon off;"]
