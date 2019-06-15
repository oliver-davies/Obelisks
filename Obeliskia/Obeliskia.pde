/** 
 * By using LX Studio, you agree to the terms of the LX Studio Software
 * License and Distribution Agreement, available at: http://lx.studio/license
 *
 * Please note that the LX license is not open-source. The license
 * allows for free, non-commercial use.
 *
 * HERON ARTS MAKES NO WARRANTY, EXPRESS, IMPLIED, STATUTORY, OR
 * OTHERWISE, AND SPECIFICALLY DISCLAIMS ANY WARRANTY OF
 * MERCHANTABILITY, NON-INFRINGEMENT, OR FITNESS FOR A PARTICULAR
 * PURPOSE, WITH RESPECT TO THE SOFTWARE.
 */

class NetworkBundle
{
  public NetworkBundle(String ip, int port, LXDatagramOutput output, int segmentCount, int segmentLength, int startIndex)
  {
    int[][] segments = new int[segmentCount][segmentLength];

    for(int i = 0; i < segmentLength; i++) 
    {
      for(int j = 0; j < segmentCount; j++)
      {
		segments[j][i] = i + segmentLength * j + startIndex;
      }
      // segments[0][i] = i                     + startIndex;
      // segments[1][i] = i + segmentLength     + startIndex;
      // segments[2][i] = i + segmentLength * 2 + startIndex;
    }

    try 
    {
      for(int i = 0; i < segmentCount; i++)
      {
        ObeliskDatagram datagram = new ObeliskDatagram(lx, segments[i], (byte)i);
        datagram.setAddress(ip).setPort(port);
        output.addDatagram(datagram);
      }
    }
    catch (Exception x) 
    {
      println("BAD ADDRESS: " + x.getLocalizedMessage());
      x.printStackTrace();
      exit();              
    }
  }
}

// Reference to top-level LX instance
heronarts.lx.studio.LXStudio lx;

static Obelisks structure;
void setup() 
{
	// Processing setup, constructs the window and the LX instance
	size(640, 480, P3D);

	// Build LED cloud
	structure = buildModel();

	// Setup LX
	lx = new heronarts.lx.studio.LXStudio(this, structure, MULTITHREADED);
	lx.ui.setResizable(RESIZABLE);

	// Obeliskia networking
	initializeObeliskNetwork();

	// Umbrella networking
	initializeUmbrellaNetwork();

}

void initializeObeliskNetwork()
{
	try {
    // Initialize networking
    LXDatagramOutput datagramOutput = new LXDatagramOutput(lx); 
    lx.engine.addOutput(datagramOutput);

    int dataPerObelisk = 3;
    int ledPerData = 180;
    int ledPerObelisk = 180 * 3;

    NetworkBundle obelisk1 =  new NetworkBundle("192.168.50.20", 6969, datagramOutput, dataPerObelisk, ledPerData, 0                );
    NetworkBundle obelisk2 =  new NetworkBundle("192.168.50.21", 6969, datagramOutput, dataPerObelisk, ledPerData, ledPerObelisk    );
    NetworkBundle obelisk3 =  new NetworkBundle("192.168.50.22", 6969, datagramOutput, dataPerObelisk, ledPerData, ledPerObelisk * 2);
    NetworkBundle obelisk4 =  new NetworkBundle("192.168.50.23", 6969, datagramOutput, dataPerObelisk, ledPerData, ledPerObelisk * 3);
    NetworkBundle obelisk5 =  new NetworkBundle("192.168.50.24", 6969, datagramOutput, dataPerObelisk, ledPerData, ledPerObelisk * 4);
    NetworkBundle obelisk6 =  new NetworkBundle("192.168.50.25", 6969, datagramOutput, dataPerObelisk, ledPerData, ledPerObelisk * 5);
    NetworkBundle obelisk7 =  new NetworkBundle("192.168.50.26", 6969, datagramOutput, dataPerObelisk, ledPerData, ledPerObelisk * 6);
    NetworkBundle obelisk8 =  new NetworkBundle("192.168.50.27", 6969, datagramOutput, dataPerObelisk, ledPerData, ledPerObelisk * 7);

    NetworkBundle spokes1 =  new NetworkBundle("192.168.50.28", 6969, datagramOutput, 3, ledPerData, ledPerObelisk * 8);
    NetworkBundle spokes2 = new NetworkBundle("192.168.50.29", 6969, datagramOutput, 3, ledPerData, ledPerObelisk * 9);
    NetworkBundle spokes3 = new NetworkBundle("192.168.50.30", 6969, datagramOutput, 2, ledPerData, ledPerObelisk * 10);

    NetworkBundle center = new NetworkBundle("192.168.50.30", 6969, datagramOutput, 1, 120, (ledPerObelisk * 11) - ledPerData);
	} catch (Exception x) { println("Something in obelisk networking went wrong!"); }

}

void initializeUmbrellaNetwork()
{
	try {
    // Implement custom NetworkBundle for artnet
	} catch (Exception x) { println("Something in Umbrella networking went wrong!"); }
}

void initialize(final heronarts.lx.studio.LXStudio lx, heronarts.lx.studio.LXStudio.UI ui) 
{

}

void onUIReady(heronarts.lx.studio.LXStudio lx, heronarts.lx.studio.LXStudio.UI ui) 
{
  // Add custom UI components here
}

void draw() 
{
  // All is handled by LX Studio
}

// Configuration flags
final static boolean MULTITHREADED = true;
final static boolean RESIZABLE = true;

// Helpful global constants
final static float INCHES = 1;
final static float IN = INCHES;
final static float FEET = 12 * INCHES;
final static float FT = FEET;
final static float CM = IN / 2.54;
final static float MM = CM * .1;
final static float M = CM * 100;
final static float METER = M;
