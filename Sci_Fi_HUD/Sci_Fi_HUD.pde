void setup()
{
 size (700, 700, P3D); 
 board = new Board(0, height *0.7);
 
 for(int i = 0; i < 100000; i++)
 {
   stars.add(new Star());
 }
}

Board board;
ArrayList<Star> stars = new ArrayList<Star>();

void draw()
{
  background(0);
  pushMatrix();
  translate(width/2, height/2);
  for(int i = 0; i < stars.size(); i++)
  {
    Star s = stars.get(i);
    s.update();
    s.render();
  }
  popMatrix();
  
  
  board.update();
  board.render();
  
}