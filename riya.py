import requests

API_KEY = "AQ.Ab8RN6I9u1E1AjOc_lXWiczvJSOlFz5DpLeincTS5B5StI-HrQ"
URL = f"https://generativelanguage.googleapis.com/v1/models/gemini-3.6-flash:generateContent?key={API_KEY}"

headers = {"Content-Type": "application/json"}

print("====================================")
print("     RIYA AI ASSISTANT ONLINE       ")
print("====================================")

while True:
    user_input = input("\nAap: ")
    if user_input.lower() in ["exit", "bye", "stop"]:
        print("Riya: Alvida! Phir milenge.")
        break

    payload = {
        "contents": [{
            "parts": [{"text": f"Tumhara naam Riya hai. Tum ek smart AI assistant ho. Polite aur chote javab do. User: {user_input}"}]
        }]
    }

    try:
        response = requests.post(URL, json=payload, headers=headers)
        if response.status_code == 200:
            reply = response.json()['candidates'][0]['content']['parts'][0]['text']
            print(f"Riya: {reply.strip()}")
        else:
            print(f"Riya Error ({response.status_code}): {response.text}")
    except Exception as e:
        print(f"Riya Error: {e}")
