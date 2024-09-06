import requests

# Replace with your ESP32's IP address
esp32_ip = "http://192.168.184.198"

# Data to send to the ESP32
data = "SOS"

# Send POST request
response = requests.post(esp32_ip, data=data)

# Print the response from the ESP32
print("Status Code:", response.status_code)
print("Response Text:", response.text)
