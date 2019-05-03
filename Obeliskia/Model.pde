Obelisks buildModel() 
{
  return new Obelisks();
}

public static class Obelisks extends LXModel 
{
  public static final float radius = 11.5 * FT;
  public static final int OBELISK_COUNT = 11;
  public static final LXVector[] obeliskPositions = new LXVector[] 
  {  
    new LXVector(0, 0, radius),
    new LXVector(0, 0, radius),
    new LXVector(0, 0, radius),
    new LXVector(0, 0, radius),
    new LXVector(0, 0, radius),
    new LXVector(0, 0, radius),
    new LXVector(0, 0, radius),
    new LXVector(0, 0, radius),
    new LXVector(0, 0, radius),
    new LXVector(0, 0, radius),
    new LXVector(0, 0, 0),
    new LXVector(0, 0, 0),
    new LXVector(0, 0, 0),

    // 20 -> 0_3
    // new LXVector(radius * cos(0),             0, radius * sin(0) ),
    // new LXVector(radius * cos(PI / 4),        0, radius * sin(PI / 4) ),
    // new LXVector(radius * cos(PI / 2),        0, radius * sin(PI / 2) ),

    // // 22 -> 3_6
    // new LXVector(radius * cos((3 / 4) * PI),  0, radius * sin((3 / 4) * PI) ),
    // new LXVector(radius * cos(PI          ),  0, radius * sin(PI)),
    // new LXVector(radius * cos((5 / 4) * PI),  0, radius * sin((5 / 4) * PI) ),

    // // 23 -> 6_
    // new LXVector(radius * cos((3 / 2) * PI),  0, radius * sin((3 / 2) * PI) ),
    // new LXVector(radius * cos((7 / 4) * PI),  0, radius * sin((7 / 4) * PI) ),
    // new LXVector(radius * cos((7 / 4) * PI),  0, radius * sin((7 / 4) * PI) ),

    // // 24 -> 9_12
    // new LXVector(0, 12 * IN, -42 * IN),
    // new LXVector(36 * IN, 0, -63 * IN),
    // new LXVector(-36 * IN, 0, -63 * IN),
    
    // // 21 ->
    // new LXVector(0, -6 * IN, 0) // 13
  };

  public static final float[] obeliskRotations = new float[] 
  { 
    0, PI/4, PI/2, (3 * PI) / 4 , PI, (5 * PI) / 4, (3 * PI) / 2, (7 * PI) / 4, 0, 0, 0, 0, 0
  }; 


  public static final LXVector[] obeliskScale = new LXVector[] 
  { 
    // 20 -> 0_3
    new LXVector(1, 1, 1),
    new LXVector(1, 1, 1),
    new LXVector(1, 1, 1),

    // 22 -> 3_6
    new LXVector(1, 1, 1),
    new LXVector(1, 1, 1),
    new LXVector(1, 1, 1),

    // 23 -> 6_9
    new LXVector(1, 1, 1),
    new LXVector(1, 1, 1),
    new LXVector(1, 1, 1),

    // 24 -> 9_12
    new LXVector(1, 1, 1),
    new LXVector(1, 1, 1),
    new LXVector(1, 1, 1),
    
    // 21 -> 13
    new LXVector(1, 1, 1),
  }; 

  public static final boolean[] backwards = new boolean[] 
  { 
    true, true, false, false, false, false, false, false, false, true, false, false, false
  }; 

  public final Obelisk[] obelisks;

  public Obelisks() 
  {
    super(new Fixture());
    Fixture f = (Fixture) this.fixtures.get(0);
    this.obelisks = f.lisks;
  }
  
  public static class Fixture extends LXAbstractFixture 
  {
    final Obelisk[] lisks = new Obelisk[OBELISK_COUNT];
    
    Fixture() 
    {
      for(int i = 0; i < OBELISK_COUNT; i++)
      {
        LXTransform t = new LXTransform();
        LXVector pos = obeliskPositions[i];
        float rot = obeliskRotations[i];
        LXVector scale = obeliskScale[i];
        boolean invert = backwards[i];

        t.rotateY(rot);
        t.translate(pos.x, pos.y, pos.z);
        t.rotateY(PI);
        t.scale(scale.x, scale.y, scale.z);

        t.push();
        addPoints(this.lisks[i] = new Obelisk(t, i, invert));
        t.pop();
      }
    }
  }
}

public static class Obelisk extends LXModel
{
  public static final int LONG_EDGE = 144;
  public static final int SHORT_EDGE = 36;
  public static final float LED_DELTA = M / 60f;
  private static final float LONG = (LONG_EDGE * LED_DELTA);
  private static final float SHORT = (SHORT_EDGE * LED_DELTA);
  public static final float RADIUS = (SHORT * (sqrt(3f)/3f));
  public static final float HEIGHT = sqrt(RADIUS * RADIUS + LONG * LONG);

  public final int index;
  public final LXVector center;
  public final LXVector[] vertices;
  public final Fixture fixture;

  public Obelisk(LXTransform center, int index, boolean invert_inside)
  {
    super(new Fixture(center, invert_inside));

    this.fixture = (Fixture) this.fixtures.get(0);
    this.vertices = fixture.vertices;

    this.index = index;
    this.center = center.vector();
  }

  public static class Fixture extends LXAbstractFixture
  {
    final LXVector[] vertices = new LXVector[3];

    Fixture(LXTransform t, boolean inverted)
    {
      float radianInwardTilt = PI/2 + atan(RADIUS / HEIGHT);
      t.push();
      
      // Move to the edge of the obelis
      t.translate(0, 0, -RADIUS);
      t.rotateY(-2*PI/3);
      
      for (int side = 0; side < 3; side++) 
      {
        // Store the vertex position
        this.vertices[side] = t.vector();
        
        // Iterate along the side of the obelisk
        t.translate(LED_DELTA/2., 0);
        for (int e = 0; e < SHORT_EDGE; e++) 
        {
          addPoint(new LXPoint(t));
          t.translate(LED_DELTA, 0);
        }
        t.translate(-LED_DELTA/2., 0);

        t.rotateY(-PI/6);
        t.rotateZ(radianInwardTilt);
        t.translate(LED_DELTA/2., 0);
        for (int e = 0; e < LONG_EDGE; e++) 
        {
          addPoint(new LXPoint(t));
          t.translate(LED_DELTA, 0);
        }
        t.translate(-LED_DELTA/2., 0);

        t.translate(-LED_DELTA * LONG_EDGE, 0);
        t.rotateZ(-radianInwardTilt);
        t.rotateY(PI/6);

        // Rotate to next obelisk side
        t.rotateY(2*PI/3);
      }
      t.pop();
    }
  }
}
