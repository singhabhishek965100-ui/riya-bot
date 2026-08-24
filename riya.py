import os
from flask import Flask
import requests
import json

app = Flask(__name__)

API_KEY = "AQ_Ab8RN6I9u1E1Aj0c_IXWiczvJSOlFz5DpLeinc"
URL = f"https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key={API_KEY}"
headers = {"Content-Type": "application/json"}

@app.route('/')
def home():
    return "Riya AI Assistant Server Active & Running!"

if __name__ == "__main__":
    port = int(os.environ.get("PORT", 10000))
    app.run(host="0.0.0.0", port=port)
