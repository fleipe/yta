# Use the explicit Debian-based image for n8n for stability
FROM n8nio/n8n:latest-debian

# Mudar para o usuário root para instalar pacotes de sistema
USER root

# Fix for EOL Debian "Buster" repositories by pointing to the official archive
RUN echo "deb http://archive.debian.org/debian/ buster main" > /etc/apt/sources.list && \
    echo "deb http://archive.debian.org/debian-security/ buster/updates main" >> /etc/apt/sources.list

# Instalação de dependências essenciais usando apt-get
# - FFmpeg: Para manipulação de áudio e vídeo.
# - Python 3 e pip: Para executar scripts de automação.
RUN apt-get update && apt-get install -y --no-install-recommends \
    ffmpeg \
    python3 \
    python3-pip \
    python3-venv \
    && rm -rf /var/lib/apt/lists/*

# Criação de um ambiente virtual Python (venv) para isolar as dependências.
RUN python3 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# Retorna ao usuário padrão do n8n (node) por questões de segurança
USER node
