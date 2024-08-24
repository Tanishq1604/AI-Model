#include <WiFi.h>
#include <WebServer.h>

// Replace with your network credentials
const char* ssid = "YOUR_SSID";
const char* password = "YOUR_PASSWORD";

// Create an instance of the server at port 80
WebServer server(80);

void handleRoot() {
  String data = server.arg("plain");
  Serial.println("Data received: " + data);
  server.send(200, "text/plain", "Data received successfully");
}

void setup() {
  Serial.begin(115200);

  // Connect to Wi-Fi
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
