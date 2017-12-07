void setup()
{
  //size (700, 700); 
  fullScreen();
  warpDrive = false;
  speed = 0;
  speedUp = false;
  warpAccelration = 2;
 
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
  warpDrive();
  
  radar1.render();
  radar1.update();
    
}

void mousePressed()
{
  if(mouseX < width/2 + (width/5)/2 && mouseX > width/2 - + (width/5)/2)
  {
    if(mouseY < height * 0.9 + (height/20)/2 && mouseY > height * 0.9 - (height/20)/2)
    {
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
   fill(0, 110, 255);
   rectMode(CENTER);
   rect(width/2, height * 0.9, width/5, height/20);
   fill(0);
   textAlign(CENTER);
   textSize(height/20);
   text("WARP", width/2, height * 0.92);
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
      speed--;
    }
    
    if(speed == 0)
    {
      println(speed);
     warpDrive = false;
     println("warpDrive: " + warpDrive);
    }
    
  }
}