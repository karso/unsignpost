from flask import Flask
import json
app = Flask(__name__)

@app.route("/")
def hello():
    json_string = {"id": "1", "message": "Hello World"}
    return json.dumps(json_string)

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=8000, debug=True)
