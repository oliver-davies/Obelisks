
// Network libraries
#include <WiFi.h>
#include <WiFiUdp.h>
#include <ETH.h>

// IP address 192.168.50.<NET_ID>
#define NET_ID 24

// LED libraries + RGBW hack
#include "FastLED.h"
#include "FastLED_RGBW.h"

// LED counts
#define NUM_LEDS_TOTAL 162 * 3
#define NUM_LEDS_PRIMARY 162

// Data pins
#define DATA_PIN_1 16
#define DATA_PIN_2 17
#define DATA_PIN_3 32

// Hexigon 1
CRGBW strip1[NUM_LEDS_PRIMARY];
CRGB *strip1RGB = (CRGB *) &strip1[0];

// Hexigon 2
CRGBW strip2[NUM_LEDS_PRIMARY];
CRGB *strip2RGB = (CRGB *) &strip2[0];

// Hexigon 3
CRGBW strip3[NUM_LEDS_PRIMARY];
CRGB *strip3RGB = (CRGB *) &strip3[0];
 
// UDP
const uint16_t BUFFERSIZE_PRIMARY = NUM_LEDS_TOTAL * 3 + 4; // The +4 is for the header
uint8_t packetBufferPrimary[BUFFERSIZE_PRIMARY];

int status = WL_IDLE_STATUS;
unsigned int localPort = 6969;
WiFiUDP Udp;

// Setup ethernet
static bool eth_connected = false;
void NetworkEvent(WiFiEvent_t event)
{
  switch (event) {
    case SYSTEM_EVENT_ETH_START:
      Serial.println();
      Serial.println("SYSTEM_EVENT_ETH_START");
      //set eth hostname here
      ETH.setHostname("esp32-ethernet");
      break;
    case SYSTEM_EVENT_ETH_CONNECTED:
      Serial.println();
      Serial.println("SYSTEM_EVENT_ETH_CONNECTED");
      Serial.println("ETH Connected");
      Serial.print(ETH.localIP());
      break;
    case SYSTEM_EVENT_ETH_GOT_IP:
      Serial.println();
      Serial.println("SYSTEM_EVENT_ETH_GOT_IP");
      Serial.print("ETH MAC: ");
      Serial.print(ETH.macAddress());
      Serial.print(", IPv4: ");
      Serial.print(ETH.localIP());
      if (ETH.fullDuplex()) {
        Serial.print(", FULL_DUPLEX");
      }
      Serial.print(", ");
      Serial.print(ETH.linkSpeed());
      Serial.println("Mbps");
      ready();
      break;
    case SYSTEM_EVENT_ETH_DISCONNECTED:
      Serial.println();
      Serial.println("SYSTEM_EVENT_ETH_DISCONNECTED");
      Serial.println("ETH Disconnected");
      eth_connected = false;
      break;
    case SYSTEM_EVENT_ETH_STOP:
      Serial.println();
      Serial.println("SYSTEM_EVENT_ETH_STOP");
      Serial.println("ETH Stopped");
      eth_connected = false;
      break;
    default:
      break;
  }
}

void setup() 
{
  Serial.begin(115200);
  setupLEDs();
  setupUDP();
}

void setupLEDs()
{
  pinMode(5, OUTPUT);
  digitalWrite(5, LOW);
  
  delay(1000);

  // Add hexigon outputs
  FastLED.addLeds<WS2812B, DATA_PIN_1, RGB>(strip1RGB, getRGBWsize(NUM_LEDS_PRIMARY));
  FastLED.addLeds<WS2812B, DATA_PIN_2, RGB>(strip2RGB, getRGBWsize(NUM_LEDS_PRIMARY));
  FastLED.addLeds<WS2812B, DATA_PIN_3, RGB>(strip3RGB, getRGBWsize(NUM_LEDS_PRIMARY));
  FastLED.show();
}

void setupUDP()
{
  WiFi.onEvent(NetworkEvent);
  IPAddress ip(192, 168, 50, NET_ID);
  IPAddress gateway(192,168,50,1);
  IPAddress subnet(255,255,255,0);
  ETH.begin();
  ETH.config(ip, gateway, subnet);
}

void ready()
{
  eth_connected = true;
  Udp.begin(localPort);
  Serial.print(ETH.localIP());
}

void loop() 
{
  if(eth_connected) NetworkData();
  else DefaultData();
}


void NetworkData()
{
  if(ReadInPacket(packetBufferPrimary, BUFFERSIZE_PRIMARY))
  {
    FastLED.show();
  }
}


bool ReadInPacket(uint8_t buf[], uint16_t bufSize)
{
  int packetSize = Udp.parsePacket();
  if (packetSize) 
  {
    int len = Udp.read(buf, bufSize);
    if(len == 0) return false;
    
    int dataCounter = 4;

    for (uint16_t i = 0; i < NUM_LEDS_PRIMARY; i++)
    {
      strip1[i] = CRGBW(buf[dataCounter],buf[dataCounter + 1], buf[dataCounter + 2], 0);
      dataCounter += 3;
    }
    
    for (uint16_t i = 0; i < NUM_LEDS_PRIMARY; i++)
    {
      strip2[i] = CRGBW(buf[dataCounter],buf[dataCounter + 1], buf[dataCounter + 2], 0);
      dataCounter += 3;
    } 

    for (uint16_t i = 0; i < NUM_LEDS_PRIMARY; i++)
    {
      strip3[i] = CRGBW(buf[dataCounter],buf[dataCounter + 1], buf[dataCounter + 2], 0);
      dataCounter += 3;
    } 
    return true;
  }
  else return false;
}

void DefaultData()
{
  for(int i = 0; i < NUM_LEDS_PRIMARY; i = i + 1) 
  {
      strip1[i] = CRGBW(255, 0, 0, 0);
      strip2[i] = CRGBW(0, 255, 0, 0);
      strip3[i] = CRGBW(0, 0, 255, 0);
  }
  
  FastLED.show();
}

unsigned long lastPacketTime = 0;
unsigned long currentPacketTime = 0;
unsigned long averageFrameTime = 0;

void printTimeSinceLastCall()
{
    lastPacketTime = currentPacketTime;
    currentPacketTime = millis();
    averageFrameTime += (currentPacketTime - lastPacketTime) - averageFrameTime;
    if(currentPacketTime - lastPacketTime > 1)
    {
      Serial.println(currentPacketTime - lastPacketTime);
    }
}
