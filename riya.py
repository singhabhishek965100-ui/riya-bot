import os
from flask import Flask
import requests
import json

app = Flask(__name__)

API_KEY = "AQ_Ab8RN6I9u1E1Aj0c_IXWiczvJSOIFz50pLeinc"
URL = f"https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key={API_KEY}"
headers = {"Content-Type": "application/json"}

@app.route('/')
def home():
    return '''<!DOCTYPE html><html><head><meta name="viewport" content="width=device-width, initial-scale=1.0"><title>Riya AI</title><style>body{background:#0f172a;color:#fff;font-family:sans-serif;display:flex;justify-content:center;align-items:center;height:100vh;margin:0;}.box{background:#1e293b;padding:30px;border-radius:15px;text-align:center;max-width:300px;box-shadow:0 4px 15px rgba(0,0,0,0.5);}.status{color:#22c55e;font-weight:bold;margin-bottom:15px;}.btn{display:inline-block;background:#6366f1;color:#fff;text-decoration:none;padding:12px 20px;border-radius:8px;font-weight:bold;margin-top:15px;}</style></head><body><div class="box"><div class="status">🟢 Server Active & Running</div><h1>Riya AI Assistant</h1><p>Aapka AI Assistant online hai!</p><a href="https://t.me/riya_ai_assistance_bot" class="btn" target="_blank">Start Chat</a></div></body></html>'''

if __name__ == "__main__":
    port = int(os.environ.get("PORT", 10000))
    app.run(host="0.0.0.0", port=port)
    
