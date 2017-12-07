class Star
{
 
  float speed;
  float r;
  float x, y, z;
  float pz;
  
  
  Star()
  {
   x = random(-width/2, width/2);
   y = random(-height/2, height/2);
   z = random(width);
   speed = 5;
  }
  
  void update(float speed)
  {
    this.speed = speed;
    z = z - speed;
    if (z < 1)
    {
      z = width;
      x = random(- width, width);
      y = random(-height, height);
      pz = z;
    }
  }
  
  void render()
  { 
    noStroke();
    fill(255);
    float sx = map(x/z, 0, 1, 0, width);
    float sy = map(y/z, 0, 1, 0, height);
    
    r = map(z, 0, width, 4, 0);
    ellipse(sx, sy, r, r); 
 
    float px = map(x / pz, 0, 1, 0, width);
    float py = map(y / pz, 0, 1, 0, height);
    
    pz = z;
    strokeWeight(1);
    stroke(255);
    
    line(px, py, sx, sy);
  }
  
  
}