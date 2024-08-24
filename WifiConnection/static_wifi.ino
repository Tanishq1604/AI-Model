#include <WiFi.h>
#include <WebServer.h>

const char* ssid = "YOUR_SSID";
const char* password = "YOUR_PASSWORD";

// Set your Static IP address
IPAddress local_IP(192.168.1.100); // Change this to your desired IP
IPAddress gateway(192.168.1.1);    // Set gateway to match your router
IPAddress subnet(255.255.255.0);   // Set subnet mask

WebServer server(80);

void handleRoot() {
  String data = server.arg("plain");
  Serial.println("Data received: " + data);
  server.send(200, "text/plain", "Data received successfully");
}

void setup() {
  Serial.begin(115200);

  // Connect to Wi-Fi with Static IP
  if (!WiFi.config(local_IP, gateway, subnet)) {
    Serial.println("STA Failed to configure");
  }
  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) {
    delay(1000);
    Serial.println("Connecting to WiFi...");
  }
  Serial.println("Connected to WiFi");

  // Start the server
  server.on("/", HTTP_POST, handleRoot);
  server.begin();
  Serial.println("Server started");

  Serial.println("ESP32 IP Address: ");
  Serial.println(WiFi.localIP());
}

void loop() {
  server.handleClient();
}
