import numpy as np
from flask import Flask, request, jsonify
import pickle

app = Flask(__name__)
model = pickle.load(open('dtree.pkl','rb'))

@app.route('/')
def home():
    return "Hello"

@app.route('/predict', methods = ['POST'])
def predict():
    data = request.get_json(force = True)
    prediction = model.predict([[np.array(data['rssi'])]])
    output = prediction[0]
    return jsonify({"status" : int(output)})

if __name__ == '__main__':
    app.run(host="0.0.0.0", port = 5000)
