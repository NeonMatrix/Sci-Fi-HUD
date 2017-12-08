void setup()
{
  size (1000, 1000,P2D); 
  //fullScreen();
  loadData();
  warpDrive = false;
  speed = 0;
  speedUp = false;
  starMapActive = false;
  warpAccelration = 5;
 
 for(int i = 0; i < 8000; i++)
 {
   stars.add(new Star());
 }
  radar1 = new Radar(width/9, height * 0.85 , height * 0.08 , 0.5, color(0, 110, 255));

}

ArrayList<Star> stars = new ArrayList<Star>();
ArrayList<MapStar> mapstars = new ArrayList<MapStar>();
float speed;
boolean warpDrive;
boolean speedUp;
float warpAccelration;
boolean starMapActive;


Radar radar1;

void draw()
{
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
  
  if(starMapActive)
  {
    starMapGrid();
    drawMapStars();
  }
  
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
    if(mouseY > height * 0.9 && mouseY < height * 0.9 + height/20)
    {
      warpDrive = true;
      speedUp = true;
      starMapActive = false;
    }
  }
  
  if(mouseX > width * 0.22 && mouseX < (width * 0.22) + height/7)
  {
    if(mouseY > height * 0.75 && mouseY < height * 0.75 + height/7)
    {
      if(starMapActive)
      {
        starMapActive = false;
      }
      else
      {
        println("StarMap");
        starMapActive = true;
      }
    }
  }
}

void loadData()
{
  Table table = loadTable("starmap.csv", "header");
  
  for(TableRow r : table.rows())
  {
     MapStar mapstar = new MapStar(r);
     mapstars.add(mapstar);
  }
  
  /*
  for(int i = 0; i < mapstars.size() ; i++)
  {
    MapStar s = mapstars.get(i);
    println(s.displayName);
  }
  */
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

void starMapGrid()
{
  
  float size = height/2;
  float posX = width/2;
  float posY = height * 0.1;
  
  stroke(0, 110, 255);
  fill(0, 110, 255);
  strokeWeight(1);
  int counter = -5;
  textAlign(CENTER, CENTER);
  
  for(int i = 0; i < 11; i++)
  {
    textAlign(CENTER);
    text(counter, (posX + ((size/10)*i)) - (size/2), posY - height/100);
    line((posX + ((size/10)*i)) - (size/2) , posY, (posX + ((size/10)*i)) - (size/2), posY + size);
    
    textAlign(RIGHT, CENTER);
    text(counter, posX - (size/2) - height/100, posY + ((size/10)*i));
    line(posX - (size/2), posY + ((size/10)*i), (posX + size) - (size/2), posY + ((size/10)*i));
    counter++;
  }
}

void drawMapStars()
{
  stroke(255, 255, 0);
  float border = width * 0.1f;
  
  for(MapStar s:mapstars)
  {
    float x = map(s.xg, -5, 5, border, width - border);
    float y = map(s.yg, -5, 5, border, width - border);
    stroke(255, 255, 0);
    line(x, y - 2, x, y + 2);
    line(x -2 , y, x + 2, y);
   
    noFill();
    stroke(255, 0, 0);
    ellipse(x, y, s.mag, s.mag);
    
    fill(255);
    text(s.displayName, x, y - 10);
  }
}