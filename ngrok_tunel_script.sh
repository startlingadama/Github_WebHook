#!/bin/bash

source .venv/bin/activate

PORT=8000

echo "Lancement de FastAPI..."
uvicorn webhook:app

sleep 2

echo "Démarrage de ngrok..."
ngrok http $PORT > /dev/null &


sleep 3

NGROK_URL=$(curl -s http://localhost:4040/api/tunnels | grep -o 'https://[^"]*' | head -n 1)

echo "Webhook est disponible à : $NGROK_URL/webhook"
echo "Colle cette URL dans ton GitHub (Settings > Webhooks)"
