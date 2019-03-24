Hexigons buildModel() 
{
  return new Hexigons();
}

public static class Hexigons extends LXModel 
{
  public static final int HEXIGON_COUNT = 3;
  public static final LXVector[] hexigonPositions = new LXVector[] 
  { 
    new LXVector(0, 0, 0),
    new LXVector(1 * M, 0, -1 * M),
    new LXVector(-1 * M, 0, -1 * M),
    new LXVector(-1 * M, 0, 1 * M),
  };

  public static final float[] hexigonRotations = new float[] 
  { 
    //-PI/4, -3 * PI/4, 3 * PI/4, PI/4
    0, 0, 0, 0
  };

  public final Hexigon[] hexigons;

  public Hexigons() 
  {
    super(new Fixture());
    Fixture f = (Fixture) this.fixtures.get(0);
    this.hexigons = f.hexi;
  }
  
  public static class Fixture extends LXAbstractFixture 
  {
    final Hexigon[] hexi = new Hexigon[HEXIGON_COUNT];
    
    Fixture() 
    {
      for(int i = 0; i < HEXIGON_COUNT; i++)
      {
        LXTransform t = new LXTransform();
        LXVector pos = hexigonPositions[i];
        float rot = hexigonRotations[i];

        t.translate(pos.x, pos.y, pos.z);
        t.rotateY(rot);

        t.push();
        addPoints(this.hexi[i] = new Hexigon(t, i));
        t.pop();
      }
    }
  }
}

public static class Hexigon extends LXModel
{
  public static final int OUTER_EDGE = 14;
  public static final int INNER_EDGE = 13;
  public static final float LED_DELTA = M / 30;
  public static final float OUTER_RADIUS = ((OUTER_EDGE + 1) * LED_DELTA);
  public static final float INNER_RADIUS = ((INNER_EDGE + 1) * LED_DELTA);

  public final int index;
  public final LXVector center;
  public final LXVector[] vertices;
  public final Fixture fixture;

  public Hexigon(LXTransform center, int index)
  {
    super(new Fixture(center));
    this.index = index;
    this.center = center.vector();

    this.fixture = (Fixture) this.fixtures.get(0);
    this.vertices = fixture.vertices;
  }

  public static class Fixture extends LXAbstractFixture
  {
    final LXVector[] vertices = new LXVector[12];

    Fixture(LXTransform t)
    {
      t.push();
      
      // Move to the edge of the hexigon
      t.translate(OUTER_RADIUS, 0, 0);
      t.rotateY(2 * PI/3);
      
      for (int side = 0; side < 6; ++side) 
      {
        // Store the vertex position
        this.vertices[side] = t.vector();
        
        // Iterate along the side of the hexigon
        t.translate(LED_DELTA/2., 0);
        for (int e = 0; e < OUTER_EDGE; ++e) 
        {
          addPoint(new LXPoint(t));
          t.translate(LED_DELTA, 0);
        }
        t.translate(-LED_DELTA/2., 0);
        
        // Rotate to next hexigon side
        t.rotateY(PI/3);
      }
      t.pop();
      
      t.push();
      
      // Move to the edge of the hexigon
      t.translate(INNER_RADIUS, 0, 0);
      t.rotateY(-2 * PI/3);
      
      for (int side = 6; side < 12; ++side) 
      {
        // Store the vertex position
        this.vertices[side] = t.vector();
        
        // Iterate along the side of the hexigon
        t.translate(LED_DELTA/2., 0);
        for (int e = 0; e < INNER_EDGE; ++e) 
        {
          addPoint(new LXPoint(t));
          t.translate(LED_DELTA, 0);
        }
        t.translate(-LED_DELTA/2., 0);
        
        // Rotate to next hexigon side
        t.rotateY(-PI/3);
      }

      t.pop();
    }
  }
}
