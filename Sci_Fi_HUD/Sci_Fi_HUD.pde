void setup()
{
  size (800, 800, P2D); 
  //fullScreen();
  loadData();
  warpDrive = false;
  speed = 0;
  speedUp = false;
  starMapActive = false;
  warpAccelration = 5;
  click1 = false;
  click2 = false;
  laserOn = false;
  aimX = width/2;
  aimY = height/2;
  laserPower = 2;

  // adds stars
  for (int i = 0; i < 10000; i++)
  {
    stars.add(new Star());
  }
  
  radar1 = new Radar(width/9, height * 0.85, height * 0.08, 0.5, color(0, 110, 255));
  aim = new Spinny(width/2, height/2, 2);
}

// delcaring variables
ArrayList<Star> stars = new ArrayList<Star>();
ArrayList<MapStar> mapstars = new ArrayList<MapStar>();
PVector mouseV, starV, clickedStar1, clickedStar2;
float cstar1x, cstar1y, cstar2x, cstar2y;
boolean click1, click2;
float speed;
boolean warpDrive;
boolean speedUp;
float warpAccelration;
boolean starMapActive;
boolean laserOn;
float aimX, aimY;
float laserPower;

Radar radar1;
Spinny aim;


void draw()
{
  background(0);
  if(laserOn)
  {
    drawAim(aimX, aimY);
  }

  warpDrive();

  pushMatrix();
  translate(width/2, height/2);
  for (int i = 0; i < stars.size(); i++)
  {
    Star s = stars.get(i);
    s.update(speed);
    s.render();
  }
  popMatrix();

  if (starMapActive)
  {
    starMapGrid();
    drawMapStars();
    if (click1 == true && click2 == true)
    {
      textAlign(CENTER);
      stroke(0, 255, 255);
      line(cstar1x, cstar1y, cstar2x, cstar2y);
      text("Star Distance: " + clickedStar1.dist(clickedStar2) + " parsecs", width/2, height* 0.65);
    }
  }

  board();

  warpButton();

  radar1.render();
  radar1.update();

  starMapButton();
  laserButton();
  laserToggle();

  //aimBullEye();
}

void mousePressed()
{
  // checks if mouse clicked on the warp button
  if (mouseX < (width * 0.22) + height/7 && mouseX >  width * 0.22)
  {
    if (mouseY > height * 0.9 && mouseY < height * 0.9 + height/20)
    {
      warpDrive = true;
      speedUp = true;
      starMapActive = false;
    }
  }

  // checks if mouse clicked on the star map button
  if (mouseX > width * 0.22 && mouseX < (width * 0.22) + height/7)
  {
    if (mouseY > height * 0.75 && mouseY < height * 0.75 + height/7)
    {
      if (starMapActive)
      {
        starMapActive = false;
      } else
      {
        println("StarMap");
        starMapActive = true;
        laserOn = false;
      }
    }
  }

  //if star map is up, it will check if it clicked on which stars
  if (starMapActive)
  {
    float size = height/1.75;
    float posX = width/2;
    float posY = height * 0.05;

    if (click1 == true && click2 == true)
    {
      click1 = false;
      click2 = false;
    }

    mouseV = new PVector(mouseX, mouseY);

    for (MapStar s : mapstars)
    {
      float realStarX = map(s.xg, -5, 5, posX - (size/2), posX + (size/2));
      float realStarY = map(s.yg, -5, 5, posY, posY + size);

      starV = new PVector(realStarX, realStarY);

      float dist = mouseV.dist(starV);

      if (dist <= s.mag)
      {
        if (click1 == false)
        {
          clickedStar1 = new PVector(s.xg, s.yg, s.zg);
          cstar1x = realStarX;
          cstar1y = realStarY;
          click1 = true;
        } else
        {
          clickedStar2 = new PVector(s.xg, s.yg, s.zg);
          cstar2x = realStarX;
          cstar2y = realStarY;
          click2 = true;
        }
      }
    }
  }

  if (mouseX > width * 0.45 - ((height/7) /2) && mouseX < (width * 0.45) + ((height/7) /2))
  {
    if (mouseY > height * 0.85 -((height/7) /2) && mouseY < height * 0.85 + ((height/7) /2))
    {
      if (laserOn)
      {
        aimX = width/2;
        aimY = height/2;
        laserOn = false;
      } else {
        laserOn = true;
        starMapActive = false;
      }
    }
  }
}

void mouseDragged()
{
  float buttonX = width * 0.6;
  float buttonY = height * 0.75;
  float buttonW = height/100;
  float buttonH = height/5;
  //rect(buttonX + buttonW/2, map(laserPower, 0,10, buttonY + buttonH, buttonY) , height/20, height/50);
  
  if(mouseX > (buttonX + buttonW/2) - (height/20)/2 && mouseX < (buttonX + buttonW/2) + (height/20)/2 )
  {
    if(mouseY > map(laserPower, 0,10, buttonY + buttonH, buttonY) - (height/50)/2 && mouseY < map(laserPower, 0,10, buttonY + buttonH, buttonY) + (height/50)/2)
    {
        laserPower = map(mouseY, buttonY, buttonY + buttonH, 10, 0);
        
        if(laserPower < 0)
        {
          laserPower = 0;
        }
        if(laserPower > 10)
        {
          laserPower = 10;
        }
        println(laserPower);
      
    }
  }
}

void loadData()
{
  Table table = loadTable("starmap.csv", "header");

  for (TableRow r : table.rows())
  {
    MapStar mapstar = new MapStar(r);
    mapstars.add(mapstar);
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
  rect(buttonX, buttonY, buttonW, buttonH);
  fill(0);
  textAlign(CENTER);
  textSize(height/30);
  text("WARP", buttonX + (buttonW/2), buttonY + ((buttonH/3) *2 ));
}

void warpDrive()
{
  if (warpDrive)
  {
    println(speed);
    println("warpDrive: " + warpDrive);
    println("speedUp: " + speedUp);
    if (speedUp)
    {
      speed +=  warpAccelration;
      background(0, 0, speed);
      println(speed);
      if (speed > 200)
      {
        speedUp = false; 
        println("speedUp: " + speedUp);
      }
    } else
    {
      println("speedUp: " + speedUp);
      speed -= warpAccelration;
      background(0, 0, speed);
    }

    if (speed == 0)
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
  for (int i = 0; i < 11; i++)
  {
    line(posX + ((size/10)*i), posY, posX + ((size/10)*i), posY + size);
    line(posX, posY + ((size/10)*i), posX + size, posY + ((size/10)*i));
  }
}

void starMapGrid()
{

  float size = height/1.75;
  float posX = width/2;
  float posY = height * 0.05;

  stroke(0, 110, 255);
  fill(0, 110, 255);
  strokeWeight(1);
  int counter = -5;
  textAlign(CENTER, CENTER);
  textSize(height/50);
  for (int i = 0; i < 11; i++)
  {
    textAlign(CENTER);
    text(counter, (posX + ((size/10)*i)) - (size/2), posY - height/100);
    line((posX + ((size/10)*i)) - (size/2), posY, (posX + ((size/10)*i)) - (size/2), posY + size);

    textAlign(RIGHT, CENTER);
    text(counter, posX - (size/2) - height/100, posY + ((size/10)*i));
    line(posX - (size/2), posY + ((size/10)*i), (posX + size) - (size/2), posY + ((size/10)*i));
    counter++;
  }
}

void drawMapStars()
{
  stroke(255, 255, 0);
  float size = height/1.75;
  float posX = width/2;
  float posY = height * 0.05;

  for (MapStar s : mapstars)
  {
    float x = map(s.xg, -5, 5, posX - (size/2), posX + (size/2));
    float y = map(s.yg, -5, 5, posY, posY + size);
    stroke(255, 255, 0);
    line(x, y - 2, x, y + 2);
    line(x -2, y, x + 2, y);

    noFill();
    stroke(255, 0, 0);
    ellipse(x, y, s.mag, s.mag);

    fill(255);
    textSize(height/70);
    text(s.displayName, x, y - 10);
  }
}

void laserButton()
{
  float size = height/7;
  float posX = width * 0.45;
  float posY = height * 0.85;
  fill(0, 110, 255);
  ellipse(posX, posY, size, size);
  fill(0);
  textAlign(CENTER, CENTER);
  text("LASER", posX, posY);
}

void drawAim(float x, float y)
{
  strokeWeight(5);
  line(x, y - 10, x, y - 45);
  line(x + 10, y, x + 45, y);
  line(x, y + 10, x, y + 45);
  line(x - 10, y, x - 45, y);
  
  aim.update(x, y);
  aim.render();
  
  if(keyPressed)
  {
     switch(keyCode)
     {
       case UP: aimY -= width/100; break;
       case DOWN: aimY += width/100; break;
       case LEFT: aimX -=  width/100; break;
       case RIGHT: aimX += width/100; break;
     }
    if(key == ' ')
    {
      shootLaser();
    }
  }
  
}

void shootLaser()
{
  strokeWeight(laserPower);
  stroke(255, 0, map(laserPower, 0, 10, 0, 255));
  line(0, height, aimX, aimY);
  line(width, height, aimX, aimY);
}

void laserToggle()
{
  float buttonX = width * 0.6;
  float buttonY = height * 0.75;
  float buttonW = height/100;
  float buttonH = height/5;
  
  rect(buttonX, buttonY, buttonW, buttonH);
  
  float gaps = buttonH/10;
  textSize(height/50);
  textAlign(RIGHT);
  for(int i = 0; i <= 10; i++)
  {
   text(i + "-", buttonX - (width/50), (buttonY + buttonH)  - (gaps * i)); 
  }
  
  rectMode(CENTER);
  fill(0, 110, 225);
  rect(buttonX + buttonW/2, map(laserPower, 0,10, buttonY + buttonH, buttonY) , height/20, height/50);
}