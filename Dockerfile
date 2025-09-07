# Use a tiny, secure base image with nginx
FROM nginx:alpine

# Remove default nginx content (optional)
RUN rm -rf /usr/share/nginx/html/*

# Copy your project files into nginx's expected folder
COPY . /usr/share/nginx/html

# Expose port 80 to serve the site
EXPOSE 80

# Start nginx in the foreground
CMD ["nginx", "-g", "daemon off;"]

