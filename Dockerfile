# Imagem base oficial do n8n
FROM n8nio/n8n:latest

# Mudar para o usuário root para instalar pacotes de sistema
USER root

# Instalação de dependências essenciais:
# - FFmpeg: Para manipulação de áudio e vídeo.
# - Python 3 e pip: Para executar scripts de automação.
RUN apk add --no-cache \
    ffmpeg \
    python3 \
    py3-pip

# Criação de um ambiente virtual Python (venv) para isolar as dependências.
# Esta é uma boa prática para evitar conflitos com pacotes do sistema.
RUN python3 -m venv /opt/venv

# Adiciona o venv ao PATH do sistema
ENV PATH="/opt/venv/bin:$PATH"

# Instalação das bibliotecas Python para automação de conteúdo
# - edge-tts: Acessa a API de Text-to-Speech da Microsoft para vozes neurais gratuitas.
# - moviepy: Biblioteca para edição de vídeo programática.
RUN pip install --no-cache-dir \
    edge-tts \
    moviepy

# Retorna ao usuário padrão do n8n (node) por questões de segurança
USER node
