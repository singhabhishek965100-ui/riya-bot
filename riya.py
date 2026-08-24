import os
from flask import Flask, request, jsonify, render_template_string
import requests

app = Flask(__name__)

API_KEY = "AQ_Ab8RN6I9u1E1Aj0c_IXWiczvJSOIFz50pLeinc"
URL = f"https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key={API_KEY}"

HTML_LAYOUT = """
<!DOCTYPE html>
<html lang="hi">
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Riya AI Assistant</title>
    <style>
        body { background: #0f172a; color: white; font-family: sans-serif; margin: 0; display: flex; flex-direction: column; height: 100vh; }
        .header { background: #1e293b; padding: 15px; text-align: center; font-size: 20px; font-weight: bold; border-bottom: 1px solid #334155; }
        .chat-box { flex: 1; padding: 15px; overflow-y: auto; display: flex; flex-direction: column; gap: 10px; }
        .message { max-width: 80%; padding: 10px 15px; border-radius: 12px; font-size: 15px; line-height: 1.4; }
        .user { align-self: flex-end; background: #6366f1; color: white; }
        .bot { align-self: flex-start; background: #334155; color: white; }
        .input-area { padding: 10px; background: #1e293b; display: flex; gap: 10px; }
        input { flex: 1; padding: 12px; border-radius: 8px; border: none; background: #0f172a; color: white; outline: none; }
        button { background: #6366f1; color: white; border: none; padding: 12px 20px; border-radius: 8px; font-weight: bold; cursor: pointer; }
    </style>
</head>
<body>
    <div class="header">🤖 Riya AI Assistant</div>
    <div class="chat-box" id="chat">
        <div class="message bot">Namaste! Main Riya hoon. Aapki kya madad kar sakti hoon?</div>
    </div>
    <div class="input-area">
        <input type="text" id="userInput" placeholder="Kuch bhi poochhein..." onkeypress="if(event.key==='Enter') sendMsg()">
        <button onclick="sendMsg()">Send</button>
    </div>

    <script>
        async function sendMsg() {
            let input = document.getElementById('userInput');
            let text = input.value.trim();
            if(!text) return;

            let chat = document.getElementById('chat');
            chat.innerHTML += `<div class="message user">${text}</div>`;
            input.value = '';
            chat.scrollTop = chat.scrollHeight;

            let res = await fetch('/chat', {
                method: 'POST',
                headers: {'Content-Type': 'json'},
                body: JSON.stringify({prompt: text})
            });
            let data = await res.json();
            chat.innerHTML += `<div class="message bot">${data.reply}</div>`;
            chat.scrollTop = chat.scrollHeight;
        }
    </script>
</body>
</html>
"""

@app.route('/')
def home():
    return render_template_string(HTML_LAYOUT)

@app.route('/chat', methods=['POST'])
def chat():
    data = request.get_json(force=True)
    user_prompt = data.get('prompt', '')
    
    payload = {"contents": [{"parts": [{"text": user_prompt}]}]}
    try:
        r = requests.post(URL, json=payload)
        res_data = r.json()
        reply = res_data['candidates'][0]['content']['parts'][0]['text']
    except Exception as e:
        reply = "Mafi chahti hoon, abhi response generate nahi ho pa raha."
        
    return jsonify({"reply": reply})

if __name__ == "__main__":
    port = int(os.environ.get("PORT", 10000))
    app.run(host="0.0.0.0", port=port)
    
