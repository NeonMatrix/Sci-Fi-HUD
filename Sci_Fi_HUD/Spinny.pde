// This is the class which was used inside the aim thingy, draws the two rotating semi circles inside the aim
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
  
  
  // this updated the rotate information along where it is located, as it has to move with the mouse
  void update(float x, float y)
  {
    this.x = x;
    this.y = y;
    theta += speed;
  }
  
  // then draws the circles, I used the same function just diffrent sizes two draw the two cricles
  void render()
  {
    drawCircle(theta, 50, 50, 0, PI);
    drawCircle(-theta, 70, 70, PI, TWO_PI);
  }
 
   // this is the function that draws the semi circles, just pass it in the values it needs and it'll draw you a roatting semi circle
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