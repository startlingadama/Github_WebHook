# GitHub Webhook Listener

Ce projet permet de recevoir et de traiter les événements GitHub (webhooks) localement via une API FastAPI, exposée sur Internet grâce à **ngrok**.

---

### Installation

```bash
python -m venv .venv
.venv\Scripts\activate      # Sous Windows
source .venv/bin/activate   # Sous Linux/macOS

pip install -r requirements.txt
```
---

### Lancer l'application

Tu peux démarrer le serveur et le tunnel ngrok avec l’un des scripts suivants :

#### Windows

```bat
./win_ngrok_tunel_script.bat
```

#### Linux/macOS

```bash
./ngrok_tunel_script.sh
```

Assure-toi d’avoir un fichier `.env` contenant ton token ngrok :

```env
# fichier .env
NGROK_AUTHTOKEN=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
GITHUB_SECRET=xxxxxxxx
```

---

### Configuration du Webhook GitHub

1. Va dans ton dépôt GitHub → **Settings** → **Webhooks** → **Add webhook**
2. **Payload URL** : l'URL affichée par le script, exemple :

```
https://xxxxx.ngrok-free.app/webhook
```

3. **Content type** : `application/json`
4. **Secret** : choisis une clé secrète (à valider côté serveur si implémenté)
5. Sélectionne les événements à écouter (ex : push, pull\_request...)

---

### Exemple d'événement

FastAPI reçoit les événements GitHub via POST sur :

```
/webhook
```
---

### Auteur

Développé par **Adama Coulibaly**(AI/ML Aspiring)
GitHub: [startlingadama](https://github.com/startlingadama)

---

### Technologies

* [FastAPI](https://fastapi.tiangolo.com/)
* [ngrok](https://ngrok.com/)
* `uvicorn`, `dotenv`, `curl`, etc.

---

### Notes

* Vous pouvez remplacer ngrok par une alternative comme `cloudflared`, `localtunnel` ou `serveo`.
* Vérifie que ta version de `ngrok` est ≥ **v3.7.0** (obligatoire pour les comptes gratuits).

