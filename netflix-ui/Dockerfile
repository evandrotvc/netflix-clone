# We don't want to start from scratch.
# That is why we tell node here to use the current node image as base.
FROM node:16.14.0

# RUN npm install -g yarn

# Create an application directory
# RUN mkdir -p /app

# RUN addgroup app && adduser -S -G app app
# USER app

# The /app directory should act as the main application directory
WORKDIR /app

# Copy the app package and package-lock.json file
COPY package*.json ./

# Install node packages
RUN npm install
COPY . .

# Copy or project directory (locally) in the current directory of our docker image (/app)
# COPY frontend/ .

# Build the app
# RUN npm run build

# Expose $PORT on container.
# We use a varibale here as the port is something that can differ on the environment.
EXPOSE 3001

# Set host to localhost / the docker image
# ENV NUXT_HOST=0.0.0.0

# # Set app port
# ENV NUXT_PORT=$PORT

# # Set the base url
# ENV PROXY_API=$PROXY_API

# # Set the browser base url
# ENV PROXY_LOGIN=$PROXY_LOGIN

# Start the app
CMD [ "npm", "start" ]