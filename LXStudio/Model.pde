Obelisk buildModel() 
{
  return new Obelisk(new LXTransform(), 0);
}

public static class Obelisks extends LXModel 
{
  public static final int OBELISK_COUNT = 1;
  public static final LXVector[] obeliskPositions = new LXVector[] 
  { 
    new LXVector(2, 0, 2),
    new LXVector(2, 0, -2),
    new LXVector(-2, 0, -2),
    new LXVector(-2, 0, 2),
  };

  public static final float[] obeliskRotations = new float[] 
  { 
    -PI/4, -3 * PI/4, 3 * PI/4, PI/4
  };

  public final Obelisk[] obelisks;
  public Obelisks() 
  {
    super(new Fixture());
    Fixture f = (Fixture) this.fixtures.get(0);
    this.obelisks = f.obelisks;
  }
  
  public static class Fixture extends LXAbstractFixture 
  {
    final Obelisk[] obelisks = new Obelisk[OBELISK_COUNT];

    Fixture() 
    {
      for(int i = 0; i < OBELISK_COUNT; i++)
      {
        LXTransform t = new LXTransform();
        LXVector pos = obeliskPositions[i];
        float rot = obeliskRotations[i];

        t.translate(pos.x, pos.y, pos.z);
        t.rotateY(rot);
        addPoints(this.obelisks[i] = new Obelisk(t, i));
      }
    }
  }
}

public static class Obelisk extends LXModel
{
  public static final float BASE_RADIUS = 1.212;
  public static final int TUBE_LED_COUNT_SHORT = 36;
  public static final int TUBE_LED_COUNT_LONG = 144;
  public static final float TUBE_LENGTH_SHORT = 2.1;
  public static final float TUBE_LENGTH_LONG = 8;
  public static final float TUBE_LED_SPACING_SHORT = TUBE_LENGTH_SHORT / TUBE_LED_COUNT_SHORT;
  public static final float TUBE_LED_SPACING_LONG = TUBE_LENGTH_LONG / TUBE_LED_COUNT_LONG;

  public final int index;
  public final LXVector top;
  public final LXVector bottomCenter;
  public final LXVector[] bottomVertices;
  public final Fixture fix;

  public Obelisk(LXTransform bottomCenter, int index)
  {
    super(new Fixture(bottomCenter));
    this.index = index;
    this.bottomCenter = bottomCenter.vector();

    this.fix = (Fixture) this.fixtures.get(0);
    this.top = fix.top;
    this.bottomVertices = fix.bottomVertices;
  }

  public static class Fixture extends LXAbstractFixture
  {
    final LXVector[] bottomVertices = new LXVector[3];
    LXVector top = new LXVector(0,0,0);

    Fixture(LXTransform t)
    {
      t.push();

      // Move to the tip of the triangle
      t.translate(0, 0, -BASE_RADIUS);

      // Rotate to direction of first triangle side
      t.rotateY(-2*PI/3);

      for (int side = 0; side < 3; ++side) 
      {
        // Store the vertex position
        this.bottomVertices[side] = t.vector();
        
        // Iterate along the side of the triangle
        t.translate(TUBE_LED_SPACING_SHORT/2., 0);
        for (int e = 0; e < TUBE_LED_COUNT_SHORT; ++e) 
        {
          addPoint(new LXPoint(t));
          t.translate(TUBE_LED_SPACING_SHORT, 0);
        }
        t.translate(-TUBE_LED_SPACING_SHORT/2., 0);
        
        // Rotate to next triangle side
        t.rotateY(2*PI/3);
      }

      t.pop();

      this.top = t.vector().copy().add(new LXVector(0,8,0));
      float radianInwardTilt = -atan(BASE_RADIUS / this.top.y);

      // leg 1
      t.push();

      t.translate(0, 0, -BASE_RADIUS);
      t.rotateZ(PI/2);
      t.rotateY(radianInwardTilt);
      t.translate(TUBE_LED_SPACING_LONG/2., 0);
      for (int e = 0; e < TUBE_LED_COUNT_LONG; ++e) 
      {
        addPoint(new LXPoint(t));
        t.translate(TUBE_LED_SPACING_LONG, 0);
      }
      t.translate(-TUBE_LED_SPACING_LONG/2., 0);
      t.rotateY(-radianInwardTilt);
      t.rotateZ(-PI/2);
      t.translate(0, 0, BASE_RADIUS);
      t.pop();

      // Leg 2
      t.push();

      t.rotateY(2 * PI/3);
      t.translate(0, 0, -BASE_RADIUS);
      t.rotateZ(PI/2);
      t.rotateY(radianInwardTilt);
      t.translate(TUBE_LENGTH_LONG, 0, 0);

      t.translate(-TUBE_LED_SPACING_LONG/2., 0);
      for (int e = 0; e < TUBE_LED_COUNT_LONG; ++e) 
      {
        addPoint(new LXPoint(t));
        t.translate(-TUBE_LED_SPACING_LONG, 0);
      }
      t.translate(TUBE_LED_SPACING_LONG/2., 0);
      
      t.rotateY(-radianInwardTilt);
      t.rotateZ(-PI/2);
      t.translate(0, 0, BASE_RADIUS);

      t.pop();

      // Leg 3
      t.push();
      t.rotateY(4 * PI/3);
      t.translate(0, 0, -BASE_RADIUS);
      t.rotateZ(PI/2);
      t.rotateY(radianInwardTilt);

      t.translate(TUBE_LED_SPACING_LONG/2., 0);
      for (int e = 0; e < TUBE_LED_COUNT_LONG; ++e) 
      {
        addPoint(new LXPoint(t));
        t.translate(TUBE_LED_SPACING_LONG, 0);
      }
      t.translate(-TUBE_LED_SPACING_LONG/2., 0);
      
      t.rotateY(-radianInwardTilt);
      t.rotateZ(-PI/2);
      t.translate(0, 0, BASE_RADIUS);

      t.pop();
    }
  }
}
