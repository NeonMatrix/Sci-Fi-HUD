void setup()
{
  size (700, 700); 
  //fullScreen();
  warpDrive = false;
  speed = 0;
  speedUp = false;
  warpAccelration = 5;
 
 for(int i = 0; i < 8000; i++)
 {
   stars.add(new Star());
 }
  radar1 = new Radar(width/9, height * 0.85 , height * 0.08 , 0.5, color(0, 110, 255));

}

ArrayList<Star> stars = new ArrayList<Star>();
float speed;
boolean warpDrive;
boolean speedUp;
float warpAccelration;
Radar radar1;

void draw()
{
  
  //speed = map(mouseX, 0, width, 0, 100);
  //println(speed);
  background(0);
  
  warpDrive();
  
  pushMatrix();
  translate(width/2, height/2);
  for(int i = 0; i < stars.size(); i++)
  {
    Star s = stars.get(i);
    s.update(speed);
    s.render();
  }
  popMatrix();
  
  board();
  
  warpButton();
  
  radar1.render();
  radar1.update();
  
  starMapButton();
    
}

void mousePressed()
{
  if(mouseX < (width * 0.22) + height/7 && mouseX >  width * 0.22)
  {
    println("mouseX");
    if(mouseY > height * 0.9 && mouseY < height * 0.9 + height/20)
    {
      println("mouseX");
      warpDrive = true;
      speedUp = true;
    }
  }
}

void board()
{
  rectMode(CORNER);
  strokeWeight(5);
  stroke(0, 110, 255);
  fill(0, 110, 255, 100);
  rect(0, height * 0.7, width, height * 0.3);
}

void warpButton()
{
   float buttonX = width * 0.22;
   float buttonY = height * 0.9;
   float buttonW = height/7;
   float buttonH = height/20;
   fill(0, 110, 255);
   noStroke();
   //rectMode(CENTER);
   rect(buttonX , buttonY, buttonW, buttonH);
   fill(0);
   textAlign(CENTER);
   textSize(height/30);
   text("WARP", buttonX + (buttonW/2), buttonY + ((buttonH/3) *2 ));
}

void warpDrive()
{
  if(warpDrive)
  {
    println(speed);
    println("warpDrive: " + warpDrive);
    println("speedUp: " + speedUp);
    if(speedUp)
    {
     speed +=  warpAccelration;
     background(0, 0, speed);
     println(speed);
     if(speed > 200)
     {
          speedUp = false; 
          println("speedUp: " + speedUp);
     }
    }
    else
    {
      println("speedUp: " + speedUp);
      speed -= warpAccelration;
      background(0, 0, speed);
    }
    
    if(speed == 0)
    {
      println(speed);
     warpDrive = false;
     println("warpDrive: " + warpDrive);
    }
    
  }
}

void starMapButton()
{
  float size = height/7;
  float posX = width * 0.22;
  float posY = height * 0.75;
  
  strokeWeight(1);
  for(int i = 0; i < 11; i++)
  {
    line(posX + ((size/10)*i), posY, posX + ((size/10)*i), posY + size);
    line(posX, posY + ((size/10)*i), posX + size, posY + ((size/10)*i));
  }
  
}