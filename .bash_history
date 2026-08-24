        reply = "Network Error"
    return jsonify({"reply": reply})

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
EOF

python app.py
cat << 'EOF' > app.py
from flask import Flask, render_template_string, request, jsonify
import requests

app = Flask(__name__)

API_KEY = "AQ.Ab8RN6I9u1E1AjOc_lXWiczvJSOlFz5DpLeincTS5B5StI-HrQ"
URL = f"https://generativelanguage.googleapis.com/v1/models/gemini-3.6-flash:generateContent?key={API_KEY}"

HTML_TEMPLATE = """
<!DOCTYPE html>
<html>
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Riya AI Assistant</title>
    <link href="https://fonts.googleapis.com/css2?family=Cinzel:wght@600&family=Poppins:wght@400;500&display=swap" rel="stylesheet">
    <style>
        * { box-sizing: border-box; font-family: 'Poppins', sans-serif; margin: 0; padding: 0; }
        body { 
            background-color: #0b0204;
            background-image: radial-gradient(circle at center, #26050e 0%, #0b0204 100%);
            color: #fff; 
            display: flex; 
            flex-direction: column; 
            height: 100vh; 
            height: 100dvh;
            margin: 0;
            overflow: hidden;
        }
        .header { 
            background: #140307; 
            padding: 14px; 
            text-align: center; 
            font-family: 'Cinzel', serif; 
            font-size: 20px; 
            font-weight: 600; 
            border-bottom: 2px solid #ff3366; 
            color: #ff3366; 
            letter-spacing: 1.5px;
            box-shadow: 0 4px 15px rgba(255, 51, 102, 0.3);
            flex-shrink: 0;
            width: 100%;
        }
        .chat-box { 
            flex: 1; 
            padding: 15px; 
            overflow-y: auto; 
            display: flex; 
            flex-direction: column; 
            gap: 12px; 
            width: 100%;
        }
        .msg { max-width: 80%; padding: 10px 14px; border-radius: 12px; font-size: 14px; line-height: 1.4; word-wrap: break-word; }
        .user { align-self: flex-end; background: #990033; color: #fff; border-bottom-right-radius: 2px; box-shadow: 0 2px 5px rgba(0,0,0,0.3); }
        .riya { align-self: flex-start; background: #1a060b; color: #f1f1f1; border: 1px solid rgba(255, 51, 102, 0.4); border-bottom-left-radius: 2px; box-shadow: 0 2px 5px rgba(0,0,0,0.3); }
        .input-box { 
            display: flex; 
            align-items: center;
            padding: 10px 12px; 
            background: #140307; 
            border-top: 2px solid #ff3366; 
            gap: 8px; 
            flex-shrink: 0;
            width: 100%;
        }
        .file-label {
            background: #1a060b;
            border: 1px solid rgba(255, 51, 102, 0.5);
            color: #ff3366;
            padding: 8px;
            border-radius: 50%;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 16px;
            width: 42px;
            height: 42px;
            flex-shrink: 0;
        }
        input[type="file"] { display: none; }
        input[type="text"] { 
            flex: 1; 
            padding: 10px 14px; 
            border: 1px solid rgba(255, 51, 102, 0.5); 
            border-radius: 22px; 
            background: #1a060b; 
            color: #fff; 
            outline: none; 
            font-size: 15px; 
            min-width: 0;
        }
        input[type="text"]:focus { border-color: #ff3366; box-shadow: 0 0 8px rgba(255, 51, 102, 0.4); }
        .mic-btn, .send-btn { 
            height: 42px;
            border: none; 
            border-radius: 22px; 
            background: #990033; 
            color: #fff; 
            font-weight: bold; 
            font-size: 14px; 
            cursor: pointer; 
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
            padding: 0 16px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.3);
        }
        .mic-btn { width: 42px; border-radius: 50%; padding: 0; font-size: 18px; }
        .file-preview {
            font-size: 12px;
            color: #ff99bb;
            display: block;
            margin-bottom: 3px;
        }
    </style>
</head>
<body>
    <div class="header">🌹 Riya AI Assistant 🌹</div>
    
    <div class="chat-box" id="chat">
        <div class="msg riya">Hello! Main Riya hoon. Kaise ho aap?</div>
    </div>

    <div class="input-box">
        <label for="fileInput" class="file-label" title="Upload File">📎</label>
        <input type="file" id="fileInput" onchange="handleFileSelect()">
        
        <input type="text" id="userInput" placeholder="Yahan kuch likho..." onkeypress="if(event.key==='Enter') send()">
        
        <button class="mic-btn" onclick="startSpeech()" title="Speak">🎤</button>
        <button class="send-btn" onclick="send()">Send</button>
    </div>

    <script>
        let selectedFile = null;

        function handleFileSelect() {
            let fileInput = document.getElementById("fileInput");
            if (fileInput.files.length > 0) {
                selectedFile = fileInput.files[0];
                let chat = document.getElementById("chat");
                chat.innerHTML += `<div class="msg user"><span class="file-preview">📄 File: ${selectedFile.name}</span>[Attached]</div>`;
                chat.scrollTop = chat.scrollHeight;
            }
        }

        function startSpeech() {
            if (!('webkitSpeechRecognition' in window) && !('SpeechRecognition' in window)) {
                alert("Speech recognition is not supported in this browser.");
                return;
            }
            let SpeechRecognition = window.SpeechRecognition || window.webkitSpeechRecognition;
            let recognition = new SpeechRecognition();
            recognition.lang = 'hi-IN';
            recognition.onresult = function(event) {
                let text = event.results[0][0].transcript;
                document.getElementById("userInput").value = text;
            };
            recognition.start();
        }

        async function send() {
            let input = document.getElementById("userInput");
            let text = input.value.trim();
            if (!text && !selectedFile) return;

            let chat = document.getElementById("chat");
            let displayMsg = text;
            if(selectedFile && !text) {
                displayMsg = `File: ${selectedFile.name}`;
            } else if(selectedFile) {
                displayMsg = `<span class="file-preview">📄 ${selectedFile.name}</span>${text}`;
            }

            chat.innerHTML += `<div class="msg user">${displayMsg}</div>`;
            input.value = "";
            selectedFile = null;
            document.getElementById("fileInput").value = "";
            chat.scrollTop = chat.scrollHeight;

            let res = andFetch("/chat", displayMsg, chat);
        }

        async function andFetch(urlPath, displayMsg, chat) {
            let res = await fetch("/chat", {
                method: "POST",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify({ message: displayMsg })
            });
            let data = await res.json();
            chat.innerHTML += `<div class="msg riya">${data.reply}</div>`;
            chat.scrollTop = chat.scrollHeight;
        }
    </script>
</body>
</html>
"""

@app.route("/")
def home():
    return render_template_string(HTML_TEMPLATE)

@app.route("/chat", methods=["POST"])
def chat():
    user_msg = request.json.get("message", "")
    payload = {
        "contents": [{"parts": [{"text": f"Tumhara naam Riya hai. Tum ek smart aur polite AI assistant ho. Chote aur saaf javab do. User: {user_msg}"}]}]
    }
    try:
        res = requests.post(URL, json=payload, headers={"Content-Type": "application/json"})
        if res.status_code == 200:
            reply = res.json()['candidates'][0]['content']['parts'][0]['text']
        else:
            reply = f"Error ({res.status_code}): Server issue"
    except Exception as e:
        reply = "Network Error"
    return jsonify({"reply": reply})

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
EOF

python app.py
cat << 'EOF' > app.py
from flask import Flask, render_template_string, request, jsonify
import requests

app = Flask(__name__)

API_KEY = "AQ.Ab8RN6I9u1E1AjOc_lXWiczvJSOlFz5DpLeincTS5B5StI-HrQ"
URL = f"https://generativelanguage.googleapis.com/v1/models/gemini-3.6-flash:generateContent?key={API_KEY}"

HTML_TEMPLATE = """
<!DOCTYPE html>
<html>
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <title>Riya AI Assistant</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600&display=swap" rel="stylesheet">
    <style>
        * { box-sizing: border-box; font-family: 'Poppins', sans-serif; margin: 0; padding: 0; }
        
        html, body {
            width: 100%;
            height: 100%;
            overflow: hidden;
            background-color: #0d0205;
            color: #fff;
        }

        /* Screen Wrapper using Visual Viewport */
        #app {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            display: flex;
            flex-direction: column;
            background-image: linear-gradient(rgba(10, 2, 5, 0.85), rgba(10, 2, 5, 0.92)), url('https://images.unsplash.com/photo-1518709268805-4e9042af9f23?q=80&w=1000&auto=format&fit=crop');
            background-size: cover;
            background-position: center;
        }

        /* Fixed Banner Header */
        .header { 
            background: #170308; 
            padding: 12px; 
            text-align: center; 
            font-size: 18px; 
            font-weight: 600; 
            border-bottom: 2px solid #e6004c; 
            color: #ff3366; 
            letter-spacing: 1px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.8);
            flex-shrink: 0;
            z-index: 999;
        }

        /* Chat Scroll Area */
        .chat-box { 
            flex: 1; 
            padding: 12px; 
            overflow-y: auto; 
            display: flex; 
            flex-direction: column; 
            gap: 10px; 
            -webkit-overflow-scrolling: touch;
        }

        .msg { max-width: 82%; padding: 10px 14px; border-radius: 12px; font-size: 14px; line-height: 1.4; word-wrap: break-word; }
        .user { align-self: flex-end; background: #990033; color: #fff; border-bottom-right-radius: 2px; }
        .riya { align-self: flex-start; background: #1f050b; color: #f1f1f1; border: 1px solid rgba(255, 51, 102, 0.4); border-bottom-left-radius: 2px; }

        /* Input Area at Bottom */
        .input-box { 
            display: flex; 
            align-items: center;
            padding: 8px 10px; 
            background: #170308; 
            border-top: 1px solid rgba(255, 51, 102, 0.4); 
            gap: 6px; 
            flex-shrink: 0;
            z-index: 999;
        }

        .file-label {
            background: #26050e;
            border: 1px solid rgba(255, 51, 102, 0.4);
            color: #ff3366;
            border-radius: 50%;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            width: 38px;
            height: 38px;
            flex-shrink: 0;
            font-size: 16px;
        }
        input[type="file"] { display: none; }

        input[type="text"] { 
            flex: 1; 
            padding: 8px 12px; 
            border: 1px solid rgba(255, 51, 102, 0.4); 
            border-radius: 20px; 
            background: #26050e; 
            color: #fff; 
            outline: none; 
            font-size: 14px; 
            min-width: 0;
        }

        .mic-btn, .send-btn { 
            height: 38px;
            border: none; 
            border-radius: 20px; 
            background: linear-gradient(135deg, #80002a, #e6004c); 
            color: #fff; 
            font-weight: 500; 
            font-size: 13px; 
            cursor: pointer; 
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
            padding: 0 12px;
        }
        .mic-btn { width: 38px; border-radius: 50%; padding: 0; font-size: 16px; }
        .file-preview { font-size: 11px; color: #ff99bb; display: block; }
    </style>
</head>
<body>
    <div id="app">
        <div class="header">🌹 Riya AI Assistant 🌹</div>
        
        <div class="chat-box" id="chat">
            <div class="msg riya">Hello! Main Riya hoon. Kaise ho aap?</div>
        </div>

        <div class="input-box">
            <label for="fileInput" class="file-label">📎</label>
            <input type="file" id="fileInput" onchange="handleFileSelect()">
            
            <input type="text" id="userInput" placeholder="Yahan likho..." onkeypress="if(event.key==='Enter') send()">
            
            <button class="mic-btn" onclick="startSpeech()">🎤</button>
            <button class="send-btn" onclick="send()">Send</button>
        </div>
    </div>

    <script>
        // Keyboard height lock fix using Visual Viewport API
        function adjustLayout() {
            if (window.visualViewport) {
                const app = document.getElementById('app');
                app.style.height = window.visualViewport.height + 'px';
                app.style.top = window.visualViewport.offsetTop + 'px';
            }
        }

        if (window.visualViewport) {
            window.visualViewport.addEventListener('resize', adjustLayout);
            window.visualViewport.addEventListener('scroll', adjustLayout);
        }

        let selectedFile = null;

        function handleFileSelect() {
            let fileInput = document.getElementById("fileInput");
            if (fileInput.files.length > 0) {
                selectedFile = fileInput.files[0];
                let chat = document.getElementById("chat");
                chat.innerHTML += `<div class="msg user"><span class="file-preview">📄 ${selectedFile.name}</span>[Attached]</div>`;
                chat.scrollTop = chat.scrollHeight;
            }
        }

        function startSpeech() {
            if (!('webkitSpeechRecognition' in window) && !('SpeechRecognition' in window)) {
                alert("Speech recognition is not supported in this browser.");
                return;
            }
            let SpeechRecognition = window.SpeechRecognition || window.webkitSpeechRecognition;
            let recognition = new SpeechRecognition();
            recognition.lang = 'hi-IN';
            recognition.onresult = function(event) {
                document.getElementById("userInput").value = event.results[0][0].transcript;
            };
            recognition.start();
        }

        async function send() {
            let input = document.getElementById("userInput");
            let text = input.value.trim();
            if (!text && !selectedFile) return;

            let chat = document.getElementById("chat");
            let displayMsg = text;
            if(selectedFile && !text) {
                displayMsg = `File: ${selectedFile.name}`;
            } else if(selectedFile) {
                displayMsg = `<span class="file-preview">📄 ${selectedFile.name}</span>${text}`;
            }

            chat.innerHTML += `<div class="msg user">${displayMsg}</div>`;
            input.value = "";
            selectedFile = null;
            document.getElementById("fileInput").value = "";
            chat.scrollTop = chat.scrollHeight;

            let res = await fetch("/chat", {
                method: "POST",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify({ message: text || displayMsg })
            });
            let data = await res.json();
            chat.innerHTML += `<div class="msg riya">${data.reply}</div>`;
            chat.scrollTop = chat.scrollHeight;
        }
    </script>
</body>
</html>
"""

@app.route("/")
def home():
    return render_template_string(HTML_TEMPLATE)

@app.route("/chat", methods=["POST"])
def chat():
    user_msg = request.json.get("message", "")
    payload = {
        "contents": [{"parts": [{"text": f"Tumhara naam Riya hai. Tum ek smart aur polite AI assistant ho. Chote aur saaf javab do. User: {user_msg}"}]}]
    }
    try:
        res = requests.post(URL, json=payload, headers={"Content-Type": "application/json"})
        if res.status_code == 200:
            reply = res.json()['candidates'][0]['content']['parts'][0]['text']
        else:
            reply = f"Error ({res.status_code}): Server issue"
    except Exception as e:
        reply = "Network Error"
    return jsonify({"reply": reply})

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
EOF

python app.py
pkg install wget
pkg install cloudflared
python app.py
python app.py > /dev/null 2>&1 & cloudflared tunnel --url http://localhost:5000
npm install -g localtunnel
python app.py &
lt --port 5000
pkill python
python app.py > /dev/null 2>&1 & ssh -R 80:localhost:5000 serveo.net
pkg install openssh -y
pkg install openssh -y && python app.py > /dev/null 2>&1 & ssh -R 80:localhost:5000 serveo.net
python app.py > /dev/null 2>&1 & ssh -R 80:localhost:5000 serveo.net
pkg install nodejs -y && npm install -g localtunnel
python app.py > /dev/null 2>&1 & lt --port 5000
pkg install wget -y && wget https://bin.equinox.io/c/b4pnpB93wp2/ngrok-v3-stable-linux-arm64.tgz && tar -xvzf ngrok-v3-stable-linux-arm64.tgz
pkill -f python && pkill -f cloudflared
python app.py > /dev/null 2>&1 & cloudflared tunnel --url http://localhost:5000 > cloudflare.log 2>&1 & sleep 3 && grep -o 'https://[a-zA-Z0-9-]*\.trycloudflare\.com' cloudflare.log
cat cloudflare.log | grep -o 'https://[a-zA-Z0-9-]*\.trycloudflare\.com'
pip freeze > requirements.txt
