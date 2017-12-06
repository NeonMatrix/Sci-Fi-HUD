class Board
{
  float x;
  float y;
  
  Board(float x, float y)
  {
    this.x = x;
    this.y = y;
  }
  
  void update()
  {
    
  }
  
  void render()
  {
    fill(150);
    noStroke();
    rect(x, y, width, height - y);  
  }
}