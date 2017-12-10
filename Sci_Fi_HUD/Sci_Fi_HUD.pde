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
  laserCharge = 100;
  shieldCharge = 100;
  shootingLaser = false;
  triangleTheta = 0;
  starSelect = false;

  // adds stars
  for (int i = 0; i < 10000; i++)
  {
    stars.add(new Star());
  }
  
  currentStar = mapstars.get((int)random(0, mapstars.size()));
  radar1 = new Radar(width/9, height * 0.85, height * 0.08, 0.5, color(0, 110, 255));
  aim = new Spinny(width/2, height/2, 2);
  
  //println(mapstars.size());
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
float laserCharge;
float shieldCharge;
float triangleTheta;
boolean shootingLaser;
boolean starSelect;
Radar radar1;
Spinny aim;
MapStar currentStar, selectedStar;


void draw()
{
  background(0);

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
  
  if(laserOn)
  {
    drawAim(mouseX, mouseY);
  }
  
  if(shootingLaser)
  {
    if(laserCharge > laserPower)
      {
        shootLaser(mouseX, mouseY);
      }
  }

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
  chargeMetre();
  shieldMetre(); 
  drawCurrentStar();
  
  if(laserCharge <= 100)
  {
    laserCharge++;
  }
  
  
}

// checls which buttons have been pressed
void mousePressed()
{
  // checks if mouse clicked on the warp button
  if (mouseX < (width * 0.22) + height/7 && mouseX >  width * 0.22)
  {
    if (mouseY > height * 0.9 && mouseY < height * 0.9 + height/20)
    {
      if(starSelect)
      {
        warpDrive = true;
        speedUp = true;
        starMapActive = false;
        laserOn = false;
        shootingLaser = false;
      }
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
        shootingLaser = false;
      } else
      {
        println("StarMap");
        starMapActive = true;
        laserOn = false;
        shootingLaser = false;
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
          starSelect = true;
          selectedStar = s;
        } else
        {
          clickedStar2 = new PVector(s.xg, s.yg, s.zg);
          cstar2x = realStarX;
          cstar2y = realStarY;
          click2 = true;
          starSelect = false;
        }
      }
    }
  }
  
  if(laserOn)
  {
    shootingLaser = true;
    if(laserCharge > laserPower)
      {
        shootLaser(mouseX, mouseY);
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
        shootingLaser = false;
      } else {
        //delay(1000);
        //laserOn = true;
        shootingLaser = false;
        starMapActive = false;
        laserOn = true;
      }
    }
  }
}

void mouseReleased()
{
  if(shootingLaser)
  {
    shootingLaser = false;
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
        shootingLaser = false;
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
  if(starSelect)
  {
    fill(0, 255, 0);
  }
  noStroke();
  //rectMode(CENTER);
  rect(buttonX, buttonY, buttonW, buttonH);
  fill(0);
  textAlign(CENTER);
  textSize(height/30);
  text("WARP", buttonX + (buttonW/2), buttonY + ((buttonH/3) *2 ));
}

// The animations and maths for the warp drive
void warpDrive()
{
  if (warpDrive)
  {
    println(speed);
    println("warpDrive: " + warpDrive);
    println("speedUp: " + speedUp);
    starSelect = false;
    
    // this speeds the animtion for the star warp
    if (speedUp)
    {
      speed +=  warpAccelration;
      background(0, 0, speed);
      println(speed);
      shieldCharge = random(50, 100);
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
      shieldCharge = random(50, 100);
    }

    if (speed == 0)
    {
      println(speed);
      warpDrive = false;
      println("warpDrive: " + warpDrive);
      shieldCharge = 100;
      currentStar = selectedStar;
      click1 = false;
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
    //textAlign(CENTER);
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
  stroke(0, 110, 255);
  line(x, y - 10, x, y - 45);
  line(x + 10, y, x + 45, y);
  line(x, y + 10, x, y + 45);
  line(x - 10, y, x - 45, y);
  aim.update(x, y);
  aim.render();  
}

void shootLaser(float aimX, float aimY)
{
  strokeWeight(laserPower);
  //stroke(255, 0, map(laserPower, 0, 10, 0, 255));
  stroke(225, 0, 0);
  line(0, height, aimX, aimY);
  line(width, height, aimX, aimY);
  laserCharge -= laserPower;
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
  
  textAlign(CENTER);
  fill(0, 255, 255);
  text("Laser Toggle", buttonX + buttonW/2, (buttonY + buttonH) + height/40); 
}

void chargeMetre()
{
  float buttonX = width * 0.7;
  float buttonY = height * 0.75;
  float buttonW = height/12;
  float buttonH = height/5;
  
  rectMode(CORNER);
  fill(255, 255, 0);
  rect(buttonX, buttonY, buttonW, buttonH);
  
  fill(0);
  noStroke();
  rect(buttonX, buttonY, buttonW, map(laserCharge, 100, 0, 0, buttonH) );
  
  float gaps = buttonH/10;
  textSize(height/50);
  textAlign(RIGHT);
  for(int i = 0; i <= 10; i++)
  {
   text(i * 10 + "-", buttonX - (width/100), (buttonY + buttonH)  - (gaps * i)); 
  }
  
  textAlign(CENTER);
  fill(0, 255, 255);
  text("Charge", buttonX + buttonW/2, (buttonY + buttonH) + height/40);
}

void shieldMetre() 
{
  float buttonX = width * 0.87;
  float buttonY = height * 0.75;
  float buttonW = height/12;
  float buttonH = height/5;
  
  rectMode(CORNER);
  fill(0, 255, 0);
  rect(buttonX, buttonY, buttonW, buttonH);
  
  fill(0);
  noStroke();
  rect(buttonX, buttonY, buttonW, map(shieldCharge, 100, 0, 0, buttonH) );
  
  float gaps = buttonH/10;
  textSize(height/50);
  textAlign(RIGHT);
  for(int i = 0; i <= 10; i++)
  {
   text(i * 10 + "-", buttonX - (width/100), (buttonY + buttonH)  - (gaps * i)); 
  }
  
  textAlign(CENTER);
  fill(0, 255, 255);
  text("Charge", buttonX + buttonW/2, (buttonY + buttonH) + height/40);
}

void drawCurrentStar()
{
  float x = width * 0.075;
  float y = height * 0.075;
  float size = height/10;
  float speed = (PI / 60.0) * 1;
  float triHeight = (sqrt(3) * size)/2;
  triangleTheta += speed;
  stroke(0, 110, 255);
  strokeWeight(height/200);
  
  pushMatrix();
  translate(x, y);
  rotate(triangleTheta); 
  line(0, -(triHeight/3)*2, -size/2, triHeight/3);  
  line(-size/2, triHeight/3, size/2, triHeight/3); 
  line(size/2, triHeight/3, 0, -(triHeight/3)*2);
  popMatrix();
 
  line(x + triHeight + width/200, y + triHeight/2, (x + triHeight + width/200) + height/200 , (y + triHeight/2) - height/50); 
  line((x + triHeight + width/200) + height/200, (y + triHeight/2) - height/50, ((x + triHeight + width/200) + height/200) + height/7 , (y + triHeight/2) - width/50);
  
  textAlign(LEFT);
  textSize(height/40);
  text(currentStar.displayName,(x + triHeight + width/200) + height/200, height * 0.075);
   
}