class Star
{
 
  float speed;
  float r;
  float x, y, z;
  
  
  Star()
  {
   x = random(-width/2, width/2);
   y = random(-height/2, height/2);
   z = random(width);
   speed = 5;
   r = 2;

  }
  
  void update()
  {
    z = z - speed;
    if (z < 1)
    {
      z = width;
      x = random(- width, width);
      y = random(-height, height);
    }
  }
  
  void render()
  { 
    noStroke();
    fill(255);
    float sx = map(x / z, 0, 1, 0, width);
    float sy = map(y / z, 0, 1, 0, height);
    
    ellipse(sx, sy, r, r);  
  }
  
  
}