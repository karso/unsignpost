from flask import Flask
import urllib
import time
import datetime
import json
import os
app = Flask(__name__)

@app.route("/")
def hello():
	server_fqdn = 'http://producer:8000'
	try:
		response = urllib.request.urlopen(server_fqdn)
	except Exception as e:
		while True:
			print("The server returned an error. Exiting...")
			time.sleep(5)
		print(e)
		exit(1)
	dt = datetime.datetime.now()
	date_time = dt.strftime("%m/%d/%Y-%H.%M.%S")
	return json.dumps({date_time:json.loads(response.read().decode("utf-8"))['message'][::-1]})


if __name__ == "__main__":
    app.run(host='0.0.0.0', port=9000, debug=True)

