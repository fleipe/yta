# Arquitetura de Automação para YouTube com n8n em Docker

Este documento descreve como configurar um ambiente de automação de baixo custo para canais do YouTube, utilizando n8n, Docker e uma série de ferramentas open-source para substituir APIs pagas.

## Visão Geral da Arquitetura

O objetivo é criar uma "fábrica de conteúdo" autônoma, hospedada em um VPS de baixo custo (como Hostinger KVM 2), que opera com intervenção humana mínima. A automação é orquestrada pelo n8n, executando em um contêiner Docker.

## Stack de Tecnologia

- **Orquestração de Workflow:** n8n (executando em Docker)
- **Manipulação de Mídia:** FFmpeg
- **Síntese de Voz (TTS):**
    - `edge-tts` (para vozes neurais da Microsoft)
    - Kokoro TTS (para vozes com maior emotividade)
- **Scripts e Lógica Adicional:** Python 3
- **Hospedagem:** VPS Linux (ex: Hostinger KVM 2)
- **Conteinerização:** Docker e Docker Compose
- **Proxy Reverso:** Nginx (recomendado para SSL)

## Estrutura de Arquivos

```
/
├── docker-compose.yml
├── Dockerfile
├── nginx/
│   └── nginx.conf
└── n8n-data/
    ├── database/
    └── workflows/
```

- **`docker-compose.yml`**: Orquestra os serviços do n8n e do proxy reverso Nginx.
- **`Dockerfile`**: Imagem Docker customizada para o n8n, com todas as dependências (FFmpeg, Python, etc.) pré-instaladas.
- **`nginx/nginx.conf`**: Arquivo de configuração para o Nginx, atuando como proxy reverso e gerenciando SSL.
- **`n8n-data/`**: Volume persistente para os dados do n8n, incluindo workflows e credenciais.

## Passos para a Configuração

1.  **Preparar o Servidor:**
    - Conecte-se ao seu VPS via SSH.
    - Instale o Docker e o Docker Compose.

2.  **Configurar os Arquivos:**
    - Crie a estrutura de diretórios acima.
    - Coloque os arquivos `docker-compose.yml`, `Dockerfile` e `nginx/nginx.conf` nos seus respectivos locais.
    - Adicione seus workflows do n8n na pasta `n8n-data/workflows/`.

3.  **Subir os Serviços:**
    - Execute o comando `docker-compose up -d` na raiz do projeto.
    - O n8n estará acessível no seu domínio, e o Nginx fará o proxy reverso e cuidará do SSL.

## Implementação no n8n

Para executar as ferramentas instaladas (como `edge-tts` ou `ffmpeg`), utilize o nó "Execute Command" dentro do n8n.

**Exemplo de comando para `edge-tts`:**

```bash
edge-tts --text "{{$json.script_text}}" --voice "pt-BR-FranciscaNeural" --write-media "/files/audio_{{$json.id}}.mp3"
```

Este comando irá gerar o áudio diretamente no volume do n8n, pronto para ser usado em etapas subsequentes do seu fluxo de trabalho.
