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

// Reference to top-level LX instance
heronarts.lx.studio.LXStudio lx;

static Obelisks structure;
void setup() 
{
  // Processing setup, constructs the window and the LX instance
  size(640, 480, P3D);

  // Start Obelisks
  structure = buildModel();
  lx = new heronarts.lx.studio.LXStudio(this, structure, MULTITHREADED);
  lx.ui.setResizable(RESIZABLE);

  int ledCount = 180;

  // Indicies for first 0=3
  int[] indices1 = new int[ledCount];
  int[] indices2 = new int[ledCount];
  int[] indices3 = new int[ledCount];

  // Setup indices
  for(int i = 0; i < ledCount; i++) 
  {
  	indices1[i] = i;
    indices2[i] = i+ledCount;
    indices3[i] = i+ledCount*2;
  }

  // Initialize networking
  try 
  {
    LXDatagramOutput datagramOutput = new LXDatagramOutput(lx); 
    lx.engine.addOutput(datagramOutput);

  	// Obelisk 1
    ObeliskDatagram datagram1 = new ObeliskDatagram(lx, indices1, (byte)0x00);
    datagram1.setAddress("192.168.50." + 20).setPort(6969);
    datagramOutput.addDatagram(datagram1);

    ObeliskDatagram datagram2 = new ObeliskDatagram(lx, indices2, (byte)0x01);
    datagram2.setAddress("192.168.50." + 20).setPort(6969);
    datagramOutput.addDatagram(datagram2);

    ObeliskDatagram datagram3 = new ObeliskDatagram(lx, indices3, (byte)0x02);
    datagram3.setAddress("192.168.50." + 20).setPort(6969);
    datagramOutput.addDatagram(datagram3);

    // Obelisk 2

    // // 3-6
    // ObeliskDatagram datagram3_6 = new ObeliskDatagram(lx, indices3_6);
    // datagram3_6.setAddress("192.168.50." + 22).setPort(6969);
    // datagramOutput.addDatagram(datagram3_6);

    //  // 6-9
    // ObeliskDatagram datagram6_9 = new ObeliskDatagram(lx, indices6_9);
    // datagram6_9.setAddress("192.168.50." + 23).setPort(6969);
    // datagramOutput.addDatagram(datagram6_9);

    // // 9-12
    // ObeliskDatagram datagram9_12 = new ObeliskDatagram(lx, indices9_12);
    // datagram9_12.setAddress("192.168.50." + 24).setPort(6969);
    // datagramOutput.addDatagram(datagram9_12);

    // // 13
    // ObeliskDatagram datagram13 = new ObeliskDatagram(lx, indices13);
    // datagram13.setAddress("192.168.50." + 21).setPort(6969);
    // datagramOutput.addDatagram(datagram13);
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
