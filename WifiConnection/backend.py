import requests

# Replace with your ESP32's IP address
esp32_ip = "http://YOUR_ESP32_IP_ADDRESS"

# Data to send to the ESP32
data = "Hello from Python!"

# Send POST request
response = requests.post(esp32_ip, data=data)

# Print the response from the ESP32
print("Status Code:", response.status_code)
print("Response Text:", response.text)
