import controlP5.*;
ControlP5 cp5;

float camX = 0;
float camY = 0;
float camZ = 10;

void setup()
{
  size(800,800,P3D);
  pixelDensity(2);
  cp5 = new ControlP5(this);
  
  cp5.addSlider("camX", -10, 10);
  cp5.addSlider("camY", -10, 10);
  cp5.addSlider("camZ", -10, 10);
  
  
}

void draw(){
  
  background(50);
  
  camera(camX, camY, camZ, 0, 0, 0, 0, 1, 0);
  
  perspective(radians(90), (float)width/height, 0.1, 100);
  
  box(1);
  
  fill(0,255,0);
  for(int i = -10; i<= 10; i++){
    
    pushMatrix();
    translate(i,0,0);
    box(0.5);
    popMatrix();
    
  }
  
  
  
  resetMatrix();
  camera();
  perspective();
  
  
  
  
  
  
  
  
  
  
}
