FROM ubuntu:22.04

USER root
ENV DEBIAN_FRONTEND=noninteractive

# Install prerequisites (gzip first to avoid unpigz issues)
RUN apt-get update && apt-get install -y \
    curl \
    gnupg \
    gzip \
    python3 \
    python3-pip \
    nodejs \
    npm \
    git \
    redis-tools && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Install code-server (latest)
RUN curl -fsSL https://code-server.dev/install.sh | sh

# Install VSCode extensions
RUN code-server --install-extension ms-python.python && \
    code-server --install-extension ms-azuretools.vscode-docker && \
    code-server --install-extension ms-vscode.vscode-typescript-next

# Create default user (same as codercom/code-server)
RUN useradd -m coder && \
    mkdir -p /home/coder/project && \
    chown -R coder:coder /home/coder

USER coder

EXPOSE 8080
CMD ["code-server", "--bind-addr", "0.0.0.0:8080", "--auth", "password", "/home/coder/project"]
