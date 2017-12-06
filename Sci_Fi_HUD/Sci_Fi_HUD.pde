void setup()
{
 size (700, 700, P3D); 
 board = new Board(0, height *0.7);
 
 for(int i = 0; i < 10000; i++)
 {
   stars.add(new Star());
 }
}

Board board;
ArrayList<Star> stars = new ArrayList<Star>();
float speed;

void draw()
{
  speed = map(mouseX, 0, width, 0, 100);
  println(speed);
  background(0);
  pushMatrix();
  translate(width/2, height/2);
  for(int i = 0; i < stars.size(); i++)
  {
    Star s = stars.get(i);
    s.update(speed);
    s.render();
  }
  popMatrix();
  
  
  board.update();
  board.render();
  
}