

//Here's some code to demonstrate the use of DYNAMIC ARRAYS to
//add and remove OBJECTS from a program.

//The objects in this case are BALLOONS (faces!) that live for a little while
//and are then extinguished. 

//This time a dynamic list is used to continuously create new balloons on mouseclick. They die after a while and are removed from memory.

//A global variable is used to record the number of balloons that have
//lived so far.

//also demonstrated: IF statements, pushMatrix/popMatrix techniques, PImage and font embedding
///////////////////////////////////////////////////////////////////////////////////////////////////////////
//TRISTAN MILLER 2014
///////////////////////////////////////////////////////////////////////////////////////////////////////////


int balloonNumber;
int balloonLifetime = 240; //how many frames should a balloon last for?

boolean radianMode = false;
boolean invertMode = false;
boolean HSBMode = false;
ArrayList balloonList;   //must declare this at the beginning! Once created, this will store the many balloons we'll create.

int balloonLimit = 40;   //how many balloons should be allowed to exist simultaneously? Usually a good idea to set something up like this.


PFont font;


void setup() {
  size(1920, 1080);

  balloonNumber = 0;

  balloonList = new ArrayList();  //create the balloonList (an ArrayList object)

  background(200);


  font = loadFont("Amstrad-CPC464-32.vlw");
  textFont(font, 48);
}



void draw() {
  blendMode(BLEND);
  //background(0);    //UNCOMMENT THIS to get rid of the trails

  if (radianMode == false) {
    for (int i = 0; i < balloonList.size(); i++) {
      NumberedBalloon thisBalloon = (NumberedBalloon) balloonList.get(i);
      thisBalloon.rotationSpeed = radians(balloonNumber);
    }
  } 
  else {
    for (int i = 0; i < balloonList.size(); i++) {
      NumberedBalloon thisBalloon = (NumberedBalloon) balloonList.get(i);
      thisBalloon.rotationSpeed = balloonNumber;
    }
  }

  if (invertMode == false) {
    for (int i = 0; i < balloonList.size(); i++) {
      NumberedBalloon thisBalloon = (NumberedBalloon) balloonList.get(i);
      thisBalloon.shadowColour = color(0, 0, 0);
      thisBalloon.shadowAlpha = thisBalloon.balloonAlpha;
      blendMode(BLEND);
    }
  } 
  else {
    for (int i = 0; i < balloonList.size(); i++) {
      NumberedBalloon thisBalloon = (NumberedBalloon) balloonList.get(i);
      thisBalloon.shadowColour = color(255, 255, 255);
      thisBalloon.shadowAlpha = 0;
      blendMode(SCREEN);
    }
  }

  if (balloonList.size() != 0) { //if there are any balloons in balloonList, do the following:
    for (int i = 0; i < balloonList.size(); i++) { //for each balloon in balloonList,
      NumberedBalloon balloon = (NumberedBalloon) balloonList.get(i);  //get the balloon (here we have to be specific and mention that it's a NumberedBalloon object),

      balloon.update(); //update position and rotation of this balloon

      if (balloon.balloonTimer >= balloonLifetime) { //fade this balloon if it's lived too long
        balloon.fade();
      }

      balloon.display(); //display this balloon on screen

      if (balloon.balloonAlpha <= 0) { //remove this balloon from the list if it's faded completely
        balloonList.remove(i);
      }
    }
  }
}

void mouseClicked() {          //do this stuff when the mouse is clicked

    if (balloonList.size() < balloonLimit) {  //if there aren't already too many balloons around...
    NumberedBalloon newBalloon = new NumberedBalloon(mouseX, mouseY, random(-3, 3), random(-3, 3), color(random(0, 255), random(0, 255), random(0, 255)));  //declare and create a new balloon, with random properties
    balloonList.add(newBalloon); //add this balloon to the list before it disappears
    balloonNumber ++;   //increase the global balloon number, so that the next one has a higher number
  }

  //alternatively, use a FOR LOOP to generate 5 balloons at once on each click...uncomment the following (and comment the above) to test

  /*
    for(int i = 0; i < 5; i++){
   if(balloonList.size() < balloonLimit){
   NumberedBalloon newBalloon = new NumberedBalloon(mouseX, mouseY, random(-3,3), random(-3,3), color(random(0,255),random(0,255),random(0,255)));  //declare and create a new balloon, with random properties
   balloonList.add(newBalloon); //add this balloon to the list before it disappears
   }
   } 
   */
} 


boolean sketchFullScreen() {  //plop these lines at the end of your code to engage presentation mode (thanks S.H.)
  return true;
} 

void keyPressed() {
  if (keyCode == 82) {
    if (radianMode == false) {
      radianMode = true;
    } 
    else {
      radianMode = false;
    }
  }

  if (keyCode == 73) {
    if (invertMode == false) {
      invertMode = true;
      background(0);
    } 
    else {
      invertMode = false;
      background(200);
    }
  }

  if (keyCode == 68 && balloonList.size() < 3*balloonLimit) {
    detonate();
  }

  if (keyCode == 67) {
    if (HSBMode == false) {
      HSBMode = true;
      colorMode(HSB);
    } 
    else {
      HSBMode = false;
      colorMode(RGB);
    }
  }
}

void detonate() {
  int lenny = balloonList.size();
  for (int i = 0; i < lenny; i++) {
    NumberedBalloon thisBalloon = (NumberedBalloon) balloonList.get(i);
    if (thisBalloon.fragment == false) {

      NumberedBalloon redBalloon = new NumberedBalloon(thisBalloon.posiX, thisBalloon.posiY, random(-3, 3), random(-3, 3), color(red(thisBalloon.balloonColour), 0, 0));

      NumberedBalloon greenBalloon = new NumberedBalloon(thisBalloon.posiX, thisBalloon.posiY, random(-3, 3), random(-3, 3), color(0, green(thisBalloon.balloonColour), 0));
      NumberedBalloon blueBalloon = new NumberedBalloon(thisBalloon.posiX, thisBalloon.posiY, random(-3, 3), random(-3, 3), color(0, 0, blue(thisBalloon.balloonColour)));


      redBalloon.veloX = redBalloon.veloX + thisBalloon.veloX;
      redBalloon.veloY = redBalloon.veloY + thisBalloon.veloY;
      redBalloon.balloonTimer = thisBalloon.balloonTimer;
      redBalloon.balloonAlpha = thisBalloon.balloonAlpha;
      redBalloon.serialNumber = thisBalloon.serialNumber;
      redBalloon.fragment = true;

      greenBalloon.veloX = greenBalloon.veloX + thisBalloon.veloX;
      greenBalloon.veloY = greenBalloon.veloY + thisBalloon.veloY;
      greenBalloon.balloonTimer = thisBalloon.balloonTimer;
      greenBalloon.balloonAlpha = thisBalloon.balloonAlpha;
      greenBalloon.serialNumber = thisBalloon.serialNumber;
      greenBalloon.fragment = true;

      blueBalloon.veloX = redBalloon.veloX + thisBalloon.veloX;
      blueBalloon.veloY = redBalloon.veloY + thisBalloon.veloY;
      blueBalloon.balloonTimer = thisBalloon.balloonTimer;
      blueBalloon.balloonAlpha = thisBalloon.balloonAlpha;
      blueBalloon.serialNumber = thisBalloon.serialNumber;
      blueBalloon.fragment = true;

      balloonList.add(redBalloon);
      balloonList.add(greenBalloon);
      balloonList.add(blueBalloon);

      thisBalloon.balloonAlpha = 0;
      thisBalloon.balloonTimer = balloonLifetime;
    }
  }
}

