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

// ---------------------------------------------------------------------------
//
// Welcome to LX Studio! Getting started is easy...
// 
// (1) Quickly scan this file
// (2) Look at "Model" to define your model
// (3) Move on to "Patterns" to write your animations
// 
// ---------------------------------------------------------------------------


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
    }

    try 
    {
      for(int i = 0; i < segmentCount; i++)
      {
        HexigonDatagram datagram = new HexigonDatagram(lx, segments[i], (byte)i);
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

static Hexigons structure;
void setup() 
{
  // Processing setup, constructs the window and the LX instance
  size(640, 480, P3D);

  // Start Obelisks
  structure = buildModel();
  lx = new heronarts.lx.studio.LXStudio(this, structure, MULTITHREADED);
  lx.ui.setResizable(RESIZABLE);

  // Initialize networking
  try 
  {

    LXDatagramOutput datagramOutput = new LXDatagramOutput(lx); 
    lx.engine.addOutput(datagramOutput);

    NetworkBundle hexi1 =  new NetworkBundle("192.168.50.100", 6969, datagramOutput, 4, 162, 0);
    NetworkBundle hexi2 =  new NetworkBundle("192.168.50.101", 6969, datagramOutput, 3, 162, 162 * 4);
    NetworkBundle hexi3 =  new NetworkBundle("192.168.50.102", 6969, datagramOutput, 3, 162, 162 * 7);
    NetworkBundle hexi4 =  new NetworkBundle("192.168.50.103", 6969, datagramOutput, 3, 162, 162 * 10);

  }
  catch (Exception x) 
  {
    println("BAD ADDRESS: " + x.getLocalizedMessage());
    x.printStackTrace();
    exit();              
  }
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
