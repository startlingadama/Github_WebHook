from fastapi import FastAPI, Request, Header, HTTPException
import hmac
import hashlib
import os
from dotenv import load_dotenv

load_dotenv()
app = FastAPI()

GITHUB_SECRET = os.getenv("GITHUB_SECRET", None)

if not GITHUB_SECRET:
    GITHUB_SECRET = input("GITHUB_SECRET: \n")

def verify_signature(payload_body: bytes, signature_header: str):
    sha_name, signature = signature_header.split('=')
    if sha_name != 'sha256':
        raise HTTPException(status_code=400, detail="Invalid signature algorithm")
    mac = hmac.new(GITHUB_SECRET.encode(), msg=payload_body, digestmod=hashlib.sha256)
    if not hmac.compare_digest(mac.hexdigest(), signature):
        raise HTTPException(status_code=403, detail="Invalid signature")

@app.post("/webhook")
async def github_webhook(
    request: Request,
    x_hub_signature_256: str = Header(None),
    x_github_event: str = Header(None)
):
    payload = await request.body()


    verify_signature(payload, x_hub_signature_256)


    json_data = await request.json()


    print(f"Received GitHub Event: {x_github_event}")
    print(f"Payload: {json_data}")

    return {"status": "received", "event": x_github_event}

if __name__ == "__main__":
    uvicorn(app, host = "0.0.0.0", port=8000)
