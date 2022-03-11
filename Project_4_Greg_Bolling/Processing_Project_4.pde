import controlP5.*;
ControlP5 cp5;

boolean DEBUG0 = false;
boolean DEBUG1 = true;
boolean DEBUG2 = false;
boolean DEBUG3 = false;
boolean DEBUG4 = false;
boolean DrawGrid = false;


Button StartButton;
Toggle Strokebutton;
Toggle Colorbutton;
Toggle Blendbutton;
Slider RowsSlider;
Slider ColumnsSlider;
Slider TerrainSizeSlider;
Slider HeightModifierSlider;
Slider SnowThresholdSlider;
Textfield LoadFromFile;


float scroll;
float positionX = 0;
float positionY = 0;
float positionZ = 10;
float camSpeed = 1;
Mycamera object1 = new Mycamera();
TerrainClass TheTerrain = new TerrainClass();

PVector newVector1 = new PVector(0,0,0);

// ToDo: Remove the next set of definitons as they are test from using Project 3
PShape boxTriangle;
PShape fanShapeHex;
float Normal   =  1.0f;
float Invert   = -1.0f;
float InvertV  = Invert;
int   InvertC  = (int) (-1.0f * InvertV);



void setup()
{
    
  size(1400, 1000, P3D);
  cp5 = new ControlP5(this);
  
  RowsSlider = cp5.addSlider("ROWS")
                 .setPosition(15,15)
                 .setRange(1,100)
                 .setSize(170, 25) 
                 .setValue(50)
                 .setDecimalPrecision(0)
                  ;
  
  ColumnsSlider = cp5.addSlider("COLUMNS")
                 .setPosition(15,50)
                 .setRange(1,100)
                 .setSize(170, 25) 
                 .setValue(50)
                 .setDecimalPrecision(0)
                  ;
                  
  TerrainSizeSlider = cp5.addSlider("TERRAIN SIZE")
                 .setPosition(15,85)
                 .setRange(20,50)
                 .setSize(170, 25) 
                 .setValue(30)
                 .setDecimalPrecision(2)
                  ;
                  
  StartButton = cp5.addButton("GENERATE")
                 .setValue(0)
                 .setPosition(15,120)
                 //.setColorValue(color(0, 200, 0))
                 //.setColorForeground(color(0,250,0))
                 //.setColorBackground(color(0, 200, 0))
                 .setSize(120,30)
                  ;
  
  LoadFromFile = cp5.addTextfield("LOAD FROM FILE")
                 .setPosition(15,155)
                 .setSize(170, 25) 
                 .setAutoClear(false)
                 .setValue("terrain1.png")
                  ;
                  
  Strokebutton = cp5.addToggle("STROKE")
                 .setPosition(315,15)
                 .setSize(25, 25) 
                 .setValue(true)
                 .setDecimalPrecision(0)
                  ;
                  
                  
  Blendbutton = cp5.addToggle("BLEND")
                 .setPosition(350,15)
                 .setSize(25, 25) 
                 .setValue(true)
                 .setDecimalPrecision(0)
                  ;
                  
                  
  Colorbutton = cp5.addToggle("COLOR")
                 .setPosition(385,15)
                 .setSize(25, 25) 
                 .setValue(true)
                 .setDecimalPrecision(0)
                  ;                  
                  
  HeightModifierSlider = cp5.addSlider("HEIGHT MODIFIER")
                 .setPosition(315,75)
                 .setRange(-5.0,5.0)
                 .setSize(170, 25) 
                 .setValue(1.0f)
                 .setDecimalPrecision(2)
                  ;
                  
  SnowThresholdSlider = cp5.addSlider("SNOW THRESHOLD")
                 .setPosition(315,120)
                 .setRange(1,5)
                 .setSize(170, 25) 
                 .setValue(5.0f)
                 .setDecimalPrecision(2)
                  ;
  
  
  
  perspective(radians(90.0f), width/(float)height, 0.1, 1000);

  object1.AddLookAtTarget(newVector1);
}

void DrawAGrid() {
  TheTerrain.CaptureSettings();
  float GridSize = TheTerrain.getTerrainSize() / 2;
  float stepSizeRow = TheTerrain.getTerrainSize() / (TheTerrain.getRows());
  float stepSizeColumn = TheTerrain.getTerrainSize() / (TheTerrain.getColumns());
  for(float i = -GridSize; i<= GridSize; i+= stepSizeRow){
    pushMatrix();
    stroke(255);
    line(i, 0, -GridSize, i, 0, GridSize);
    stroke(0);
    popMatrix();
  }
  
  for(float i = -GridSize; i<= GridSize; i+= stepSizeColumn){
    pushMatrix();
    stroke(255);
    line(-GridSize, 0, i, GridSize, 0, i);
    stroke(0);
    popMatrix();
   }
}


void draw(){
  background(50);
 
  object1.Update();
  
  camera(object1.cameraPosition.x, object1.cameraPosition.y,object1.cameraPosition.z, object1.lookatTarget.x, object1.lookatTarget.y, object1.lookatTarget.z, 0, 1, 0); 
  
  if (DEBUG0 == true) {
    DrawAGrid(); // for reference
  }
  
  TheTerrain.DrawTheTerrain();  // does the drawing
 
  resetMatrix();
  camera();
  perspective(); 
}


class TerrainClass {
  int      Rows;
  int      Columns;
  float    TerrainSize;
  boolean  Stroke;     
  boolean  Color;    
  boolean  Blend;
  float    HeightModifier;
  float    SnowThreshold;
  String   FileName;
  PShape   TheTerrainShape;
  PImage   Loadfile;
  PVector[] vertices;
  PVector[] triangles;
  boolean  TerrainExists = false;
  color snowColor  = color(255, 255, 255);
  color grassColor = color(143, 170, 64);
  color rockColor  = color( 135, 135, 135);
  color dirtColor  = color(160, 126, 84);
  color waterColor = color(0, 75, 200);

  
  TerrainClass() {
    this.Rows = 10;
    this.Columns = 10;
    this.TerrainSize = 30.0f;
    this.Stroke = true;     
    this.Color  = true;    
    this.Blend  = true;
    this.HeightModifier = 1.0f;
    this.SnowThreshold  = 5.0f;
    this.FileName = "";
  }
  
  color GenerateTerrainColor(float ScaledPixelColor) {
    color retVal =  color(200, 200, 200);
    float ratio;
    //println("ScaledPixel Color is " + ScaledPixelColor); 
    if (this.getColor() == true) {
      if (this.getBlend() == false) {
        if (ScaledPixelColor > 0.8f)                                  { // snow
          retVal = snowColor;
        } 
        if ((ScaledPixelColor <= 0.8f) && (ScaledPixelColor > 0.6f))  { // rock
          retVal = rockColor;
        } 
        if ((ScaledPixelColor <= 0.6f) && (ScaledPixelColor > 0.4f))  { // grass
          retVal = grassColor;
        } 
        if ((ScaledPixelColor <= 0.4f) && (ScaledPixelColor > 0.2f))  { // dirt
          retVal = dirtColor;
        } 
        if (ScaledPixelColor <= 0.2f) { // water
          retVal = waterColor;
        }
      } else { // Test for Blending
        if (ScaledPixelColor > 0.8f)                                  { // snow & rock
          ratio  = (ScaledPixelColor - 0.8f) / 0.2f;
          retVal = lerpColor(rockColor, snowColor, ratio);
        } 
        if ((ScaledPixelColor <= 0.8f) && (ScaledPixelColor > 0.4f))  { //  grass & rock
          ratio  = (ScaledPixelColor - 0.4f) / 0.4f;
          retVal = lerpColor(grassColor, rockColor, ratio);
        } 
        if ((ScaledPixelColor <= 0.4f) && (ScaledPixelColor > 0.2f))  { // dirt & grass
          ratio  = (ScaledPixelColor - 0.2f) / 0.2f;
          retVal = lerpColor(dirtColor, grassColor, ratio);
        } 
        if (ScaledPixelColor <= 0.2f) { // water
          ratio  = ScaledPixelColor / 0.2f;
          retVal = lerpColor(waterColor, dirtColor, ratio);
        }
      } // Test for Blending
    } // only assign color if asked to do so by the menu
    return retVal;
  }
  
  void CaptureSettings( ) {
    this.Rows           = (int) RowsSlider.getValue();
    this.Columns        = (int) ColumnsSlider.getValue();
    this.TerrainSize    = (float) map((float) TerrainSizeSlider.getValue(), 20.0f, 50.0f, 100.0f, 300.0f) ;
    this.Stroke         = Strokebutton.getState();     
    this.Color          = Colorbutton.getState();    
    this.Blend          = Blendbutton.getState();
    this.HeightModifier = HeightModifierSlider.getValue();
    this.SnowThreshold  = SnowThresholdSlider.getValue();
    this.FileName       = LoadFromFile.getText();
  }
  
  void CreateTheTerrain() {
    // first capture all the user interface settings and place them in the local variables for this terrain
    this.CaptureSettings();

    // Open up a file and attempt to read in the terrain data.
    // if the file can't be opened, can't crash, just print out an error to the console
    
    int RowCount;
    int ColumnCount;
    boolean FileLoaded = false;
    
    vertices = new PVector[(this.Rows+1) * (this.Columns + 1)]; // automatically deallocates previous unused array

    int   imageWidth  = 100;
    int   imageHeight = 100; 
    Loadfile = loadImage(this.getFileName());
    if (Loadfile == null) {
      println("Enter a different file name than " + this.getFileName());
      FileLoaded = false;
    } else {
      FileLoaded    = true;
      imageWidth    = Loadfile.width;
      imageHeight   = Loadfile.height;
    }  // file read returned a NULL to get to the above
    float x_index;
    float y_index;
    color mycolor;
    float mycolor_red;
    float relativeHeight;
 
    float stepSizeRow = TheTerrain.getTerrainSize() / (TheTerrain.getRows());
    float stepSizeColumn = TheTerrain.getTerrainSize() / (TheTerrain.getColumns());
    triangles = new PVector[(this.Rows+1) * (this.Columns + 1) * 2]; 
    // create the total set of points (each is a location in x,y,z)
    for (RowCount = 0; RowCount <= this.Rows; RowCount++) {
        for (ColumnCount = 0; ColumnCount <= this.Columns; ColumnCount++) {
          int index = RowCount*(TheTerrain.getColumns()+1) + ColumnCount;
          vertices[index] = new PVector(0,0,0);
          vertices[index].x = (int) (RowCount*stepSizeRow - (stepSizeRow * this.Rows / 2)); // this point's X location
          vertices[index].y = 0; // this point's Y location, to be updated below by image height computations
          vertices[index].z =  (int) (ColumnCount*stepSizeColumn - (stepSizeColumn * this.Columns / 2)); // this point's Z location
          x_index = round(map(RowCount, 0, this.Rows, 0, imageWidth));
          y_index = round(map(ColumnCount, 0, this.Columns, 0, imageHeight));
          if (FileLoaded == true) {
            mycolor = Loadfile.get( (int) x_index, (int) y_index);
          } else {
            mycolor = color(0, 0, 0);
          }
          mycolor_red =  -(red(mycolor) * this.getHeightModifier());
          relativeHeight = mycolor_red / -this.getSnowThreshold() / 255.0f;
          //vertices[index].y = mycolor_red / 5.0f; // this point's Y location
          vertices[index].y = mycolor_red; // this point's Y location

          if ((RowCount < 2) && (DEBUG1 == true)) {
            println(" Made it here " + index  + " Row Count is " + RowCount + " and Column Count is " + ColumnCount + " mycolor " + mycolor_red + " image x " + x_index + " image y " + y_index + " image width " + imageWidth + " image height " + imageHeight);
            println(" ("+vertices[index].x + ", " + vertices[index].y + ", " + vertices[index].z + " this.getHeightModifier() " + this.getHeightModifier() + " relativeHeight " + relativeHeight);
          }            
          if ((RowCount < this.Rows) && (ColumnCount < this.Columns)) {
            int trianglenumber = (RowCount*this.Columns*2)+(ColumnCount*2);
            int baseLeftPoint = ( RowCount * (this.Columns+1) ) + ColumnCount;
            int baseLeftPointDown = ( (RowCount+1) * (this.Columns+1) ) + ColumnCount;
            triangles[trianglenumber] = new PVector( baseLeftPoint+1, baseLeftPointDown, baseLeftPoint);
            triangles[trianglenumber+1] = new PVector( baseLeftPoint+1, baseLeftPointDown+1, baseLeftPointDown);
            if ((RowCount < 2) && (DEBUG2 == true)) {
              println(" Triangle Number " + trianglenumber + " " + triangles[trianglenumber]);
              println(" Triangle Number " + (int)(trianglenumber+1) + " " + triangles[trianglenumber+1]);
            }
          }
        }
    }    
   
    TheTerrainShape = createShape();
    // Stroke conditions
    if (this.getStroke() == true) {
       stroke(2);
       TheTerrainShape.setStroke(color(0,0,0));
       TheTerrainShape.setStrokeWeight(0.3f); 
       TheTerrainShape.setStroke(true);
    } else {
       stroke(0);
       TheTerrainShape.setStroke(color(0,0,0));
       TheTerrainShape.setStrokeWeight(0.0f); 
       TheTerrainShape.setStroke(false);
    }
    this.TheTerrainShape.beginShape(TRIANGLE);
    int trianglenumber;
    float PixelYValue;
    color TerrainColoring;
    for (RowCount = 0; RowCount < this.Rows-1; RowCount++) {
    //for (RowCount = 0; RowCount < 1; RowCount++) {
        for (ColumnCount = 0; ColumnCount < this.Columns-1; ColumnCount++) {
        //for (ColumnCount = 0; ColumnCount < 2; ColumnCount++) {
          int thisTriangle = (RowCount*this.Columns*2)+(ColumnCount*2);
          for( trianglenumber = thisTriangle; trianglenumber <= thisTriangle+1; ++trianglenumber) {
            if ((RowCount < 2) && (DEBUG3 == true)) {
              println("Row " + RowCount + " Column " + ColumnCount + " triangle number " + trianglenumber + " triangles[trianglenumber].x) " + triangles[trianglenumber].x + " triangles[trianglenumber].y) " + triangles[trianglenumber].y + " triangles[trianglenumber].z) " + triangles[trianglenumber].z );
              println("vertices[triangles[trianglenumber].x)].x " + vertices[(int) triangles[trianglenumber].x].x, "vertices[triangles[trianglenumber].x)].y " + vertices[(int) triangles[trianglenumber].x].y, "vertices[triangles[trianglenumber].x)].z " + vertices[(int) triangles[trianglenumber].x].z);
              println("vertices[triangles[trianglenumber].y)].x " + vertices[(int) triangles[trianglenumber].y].x, "vertices[triangles[trianglenumber].y)].y " + vertices[(int) triangles[trianglenumber].y].y, "vertices[triangles[trianglenumber].y)].z " + vertices[(int) triangles[trianglenumber].y].z);
              println("vertices[triangles[trianglenumber].z)].x " + vertices[(int) triangles[trianglenumber].z].x, "vertices[triangles[trianglenumber].z)].y " + vertices[(int) triangles[trianglenumber].z].y, "vertices[triangles[trianglenumber].z)].z " + vertices[(int) triangles[trianglenumber].z].z);
            }
       
            // Blend conditions
            // if (this.getBlend() == true) {
            // For each point on the vertex, select a color that is based on the image
            // } else {
            // for each point on the vertex, select a common color based on the image
            // }
            PixelYValue = vertices[(int) triangles[trianglenumber].x].y;
            relativeHeight = PixelYValue / -this.getSnowThreshold() / 255.0f;
            TerrainColoring = this.GenerateTerrainColor(relativeHeight);
            TheTerrainShape.fill(red(TerrainColoring), green(TerrainColoring), blue(TerrainColoring));
            TheTerrainShape.vertex(vertices[(int) triangles[trianglenumber].x].x, PixelYValue / 5.0f, vertices[(int) triangles[trianglenumber].x].z);
            PixelYValue = vertices[(int) triangles[trianglenumber].y].y;
            relativeHeight = PixelYValue / -this.getSnowThreshold() / 255.0f;
            TerrainColoring = this.GenerateTerrainColor(relativeHeight);
            TheTerrainShape.fill(red(TerrainColoring), green(TerrainColoring), blue(TerrainColoring));
            TheTerrainShape.vertex(vertices[(int) triangles[trianglenumber].y].x, PixelYValue / 5.0f, vertices[(int) triangles[trianglenumber].y].z);
            PixelYValue = vertices[(int) triangles[trianglenumber].z].y;
            relativeHeight = PixelYValue / -this.getSnowThreshold() / 255.0f;
            TerrainColoring = this.GenerateTerrainColor(relativeHeight);
            TheTerrainShape.fill(red(TerrainColoring), green(TerrainColoring), blue(TerrainColoring));
            TheTerrainShape.vertex(vertices[(int) triangles[trianglenumber].z].x, PixelYValue / 5.0f, vertices[(int) triangles[trianglenumber].z].z);
            if ((RowCount < 2) && (DEBUG4 == true)) {
              println("Row " + RowCount + " Column " + ColumnCount + " triangle number " + trianglenumber + " thisTriangle " + thisTriangle + " triangles[trianglenumber].x) " + triangles[trianglenumber].x + " triangles[trianglenumber].y) " + triangles[trianglenumber].y + " triangles[trianglenumber].z) " + triangles[trianglenumber].z );
              println("vertices[triangles[trianglenumber].x)].x " + vertices[(int) triangles[trianglenumber].x].x, "vertices[triangles[trianglenumber].x)].y " + vertices[(int) triangles[trianglenumber].x].y, "vertices[triangles[trianglenumber].x)].z " + vertices[(int) triangles[trianglenumber].x].z);
              println("vertices[triangles[trianglenumber].y)].x " + vertices[(int) triangles[trianglenumber].y].x, "vertices[triangles[trianglenumber].y)].y " + vertices[(int) triangles[trianglenumber].y].y, "vertices[triangles[trianglenumber].y)].z " + vertices[(int) triangles[trianglenumber].y].z);
              println("vertices[triangles[trianglenumber].z)].x " + vertices[(int) triangles[trianglenumber].z].x, "vertices[triangles[trianglenumber].z)].y " + vertices[(int) triangles[trianglenumber].z].y, "vertices[triangles[trianglenumber].z)].z " + vertices[(int) triangles[trianglenumber].z].z);
            }
          } // for triangoeNumber
        } // for ColumnCount
    } // for RowCount
    TheTerrainShape.endShape();
    TerrainExists = true;
    
  } // end of CreateTheTerrain() method
    
  // Draws the created shape for the terrain against the PShape object owned by this terrain object (whichever one this is..)
  // when drawing, it will refer to this as TheTerrainShape
  void DrawTheTerrain() {
    if (this.TerrainExists == true) {
        pushMatrix();
        translate(-1, 0, 0);
        shape(this.TheTerrainShape);
        popMatrix();
    }
  }
  
  // create a getter for Rows
  int getRows() {
    return this.Rows;
  }
  
  // create a getter for Columns
  int getColumns() {
    return this.Columns;
  }
  
  // create a getter for TerrainSize
  float getTerrainSize() {
    return this.TerrainSize;
  }
  
  // create a getter for Stroke
  boolean getStroke() {
    return this.Stroke;
  }
  
  // create a getter for Color
  boolean getColor() {
    return this.Color;
  }
  
  // create a getter for Blend
  boolean getBlend() {
    return this.Blend;
  }
 
  // create a getter for HeightModifier
  float getHeightModifier() {
    return this.HeightModifier;
  }
  
  // create a getter for SnowThreshold
  float getSnowThreshold() {
    return this.SnowThreshold;
  }
  
  // create a getter for FileName
  String getFileName() {
    return FileName;
  }
} // End of TerrainClass


class Mycamera{
  float radius = 220;
  int   count  = 0;
  ArrayList<PVector> TargetList = new ArrayList<PVector>();
  PVector lookatTarget          = new PVector(0,0,0);
  PVector cameraPosition        = new PVector(0,0,0);
  float   Phi = PI;
  float   Theta = PI/2;
  float   derivedX;
  float   derivedY;
  float   derivedZ;
  float   CurrentX = 0;
  float   CurrentY = 0;
  
  Mycamera(){
  }
  
  void setDelta( float DeltaXUpdate, float DeltaYUpdate) {
    //mousex and mousey for theta and phi
    CurrentX = DeltaXUpdate + CurrentX;
    CurrentY = DeltaYUpdate + CurrentY;
  }
  void Update(){
    
    Zoom(scroll);
    scroll = 0;
    
    Phi    = map(CurrentX, 0, width - 1, 0, 2*PI);
    Theta  = map(CurrentY, 1, height - 1, 0, PI);
      //Phi   = Phi + deltaX;
      //Theta = Phi + deltaY;
    
    
    derivedX = radius * cos(Phi) * sin(Theta);
    derivedY = radius * cos(Theta);
    derivedZ = radius * sin(Theta) * sin(Phi);
    
    cameraPosition.x = 50.0f + derivedX;
    cameraPosition.y = 50.0f + derivedY;
    cameraPosition.z = 50.0f + derivedZ;

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
    if(radius < 10){
      radius = 10;
    }
    if(radius > 1420){
      radius = 1420;
    }
  }
} 
  
void mouseDragged() {
  if(cp5.isMouseOver())  {
    //println("test");
    return;
  } 
  object1.setDelta( ( (mouseX - pmouseX) * 0.95f) , ((mouseY - pmouseY) * 0.95f) );
}
  
void keyPressed() {
    //object1.CycleTarget();
  }

void mouseWheel(MouseEvent event) {
  scroll = 20*event.getCount();
  println(scroll);
} 

// For some reason, the startup always calls this once and that causes it to think the user hit the button...
// so a variable to reset whenever the startup is complete...
boolean FirstGENERATE = false;
void GENERATE(float theValue) {
  if (FirstGENERATE == false) {
    FirstGENERATE = true;
  } else {
    println("got a button press and will now draw the terrain.");
    TheTerrain.CreateTheTerrain();
  }  
}


void controlEvent(ControlEvent theEvent) {
  if (theEvent.isAssignableFrom(Textfield.class)) {
    if (theEvent.getName() == "LOAD FROM FILE"){
      println("Asked to load file " + theEvent.getStringValue());
        TheTerrain.CreateTheTerrain();
    }
  }  
}
