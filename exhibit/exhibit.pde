int cols, rows;
int scale = 20; 
float rotation = 0;

boolean thirdPerson = false;
boolean freeLook = false;

int directionX = 1;
boolean rotateY = false;

float posX = 0, posZ = 0;
float degree = 40;
float thirdPersonRotationX  = 0;
float thirdPersonRotationY  = 0;

float eyeX = 0, eyeY = -1, eyeZ = 0, centerX = 0, centerY = 0, centerZ = -2, upX = 0, upY = 1, upZ = 0;

boolean rotate = false;
void setup() {
  size(800, 600, P3D);

  cols = width/scale;
  rows = height/scale;

    frustum(-float(width)/height, float(width)/height, 1, -1, 2, 20);
    camera(eyeX, eyeY, eyeZ, centerX, centerY, centerZ, upX, upY, upZ);
  
}

void draw() {
  background(0, 0, 0);
  rotation+=.1;
  
  if(thirdPerson){
    camera(eyeX, 1, eyeZ+1, centerX, centerY, centerZ, upX, upY, upZ);
    
    character();
  }else{
    camera(eyeX, .3, eyeZ, centerX, centerY, centerZ, upX, upY, upZ);
  }  
  
  if(freeLook){
     println("x: "+mouseX+" y: "+mouseY+" z: "+ eyeZ); 
     PVector newQ = calcQuaternion(radians(degree), mouseX/20, mouseY/20, eyeZ);
    println("quaternion w: "+degree+" x: "+newQ.x+" y: "+newQ.y+" z: "+newQ.z);

    //translate(newQ.x, newQ.y, posZ);
    rotateY(newQ.x);
    rotateX(newQ.y);
    
    //rotateZ(newQ.z*50);
   //camera(newQ.x, newQ.y, posZ, centerX, centerY, centerZ, upX, upY, upZ);
  
  }
  
  pushMatrix(); 
  translate(posX, eyeY, posZ); 
  rotateY(radians(degree));
  
   rotation+=.1;
   drawWorld();
   exhibits();
   
  popMatrix();


}

void drawWorld(){
  floors();  
  walls();  
}

//used for free look
PVector calcQuaternion(float w, float x, float y, float z){
   //float rads = w / 360 * (float)PI/2 * 2;
    //float rads = w;
    float rads = radians(w);
    
    float W = cos(rads/2);
    float X = x*sin(rads/2);
    float Y = y*sin(rads/2);
    float Z = z*sin(rads/2);
    float norme = sqrt(W*W + X*X + Y*Y + Z*Z);
    
    if (norme == 0.0){
      W = 1.0; 
      X = Y = Z = 0.0;
    }else{
      float recip = 1.0/norme;
    
      W *= recip;
      X *= recip;
      Y *= recip;
      Z *= recip;
    }
    
  return new PVector(X,Y,Z);
}

void character(){
    PShape ball = createShape(SPHERE, .5);
    textureMode(NORMAL); // you want this!
    PImage sun = loadImage("assets/sun.jpg");
    textureWrap(REPEAT);
    
    pushMatrix();
    beginShape(QUADS);
     translate(0, -1, -1.8);
     rotateY(thirdPersonRotationX);
     rotateX(thirdPersonRotationY);
     ball.setTexture(sun);
     ball.setStroke(false);
     shape(ball);
    popMatrix();
}

void mousePressed(){
     println("x: "+mouseX+" y: "+mouseY+" z: "+ eyeZ); 
     PVector newQ = calcQuaternion(radians(degree), mouseX/20, mouseY/20, eyeZ);
    println("quaternion w: "+degree+" x: "+newQ.x+" y: "+newQ.y+" z: "+newQ.z);

     camera(newQ.x, newQ.y, newQ.z, centerX, centerY, centerZ, upX, upY, upZ);
  
     println("x: "+mouseX+" y: "+mouseY+" z: "+ posZ); 

     if( (mouseX >= 340 && mouseX <= 450) && (posZ >= 1.4 && posZ <= 2.45)){
        directionX *= -1;
     }
  
}


void keyPressed() {
    switch(key){
    case 'f':
      freeLook = !freeLook;
    break;
    case 'w':
      if(posZ < 2.35){
        posZ += 0.2;
      thirdPersonRotationY += 3;}
      break;
    case 's':
      if(posZ > -5.35){
        posZ -= 0.2;
       thirdPersonRotationY -= 3;}
      break;
    case 'd':
      degree += 3;
      thirdPersonRotationX += 1.5;
      freeLook = false;
      break;
    case 'a':
      degree -= 3;
      thirdPersonRotationX += 1.5;
      freeLook = false;
      break;
    case 'q':
      if(posX < 4){
        posX += 0.2;
       thirdPersonRotationX += 3; }
      break;
    case 'e':
      if(posX > -4){
        posX -= 0.2;
        thirdPersonRotationX -= 3;}
      break;
    case ' ':
      thirdPerson = !thirdPerson;
      break;
  }
  println("\n");
  println("position = ("+posX+", "+eyeY+", "+posZ+")");
  println("rotation angle = "+degree);

  
  }

void stand(float posX, float posY, float posZ){
  textureMode(NORMAL); // you want this!
  PImage img = loadImage("assets/wood_floor.jpg");
  textureWrap(REPEAT);
    
  pushMatrix();
  translate(posX, posY, posZ);
  beginShape(QUADS);
  texture(img);
 

  //top stand wall
  vertex(-1, 4, 1, 0, 1);  
  vertex(-0.5, 4, 1, 1, 1);
  vertex(-0.5 , 4.8, 1, 1, 0);
  vertex(-1, 4.8, 1, 0, 0);
  
   //bottom stand wall
  vertex(-1, 4, .5, 0, 1);  
  vertex(-0.5, 4, .5, 1, 1);
  vertex(-0.5 , 4.8, .5, 1, 0);
  vertex(-1, 4.8, .5, 0, 0);
  
 //left stand wall
  vertex(-1, 4, 1, 0, 1);  
  vertex(-1, 4, 0.5, 1, 1);
  vertex(-1 , 4.8, 0.5, 1, 0);
  vertex(-1, 4.8, 1, 0, 0);
  
 //right stand wall
  vertex(-0.5, 4, 1, 0, 1);  
  vertex(-0.5, 4, 0.5, 1, 1);
  vertex(-0.5, 4.8, 0.5, 1, 0);
  vertex(-0.5, 4.8, 1, 0, 0);
  
 //lid
  vertex(-1, 4.8, 1, 0, 1);  
  vertex(-0.5, 4.8, 0.5, 1, 1);
  vertex(-1, 4.8, 0.5, 1, 0);
  vertex(-0.5, 4.8, 1, 0, 0);
  
  endShape();

  popMatrix();

}

void exhibits(){  
  PShape planet1 = createShape(SPHERE, .5);
  PShape planet2 = createShape(SPHERE, .5);
  PShape planet3 = createShape(SPHERE, .5);
  PShape planet4 = createShape(SPHERE, .5);
  
  textureMode(NORMAL); // you want this!
  PImage earth = loadImage("assets/earth.jpg");
  PImage venus = loadImage("assets/venus.jpg");
  PImage moon = loadImage("assets/moon.jpg");
  PImage jupiter = loadImage("assets/jupiter.jpg");
  textureWrap(REPEAT);
  
  planet1.setStroke(false);
  planet2.setStroke(false);
  planet3.setStroke(false);
  planet4.setStroke(false);
  
 planet1.setTexture(earth);
 planet2.setTexture(venus);
 planet3.setTexture(moon);
 planet4.setTexture(jupiter);

  pushMatrix();
    translate(-4.25, .3, -3.25);
    stand(0.75, -5.3, -.7);
    rotateX(radians(23.5));  //real earth angle rotation!
    rotateY(rotation);
    //rotateZ(rotation);
    shape(planet1);
  popMatrix();
  
  pushMatrix();
    translate(-4.25, .3, 3.25);
    stand(0.75, -5.3, -.7);
    rotateX(rotation);
    shape(planet2);
  popMatrix();
  
  pushMatrix();
    translate(4.25, .3, 3.25);
    stand(0.75, -5.3, -.7);
    rotateY(rotation);
    rotateZ(rotation);
    shape(planet3);
  popMatrix();
  
  pushMatrix();
    translate(4.25, .3, -3.25);
    stand(0.75, -5.3, -.7);
    rotateY(rotation * directionX);
    if(rotateY)
      rotateX(rotation);
    shape(planet4);
  popMatrix();

}

void walls() {
    textureMode(NORMAL); // you want this!
    PImage img = loadImage("assets/galaxy.jpeg");
    textureWrap(REPEAT);
    //fill(25,123,3);
    PShape topWall = createShape();
    topWall.beginShape();
      topWall.texture(img);
      topWall.vertex(-5, -1, 5, 0, 1);
      topWall.vertex(5, -1, 5, 1, 1);
      topWall.vertex(5, 5, 5, 1, 0);
      topWall.vertex(-5, 5, 5, 0, 0);
    topWall.endShape();
    
    PShape bottomWall = createShape();
    bottomWall.beginShape();
      bottomWall.texture(img);
      bottomWall.vertex(-5, -1, -5, 0, 1);
      bottomWall.vertex(5, -1, -5, 1, 1);
      bottomWall.vertex(5, 5, -5, 1, 0);
      bottomWall.vertex(-5, 5, -5, 0, 0);
    bottomWall.endShape();
    
  PShape leftWall = createShape();
    leftWall.beginShape();
      leftWall.texture(img);
      leftWall.vertex(-5, -1, -5, 0, 1);
      leftWall.vertex(-5, -1, 5, 1, 1);
      leftWall.vertex(-5, 5, 5, 1, 0);
      leftWall.vertex(-5, 5, -5, 0, 0);
    leftWall.endShape();

  PShape rightWall = createShape();
    rightWall.beginShape();
      rightWall.texture(img);
      rightWall.vertex(5, -1, -5, 0, 1);
      rightWall.vertex(5, -1, 5, 1, 1);
      rightWall.vertex(5, 5, 5, 1, 0);
      rightWall.vertex(5, 5, -5, 0, 0);
    rightWall.endShape();
    
  shape(topWall);
  shape(bottomWall);
  shape(leftWall);
  shape(rightWall);

}

void floors () {
    textureMode(NORMAL); // you want this!
    PImage img = loadImage("assets/galaxy.jpeg");
    textureWrap(REPEAT);
    beginShape();
    texture(img);
    vertex(-5, -1, -5, 0, 1);
    vertex(5, -1, -5, 1, 1);
    vertex(5, -1, 5, 1, 0);
    vertex(-5, -1, 5, 0, 0);
    endShape();
}
