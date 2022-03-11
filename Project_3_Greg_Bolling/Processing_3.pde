import controlP5.*;
ControlP5 cp5;

float scroll;
float positionX = 0;
float positionY = 0;
float positionZ = 10;
float camSpeed = 1;
Mycamera object1 = new Mycamera();

PVector newVector1 = new PVector(-120,0,0);
PVector newVector2 = new PVector(-110,0,0);
PVector newVector3 = new PVector(-100,0,0);
PVector newVector4 = new PVector(-55,0,0);
PVector newVector5 = new PVector(-45,0,0);
PVector newVector6 = new PVector(0,0,0);
PVector newVector7 = new PVector(75,0,0);
PShape someObject;
PShape someObject2;
PShape boxTriangle;
PShape fanShapeHex;
PShape fanShapeCircle;
 
void setup()
{
    

  size(1600, 1000, P3D);
  pixelDensity(2);
  cp5 = new ControlP5(this);
  perspective(radians(50.0f), width/(float)height, 0.1, 1000);
  
  float BoxLen = 0.5;
  boxTriangle = createShape();
  boxTriangle.beginShape(TRIANGLE);
  //front side
  boxTriangle.fill(255, 255, 51);
  boxTriangle.vertex(-BoxLen, -BoxLen,0);
  boxTriangle.vertex(0,0,0);
  boxTriangle.vertex(-BoxLen,0,0);

  boxTriangle.fill(51, 255, 51);
  boxTriangle.vertex(-BoxLen, -BoxLen,0);
  boxTriangle.vertex(0,0,0);
  boxTriangle.vertex(0, -BoxLen,0);
  //top side
  boxTriangle.fill(160, 160, 160);
  boxTriangle.vertex(-BoxLen, -BoxLen,0);
  boxTriangle.vertex(0, -BoxLen,0);
  boxTriangle.vertex(-BoxLen, -BoxLen, -BoxLen);

  boxTriangle.fill(255, 128, 0);
  boxTriangle.vertex(-BoxLen, -BoxLen, -BoxLen);
  boxTriangle.vertex(0, -BoxLen,0);
  boxTriangle.vertex(0, -BoxLen, -BoxLen);

  //left side
  boxTriangle.fill(75, 160, 160);
  boxTriangle.vertex(-BoxLen, -BoxLen,0);
  boxTriangle.vertex(-BoxLen,0,0);
  boxTriangle.vertex(-BoxLen, -BoxLen, -BoxLen);

  boxTriangle.fill(0, 0, 255);
  boxTriangle.vertex(-BoxLen,0, -BoxLen);
  boxTriangle.vertex(-BoxLen,0,0);
  boxTriangle.vertex(-BoxLen, -BoxLen, -BoxLen);

  //right side
  boxTriangle.fill(0, 0, 255);
  boxTriangle.vertex(0,0,0);
  boxTriangle.vertex(0,0, -BoxLen);
  boxTriangle.vertex(0, -BoxLen, -BoxLen);

  boxTriangle.fill(255, 0, 0);
  boxTriangle.vertex(0, -BoxLen,0);
  boxTriangle.vertex(0,0,0);
  boxTriangle.vertex(0, -BoxLen, -BoxLen);

  //underside
  boxTriangle.fill(0, 255, 0);
  boxTriangle.vertex(-BoxLen,0,0);
  boxTriangle.vertex(0,0,0);
  boxTriangle.vertex(-BoxLen,0, -BoxLen);

  boxTriangle.fill(255, 0, 128);
  boxTriangle.vertex(0,0, -BoxLen);
  boxTriangle.vertex(0,0,0);
  boxTriangle.vertex(-BoxLen,0, -BoxLen);

  //backside
  boxTriangle.fill(255, 255, 51);
  boxTriangle.vertex(-BoxLen, -BoxLen, -BoxLen);
  boxTriangle.vertex(-BoxLen,0, -BoxLen);
  boxTriangle.vertex(0,0, -BoxLen);

  boxTriangle.fill(0, 255, 0);
  boxTriangle.vertex(-BoxLen, -BoxLen, -BoxLen);
  boxTriangle.vertex(0,0, -BoxLen);
  boxTriangle.vertex(0, -BoxLen, -BoxLen);
  boxTriangle.endShape();
 
  float HexLenght    = 1.0f;
  float HexSmallStep = HexLenght * cos(PI/3);
  float HexBigStep   = HexLenght * sin(PI/3);
  fanShapeHex = createShape();
  fanShapeHex.beginShape(TRIANGLE_FAN);
  fanShapeHex.colorMode(HSB, 5, 255, 255);
  // Segment 1
  fanShapeHex.fill(0, 255, 255);
  fanShapeHex.vertex(0, -HexBigStep, 0);
  fanShapeHex.fill(1, 255, 255);
  fanShapeHex.vertex(-HexSmallStep, 0, 0);
  fanShapeHex.fill(2, 255, 255);
  fanShapeHex.vertex(-1-HexSmallStep, 0, 0);
  // Segment 2
  fanShapeHex.fill(0, 255, 255);
  fanShapeHex.vertex(0, -HexBigStep, 0);
  fanShapeHex.fill(2, 255, 255);
  fanShapeHex.vertex(-1-HexSmallStep, 0, 0);
  fanShapeHex.fill(3, 255, 255);
  fanShapeHex.vertex(-1-2*HexSmallStep, -HexBigStep, 0);
  // Segment 3
  fanShapeHex.fill(0, 255, 255);
  fanShapeHex.vertex(0, -HexBigStep, 0);
  fanShapeHex.fill(3, 255, 255);
  fanShapeHex.vertex(-1-2*HexSmallStep, -HexBigStep, 0);
  fanShapeHex.fill(4, 255, 255);
  fanShapeHex.vertex(-1-HexSmallStep, -2*HexBigStep, 0);
  // Segment 3
  fanShapeHex.fill(0, 255, 255);
  fanShapeHex.vertex(0, -HexBigStep, 0);
  fanShapeHex.fill(4, 255, 255);
  fanShapeHex.vertex(-1-HexSmallStep, -2*HexBigStep, 0);
  fanShapeHex.fill(5, 255, 255);
  fanShapeHex.vertex(-HexSmallStep, -2*HexBigStep, 0);
  fanShapeHex.endShape();

  float CircleRadius    = 1.0f;
  int   CircleFanPoints = 20;
  float Circle0ptX      = 0.0f;
  float Circle0ptY      = -CircleRadius;
  float Circle0ptZ      = 0.0f;
  fanShapeCircle = createShape();
  fanShapeCircle.setStroke(true);
  fanShapeCircle.setStroke(color(0,0,0));
  fanShapeCircle.setStrokeWeight(0.3f); 
  fanShapeCircle.beginShape(TRIANGLE_FAN);
  fanShapeCircle.colorMode(HSB, 21, 255, 255);
  
  //for (int PointCnt = 0; PointCnt < CircleFanPoints; ++PointCnt) {
  for (int PointCnt = 0; PointCnt < CircleFanPoints; ++PointCnt) {
     // Segment 3
     fanShapeCircle.fill(0, 255, 255);
     fanShapeCircle.vertex(Circle0ptX, Circle0ptY, Circle0ptZ);
     fanShapeCircle.fill((PointCnt+CircleFanPoints/2)%CircleFanPoints, 255, 255);
     fanShapeCircle.vertex(-1-cos((float)(PointCnt+1)*PI*2.0f/(float)CircleFanPoints), Circle0ptY-sin((float)(PointCnt+1)*PI*2.0f/(float)(CircleFanPoints)), 0.0f);
     fanShapeCircle.fill((PointCnt+1+CircleFanPoints/2)%CircleFanPoints, 255, 255);
     fanShapeCircle.vertex(-1-cos(((float)PointCnt+2)*PI*2.0f/(float)(CircleFanPoints)), Circle0ptY-sin(((float)(PointCnt+2))*PI*2.0f/((float)(CircleFanPoints))), 0.0f);
  }
  fanShapeCircle.endShape();
  
 
  someObject  = loadShape("monster.obj");
  someObject2 = loadShape("monster.obj");
  someObject2.setStroke(true);
  someObject2.setStroke(color(0,0,0));
  someObject2.setStrokeWeight(2.0f); 

  object1.AddLookAtTarget(newVector1);
  object1.AddLookAtTarget(newVector2);
  object1.AddLookAtTarget(newVector3);
  object1.AddLookAtTarget(newVector4);
  object1.AddLookAtTarget(newVector5);
  object1.AddLookAtTarget(newVector6);
  object1.AddLookAtTarget(newVector7);
}


void draw(){
  background(50);
 
  object1.Update();
  
  camera(object1.cameraPosition.x, object1.cameraPosition.y,object1.cameraPosition.z, object1.lookatTarget.x, object1.lookatTarget.y, object1.lookatTarget.z, 0, 1, 0); 
  
  for(int i = -100; i<= 100; i+= 10){
    pushMatrix();
    stroke(255);
    line(i, 0, -100, i, 0, 100);
    stroke(0);
    popMatrix();
  }
  
  for(int i = -100; i<= 100; i+= 10){
    pushMatrix();
    stroke(255);
    line(-100, 0, i, 100, 0, i);
    stroke(0);
    popMatrix();
  }
 
 


  //someObject.stroke(255, 255, 255);
  //stroke(255, 255, 255);
  //someObject.setFill(color(20, 120, 20, 50 ));
  someObject2.setFill(color(2, 120, 20, 0 ));
  pushMatrix();
  translate(75, 0, 0);
  rotate(PI);
  shape(someObject2);
  popMatrix();

  someObject.setFill(color(20, 255, 20, 220));
  pushMatrix();
  translate(0, 0, 0);
  scale(0.5,0.5,0.5);
  rotate(PI);
  shape(someObject);
  popMatrix();
 
  pushMatrix();
  translate(-40, 0, 0);
  scale(5,5,5);
  shape(fanShapeHex);
  popMatrix();

  pushMatrix();
  translate(-60, 0, 0);
  scale(5, 5, 5);
  shape(fanShapeCircle);
  popMatrix();


  pushMatrix();
  translate(-120, 0, 0);
  shape(boxTriangle);
  popMatrix();
 
  pushMatrix();
  translate(-110,0,0);
  scale(5,5,5);
  shape(boxTriangle);
  popMatrix();
 
  pushMatrix();
  translate(-100,0,0);
  scale(10,20,10);
  shape(boxTriangle);
  popMatrix();
   
  resetMatrix();
  camera();
  perspective(); 
}


class Mycamera{
  float radius = 100;
  int   count  = 0;
  ArrayList<PVector> TargetList = new ArrayList<PVector>();
  PVector lookatTarget          = new PVector(0,0,0);
  PVector cameraPosition        = new PVector(0,0,0);
  float   Phi;
  float   Theta;
  float   derivedX;
  float   derivedY;
  float   derivedZ;
  
  Mycamera(){
  }
  
  void Update(){
    
    Zoom(scroll);
    
    //mousex and mousey for theta and phi
    Phi   = map(mouseX, 0, width - 1, 0, 2*PI);
    Theta = map(mouseY, 1, height - 1, 0, PI);
    
    derivedX = radius * cos(Phi) * sin(Theta);
    derivedY = radius * cos(Theta);
    derivedZ = radius * sin(Theta) * sin(Phi);
    
    cameraPosition.x = lookatTarget.x + derivedX;
    cameraPosition.y = lookatTarget.y + derivedY;
    cameraPosition.z = lookatTarget.z + derivedZ;

  }
  
  void AddLookAtTarget(PVector addedVector){
    TargetList.add(addedVector);
  }
  
  
  void CycleTarget(){
    if(key == ' '){
       if( (count) == (TargetList.size() - 1)){
           count = 0;
       } else {
           count += 1;
       }
       println(count);
       lookatTarget = TargetList.get(count);
    }
  }
  
  void Zoom(float amount){
   radius += amount;
    if(radius < 30){
      radius = 30;
    }
    if(radius > 200){
      radius = 200;
    }
  }
  
}
void keyPressed() {
    object1.CycleTarget();
  }

void mouseWheel(MouseEvent event) {
  scroll = 20*event.getCount();
  println(scroll);
} 
