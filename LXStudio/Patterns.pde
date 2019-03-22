// In this file you can define your own custom patterns

// Here is a fairly basic example pattern that renders a plane that can be moved
// across one of the axes.
@LXCategory("Form")
public static class PlanePattern extends LXPattern {
  
  public enum Axis {
    X, Y, Z
  };
  
  public final EnumParameter<Axis> axis =
    new EnumParameter<Axis>("Axis", Axis.X)
    .setDescription("Which axis the plane is drawn across");
  
  public final CompoundParameter pos = new CompoundParameter("Pos", 0, 1)
    .setDescription("Position of the center of the plane");
  
  public final CompoundParameter wth = new CompoundParameter("Width", .4, 0, 1)
    .setDescription("Thickness of the plane");
  
  public PlanePattern(LX lx) {
    super(lx);
    addParameter("axis", this.axis);
    addParameter("pos", this.pos);
    addParameter("width", this.wth);
  }
  
  public void run(double deltaMs) {
    float pos = this.pos.getValuef();
    float falloff = 100 / this.wth.getValuef();
    float n = 0;
    for (LXPoint p : model.points) {
      switch (this.axis.getEnum()) {
      case X: n = p.xn; break;
      case Y: n = p.yn; break;
      case Z: n = p.zn; break;
      }
      colors[p.index] = LXColor.gray(max(0, 100 - falloff*abs(n - pos))); 
    }
  }
}

// In this file you can define your own custom patterns

// Here is a fairly basic example pattern that renders a plane that can be moved
// across one of the axes.
@LXCategory("Form")
public static class DopsPattern extends LXPattern {
  
  public enum Axis {
    X, Y, Z
  };
  
  public final EnumParameter<Axis> axis =
    new EnumParameter<Axis>("Axis", Axis.X)
    .setDescription("Which axis the plane is drawn across");
  
  public final CompoundParameter speed = new CompoundParameter("Speed", 0, 1)
    .setDescription("Position of the center of the plane");
  
  public final CompoundParameter wth = new CompoundParameter("Width", .4, 0, 10)
    .setDescription("Thickness of the plane");
  
  public DopsPattern(LX lx) {
    super(lx);
    addParameter("axis", this.axis);
    addParameter("speed", this.speed);
    addParameter("width", this.wth);
  }
  float delta = 0;

  public <T extends Comparable<T>> T clamp(T val, T min, T max) 
  {
      if (val.compareTo(min) < 0) return min;
      else if (val.compareTo(max) > 0) return max;
      else return val;
  }
  
  public void run(double deltaMs) {
    float speed = this.speed.getValuef();
    float falloff = 100 / this.wth.getValuef();
    float n = 0;
    delta += deltaMs * speed;

    for (LXPoint p : model.points) {
      switch (this.axis.getEnum()) {
      case X: n = p.xn; break;
      case Y: n = p.yn; break;
      case Z: n = p.zn; break;
      }
      double test = abs(delta - p.index) % (144 * 3 + 36 * 3) ;
      colors[p.index] = LXColor.gray( clamp(falloff - test, (double)0, (double)100) ); 
    }
  }
}

@LXCategory("Form")
public static class CornersPattern extends LXPattern 
{
  public enum Axis {
    X, Y, Z
  };
  
  public final EnumParameter<Axis> axis = new EnumParameter<Axis>("Axis", Axis.X);
  public final CompoundParameter speed = new CompoundParameter("Spread", 0, -0.05, 0.05);
  public final CompoundParameter freq = new CompoundParameter("Freq", 0, 100);

  public CornersPattern(LX lx) 
  {
    super(lx);
    addParameter("axis", this.axis);
    addParameter("Speed", this.speed);
    addParameter("Freq", this.freq);
  }

  public <T extends Comparable<T>> T clamp(T val, T min, T max) 
  {
      if (val.compareTo(min) < 0) return min;
      else if (val.compareTo(max) > 0) return max;
      else return val;
  }


  float timer = 0;
  public void run(double deltaMs) 
  {
    float speed = this.speed.getValuef();
    float freq = this.freq.getValuef();
    float n = 0;

    timer += deltaMs * speed;
    for (LXPoint p : obelisk.points) 
    {

      switch (this.axis.getEnum()) 
      {
        case X: n = p.xn; break;
        case Y: n = p.yn; break;
        case Z: n = p.zn; break;
      }

      if(sin(timer + n * freq) > 0) colors[p.index] = LXColor.gray(100); 
      else colors[p.index] = LXColor.gray(0); 
    }
  }
}

