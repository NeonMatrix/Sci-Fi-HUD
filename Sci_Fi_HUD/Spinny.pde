class Spinny
{
 
  float x, y, theta, speed, freq;
  
  Spinny(float x, float y, float freq)
  {
    this.x = x;
    this.y = y;
    this.freq = freq;
    speed = (PI / 60.0) * freq;
    theta = 0;
  }
  
  
  void update(float x, float y)
  {
    this.x = x;
    this.y = y;
    theta += speed;
  }
  
  void render()
  {
    drawCircle(theta, 50, 50, 0, PI);
    drawCircle(-theta, 70, 70, PI, TWO_PI);
  }
 
  void drawCircle(float theta, float arcWidth, float arcHeight ,float beingR, float endR)
  {
    pushMatrix();
    translate(x,y);
    rotate(theta);
    noFill();
    strokeWeight(5);
    arc(0, 0, arcWidth, arcHeight, beingR, endR);
    popMatrix();
  }
  
}