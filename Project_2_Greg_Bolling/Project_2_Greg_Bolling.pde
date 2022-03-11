import controlP5.*;

ControlP5 cp5;

int    ScreenWidth   = 1200;
int    ScreenLength  = 800;
int    MenuLeftWidth = 200;
boolean SkipStartup  = true;
Button Startbutton;
Toggle Constrainbutton;
Toggle SimTerrainbutton;
Toggle UseStrokebutton;
Toggle UseRandombutton;
Slider MaxSteps;
Slider StepRate;
Slider StepSize;
Slider StepScale;
int Color4Red    = 160;
int Color4Green  = 126;
int Color4Blue   = 84;
int Color7Red    = 143;
int Color7Green  = 170;
int Color7Blue   = 64;
int Color10Red   = 135;
int Color10Green = 135;
int Color10Blue  = 135;
Textlabel MaxStepsLabel;
Textlabel StepRateLabel;
Textlabel StepSizeLabel;
Textlabel StepScaleLabel;
boolean Running = false;
Textfield RandomSeedInput;
DropdownList DropDown1;

RandomWalkBaseClass SomeObject    = null;
SquareClass         SquareObject  = null;
HexagonClass        HexagonObject = null;

PVector CartesianToHex(float xPos, float yPos, float hexRadius, float stepScale, float xOrigin, float yOrigin)
{
  float startX = xPos - xOrigin;
  float startY = yPos - yOrigin;

  float col = (2.0/3.0f * startX) / (hexRadius * stepScale);
  float row = (-1.0f/3.0f * startX + 1/sqrt(3.0f) * startY) / (hexRadius * stepScale);
  
  /*===== Convert to Cube Coordinates =====*/
  float x = col;
  float z = row;
  float y = -x - z; // x + y + z = 0 in this system
  
  float roundX = round(x);
  float roundY = round(y);
  float roundZ = round(z);
  
  float xDiff = abs(roundX - x);
  float yDiff = abs(roundY - y);
  float zDiff = abs(roundZ - z);
  
  if (xDiff > yDiff && xDiff > zDiff)
    roundX = -roundY - roundZ;
  else if (yDiff > zDiff)
    roundY = -roundX - roundZ;
  else
    roundZ = -roundX - roundY;
    
  /*===== Convert Cube to Axial Coordinates =====*/
  PVector result = new PVector(roundX, roundZ);
  
  return result;
}

void DrawHex(float x, float y, float radius)
{
  //fill(255);
  beginShape();
  for (int i = 0; i <= 360; i+= 60)
  {
    float xPos = x + cos(radians(i)) * radius;
    float yPos = y + sin(radians(i)) * radius;

    vertex(xPos, yPos);
  }
  endShape();
  
}


class RandomWalkBaseClass {
  int      SquaresOrHex;
  long     MaxStepsValue;
  long     StepRateValue;
  long     StepSizeValue;     
  float    StepScaleValue;    
  float    SizeOfObjectsValue;
  float    ComputedStepDistanceValue;
  boolean  ConstraintEnabled;
  boolean  SimTerraEnabled;
  boolean  UseStrokeEnabled;
  boolean  UseRandomSeedEnabled;
  long     RandomSeedValue;
  float    CurrentScreenPosnX;
  float    CurrentScreenPosnY;
  PVector  CurrentGridPosn;
  long     CurrentStepCount;
  float    CurrentScreenStartPosn;
  HashMap<PVector,Integer> WalkHistory;
  
  RandomWalkBaseClass() {
    CurrentStepCount        = 0;  
    CurrentScreenPosnX      = 700.0f;
    CurrentScreenPosnY      = 400.0f;
    CurrentScreenStartPosn  = 200.0f;
    CurrentGridPosn         = new PVector(0, 0);
    WalkHistory             = new HashMap<PVector,Integer>();
  }
  
  void Restart() {
    CurrentScreenPosnX     = 700.0f;
    CurrentScreenPosnY     = 400.0f;
    CurrentScreenStartPosn = 200.0f;
    this.CaptureSettings();
    this.RestartRandomNumber();
    CurrentStepCount       = 0;
    CurrentGridPosn.x      = 0;
    CurrentGridPosn.y      = 0;
    WalkHistory.clear();
  }
  
  PVector ComputeGridPosition() {
    // for Hex use the conversion as follows: PVector CartesianToHex(float xPos, float yPos, (float) SizeOfObjectsValue, (float) StepScaleValue, (float) 700.0, (float) 400.0);
    // standard below, four directions, any object...
    long roundX, roundY;
    roundX = (int) round((CurrentScreenPosnX - 700.0f) / SizeOfObjectsValue);
    roundY = (int) round((CurrentScreenPosnY - 400.0f) / SizeOfObjectsValue);
    PVector result = new PVector(roundX, roundY);
    return result;
  }
  
   void RestartRandomNumber() {  // resets the seed and starting value
    if (UseRandomSeedEnabled == true) {
      randomSeed(RandomSeedValue);
    }
  }  
  
  void CaptureSettings( ) {
    SquaresOrHex              = (int) DropDown1.getValue();
    StepScaleValue            = StepScale.getValue();
    StepSizeValue             = (long) StepSize.getValue(); 
    StepScaleValue            = StepScale.getValue();
    SizeOfObjectsValue        = (float) StepSizeValue;
    ComputedStepDistanceValue = (long) ((float)SizeOfObjectsValue * StepScaleValue);
    MaxStepsValue             = (long) MaxSteps.getValue();
    StepRateValue             = (long) StepRate.getValue();
    ConstraintEnabled         = Constrainbutton.getState();
    if (ConstraintEnabled == true) {
        CurrentScreenStartPosn = 200.0f;
    } else {
        CurrentScreenStartPosn = 0.0f;
    }
    SimTerraEnabled      = SimTerrainbutton.getState();
    UseStrokeEnabled     = UseStrokebutton.getState();
    UseRandomSeedEnabled = UseRandombutton.getState();
  }

  int GenRandomNumber(int maxret) {  // returns 0..6 as possible valuesr
    float randomval;
    randomval = random(0, (float)maxret+1.0);
    return int (randomval);
  }
  void Update() { // add this on inheritence
  }
  void Draw() {  // add this on inhertence
  }
  int GetSquaresOrHex() {
    return SquaresOrHex;
  }
  float GetCurrentScreenPosnX() {
     return CurrentScreenPosnX;
   }
  float GetCurrentScreenPosnY(){
    return CurrentScreenPosnY;
  }
  float GetSizeOfObject() {
    return SizeOfObjectsValue;
  }
  float GetStepScale() {
    StepScaleValue = StepScale.getValue();
    return StepScaleValue;
  }
  long GetStepSize() {
    StepSizeValue  = (long) StepSize.getValue();
    return StepSizeValue;
  }
  float GetComputedStepDistance() {
    return ComputedStepDistanceValue; // convert to a float, multiply out and return step size.
  }
  long GetMaxSteps() {
    MaxStepsValue = (long) MaxSteps.getValue();
    return MaxStepsValue;
  }
  long GetStepRate() {
    StepRateValue = (long) StepRate.getValue();
    return StepRateValue;
  }
  boolean GetConstraintEnabled() {
    ConstraintEnabled = Constrainbutton.getState();
    return ConstraintEnabled;
  }
  boolean GetSimTerraEnabled() {
    SimTerraEnabled = SimTerrainbutton.getState();
    return SimTerraEnabled;
  }
  boolean GetUseStrokeEnabled() {
    UseStrokeEnabled = UseStrokebutton.getState();
    return UseStrokeEnabled;
  }
  boolean GetUseRandomSeedEnabled() {
    UseRandomSeedEnabled = UseRandombutton.getState();
    return UseRandomSeedEnabled;
  }
}


class SquareClass extends RandomWalkBaseClass {
  SquareClass() {
    super();
  }
  void Update() { // add this on inheritence
      
    int RandomNum;
    boolean ValidMove;
    ValidMove = false;
    while (ValidMove == false) {
      RandomNum = GenRandomNumber(3);
     switch (RandomNum) {
         case 0 : 
                  if ((CurrentScreenPosnX - (float) this.ComputedStepDistanceValue) > this.CurrentScreenStartPosn) {
                       ValidMove = true;
                       this.CurrentScreenPosnX = CurrentScreenPosnX - (float) this.ComputedStepDistanceValue;
                  }
                  break;
         case 1 : 
                  if ((this.CurrentScreenPosnX + (float) this.ComputedStepDistanceValue) < (1199 - this.SizeOfObjectsValue)) {
                       ValidMove = true;
                       this.CurrentScreenPosnX = this.CurrentScreenPosnX + (float) this.ComputedStepDistanceValue;
                  }
                  break;
         case 2 : 
                  if ((this.CurrentScreenPosnY - (float) this.ComputedStepDistanceValue) > 0) {
                       ValidMove = true;
                       this.CurrentScreenPosnY = this.CurrentScreenPosnY - (float) this.ComputedStepDistanceValue;
                  }
                  break;
         case 3 : 
                  if ((this.CurrentScreenPosnY + (float) this.ComputedStepDistanceValue) < (799 - this.SizeOfObjectsValue)) {
                       ValidMove = true;
                       this.CurrentScreenPosnY = this.CurrentScreenPosnY + (float) this.ComputedStepDistanceValue;
                  }
                 break;
      } 
    }
    CurrentGridPosn.x = CurrentScreenPosnX;
    CurrentGridPosn.y = CurrentScreenPosnY;
    if (WalkHistory.containsKey(CurrentGridPosn)) {
      WalkHistory.replace(CurrentGridPosn, WalkHistory.get(CurrentGridPosn),WalkHistory.get(CurrentGridPosn)+1);  // adds one if it exists
    } else  {     
      WalkHistory.putIfAbsent(CurrentGridPosn, 1);
    }
  }
  
  void Draw(float XLocation, float YLocation, float size, int RedColor, int GreenColor, int BlueColor, boolean StrokeEnabled ) {  
      if (StrokeEnabled == true) {
        stroke(255);
      } else {
        noStroke();
      }
      
      if ((WalkHistory.containsKey(CurrentGridPosn)) && (this.SimTerraEnabled == true)) {
        int Visits = WalkHistory.get(CurrentGridPosn);
        if (Visits < 4) {
          fill (Color4Red, Color4Green, Color4Blue);
        } else if (Visits < 7) {
          fill (Color7Red, Color7Green, Color7Blue);
        } else if (Visits < 10) {
          fill (Color10Red, Color10Green, Color10Blue);
        } else {
          int RedComputed, GreenComputed, BlueComputed;
          RedComputed = Visits * 20;
          if (RedComputed > 255) {
            RedComputed = 255;
          }
          GreenComputed = Visits * 20;
          if (GreenComputed > 255) {
            GreenComputed = 255;
          }
          BlueComputed = Visits * 20;
          if (BlueComputed > 255) {
            BlueComputed = 255;
          }
          fill (RedComputed, GreenComputed, BlueComputed);
        }
      } else {
        fill (RedColor, GreenColor, BlueColor);
      }
      rect((int) XLocation,(int) YLocation,(int) size, (int) size);
  }
  
  boolean DoNextSteps() {  
     boolean retVal = false;
     long countdown = this.GetStepRate();
     while ( (countdown > 0) && (this.CurrentStepCount < this.GetMaxSteps()) ) {
       countdown--;
       this.CurrentStepCount++;
       this.Draw(this.GetCurrentScreenPosnX(), this.GetCurrentScreenPosnY(), this.GetSizeOfObject(), Color4Red, Color4Green, Color4Blue, this.GetUseStrokeEnabled());
       this.Update();
     }
     if (this.CurrentStepCount >= this.GetMaxSteps()) {
       retVal = true;
     }
     return retVal;
   }
}
  
  

class HexagonClass extends RandomWalkBaseClass {
  HexagonClass() {
    super();
  }
  void Update() { // add this on inheritence
      
    int RandomNum;
    boolean ValidMove;
    ValidMove = false;
    float HexStepDistanceAngleX = cos(radians(30)) * sqrt(3.0f) * this.ComputedStepDistanceValue;
    float HexStepDistanceAngleY = sin(radians(30)) * sqrt(3.0f) * this.ComputedStepDistanceValue;
    float HexStepDistanceUpDown    = sqrt(3.0f) * this.ComputedStepDistanceValue;
    while (ValidMove == false) {
      RandomNum = GenRandomNumber(5);
     switch (RandomNum) {
         case 0 : 
                  if (((CurrentScreenPosnX + HexStepDistanceAngleX) < (1199 - this.SizeOfObjectsValue)) && ((this.CurrentScreenPosnY + (float) HexStepDistanceAngleY) < (799 - this.SizeOfObjectsValue))) {
                       ValidMove = true;
                       this.CurrentScreenPosnX = CurrentScreenPosnX + (float) HexStepDistanceAngleX;
                       this.CurrentScreenPosnY = CurrentScreenPosnY + (float) HexStepDistanceAngleY;
                  }
                  break;
         case 1 : 
                  if ((this.CurrentScreenPosnY + (float) HexStepDistanceUpDown) < (799 - this.SizeOfObjectsValue)) {
                       ValidMove = true;
                       this.CurrentScreenPosnY = CurrentScreenPosnY + (float) HexStepDistanceUpDown;
                  }
                  break;
         case 2 : 
                  if (((CurrentScreenPosnX - HexStepDistanceAngleX) > (this.CurrentScreenStartPosn + this.SizeOfObjectsValue)) && ((this.CurrentScreenPosnY + (float) HexStepDistanceAngleY) < (799 - this.SizeOfObjectsValue))) {
                       ValidMove = true;
                       this.CurrentScreenPosnX = CurrentScreenPosnX - (float) HexStepDistanceAngleX;
                       this.CurrentScreenPosnY = CurrentScreenPosnY + (float) HexStepDistanceAngleY;
                  }
                  break;
         case 3 : 
                  if (((CurrentScreenPosnX - HexStepDistanceAngleX) > (this.CurrentScreenStartPosn + this.SizeOfObjectsValue)) && ((this.CurrentScreenPosnY - (float) HexStepDistanceAngleY) > this.SizeOfObjectsValue)) {
                       ValidMove = true;
                       this.CurrentScreenPosnX = CurrentScreenPosnX - (float) HexStepDistanceAngleX;
                       this.CurrentScreenPosnY = CurrentScreenPosnY - (float) HexStepDistanceAngleY;
                  }
                  break;
         case 4 : 
                  if ((this.CurrentScreenPosnY - (float) HexStepDistanceUpDown) > this.SizeOfObjectsValue) {
                       ValidMove = true;
                       this.CurrentScreenPosnY = CurrentScreenPosnY - (float) HexStepDistanceUpDown;
                  }
                  break;
         case 5 : 
                  if (((CurrentScreenPosnX + HexStepDistanceAngleX) < (1199 - this.SizeOfObjectsValue)) && ((this.CurrentScreenPosnY - (float) HexStepDistanceAngleY) > this.SizeOfObjectsValue)) {
                       ValidMove = true;
                       this.CurrentScreenPosnX = CurrentScreenPosnX + (float) HexStepDistanceAngleX;
                       this.CurrentScreenPosnY = CurrentScreenPosnY - (float) HexStepDistanceAngleY;
                  }
                  break;
      } 
    }
    PVector Temp = null;
    Temp              = CartesianToHex((float) CurrentScreenPosnX, (float) CurrentScreenPosnY, (float) this.GetStepSize(), (float) this.GetStepScale(), 700.0f, 400.0f);
    CurrentGridPosn.x = (int) Temp.x;
    CurrentGridPosn.y = (int) Temp.y;
    if (this.WalkHistory.containsKey(CurrentGridPosn)) {
      this.WalkHistory.replace(CurrentGridPosn, this.WalkHistory.get(CurrentGridPosn),this.WalkHistory.get(CurrentGridPosn)+1);  // adds one if it exists
    } else  {     
      this.WalkHistory.put(CurrentGridPosn, 1);
    }
  }
  
  void Draw(float XLocation, float YLocation, float size, int RedColor, int GreenColor, int BlueColor, boolean StrokeEnabled ) {  
      if (StrokeEnabled == true) {
        stroke(255);
      } else {
        noStroke();
      }
      
      if ((WalkHistory.containsKey(CurrentGridPosn)) && (this.SimTerraEnabled == true)) {
        int Visits = WalkHistory.get(CurrentGridPosn);
        if (Visits < 4) {
          fill (Color4Red, Color4Green, Color4Blue);
        } else if (Visits < 7) {
          fill (Color7Red, Color7Green, Color7Blue);
        } else if (Visits < 10) {
          fill (Color10Red, Color10Green, Color10Blue);
        } else {
          int RedComputed, GreenComputed, BlueComputed;
          RedComputed = Visits * 20;
          if (RedComputed > 255) {
            RedComputed = 255;
          }
          GreenComputed = Visits * 20;
          if (GreenComputed > 255) {
            GreenComputed = 255;
          }
          BlueComputed = Visits * 20;
          if (BlueComputed > 255) {
            BlueComputed = 255;
          }
          fill (RedComputed, GreenComputed, BlueComputed);
        }
      } else {
        fill (RedColor, GreenColor, BlueColor);
      }
      beginShape();
      for (int i = 0; i <= 360; i+= 60)
      {
        float xPos = XLocation + cos(radians(i)) * size;
        float yPos = YLocation + sin(radians(i)) * size;

        vertex(xPos, yPos);
      }
      endShape();
  }
  
  boolean DoNextSteps() {  
     boolean retVal = false;
     long countdown = this.GetStepRate();
     while ( (countdown > 0) && (this.CurrentStepCount < this.GetMaxSteps()) ) {
       countdown--;
       this.CurrentStepCount++;
       this.Draw(this.GetCurrentScreenPosnX(), this.GetCurrentScreenPosnY(), this.GetSizeOfObject(), Color4Red, Color4Green, Color4Blue, this.GetUseStrokeEnabled());
       this.Update();
     }
     if (this.CurrentStepCount >= this.GetMaxSteps()) {
       retVal = true;
     }
     return retVal;
   }
}
    
  
void DrawBaseScreen() {
  noStroke(); 
  background(125);
  fill (0,0,200);
  rect(MenuLeftWidth, 0, ScreenWidth-1, ScreenLength-1);
  //background(152,190,200);
  colorMode(RGB);   
  // create a new button with name 'buttonA'
}
 
void setup()
{
  
  SomeObject     = new RandomWalkBaseClass();
  SquareObject   = new SquareClass();
  HexagonObject  = new HexagonClass();
  
  frameRate(15);
  DrawBaseScreen(); 
  size(1200,800);
  
  cp5 = new ControlP5(this);  
  Startbutton = cp5.addButton("Start")
                 .setValue(0)
                 .setPosition(15,15)
                 .setColorValue(color(0, 200, 0))
                 .setColorForeground(color(0,250,0))
                 .setColorBackground(color(0, 200, 0))
                 .setSize(120,20)
                 .setFont(createFont("bitFont ",10))
                  ;
     
    DropDown1 = cp5.addDropdownList("Squares")
                 .setPosition(15, 60)
                 .setSize(100, 120)
                 .setColorBackground(color(0, 0, 220))
                 .setColorForeground(color(0, 0, 210))
                 .setColorActive(color(0, 0, 200))
                 .setColorLabel(color(255, 255, 255))
                 .setColorValueLabel(color(255, 255, 255))
                 .setColorCaptionLabel(color(255, 255, 255))    
                 .setBarHeight(25)
                 .setHeight(75)
                 .setItemHeight(25)
                 .setOpen(false);
                 ;
  DropDown1.addItem("Squares", 1);
  DropDown1.addItem("Hexagons", 1);
   
  
  stroke(255,255,255);
  strokeWeight(1);

  MaxSteps = cp5.addSlider("Maximum Steps")
                 .setFont(createFont("bitFont",10))
                 .setPosition(15,170)
                 .setRange(100,50000)
                 .setSize(170, 25) 
                 .setValue(25000)
                 .setDecimalPrecision(0)
                  ;
  //cp5.getController("Maximum Steps").getCaptionLabel().align(ControlP5.LEFT, ControlP5.TOP_OUTSIDE).setPaddingX(0);
  cp5.getController("Maximum Steps").getCaptionLabel().setVisible(false);
  MaxStepsLabel = cp5.addTextlabel("MaxStepsLabel")
                 .setText("Max Steps")
                 .setPosition(15,150)
                 .setFont(createFont("bitFont",12))
                  ;
  
  StepRate = cp5.addSlider("Step Rate")
                 .setFont(createFont("bitFont",10))
                 .setPosition(15,220)
                 .setRange(1,1000)
                 .setSize(170, 25) 
                 .setValue(500)
                 .setDecimalPrecision(0)
                  ;                
  //cp5.getController("Step Rate").getCaptionLabel().align(ControlP5.LEFT, ControlP5.TOP_OUTSIDE).setPaddingX(0);
  cp5.getController("Step Rate").getCaptionLabel().setVisible(false);
  StepRateLabel = cp5.addTextlabel("StepRateLabel")
                 .setText("Step Rate")
                 .setPosition(15,200)
                 .setFont(createFont("bitFont",12))
                  ;
  
  StepSize = cp5.addSlider("Step Size")
                 .setFont(createFont("bitFont",10))
                 .setPosition(15,300)
                 .setRange(10,30)
                 .setSize(80, 25) 
                 .setValue(20)
                 .setDecimalPrecision(0)
                  ;                
  //cp5.getController("Step Size").getCaptionLabel().align(ControlP5.LEFT, ControlP5.TOP_OUTSIDE).setPaddingX(0);
  cp5.getController("Step Size").getCaptionLabel().setVisible(false);
  StepSizeLabel = cp5.addTextlabel("StepSizeLabel")
                 .setText("Step Size")
                 .setPosition(15,280)
                 .setFont(createFont("bitFont",12))
                  ;
    
  StepScale = cp5.addSlider("Step Scale")
                 .setFont(createFont("bitFont",10))
                 .setPosition(15,350)
                 .setRange(1.0,1.5)
                 .setSize(80, 25) 
                 .setValue(1.25)
                 .setDecimalPrecision(2)
                  ;                
  //cp5.getController("Step Scale").getCaptionLabel().align(ControlP5.LEFT, ControlP5.TOP_OUTSIDE).setPaddingX(0);
  cp5.getController("Step Scale").getCaptionLabel().setVisible(false);
  StepScaleLabel = cp5.addTextlabel("StepScaleLabel")
                 .setText("Step Scale")
                 .setPosition(15,330)
                 .setFont(createFont("bitFont",12))
                  ;
 
  Constrainbutton = cp5.addToggle("CONSTRAIN STEPS")
                 .setPosition(15,400)
                 .setSize(30,30)
                 .setValue(false)
                 .setFont(createFont("bitFont",10));
  
  SimTerrainbutton = cp5.addToggle("SIMULATE TERRAIN")
                 .setPosition(15,470)
                 .setSize(30,30)
                 .setValue(false)
                 .setFont(createFont("bitFont",10));
     
  UseStrokebutton = cp5.addToggle("USE STROKE")
                 .setPosition(15,540)
                 .setSize(30,30)
                 .setValue(false)
                 .setFont(createFont("bitFont",10));
     
  UseRandombutton = cp5.addToggle("USE RANDOM SEED")
                 .setPosition(15,610)
                 .setSize(30,30)
                 .setValue(false)
                 .setFont(createFont("bitFont",10));
  
  RandomSeedInput = cp5.addTextfield("Seed Value")
                 .setPosition(130,610)
                 .setInputFilter(cp5.INTEGER)
                 .setSize(65,30);
}

public void Start(){
  //println("Button pressed");
  if (SkipStartup == true) {
    SkipStartup = false;
  } else {
    Running = true;
    DrawBaseScreen();
    SomeObject.Restart();
    SquareObject.Restart();
    HexagonObject.Restart();
  }
}

public void Squares(){  // clear the drop down when it has been selected.
  // Perform Calculations
  DrawBaseScreen();
}
 
void draw()
{ //<>//
  if (Running == true) {
    if (SomeObject.GetSquaresOrHex() == 0) {
      if (SquareObject.DoNextSteps() ==  true) {
        Running = false;
        //println("Stopping Squares.");
      }
    } else {
      if (HexagonObject.DoNextSteps() ==  true) {
        Running = false;
        //println("Stopping Hexagons.");
      }
    }
  }
    
}
