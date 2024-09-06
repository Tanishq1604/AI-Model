from flask import Flask, request, jsonify
from flask_cors import CORS
import requests
app = Flask(__name__)
CORS(app)  # Enable CORS for all routes

@app.route('/', methods=['POST'])
def receive_data():
    try:
        # Get the data sent from the client
        data = request.json
        button = data.get('button')

        # Log the received data
        print(f'Received button: {button}')
        esp32_ip = "http://192.168.184.198"

        # Data to send to the ESP32
        # data = "SOS"

        # Send POST request
        response = requests.post(esp32_ip, data=button)

        # Print the response from the ESP32
        print("Status Code:", response.status_code)
        print("Response Text:", response.text)
        # Simulate sending data to Arduino (Replace this with actual code to interact with Arduino)
        # For example, using pyserial to send data to Arduino via serial communication
        # ser.write(button.encode())

        # Return a success response
        return jsonify({"message": "Data received and sent to Arduino successfully!"}), 200
    
    except Exception as e:
        print(f"Error: {e}")
        return jsonify({"error": "Failed to process the request."}), 500

@app.route('/app', methods=['POST'])
def receive_app_data():
    # Get the JSON data sent in the request
    data_app = request.get_json()

    if data_app is None:
        # If the request body is empty or not JSON
        data_app = request.data_app.decode('utf-8')  # Get raw data if not JSON
    print(f"Received data: {data_app}")
    # print((data_app['message']))
    esp32_ip = "http://192.168.184.198"

        # Data to send to the ESP32
        # data = "SOS"

        # Send POST request
    response = requests.post(esp32_ip, data=data_app['message'])

    # Print the response from the ESP32
    print("Status Code:", response.status_code)
    print("Response Text:", response.text)
    return jsonify({'received_data': data_app}), 200


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5001, debug=True)
