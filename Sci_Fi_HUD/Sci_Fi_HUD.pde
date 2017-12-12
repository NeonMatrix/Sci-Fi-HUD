/*
  Povilas Kubilius  
  DT228/2 OOP
  My sci fi HUD
*/
import ddf.minim.*;
AudioPlayer spaceshipSounds, laserShot, laserBurn, warpDriveSound;
Minim minim;

void setup()
{
  //size (900, 900, P2D); 
  fullScreen(P3D);
  loadData();
  warpDrive = false;
  speed = 0;
  speedUp = false;
  starMapActive = false;
  warpAccelration = 7;
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

  // adding background stars
  for (int i = 0; i < 10000; i++)
  {
    stars.add(new Star());
  }
  
  // this is actually is MapStar object which holds the star info of the current star we are on, 
  // which is randomly assigned when you start, and changes when you wrap to a new star
  currentStar = mapstars.get((int)random(0, mapstars.size()));
  
  //initializing radar
  radar1 = new Radar(width/9, height * 0.85, height * 0.08, 0.5, color(0, 110, 255));
  
  // initializing the aim thing with the spinny thing
  aim = new Spinny(width/2, height/2, 2);
  
  //initializing the sound effects
  minim = new Minim(this);
  spaceshipSounds = minim.loadFile("spaceshipsounds.mp3");
  laserShot = minim.loadFile("lasershot.mp3");
  laserBurn = minim.loadFile("laserburn.mp3");
  warpDriveSound = minim.loadFile("warpdrive.mp3");
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

  // updating the stars in the background
  pushMatrix();
  translate(width/2, height/2);
  for (int i = 0; i < stars.size(); i++)
  {
    Star s = stars.get(i);
    s.update(speed);
    s.render();
  }
  popMatrix();
  
  // draw the aim if the laser is on
  if(laserOn)
  {
    drawAim(mouseX, mouseY);
  }
  
  // shoot lasers when shooting laser is on
  if(shootingLaser)
  {
    if(laserCharge > laserPower)
      {
        shootLaser(mouseX, mouseY);
      }
  }

  // draw the star map when the star button is pressed
  if (starMapActive)
  {
    // draw the star grid
    starMapGrid();
    // if the two stars have been clicked 
    if (click1 == true && click2 == true)
    {
      textAlign(CENTER);
      stroke(0, 255, 255);
      //draw the connecting line between the stars
      line(cstar1x, cstar1y, cstar2x, cstar2y);
      // display the display the disatnce between the stars below the star map
      text("Star Distance: " + clickedStar1.dist(clickedStar2) + " parsecs", width/2, height* 0.65);
    }
  }

  // draw the blue background of the space ship
  board();

  // draw the buttons, radars and toggles
  warpButton();

  radar1.render();
  radar1.update();

  starMapButton();
  laserButton();
  laserToggle();
  chargeMetre();
  shieldMetre(); 
  drawCurrentStar();
  
  // recharge the laser charge battry
  if(laserCharge <= 100)
  {
    laserCharge++;
  }
  
  
}

// checks which buttons have been pressed
void mousePressed()
{
  // checks if mouse clicked on the warp button
  if (mouseX < (width * 0.22) + height/7 && mouseX >  width * 0.22)
  {
    if (mouseY > height * 0.9 && mouseY < height * 0.9 + height/20)
    {
      // check if a star has been selected, since you need to warp to that star
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
      //check if the star map is already turned on, if it is, turn it off
      if (starMapActive)
      {
        starMapActive = false;
        shootingLaser = false;
      } else // turn on the star map
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

    // if two stars already selected, turn off the selected stars
    if (click1 == true && click2 == true)
    {
      click1 = false;
      click2 = false;
    }

    mouseV = new PVector(mouseX, mouseY);

    // itterate throught the stars and check which star has been clicked
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
  
  // if the laser is o, shoot the laser
  if(laserOn)
  {
    shootingLaser = true;
    // only shoot laser if there is laser charge left
    if(laserCharge > laserPower)
      {
        laserShot.rewind();
        laserShot.play();
        // shoot laser where the mouse is at
        shootLaser(mouseX, mouseY);
      }
  }
  
  // check if the laser botton is clicked
  if (mouseX > width * 0.45 - ((height/7) /2) && mouseX < (width * 0.45) + ((height/7) /2))
  {
    if (mouseY > height * 0.85 -((height/7) /2) && mouseY < height * 0.85 + ((height/7) /2))
    {
      // if laser is on already, turn it off
      if (laserOn)
      {
        laserOn = false;
        shootingLaser = false;
        laserBurn.pause();
      } else { // else turn is off then turn it on
      
        shootingLaser = false;
        starMapActive = false;
        laserOn = true;
      }
    }
  }
}

void mouseReleased()
{
  // if mouse is released, stop shooting laser
  if(shootingLaser)
  {
    shootingLaser = false;
    laserBurn.pause();
    laserBurn.rewind();
  }
}

void mouseDragged()
{
  float buttonX = width * 0.6;
  float buttonY = height * 0.75;
  float buttonW = height/100;
  float buttonH = height/5;
  
  // check if the mouse is on the laser charge toggle
  if(mouseX > (buttonX + buttonW/2) - (height/20)/2 && mouseX < (buttonX + buttonW/2) + (height/20)/2 )
  {
    if(mouseY > map(laserPower, 0,10, buttonY + buttonH, buttonY) - (height/50)/2 && mouseY < map(laserPower, 0,10, buttonY + buttonH, buttonY) + (height/50)/2)
    {
        // change the laserPower when you drag the laser power toggle
        laserPower = map(mouseY, buttonY, buttonY + buttonH, 10, 0);
        
        // this limits the toggle, so you won't push the toggle too much top or button
        if(laserPower < 0)
        {
          laserPower = 0;
        }
        if(laserPower > 10)
        {
          laserPower = 10;
        }
        shootingLaser = false;
        laserBurn.pause();     
    }
  }
}

//load star data from the .csv file
void loadData()
{
  // make the table
  Table table = loadTable("starmap.csv", "header");

  // itterate through the rows, and add them into an array list of MapStars
  for (TableRow r : table.rows())
  {
    MapStar mapstar = new MapStar(r);
    mapstars.add(mapstar);
  }
}

// draw drawing the blue background of the dash board
void board()
{
  rectMode(CORNER);
  strokeWeight(5);
  stroke(0, 110, 255);
  fill(0, 110, 255, 100);
  rect(0, height * 0.7, width, height * 0.3);
}

// drawing the warp button on the dash board
void warpButton()
{
  float buttonX = width * 0.22;
  float buttonY = height * 0.9;
  float buttonW = height/7;
  float buttonH = height/20;
  
  // color the button blue, by default
  fill(0, 110, 255);

  //if a star has been selected from the star map, the colour the warp button green.
  if(starSelect)
  {
    fill(0, 255, 0);
  }

  // drawing the actual button
  noStroke();
  rect(buttonX, buttonY, buttonW, buttonH);
  fill(0);
  textAlign(CENTER);
  textSize(height/30);
  text("WARP", buttonX + (buttonW/2), buttonY + ((buttonH/3) *2 ));
}

// The animations and maths for the warp drive
void warpDrive()
{
  // if warp
  if (warpDrive)
  {
    warpDriveSound.play();
    println(speed);
    starSelect = false;
    
    // this speeds the animtion for the star warp
    if (speedUp)
    {
      // increases the speed at which the stars move towards the screen
      speed +=  warpAccelration;
      // this turns the background blue the faster the warp is
      background(0, 0, speed);
      println(speed);
      // this also makes the shield metre flicker while warping
      shieldCharge = random(50, 100);
      // when maxium speeed is reached, speed stops and stars declearting
      if (speed > 200)
      {
        speedUp = false; 
      }
      
    } else
    // this where the star speed stars to decelarte
    {
      speed -= warpAccelration;
      background(0, 0, speed);
      shieldCharge = random(50, 100);
    }

    // once the speed is 0, turn off the warp drive
    if (speed == 0)
    {
      println(speed);
      warpDrive = false;
      println("warpDrive: " + warpDrive);
      shieldCharge = 100;
      // when you warp to a new star, the currentStar gets updated to be star we selected on the star map
      currentStar = selectedStar;
      click1 = false;
      warpDriveSound.pause();
      warpDriveSound.rewind();
    }
  }
}

// draw the star map button
void starMapButton()
{
  float size = height/7;
  float posX = width * 0.22;
  float posY = height * 0.75;

  strokeWeight(1);
  // drawing the lines of the grid in the star map button
  for (int i = 0; i < 11; i++)
  {
    line(posX + ((size/10)*i), posY, posX + ((size/10)*i), posY + size);
    line(posX, posY + ((size/10)*i), posX + size, posY + ((size/10)*i));
  }
}

// drawing the star map
void starMapGrid()
{

  float size = height/1.75;
  float posX = width/2;
  float posY = height * 0.05;
  
  // the whole push matrix and translates are from my attemp to make the star map pop up
  pushMatrix();
  // the translate makes all the future co ordinate from posX and posY as 0, 0
  translate(posX, posY);
  scale(1);
  // this makes the semi transparent blue background of the star map
  noStroke();
  rectMode(CENTER);
  fill(0, 110, 255, 100);
  rect(0,0 + size/2, size, size);
  
  // set up to draw the grid lines
  fill(0, 110, 255);
  stroke(0, 110, 255);
  strokeWeight(1);
  int counter = -5;
  textAlign(CENTER, CENTER);
  textSize(height/50);
  
  // drawing the grid lines of the star map
  for (int i = 0; i < 11; i++)
  {
    // the vertical lines
    textAlign(CENTER);
    text(counter, (((size/10)*i)) - (size/2), 0 - height/100);
    line((((size/10)*i)) - (size/2), 0, (((size/10)*i)) - (size/2),size);

    // the horizontal lines
    textAlign(RIGHT, CENTER);
    text(counter, 0 - (size/2) - height/100,((size/10)*i));
    line(0 - (size/2), ((size/10)*i), (size) - (size/2),((size/10)*i));
    // the counter is the numbers that are gonna be writing on the side of the map, to represent the parsects 
    counter++;
  }
  
  // draws the actual the stars on the from, from the map stars array list
  stroke(255, 255, 0);
  for (MapStar s : mapstars)
  {
    // sets the x and y cooridnates by maping the parsects from the file, to the screen size
    float x = map(s.xg, -5, 5, 0 - (size/2), (size/2));
    float y = map(s.yg, -5, 5, 0, size);
    
    // drawing the cross hairs to mark where the star is on the map
    stroke(255, 255, 0);
    line(x, y - 2, x, y + 2);
    line(x -2, y, x + 2, y);

    // drawing the circle around the cross hair, and diffrent size depending of the star magnitude
    noFill();
    stroke(255, 0, 0);
    ellipse(x, y, s.mag, s.mag);

    // then write the star name where the star is located
    fill(255);
    textSize(height/70);
    text(s.displayName, x, y - 10);
  }
  
  popMatrix();
}

// drawing the laser circular button
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

// drawing the aim thing when laser is on
void drawAim(float x, float y)
{
  strokeWeight(5);
  stroke(0, 110, 255);
  // drawing the 4 lines in the aim thingy
  line(x, y - 10, x, y - 45);
  line(x + 10, y, x + 45, y);
  line(x, y + 10, x, y + 45);
  line(x - 10, y, x - 45, y);
  // this draws the two spinny circles in the aim thingy
  aim.update(x, y);
  aim.render();  
}

// this draws the laser when the laser is shot
void shootLaser(float aimX, float aimY)
{
  strokeWeight(laserPower);
  stroke(225, 0, 0);
  // drawing the laser beams from the bottom corner to where the mouse is located
  line(0, height, aimX, aimY);
  line(width, height, aimX, aimY);
  
  //discharge the laser chrage after shot
  laserCharge -= laserPower; 
  
  // play the laser sound effect
  laserBurn.play();
  
  // rewind the laser sound effect every second, to have a contintues laser burn sound effect
  if(frameCount % 60 == 0)
  {
    laserBurn.rewind(); 
  }
}

// draw the laser power toggle button 
void laserToggle()
{
  float buttonX = width * 0.6;
  float buttonY = height * 0.75;
  float buttonW = height/100;
  float buttonH = height/5;
  
  // draw the middle bar where the botton will be sliding
  rect(buttonX, buttonY, buttonW, buttonH);
  
  // draw the numbers labels to let you know what's the laser power
  float gaps = buttonH/10;
  textSize(height/50);
  textAlign(RIGHT);
  for(int i = 0; i <= 10; i++)
  {
   text(i + "-", buttonX - (width/50), (buttonY + buttonH)  - (gaps * i)); 
  }
  
  // draw the blue slider on the toggle, but the Y axis is mapped based of the laser power
  rectMode(CENTER);
  fill(0, 110, 225);
  rect(buttonX + buttonW/2, map(laserPower, 0,10, buttonY + buttonH, buttonY) , height/20, height/50);
  
  // drawing the label of this slider under it
  textAlign(CENTER);
  fill(0, 255, 255);
  text("Laser Power", buttonX + buttonW/2, (buttonY + buttonH) + height/40); 
}

// draw the laser charge meter
void chargeMetre()
{
  float buttonX = width * 0.7;
  float buttonY = height * 0.75;
  float buttonW = height/12;
  float buttonH = height/5;
  
  // draw the yellow rectangle to be the charge bar
  rectMode(CORNER);
  fill(255, 255, 0);
  rect(buttonX, buttonY, buttonW, buttonH);
  
  // draw a black bar, which is drawn down the less laser chrage there is
  fill(0);
  noStroke();
  rect(buttonX, buttonY, buttonW, map(laserCharge, 100, 0, 0, buttonH) );
  
  // just draws the numbers on the side showing how much laser chrage there is left
  float gaps = buttonH/10;
  textSize(height/50);
  textAlign(RIGHT);
  for(int i = 0; i <= 10; i++)
  {
   text(i * 10 + "-", buttonX - (width/100), (buttonY + buttonH)  - (gaps * i)); 
  }
  
  // label under the charge metre
  textAlign(CENTER);
  fill(0, 255, 255);
  text("Charge", buttonX + buttonW/2, (buttonY + buttonH) + height/40);
}

//this draws the shield meter
void shieldMetre() 
{
  float buttonX = width * 0.87;
  float buttonY = height * 0.75;
  float buttonW = height/12;
  float buttonH = height/5;
  
  // draw the green rectangle to be the shield bar
  rectMode(CORNER);
  fill(0, 255, 0);
  rect(buttonX, buttonY, buttonW, buttonH);
  
  // draw a black bar, which is drawn down the less shield charge there is
  fill(0);
  noStroke();
  rect(buttonX, buttonY, buttonW, map(shieldCharge, 100, 0, 0, buttonH) );
  
  // just draws the numbers on the side showing how much shield charge there is left
  float gaps = buttonH/10;
  textSize(height/50);
  textAlign(RIGHT);
  for(int i = 0; i <= 10; i++)
  {
   text(i * 10 + "-", buttonX - (width/100), (buttonY + buttonH)  - (gaps * i)); 
  }
  
  // label under the shield metre
  textAlign(CENTER);
  fill(0, 255, 255);
  text("Shield", buttonX + buttonW/2, (buttonY + buttonH) + height/40);
}

// draws the triangle and star name in the top left corner
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
  // so this draws the rotating circle in the top left corner of the screen 
  rotate(triangleTheta); 
  line(0, -(triHeight/3)*2, -size/2, triHeight/3);  
  line(-size/2, triHeight/3, size/2, triHeight/3); 
  line(size/2, triHeight/3, 0, -(triHeight/3)*2);
  popMatrix();
 
  // this draws the little underline beneath the star name in the corner... yes it's probablt the messiest uninteligble code co ordiantes for some lines
  line(x + triHeight + width/200, y + triHeight/2, (x + triHeight + width/200) + height/200 , (y + triHeight/2) - height/50); 
  line((x + triHeight + width/200) + height/200, 
      ( y + triHeight/2) - height/50, 
      ((x + triHeight + width/200) + height/200) + height/7 , 
      (y + triHeight/2) - height/50);
  
  // draw the star name we are on
  textAlign(LEFT);
  textSize(height/40);
  text(currentStar.displayName,(x + triHeight + width/200) + height/200, height * 0.075);
   
}