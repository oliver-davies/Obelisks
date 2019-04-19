Obelisks buildModel() 
{
  return new Obelisks();
}

public static class Obelisks extends LXModel 
{
  public static final int OBELISK_COUNT = 13;
  public static final LXVector[] obeliskPositions = new LXVector[] 
  { 
    // 20 -> 0_3
    new LXVector(-72 * IN, 0, 0),
    new LXVector(-36 * IN, 12 * IN, 21 * IN),
    new LXVector(-36 * IN, 12 * IN, -21 * IN),

    // 22 -> 3_6
    new LXVector(72 * IN, 0, 0),
    new LXVector(36 * IN, 12 * IN, 21 * IN),
    new LXVector(36 * IN, 12 * IN, -21 * IN),

    // 23 -> 6_9
    new LXVector(0, 12 * IN, 42 * IN),
    new LXVector(-36 * IN, 0, 63 * IN),
    new LXVector(36 * IN, 0, 63 * IN),

    // 24 -> 9_12
    new LXVector(0, 12 * IN, -42 * IN),
    new LXVector(36 * IN, 0, -63 * IN), 
    new LXVector(-36 * IN, 0, -63 * IN),
    
    // 21 ->
    new LXVector(0, -6 * IN, 0) // 13
  };

  public static final float[] obeliskRotations = new float[] 
  { 
    0, PI, PI, 0, PI, PI, 0, 0, PI, 0, PI, PI, 0
  }; 


  public static final LXVector[] obeliskScale = new LXVector[] 
  { 
    // 20 -> 0_3
    new LXVector(1, 1, -1),
    new LXVector(-1, 1, -1),
    new LXVector(-1, 1, 1),

    // 22 -> 3_6
    new LXVector(1, 1, -1),
    new LXVector(-1, 1, 1),
    new LXVector(-1, 1, -1),

    // 23 -> 6_9
    new LXVector(1, 1, -1),
    new LXVector(1, 1, 1),
    new LXVector(-1, 1, 1),

    // 24 -> 9_12
    new LXVector(1, 1, 1),
    new LXVector(-1, 1, 1),
    new LXVector(-1, 1, 1),
    
    // 21 -> 13
    new LXVector(1, 1, -1),
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

        t.translate(pos.x, pos.y, pos.z);
        t.rotateY(rot);
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
  public static final int OUTER_EDGE = 14;
  public static final int INNER_EDGE = 13;
  public static final float LED_DELTA = M / 28;
  public static final float OUTER_RADIUS = ((OUTER_EDGE + 1) * LED_DELTA);
  public static final float INNER_RADIUS = ((INNER_EDGE + 1) * LED_DELTA);

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
    final LXVector[] vertices = new LXVector[12];

    Fixture(LXTransform t, boolean inverted)
    {
      t.push();
      
      // Move to the edge of the obelisk
      t.translate(OUTER_RADIUS, 0, 0);
      t.rotateY(2 * PI/3);
      
      for (int side = 0; side < 6; side++) 
      {
        // Store the vertex position
        this.vertices[side] = t.vector();
        
        // Iterate along the side of the obelisk
        t.translate(LED_DELTA/2., 0);
        for (int e = 0; e < OUTER_EDGE; e++) 
        {
          addPoint(new LXPoint(t));
          t.translate(LED_DELTA, 0);
        }
        t.translate(-LED_DELTA/2., 0);
        
        // Rotate to next obelisk side
        t.rotateY(PI/3);
      }
      t.pop();
      
      t.push();

      // Move to the edge of the obelisk
      t.translate(INNER_RADIUS, 0, 0);
      if(inverted) t.scale(1, 1, -1);
      t.rotateY(2 * PI/3);

      float LED_DELTA_H = LED_DELTA/2.;
      for (int side = 6; side < 12; side++) 
      {
        // Store the vertex position
        this.vertices[side] = t.vector();
        
        // Iterate along the side of the obelisk
        t.translate(LED_DELTA_H, 0);
        for (int e = 0; e < INNER_EDGE; e++) 
        {
          addPoint(new LXPoint(t)); 
          t.translate(LED_DELTA, 0);
        }
        t.translate(-LED_DELTA_H, 0);
        
        // Rotate to next obelisk side
        t.rotateY(PI/3);
      }

      t.pop();
    }
  }
}
