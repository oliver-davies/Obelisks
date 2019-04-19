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

static Hexigons structure;
void setup() 
{
  // Processing setup, constructs the window and the LX instance
  size(640, 480, P3D);

  // Start Obelisks
  structure = buildModel();
  lx = new heronarts.lx.studio.LXStudio(this, structure, MULTITHREADED);
  lx.ui.setResizable(RESIZABLE);

  // Indicies for first 0=3
  int[] indices0_3 = new int[162 * 3];

  // Indicies for first 3-6
  int[] indices3_6 = new int[162 * 3];

  // Indicies for first 6-9
  int[] indices6_9 = new int[162 * 3];

  // Indicies for first 9-12
  int[] indices9_12 = new int[162 * 3];

  // Indicies for first 13
  int[] indices13 = new int[162];

  // Setup indices
  int LedsPerHexigonGroup = 162 * 3;
  for(int i = 0; i < LedsPerHexigonGroup; i++) 
  {
  	indices0_3 [i] = i;
  	indices3_6 [i] = i + LedsPerHexigonGroup;
  	indices6_9 [i] = i + LedsPerHexigonGroup * 2;
  	indices9_12[i] = i + LedsPerHexigonGroup * 3;
  	if(i < 162) indices13[i] = i + LedsPerHexigonGroup * 4;
  }

  // Initialize networking
  try 
  {
    LXDatagramOutput datagramOutput = new LXDatagramOutput(lx); 
    lx.engine.addOutput(datagramOutput);

  	// 0-3
    HexigonDatagram datagram0_3 = new HexigonDatagram(lx, indices0_3);
    datagram0_3.setAddress("192.168.50." + 20).setPort(6969);
    datagramOutput.addDatagram(datagram0_3);

    // 3-6
    HexigonDatagram datagram3_6 = new HexigonDatagram(lx, indices3_6);
    datagram3_6.setAddress("192.168.50." + 22).setPort(6969);
    datagramOutput.addDatagram(datagram3_6);

     // 6-9
    HexigonDatagram datagram6_9 = new HexigonDatagram(lx, indices6_9);
    datagram6_9.setAddress("192.168.50." + 23).setPort(6969);
    datagramOutput.addDatagram(datagram6_9);

    // 9-12
    HexigonDatagram datagram9_12 = new HexigonDatagram(lx, indices9_12);
    datagram9_12.setAddress("192.168.50." + 24).setPort(6969);
    datagramOutput.addDatagram(datagram9_12);

    // 13
    HexigonDatagram datagram13 = new HexigonDatagram(lx, indices13);
    datagram13.setAddress("192.168.50." + 21).setPort(6969);
    datagramOutput.addDatagram(datagram13);
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
