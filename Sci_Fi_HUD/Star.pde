// this is the class for the stars seen in the background
class Star
{
 
  float speed;
  float r;
  float x, y, z;
  float pz;
  
  // star constructor, making it at a random spot on the screen,
  // -width/2 and width/2 because of the translate used later
  Star()
  {
   x = random(-width/2, width/2);
   y = random(-height/2, height/2);
   z = random(width);
   speed = 5;
  }
  
  // this updated the postiion of the star, the z value is increamned by the speed, 
  //giving it a look that the stars are moving towards you
  void update(float speed)
  {
    this.speed = speed;
    z = z - speed;
    // once a star is out of bounds, it's reset to be at the very back of the screen
    if (z < 1)
    {
      z = width;
      x = random(- width, width);
      y = random(-height, height);
      pz = z;
    }
  }
  
  // this draws the stars and the line trials when the stars move really fast
  void render()
  { 
    noStroke();
    fill(255);
    float sx = map(x/z, 0, 1, 0, width);
    float sy = map(y/z, 0, 1, 0, height);
    
    // draw the circle as the star, with the radius 
    // propotiante to how close it is to the screen
    r = map(z, 0, width, 4, 0);
    ellipse(sx, sy, r, r); 
 
    float px = map(x / pz, 0, 1, 0, width);
    float py = map(y / pz, 0, 1, 0, height);
    
    pz = z;
    strokeWeight(1);
    stroke(255);
    
    // this is the line that trails the star
    // it connects it's current position and the position it was last fame ago
    line(px, py, sx, sy);
  }
  
  
}