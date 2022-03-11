import controlP5.*;

ControlP5 cp5;
Textlabel myTextlabelA;
Textlabel myTextlabelB;
Textlabel myTextlabelC;
Textlabel myTextlabelD;
int sliderValue = 100;
int sliderTicks2 = 30;
int Iterations = 0;
Button Startbutton;
Toggle Colorbutton;
Toggle Gradualbutton;
Slider Stepcount;
Slider SliderIterations;
int pointX = 800/2;
int pointY = 800/2;
boolean ColorOn = false;
boolean GradualOn = false;




void setup()
{
  
  
  size(800, 800);
  
  cp5 = new ControlP5(this);
  noStroke(); 
  background(152,190,200);
  colorMode(HSB);   
  // create a new button with name 'buttonA'
  Startbutton = cp5.addButton("START")
                 .setValue(0)
                 .setPosition(10,50)
                 .setSize(100,25)
                 .setFont(createFont("Georgia",20))
                  ;
     
    

    Gradualbutton = cp5.addToggle("Gradual")
                       .setPosition(140,20)
                       .setSize(30,15)
                       .setValue(false)
                       .setFont(createFont("Georgia",10));
     
    Colorbutton = cp5.addToggle("Color")
                         .setValue(0)
                         .setPosition(200,20)
                         .setSize(30,15)
                         .setFont(createFont("Georgia",10))
                         ;
  
  //myTextlabelA = cp5.addTextlabel("label")
  //                  .setText("GRADUAL")
  //                  .setPosition(180,50)
  //                  //.setColorValue(0xffffff00)
  //                  .setFont(createFont("Georgia",15))
  //                  ;
                    
  //myTextlabelB = cp5.addTextlabel("labeltwo")
  //                  .setText("COLORS")
  //                  .setPosition(180,70)
  //                  //.setColorValue(0xffffff00)
  //                  .setFont(createFont("Georgia",15))
  //                  ;
 
  
  stroke(255,255,255);
  strokeWeight(0);
  rect(81, 0, 63, 0);

  SliderIterations = cp5.addSlider("ITERATIONS")
                         .setFont(createFont("Georgia",15))
                         .setPosition(300,45)
                         .setRange(1000,500000)
                         .setSize(370, 25) 
                         .setValue(250000)
                         .setDecimalPrecision(0)
                         ;
          
  Stepcount = cp5.addSlider("STEP COUNT")
                 .setFont(createFont("Georgia",15))
                 .setPosition(300,75)
                 .setRange(1,1000)
                 .setSize(370, 25) 
                 .setValue(500)
                 .setDecimalPrecision(0)
                  ;
  
  background(153, 204, 255);
}

void draw()
{
  if ( Startbutton.isPressed()){ 
     background(153, 204, 255);
     Iterations = 0;
     pointX = 800/2;
     pointY = 800/2;
  }
  
  if ( Gradualbutton.getState() == true) {  
    //if(GradualOn == false){
     GradualOn = true;
    } else { GradualOn = false; }
     
  //}
  
  if ( Colorbutton.getState() == true) { 
    //if(ColorOn == false){
    ColorOn = true;
    } else { ColorOn = false; }
    
  //}
  
  
  if (Iterations >= (SliderIterations.getValue())){

  } else { 
  
  RandomWalk(((int)Stepcount.getValue()) );
  
  
  }
  
}

void RandomWalk(int StepCount)
  {
    
    //stroke(0,0,0);
    strokeWeight(2);
    point(pointX,pointY);
    
    float maximum;
    if(GradualOn == false){
      maximum =  SliderIterations.getValue();
    } else {
      maximum = StepCount;
    }
    
    
    for( int i = 0; i < maximum; i++){
    
      Iterations++;
      
      if(ColorOn == false){
        float m = map(Iterations, 0, SliderIterations.getValue(), 0, 255);
        stroke(m);
        
      } else { stroke(0,0,0);
    }
      
      
      
     int number = (int) random(5);
    
    if (number == 0){
       //move up
       pointY += 1;
       if (pointY > 799) pointY = 799;
       point(pointX,pointY);
    }
    else if (number == 1){
       //move down
       pointY -= 1;
       if (pointY < 0) pointY = 0;
       point(pointX,pointY);
}
    else if (number == 2){
       //move left
       pointX -= 1;
       if (pointX < 0) pointX = 0;
       point(pointX,pointY);
}
    else if (number == 3){
       //move right
       pointX += 1;
       if (pointX > 799) pointX = 799;
       point(pointX,pointY);
}

    }
    
  }
