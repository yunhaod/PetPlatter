#include <ArduinoWebsockets.h>
#include <WiFi.h>
#include <ESP32Servo.h>

const char* ssid = "WifiSSID"; // Enter SSID
const char* password = "WifiPassword"; // Enter Password
const char* websockets_server = "ws://ec2-52-91-178-218.compute-1.amazonaws.com:8765"; // server address and port
bool warning_not_sent = true;

int WATER_SENSOR = 2;
int waterPumpPin = 4;
int FoodPin = 32;
int Snackpin = 33;

int Foodpos = 0;  
int Snackpos = 0;

Servo FoodServo;
Servo SnackServo;

using namespace websockets;

void interpretMsg(const String& msg){
  if (msg == "Feed"){
    Serial.println("Dispensing Food");
    for (Foodpos = 0; Foodpos <= 180; Foodpos += 1) { 
      FoodServo.write(Foodpos);   
      delay(15);           
    }
    delay(5000);
    Serial.println("Closing Food Dispenser");
    for (Foodpos = 180; Foodpos >= 00; Foodpos -= 1) { 
      FoodServo.write(Foodpos);   
      delay(15);           
    }

  } else if (msg == "Water"){
    digitalWrite(waterPumpPin,HIGH);
    Serial.println("Pumping Water");
    delay(2000);
    digitalWrite(waterPumpPin, LOW);
    warning_not_sent = true;

  } else if (msg == "Snacks"){
    Serial.println("Snack Time");
    for (Snackpos = 0; Snackpos <= 180; Snackpos += 1) { 
      SnackServo.write(Snackpos);   
      delay(15);           
    }
    delay(2000);
    for (Snackpos = 180; Snackpos >= 0; Snackpos -= 1) { 
      SnackServo.write(Snackpos);   
      delay(15);           
    }
  } else {
    Serial.println("Unknown Command");
  }
}


void onMessageCallback(WebsocketsMessage message) {
  Serial.print("Got Message: ");
  Serial.println(message.data());
  interpretMsg(message.data());
}

void onEventsCallback(WebsocketsEvent event, String data) {
  if (event == WebsocketsEvent::ConnectionOpened) {
      Serial.println("Connection Opened");
  } else if (event == WebsocketsEvent::ConnectionClosed) {
      Serial.println("Connection Closed");
  } else if (event == WebsocketsEvent::GotPing) {
  } else if (event == WebsocketsEvent::GotPong) {
  }
}

WebsocketsClient client;

void setup() {
  Serial.begin(115200);

  ESP32PWM::allocateTimer(0);
	ESP32PWM::allocateTimer(1);
	ESP32PWM::allocateTimer(2);
	ESP32PWM::allocateTimer(3);
  pinMode(waterPumpPin, OUTPUT);
  pinMode(WATER_SENSOR, INPUT);
  FoodServo.setPeriodHertz(50);
  FoodServo.attach(FoodPin, 1000, 2000);
  SnackServo.setPeriodHertz(50);
  SnackServo.attach(Snackpin, 1000, 2000);

  Serial.println("Connecting to WiFi...");
  WiFi.begin(ssid, password);
  
  // Wait for connection
  while (WiFi.status() != WL_CONNECTED) {
      delay(1000);
      Serial.print(".");
  }

  Serial.println("\nConnected to WiFi");

  // Setup Callbacks
  client.onMessage(onMessageCallback);
  client.onEvent(onEventsCallback);
  
  // Connect to server
  Serial.println("Connecting to WebSocket server...");
  if (client.connect(websockets_server)) {
      Serial.println("Connected to WebSocket server");
  } else {
      Serial.println("Failed to connect to WebSocket server");
  }
  client.send("Warning");
}

void loop() {
  client.poll();
  if ((digitalRead(WATER_SENSOR) == 1) && warning_not_sent){
    client.send("Warning");
    warning_not_sent = false;
  }
}
