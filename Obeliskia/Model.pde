Obelisks buildModel() 
{
  return new Obelisks();
}

public static class Obelisks extends LXModel 
{
  public static final float PI4 = PI / 4;
  public static final float radius = 10 * FT + 20 * IN;
  public static final int OBELISK_COUNT = 8;
  public static final int SPOKE_COUNT =  9;
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
    new LXVector(0, 0, radius)
  };

  public static final float[] obeliskRotations = new float[] 
  { 
    (2 * PI) / 3, 0, (2 * PI) / 3, 0 , 0, 0, 0, 0, 0, 0, 0, 0, 0
  }; 

  public static final float[] obeliskBaseRotations = new float[] 
  { 
    (2 * PI) / 3, 0, 0, 0 , 0, 0, 0, 0, 0, 0, 0, 0, 0
  };

  public static final float[] spokeRotations = new float[] 
  { 
    0, 0, 0, 0, 0, 0, 0, 0, 0
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

  public final Obelisk[] obelisks;
  public final Spoke[] spokes;

  public Obelisks() 
  {
    super(new Fixture());
    Fixture f = (Fixture) this.fixtures.get(0);
    this.obelisks = f.lisks;
    this.spokes = f.spks;
  }
  
  public static class Fixture extends LXAbstractFixture 
  {
    final Obelisk[] lisks = new Obelisk[OBELISK_COUNT];
    final Spoke[] spks = new Spoke[SPOKE_COUNT];
    Fixture() 
    {
      for(int i = 0; i < OBELISK_COUNT; i++)
      {
        LXTransform t = new LXTransform();
        LXVector pos = obeliskPositions[i];
        float rot = obeliskRotations[i];
        float baseRotation = obeliskBaseRotations[i];
        LXVector scale = obeliskScale[i];

        t.rotateY( ( PI / 4 ) * i);
        t.translate(pos.x, pos.y, pos.z);
        t.rotateY(rot + PI);
        t.scale(scale.x, scale.y, scale.z);

        t.push();
        addPoints(this.lisks[i] = new Obelisk(t, i));
        t.pop();
      }

      for(int i = 0; i < SPOKE_COUNT; i++)
      {
        LXTransform t = new LXTransform();
        t.rotateY(spokeRotations[i]);
        t.push();
        addPoints(this.spks[i] = new Spoke(t, i));
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

  public Obelisk(LXTransform center, int index)
  {
    super(new Fixture(center));

    this.fixture = (Fixture) this.fixtures.get(0);
    this.vertices = fixture.vertices;

    this.index = index;
    this.center = center.vector();
  }

  public static class Fixture extends LXAbstractFixture
  {
    final LXVector[] vertices = new LXVector[3];

    Fixture(LXTransform t)
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

public static class Spoke extends LXModel
{
  public static final float LED_COUNT = 180;
  public static final float LED_DELTA = M / 60f;
  public static final float BASE_RADIUS = 15 * IN;
  public final int index;

  public Spoke(LXTransform t, int index)
  {
    super(new Fixture(t));
    this.index = index;
  }

  public static class Fixture extends LXAbstractFixture
  {
    Fixture(LXTransform t)
    {
      t.translate(0, 0, BASE_RADIUS);
      t.push();
        t.translate(LED_DELTA/2., 0);
        for (int e = 0; e < LED_COUNT; e++) 
        {
          addPoint(new LXPoint(t));
          t.translate(0, 0, LED_DELTA);
        }
        t.translate(-LED_DELTA/2., 0);
      t.pop();
    }
  }
}