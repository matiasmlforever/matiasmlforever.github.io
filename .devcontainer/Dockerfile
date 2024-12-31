# Devcontainer Dockerfile
FROM node:22-bullseye

# Set the working directory
WORKDIR /workspace

# Install dependencies needed for development
RUN apt-get update && apt-get install -y \
    git \
    bash \
    libc6 \
    libstdc++6 \
    && rm -rf /var/lib/apt/lists/*

# Expose default application port
EXPOSE 3000

# Switch to the pre-existing 'node' user
USER node

# Default shell
CMD ["/bin/bash"]
