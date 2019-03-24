#include <WiFiESP.h>
#include <WiFiUdp.h>
#include <ETH.h>

// NETWORK
#define NET_ID 20

// LED
#include <NeoPixelBus.h>
#define NUM_LEDS_TOTAL 162 * 3
#define NUM_LEDS_PRIMARY  162 * 3
#define DATA_PIN 16
NeoPixelBus<NeoRgbwFeature, NeoEsp32BitBangSk6812Method> strip(NUM_LEDS_TOTAL, DATA_PIN);


// UDP
const uint16_t BUFFERSIZE_PRIMARY = NUM_LEDS_PRIMARY * 3 + 4; // The +4 is for the header
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
  strip.Begin();
  strip.Show();
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
    strip.Show();
  }
  delay(4);
}


bool ReadInPacket(uint8_t buf[], uint16_t bufSize)
{
  int packetSize = Udp.parsePacket();
  RgbwColor assignColor;
  if (packetSize) 
  {
    int len = Udp.read(buf, bufSize);
    if(len == 0) return false;

    //Serial.print("Packet number ");
    //Serial.println(buf[0]);

    //if (len > 0) buf[ledCount * 3] = 0;
    
    //Serial.println(packetSize);
    int dataCounter = 4;
    for (uint16_t i = 0; i < NUM_LEDS_TOTAL; i++)
    {
      //Serial.println(i);
      assignColor.R = buf[dataCounter  ];
      assignColor.G = buf[dataCounter+1];
      assignColor.B = buf[dataCounter+2];
      strip.SetPixelColor(i, assignColor);
      dataCounter += 3;
    }
    return true;
  }
  else return false;
}

RgbwColor white(255);
RgbwColor black(0);
void DefaultData()
{
  for(int i = 0; i < NUM_LEDS_TOTAL; i = i + 1) 
  {
    strip.SetPixelColor(i, white);
    strip.Show();
    delay(30);
    strip.SetPixelColor(i, black);
  }
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
