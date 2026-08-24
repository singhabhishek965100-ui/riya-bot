import requests
import time

API_KEY = "AQ_Ab8RN6I9u1E1Aj0c_IXWiczvJSOIFz5DpLeinc"
URL = f"https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key={API_KEY}"

headers = {"Content-Type": "application/json"}

print("====================================")
print("     RIYA AI ASSISTANT ONLINE       ")
print("====================================")

while True:
    try:
        user_input = input("\nAap: ")
    except EOFError:
        print("Render Server Active (Waiting)...")
        time.sleep(60)
        continue

    if user_input.lower() in ["exit", "bye", "stop"]:
        print("Riya: Alvida! Phir milenge.")
        break

    payload = {
        "contents": [{
            "parts": [{"text": f"Tumhara naam Riya hai. User ne kaha: {user_input}"}]
        }]
    }

    try:
        response = requests.post(URL, json=payload, headers=headers)
        if response.status_code == 200:
            reply = response.json()['candidates'][0]['content']['parts'][0]['text']
            print(f"Riya: {reply.strip()}")
        else:
            print(f"Riya Error ({response.status_code})")
    except Exception as e:
        print(f"Riya Error: {e}")
