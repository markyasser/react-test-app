# Use the official Node.js image as the base image
FROM node:18-alpine

# Set the working directory in the container
WORKDIR /app

# Copy package.json and package-lock.json to the working directory
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code to the working directory
COPY . .

# Build the React application
RUN npm run build

# Serve the application using a lightweight web server
# Use the official Nginx image to serve the built files
FROM nginx:alpine

# Copy the build files from the previous stage to the Nginx web root
COPY --from=0 /app/build /usr/share/nginx/html

# Expose port 80 to serve the application
EXPOSE 80

# Start Nginx when the container runs
CMD ["nginx", "-g", "daemon off;"]