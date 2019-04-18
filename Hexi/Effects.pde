/**
 * Copyright 2013- Mark C. Slee, Heron Arts LLC
 *
 * This file is part of the LX Studio software library. By using
 * LX, you agree to the terms of the LX Studio Software License
 * and Distribution Agreement, available at: http://lx.studio/license
 *
 * Please note that the LX license is not open-source. The license
 * allows for free, non-commercial use.
 *
 * HERON ARTS MAKES NO WARRANTY, EXPRESS, IMPLIED, STATUTORY, OR
 * OTHERWISE, AND SPECIFICALLY DISCLAIMS ANY WARRANTY OF
 * MERCHANTABILITY, NON-INFRINGEMENT, OR FITNESS FOR A PARTICULAR
 * PURPOSE, WITH RESPECT TO THE SOFTWARE.
 *
 * @author Mark C. Slee <mark@heronarts.com>
 */

import heronarts.lx.LX;
import heronarts.lx.LXCategory;
import heronarts.lx.LXEffect;
import heronarts.lx.color.LXColor;
import heronarts.lx.parameter.CompoundParameter;
import heronarts.lx.parameter.LXParameter;

@LXCategory(LXCategory.COLOR)
public static class ColorTrailEffect extends LXEffect 
{
  private final CompoundParameter amount =
    new CompoundParameter("Amount", 10, 0, 100)
    .setDescription("Sets the amount of trail to apply");

  private final CompoundParameter shiftColor =
    new CompoundParameter("Shift Color", 10, 0, 255)
    .setDescription("Set color to shift to");

  public ColorTrailEffect(LX lx) {
    super(lx);
    addParameter("amount", this.amount);
    addParameter("Shift Color", this.shiftColor);
  }

  @Override
  protected void run(double deltaMs, double amount) 
  {
    double c = this.shiftColor.getValue();
    double a = this.amount.getValue();

    for (int i = 0; i < colors.length; i++) {
      int col = colors[i];
      float b = LXColor.b(col);
      float h = LXColor.h(col);
      float s = LXColor.s(col);
      colors[i] = LXColor.hsb(
        b > a ? h : (h + c) % 255, s, b
      );
    }
  }
}

@LXCategory(LXCategory.COLOR)
public static class ColorNoiseEffect extends LXEffect 
{
  private final CompoundParameter amount =
    new CompoundParameter("Noise Scale", 0, 0, 0.25)
    .setDescription("Sets the amount of trail to apply");

  private final CompoundParameter shiftColor =
    new CompoundParameter("Shift Color", 10, 0, 255)
    .setDescription("Set color to shift to");

  public ColorNoiseEffect(LX lx) {
    super(lx);
    addParameter("Noise Scale", this.amount);
    addParameter("Shift Color", this.shiftColor);
  }

  @Override
  protected void run(double deltaMs, double amount) 
  {
    double sc = this.shiftColor.getValue();
    double a = this.amount.getValue();
    for (int i = 0; i < structure.points.length; i++) 
    {
      LXPoint p = structure.points[i];
      int col = colors[i];
      float b = LXColor.b(col);
      float h = LXColor.h(col);
      float s = LXColor.s(col);
      float n = max(0, (float)Helpers.noise(p.x * a, p.y * a, p.z * a));
      colors[i] = LXColor.hsb(
        h + n * sc, s, b
      );
    }
  }
}


@LXCategory("Not working")
public static class AntiAliasingEffect extends LXEffect 
{
  private final CompoundParameter brighten =
    new CompoundParameter("Brightening", 0.5f, 0, 1)
    .setDescription("Sets the amount of alias brightening to apply");

  private final CompoundParameter sizeOfKernal =
    new CompoundParameter("Kernal Size", 2, 1, 5)
    .setDescription("Number of pixels to blur");

  private static float[] pixels; 

  public AntiAliasingEffect(LX lx) 
  {
    super(lx);
    addParameter("Size of kernal", this.sizeOfKernal);
    addParameter("", this.brighten);
    pixels = new float[structure.points.length];
  }

  @Override
  protected void run(double deltaMs, double amount) 
  {
    int sk = floor(this.sizeOfKernal.getValuef());
    float brighten = 1 - this.brighten.getValuef();
    int size = structure.points.length;

    for(int i = 0; i < size; i++)
    {
      pixels[i] = LXColor.b(colors[i]);
    }

    for (int i = 0; i < size; i++) 
    {
      int col = colors[i];
      float b = pixels[i];

      float h = LXColor.h(col);
      float s = LXColor.s(col);

      for(int j = 1; j < sk; j++)
      {
        // Setup edge bounds
        int j_plus = (i + j) % size;
        int j_minus = (i - j) % size;
        if ( j_minus < 0 ) j_minus += size;

        float div = Helpers.clamp(brighten/(j * 0.5f + 0.5f), 0f, 1f);

        if(pixels[j_plus] <  b * div) colors[j_plus] = LXColor.hsb(h, s, b * div);
        if(pixels[j_minus] <  b * div)  colors[j_minus] = LXColor.hsb(h, s, b * div);
      }
    }
  }
}