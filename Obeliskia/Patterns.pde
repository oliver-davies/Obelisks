@LXCategory("Debug")
public static class IndividualPixelDebug extends LXPattern {

  public final CompoundParameter pixel_id = new CompoundParameter("Pixel ID", 0, Obelisks.OBELISK_COUNT * 162);

  
  public IndividualPixelDebug(LX lx) {
    super(lx);
    addParameter("Obelisk ID", this.pixel_id);
  }
  
  public void run(double deltaMs) {
    int id = int(this.pixel_id.getValuef());

    for (int i = 0; i < structure.points.length; i++)
    {
      colors[i] = LXColor.gray(0);
    }
    colors[id] = LXColor.gray(100);
  }
}

@LXCategory("Debug")
public static class ObeliskAlignDebug extends LXPattern {

  public final CompoundParameter obelisk_id = new CompoundParameter("Obelisk ID", 0, Obelisks.OBELISK_COUNT - 1);

  
  public ObeliskAlignDebug (LX lx) {
    super(lx);
    addParameter("Obelisk ID", this.obelisk_id);
  }
  
  public void run(double deltaMs) {
    int obelisk_id = int(this.obelisk_id.getValuef());

    float n = 0;
    for (int i = 0; i < Obelisks.OBELISK_COUNT; i++) 
    {
      Obelisk lisk = structure.obelisks[i];
      for (LXPoint p : lisk.points)
      {
        if(i == obelisk_id) colors[p.index] = LXColor.gray(100); 
        else colors[p.index] = LXColor.gray(0);
      }
    }
  }
}

@LXCategory("Shapes")
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
@LXCategory("Shapes")
public static class DopsPattern extends LXPattern {
  
  public final CompoundParameter speed = new CompoundParameter("Speed", 0,-0.5, 0.5)
    .setDescription("Position of the center of the plane");
  
  public final CompoundParameter wth = new CompoundParameter("Width", 0.1, 0, 1)
    .setDescription("Thickness of the plane");

  public final CompoundParameter grouping = new CompoundParameter("Grouping", 1, 0, 12)
    .setDescription("Thickness of the plane");

  public final CompoundParameter radialWidth = new CompoundParameter("Radial Width", 0.1, 0, 10)
    .setDescription("Thickness of the plane");


  
  public DopsPattern(LX lx) {
    super(lx);
    addParameter("Speed", this.speed);
    addParameter("Width", this.wth);
    addParameter("Grouping", this.grouping);
    addParameter("Radial Width", this.radialWidth);
  }
  float delta = 0;

  public void run(double deltaMs) {
    float speed = this.speed.getValuef();
    float falloff = this.wth.getValuef() * Obelisks.OBELISK_COUNT * 162;
    float grouping = floor(this.grouping.getValuef() * 162);
    float radialScale = floor(this.radialWidth.getValuef() * 162);

    float n = 0;
    delta += deltaMs * speed;
    for (int i = 0; i < model.points.length; i++) 
    {
      LXPoint p = model.points[i];
      double v = abs(delta - p.index) % grouping;
      colors[p.index] = LXColor.gray(Helpers.clamp(falloff - v * 10, 0d, 100d) ); 
    }
  }
}

@LXCategory("Shapes")
public static class StripsPattern extends LXPattern 
{
  public enum Axis {
    X, Y, Z
  };
  
  public final EnumParameter<Axis> axis = new EnumParameter<Axis>("Axis", Axis.X);
  public final CompoundParameter speed = new CompoundParameter("Spread", 0, -0.025, 0.025);
  public final CompoundParameter freq = new CompoundParameter("Freq", 0, 100);
  public final CompoundParameter edge = new CompoundParameter("Hard Edge", 0, 1);

  public StripsPattern(LX lx) 
  {
    super(lx);
    addParameter("axis", this.axis);
    addParameter("Speed", this.speed);
    addParameter("Freq", this.freq);
    addParameter("Hard Edge", this.edge);
  }


  float timer = 0;
  public void run(double deltaMs) 
  {
    float speed = this.speed.getValuef();
    float freq = this.freq.getValuef();
    float edge = this.edge.getValuef();
    float n = 0;

    timer += deltaMs * speed;
    for (LXPoint p : structure.points) 
    {

      switch (this.axis.getEnum()) 
      {
        case X: n = p.xn; break;
        case Y: n = p.yn; break;
        case Z: n = p.zn; break;
      }

      float s = sin(timer + n * freq);
      float slices = Helpers.Smooth(s*s);
      colors[p.index] = LXColor.gray(Helpers.lerp(edge, slices * 100, slices > 0.5f ? 100 : 0)); 
    }  
  }
}

@LXCategory("Shapes")
public static class SpiralPattern extends LXPattern 
{ 
  public final CompoundParameter spiralCount = new CompoundParameter("Count", 2, 1, 12);
  public final CompoundParameter curve = new CompoundParameter("Curve", 0, -3, 3);
  public final CompoundParameter wdth = new CompoundParameter("Width", 1, PI / 4, PI);
  public final CompoundParameter rotationSpeed = new CompoundParameter("Rotation Speed", 0, -0.005, 0.005);
  public final CompoundParameter noise_scale = new CompoundParameter("Noise Scale", 0, 0, 1);
  
  public SpiralPattern(LX lx) {
    super(lx);
    addParameter("Count", this.spiralCount);
    addParameter("Curve", this.curve);
    addParameter("Width", this.wdth);
    addParameter("Rotation Speed", this.rotationSpeed);
    addParameter("Noise Scale", this.noise_scale);
  }
  
  float timer = 0;
  public void run(double deltaMs) {
    float spiralCount = 1f / this.spiralCount.getValuef();
    float rotSpeed = this.rotationSpeed.getValuef();
    float curve = this.curve.getValuef();
    float wdth = this.wdth.getValuef();
    float noise_scale = this.noise_scale.getValuef();
    timer += deltaMs * rotSpeed;

    for (LXPoint p : model.points) {
      float noise = 1;
      if(noise_scale > 0)
      {
        noise = (float)(Helpers.noise(p.x * noise_scale, p.y * noise_scale, p.z * noise_scale) + 1f) * 0.5f;
      }

      float val = (PI * 2 * spiralCount);
      float offset = (p.azimuth + timer - noise + p.rn * curve) % val;
      float arm = Helpers.Smooth(1 - max(0, (sin((offset * wdth / val) * PI))));
      colors[p.index] = LXColor.gray((double)arm * arm * 100); 
    }
  }
}


@LXCategory("Shapes")
public static class RipplesPattern extends LXPattern 
{
  public final CompoundParameter lifetime = new CompoundParameter("LifeTime", 0, 0.01);
  public final CompoundParameter hardness = new CompoundParameter("Hardness", 1, 1, 10);
 public final CompoundParameter falloff = new CompoundParameter("Falloff", 1, 0, 10);

  public RipplesPattern(LX lx)  
  {
    super(lx);
    addParameter("Lifetime", this.lifetime);
    addParameter("Strength", this.hardness);
    addParameter("Falloff", this.falloff);
  }

  LXVector pv = new LXVector(0,0,0);
  float timer_wave = 0;
  public void run(double deltaMs) 
  {
    float lifetime = this.lifetime.getValuef();
    float hardness = this.hardness.getValuef();
    float falloff = this.falloff.getValuef();
    timer_wave += deltaMs * lifetime;
    for (Obelisk lisk : structure.obelisks) 
    {
      for(LXPoint p : lisk.points)
      {
        pv.x = p.x;
        pv.y = p.y;
        pv.z = p.z;

        float brightness = 0;
        float hueShift = 0;
        for(LXVector drop : lisk.vertices)
        {
          float dist = drop.dist(pv) / M;
          float val = Helpers.FreeWave(dist, timer_wave % 3, hardness);

          hueShift += val;
          brightness = max(brightness, val);
        }

        colors[p.index] = LXColor.hsb(hueShift % 360, 100, brightness < 0 ? 0 : brightness * 100); 
      }
    }
  }
}



@LXCategory("Shapes")
public static class ShockwavePattern extends LXPattern 
{
  public final CompoundParameter speed = new CompoundParameter("Speed", 0, -0.02, 0.02);
  public final CompoundParameter strength = new CompoundParameter("Strength", 0, 0.1);
  public final CompoundParameter noise_scale = new CompoundParameter("Noise Scale", 0, 0, 0.4);
  public final CompoundParameter obelisk_id = new CompoundParameter("Obelisk Center", 0, Obelisks.OBELISK_COUNT - 1);


  public ShockwavePattern(LX lx)  
  {
    super(lx);
    addParameter("Speed", this.speed);
    addParameter("Strength", this.strength);
    addParameter("Noise Scale", this.noise_scale);
    addParameter("Obelisk Center", this.obelisk_id);
  }

  float timer_wave = 0;
  public void run(double deltaMs) 
  {
    float speed = this.speed.getValuef();
    float strength = this.strength.getValuef();
    float obelisk_id = this.obelisk_id.getValuef();
    float noise_scale = this.noise_scale.getValuef();

    int floor_id = floor(obelisk_id);
    float lerp = obelisk_id - floor_id;
    LXVector c1 = structure.obelisks[floor_id].center.copy().mult(1 - lerp);
    LXVector c2 = structure.obelisks[(floor_id + 1) % Obelisks.OBELISK_COUNT].center.copy().mult(lerp);
    LXVector c = c1.add(c2);

    LXVector pv = new LXVector(0,0,0);
    timer_wave += deltaMs * speed;

    for (LXPoint p : structure.points) 
    {
      pv.x = p.x;
      pv.y = p.y;
      pv.z = p.z;

      LXVector directionToCenter = pv.sub(c);
      float d = directionToCenter.mag() * strength;

      // Noise
      float noise = 1;
      if(noise_scale > 0)
      {
        noise = (float)(Helpers.noise(pv.x * noise_scale, pv.y * noise_scale, pv.z * noise_scale) + 1f) * 0.5f;
      }

      colors[p.index] = LXColor.gray(Helpers.Smooth(Helpers.clamp((double)sin((noise - d * d) + timer_wave), 0d, 1d)) * 100); 
    }
  }
}

@LXCategory("Shapes")
public static class VoronoiPattern extends LXPattern {

  public final CompoundParameter size = new CompoundParameter("Size", 0.01, 0, 0.1)
    .setDescription("Thickness of the plane");

  public final CompoundParameter speed = new CompoundParameter("speed", 0.001, -0.005, 0.005)
    .setDescription("Speed of burble");

   
  public VoronoiPattern(LX lx) {
    super(lx);
    addParameter("Size", this.size);
    addParameter("Speed", this.speed);
  }
  
  float timer = 0;
  public void run(double deltaMs) {
    float wdth = this.size.getValuef();
    float speed = this.speed.getValuef();

    timer += deltaMs * speed;
    for (int i = 0; i < Obelisks.OBELISK_COUNT; i++) 
    {
      Obelisk lisk = structure.obelisks[i];
      for (LXPoint p : lisk.points)
      {
        float ns = Helpers.voronoi(p.x * wdth, p.z * wdth, timer);
        colors[p.index] = LXColor.gray(sin(max(0, min((-ns * 2), 1))) * 100); 
      }
    }
  }
}

@LXCategory("Shapes")
public static class RandomShapesPattern extends LXPattern {

  public final CompoundParameter size = new CompoundParameter("Size", 0.01, 0, 0.05)
    .setDescription("Thickness of the plane");

  public final CompoundParameter speed = new CompoundParameter("speed", 0.001, -0.005, 0.005)
    .setDescription("Speed of burble");

   
  public RandomShapesPattern(LX lx) {
    super(lx);
    addParameter("Size", this.size);
    addParameter("Speed", this.speed);
  }
  
  float timer = 0;
  public void run(double deltaMs) {
    float wdth = this.size.getValuef();
    float speed = this.speed.getValuef();

    timer += deltaMs * speed;
    for (int i = 0; i < Obelisks.OBELISK_COUNT; i++) 
    {
      Obelisk lisk = structure.obelisks[i];
      for (LXPoint p : lisk.points)
      {
        float ns = Helpers.voronoi(p.x * wdth, p.z * wdth, timer);
        colors[p.index] = LXColor.gray(sin(max(0, min((1/(ns * 1.3f)), 1))) * 100); 
      }
    }
  }
}


// Helper fuctions
public static class Helpers 
{
   public static double noise(double x, double y, double z) {
      int X = (int)Math.floor(x) & 255,                  // FIND UNIT CUBE THAT
          Y = (int)Math.floor(y) & 255,                  // CONTAINS POINT.
          Z = (int)Math.floor(z) & 255;
      x -= Math.floor(x);                                // FIND RELATIVE X,Y,Z
      y -= Math.floor(y);                                // OF POINT IN CUBE.
      z -= Math.floor(z);
      double u = fade(x),                                // COMPUTE FADE CURVES
             v = fade(y),                                // FOR EACH OF X,Y,Z.
             w = fade(z);
      int A = p[X  ]+Y, AA = p[A]+Z, AB = p[A+1]+Z,      // HASH COORDINATES OF
          B = p[X+1]+Y, BA = p[B]+Z, BB = p[B+1]+Z;      // THE 8 CUBE CORNERS,

      return lerp(w, lerp(v, lerp(u, grad(p[AA  ], x  , y  , z   ),  // AND ADD
                                     grad(p[BA  ], x-1, y  , z   )), // BLENDED
                             lerp(u, grad(p[AB  ], x  , y-1, z   ),  // RESULTS
                                     grad(p[BB  ], x-1, y-1, z   ))),// FROM  8
                     lerp(v, lerp(u, grad(p[AA+1], x  , y  , z-1 ),  // CORNERS
                                     grad(p[BA+1], x-1, y  , z-1 )), // OF CUBE
                             lerp(u, grad(p[AB+1], x  , y-1, z-1 ),
                                     grad(p[BB+1], x-1, y-1, z-1 ))));
   }
   public static double fade(double t) { return t * t * t * (t * (t * 6 - 15) + 10); }
   public static double lerp(double t, double a, double b) { return a + t * (b - a); }
   public static double grad(int hash, double x, double y, double z) {
      int h = hash & 15;                      // CONVERT LO 4 BITS OF HASH CODE
      double u = h<8 ? x : y,                 // INTO 12 GRADIENT DIRECTIONS.
             v = h<4 ? y : h==12||h==14 ? x : z;
      return ((h&1) == 0 ? u : -u) + ((h&2) == 0 ? v : -v);
   }
   static final int p[] = new int[512], permutation[] = { 151,160,137,91,90,15,
   131,13,201,95,96,53,194,233,7,225,140,36,103,30,69,142,8,99,37,240,21,10,23,
   190, 6,148,247,120,234,75,0,26,197,62,94,252,219,203,117,35,11,32,57,177,33,
   88,237,149,56,87,174,20,125,136,171,168, 68,175,74,165,71,134,139,48,27,166,
   77,146,158,231,83,111,229,122,60,211,133,230,220,105,92,41,55,46,245,40,244,
   102,143,54, 65,25,63,161, 1,216,80,73,209,76,132,187,208, 89,18,169,200,196,
   135,130,116,188,159,86,164,100,109,198,173,186, 3,64,52,217,226,250,124,123,
   5,202,38,147,118,126,255,82,85,212,207,206,59,227,47,16,58,17,182,189,28,42,
   223,183,170,213,119,248,152, 2,44,154,163, 70,221,153,101,155,167, 43,172,9,
   129,22,39,253, 19,98,108,110,79,113,224,232,178,185, 112,104,218,246,97,228,
   251,34,242,193,238,210,144,12,191,179,162,241, 81,51,145,235,249,14,239,107,
   49,192,214, 31,181,199,106,157,184, 84,204,176,115,121,50,45,127, 4,150,254,
   138,236,205,93,222,114,67,29,24,72,243,141,128,195,78,66,215,61,156,180
   };
   static { for (int i=0; i < 256 ; i++) p[256+i] = p[i] = permutation[i]; }

    public static float Wave(float x, float amp, float offset, float width)
    {
        return amp * exp(-((x - offset) * (x - offset))/(2 * width * width));
    }

    public static double Smooth(double t)
    {
      return (t*t*t*(t*(6d*t-15d)+10d));
    }

    public static float Smooth(float t)
    {
      return (t*t*t*(t*(6f*t-15f)+10f));
    }

    public static <T extends Comparable<T>> T clamp(T val, T min, T max) 
    {
        if (val.compareTo(min) < 0) return min;
        else if (val.compareTo(max) > 0) return max;
        else return val;
    }

    public static float RandN(float n)
    {
      float e = ( n * 321.9) % 1;
      return (e * e * 11.0) % 2 - 1;
    }

    public static float voronoi(float x, float z, float rand)
    {
      float px = floor(x);
      float pz = floor(z);
      float fx = abs(x%1f);
      float fz = abs(z%1f);

      float res_x = 8.0;
      float res_z = 8.0;
      for(int j=-1; j<=1; j++)
      for(int i=-1; i<=1; i++)
      {
        float rx = i - fx + RandN(px + i) + sin(rand) * 3;
        float rz = j - fz + RandN(pz + j) + cos(rand) * 2;

        // chebyshev dist
        float d = max(abs(rx), abs(rz));

        if(d < res_x)
        {
          res_z = res_x;
          res_x = d;
        }
        else if(d < res_z)
        {
          res_z = d;
        }
      }
      return (res_x - res_z) * 0.5;
    }

    public static float FreeWave(float x, float m, float w)
    {
      if(m + (1f/w) > x && x > m) return -0.5f*cos(2f*PI*w*x - 2f*PI*m*w) + 0.5f;
      else return 0;
    }

}
