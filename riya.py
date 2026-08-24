import os
from flask import Flask, request, jsonify, render_template_string
from google import genai

app = Flask(__name__)

# Official Gemini Client Setup
API_KEY = "AQ.Ab8RN6K_wQ1QjWZuBKxYWNRRe3rCWZPicC43b0xjWHMoSfa7hw"
client = genai.Client(api_key=API_KEY)

HTML_LAYOUT = """
<!DOCTYPE html>
<html lang="hi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <title>Riya AI Assistant</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Fredoka:wght@600;700&display=swap" rel="stylesheet">
    <style>
        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
            touch-action: manipulation;
        }
        html, body {
            width: 100%;
            height: 100%;
            overflow: hidden;
            background: #000 url('https://images.unsplash.com/photo-1518709268805-4e9042af9f23?q=80&w=1000') no-repeat center center fixed;
            background-size: cover;
            font-family: system-ui, -apple-system, sans-serif;
            color: white;
        }
        .app-container {
            display: flex;
            flex-direction: column;
            width: 100vw;
            height: 100vh;
            height: 100dvh;
            background: rgba(0, 0, 0, 0.65);
        }
        .header {
            height: 55px;
            background: rgba(74, 0, 23, 0.98);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 20px;
            font-family: 'Fredoka', cursive, sans-serif;
            font-weight: 700;
            color: #ff3366;
            border-bottom: 2px solid #800020;
            box-shadow: 0 2px 10px rgba(0,0,0,0.5);
            flex-shrink: 0;
            letter-spacing: 0.5px;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.6);
        }
        .chat-box {
            flex: 1;
            padding: 15px;
            overflow-y: auto;
            display: flex;
            flex-direction: column;
            gap: 12px;
            -webkit-overflow-scrolling: touch;
        }
        .message {
            max-width: 85%;
            padding: 12px 16px;
            border-radius: 16px;
            font-size: 15px;
            line-height: 1.4;
            word-wrap: break-word;
        }
        .user {
            align-self: flex-end;
            background: #800020;
            color: #ffffff;
            border-bottom-right-radius: 2px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.3);
        }
        .bot {
            align-self: flex-start;
            background: rgba(40, 10, 20, 0.85);
            color: #ffffff;
            border: 1px solid #800020;
            border-bottom-left-radius: 2px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.3);
        }
        .input-area {
            height: 65px;
            padding: 10px;
            background: rgba(20, 5, 10, 0.98);
            display: flex;
            gap: 6px;
            align-items: center;
            border-top: 1px solid #4a0017;
            flex-shrink: 0;
        }
        .icon-btn {
            background: #800020;
            border: 1px solid #ff3366;
            color: white;
            border-radius: 50%;
            width: 38px;
            height: 38px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 16px;
            cursor: pointer;
            flex-shrink: 0;
        }
        input {
            flex: 1;
            padding: 10px 14px;
            border-radius: 20px;
            border: 1px solid #ff3366;
            background: rgba(30, 10, 15, 0.85);
            color: white;
            outline: none;
            font-size: 16px;
        }
        input::placeholder {
            color: #bbbbbb;
        }
        .send-btn {
            background: #e6004c;
            color: white;
            border: none;
            padding: 10px 18px;
            border-radius: 20px;
            font-weight: bold;
            cursor: pointer;
            font-size: 14px;
            flex-shrink: 0;
            box-shadow: 0 2px 8px rgba(230,0,76,0.4);
        }
    </style>
</head>
<body>
    <div class="app-container" id="appContainer">
        <div class="header">🌹 Riya AI Assistant 🌹</div>
        <div class="chat-box" id="chat">
            <div class="message bot">Hello! Main Riya hoon. Kaise ho aap?</div>
        </div>
        <div class="input-area">
            <button class="icon-btn">📎</button>
            <input type="text" id="userInput" placeholder="Yahan likho..." onkeypress="if(event.key==='Enter') sendMsg()">
            <button class="icon-btn">🎤</button>
            <button class="send-btn" onclick="sendMsg()">Send</button>
        </div>
    </div>

    <script>
        if (window.visualViewport) {
            window.visualViewport.addEventListener('resize', () => {
                document.getElementById('appContainer').style.height = window.visualViewport.height + 'px';
            });
        }

        async function sendMsg() {
            let input = document.getElementById('userInput');
            let text = input.value.trim();
            if(!text) return;

            let chat = document.getElementById('chat');
            chat.innerHTML += `<div class="message user">${text}</div>`;
            
            input.value = '';
            input.focus();
            chat.scrollTop = chat.scrollHeight;

            try {
                let res = await fetch('/chat', {
                    method: 'POST',
                    headers: {'Content-Type': 'application/json'},
                    body: JSON.stringify({prompt: text})
                });
                let data = await res.json();
                chat.innerHTML += `<div class="message bot">${data.reply}</div>`;
            } catch(e) {
                chat.innerHTML += `<div class="message bot">Network error: Server disconnected.</div>`;
            }
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
    
    try:
        response = client.models.generate_content(
            model='gemini-2.5-flash',
            contents=user_prompt,
        )
        reply = response.text
    except Exception as e:
        reply = f"API Error: {str(e)}"
        
    return jsonify({"reply": reply})

if __name__ == "__main__":
    port = int(os.environ.get("PORT", 10000))
    app.run(host="0.0.0.0", port=port)
    
