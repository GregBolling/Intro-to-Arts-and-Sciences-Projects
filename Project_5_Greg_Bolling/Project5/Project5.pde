import java.io.*;    // Needed for BufferedReader
import queasycam.*;
import controlP5.*;

QueasyCam cam;
ControlP5 cp5;
float xPos = 150;
float zPos = 300;
float speed = 1.0f;

ArrayList<Scene> scenes = new ArrayList<Scene>();
Scene myscene = new Scene();
Scene myscenetwo = new Scene();

int currentScene = 0;
void setup()
{
  size(1200, 1000, P3D);
  pixelDensity(2);
  perspective(radians(60.0f), width/(float)height, 0.1, 1000);
  
  cp5 = new ControlP5(this);
  cp5.addButton("ChangeScene").setPosition(10, 10);
  
  cam = new QueasyCam(this);
  cam.speed = 0;
  cam.sensitivity = 0;
  cam.position = new PVector(0, -50, 100);

  // TODO: Load scene files here (testfile, scene 1, and scene 2)
  
  lights(); // Lights turned on once here
  
  myscene.StoreVariables("scenes/scene1.txt");
  scenes.add(myscene);
  myscenetwo.StoreVariables("scenes/scene2.txt");
  scenes.add(myscenetwo);
  
  
}

void draw()
{
  // Use lights, and set values for the range of lights. Scene gets REALLY bright with this commented out...
  lightFalloff(1.0, 0.001, 0.0001);
  perspective(radians(60.0f), width/(float)height, 0.1, 1000);
  pushMatrix();
  rotateZ(radians(180)); // Flip everything upside down because Processing uses -y as up
  
  // TODO: Draw the current scene
  
  scenes.get(currentScene).DrawScene();

  popMatrix();

  camera();
  perspective();
  noLights(); // Turn lights off for ControlP5 to render correctly
  DrawText();
}

void mousePressed()
{
  if (mouseButton == RIGHT)
  {
    // Enable the camera
    cam.sensitivity = 1.0f; 
    cam.speed = 2;
  }

}

void mouseReleased()
{  
  if (mouseButton == RIGHT)
  {
    // "Disable" the camera by setting move and turn speed to 0
    cam.sensitivity = 0; 
    cam.speed = 0;
  }
}

void ChangeScene()
{
  currentScene++;
  if (currentScene >= scenes.size())
    currentScene = 0;
}

void DrawText()
{
  textSize(30);
  text("PShapes: " + scenes.get(currentScene).GetShapeCount() , 0, 60); // was shifted down to make space for the button
  text("Lights: "  + scenes.get(currentScene).GetLightCount() , 0, 90);
}





class Scene
{
  
  // TODO: Write this class!
  /*
    Things you'll need:
    Some way to store PShapes and their positions
    Some way to store lights--position plus color for the pointLight() function
    Other classes may be helpful here
    A background color for the scene
  */
  
  int linecounter = 0;
  ArrayList<Integer> RGBBackground = new ArrayList<Integer>();
  
  int numberofMeshes;
  ArrayList<String> MeshName = new ArrayList<String>();
  ArrayList<PVector> MeshPosition = new ArrayList<PVector>();
  ArrayList<PVector> MeshColor = new ArrayList<PVector>();
 
  int numberofLights;
  ArrayList<PVector> LightPosition = new ArrayList<PVector>();
  ArrayList<PVector> LightColor = new ArrayList<PVector>();
  
  
  BufferedReader reader;
  String line;
  int i = 0;
  
  String[] previouspieces;
  
  void StoreVariables(String file){
    
    reader = createReader(file);
    
      try {
      line = reader.readLine();
    } catch (IOException e) {
      e.printStackTrace();
      line = null;
    }
    
    try {
    while (line != null) {
      linecounter++;                           // tells me which line I am reading
      String[] pieces = split(line, ",");
      
      if(pieces.length == 3){                     // this means that it is a rgb background
      RGBBackground.add(Integer.parseInt(pieces[0]));
      RGBBackground.add(Integer.parseInt(pieces[1]));
      RGBBackground.add(Integer.parseInt(pieces[2]));
      } 
      
      if((pieces.length == 1) && (linecounter == 2)){                //this means that it is the start of the meshes
        
        numberofMeshes = Integer.parseInt(pieces[0]);
        
        for(int x = 0; x < numberofMeshes; x++){
        line = reader.readLine();
        pieces = split(line, ",");
        
        MeshName.add(pieces[0]);
        
        float locationx = Float.parseFloat(pieces[1]);
        float locationy = Float.parseFloat(pieces[2]);
        float locationz = Float.parseFloat(pieces[3]);
        PVector MeshPositionAdd = new PVector(locationx,locationy,locationz);
        MeshPosition.add(MeshPositionAdd);
        
        int rgbx = Integer.parseInt(pieces[4]);
        int rgby = Integer.parseInt(pieces[5]);
        int rgbz = Integer.parseInt(pieces[6]);
        PVector MeshColorAdd = new PVector(rgbx,rgby,rgbz);
        MeshColor.add(MeshColorAdd);
        
        }
      }
        
       if((pieces.length == 1) && (linecounter != 2) && (previouspieces.length != 6)){                //this means that it is the start of the lights
        
        numberofLights = Integer.parseInt(pieces[0]);
        
        for(int x = 0; x < numberofLights; x++){
        line = reader.readLine();
        pieces = split(line, ",");
        
        float locationx = Float.parseFloat(pieces[0]);
        float locationy = Float.parseFloat(pieces[1]);
        float locationz = Float.parseFloat(pieces[2]);
        PVector LightPositionAdd = new PVector(locationx,locationy,locationz);
        LightPosition.add(LightPositionAdd);
        
        
        int rgbx = Integer.parseInt(pieces[3]);
        int rgby = Integer.parseInt(pieces[4]);
        int rgbz = Integer.parseInt(pieces[5]);
        PVector LightColorAdd = new PVector(rgbx,rgby,rgbz);
        LightColor.add(LightColorAdd);
        
        
        }
        
        
      }
      
      line = reader.readLine();
      previouspieces = pieces;
    }
    reader.close();
  } catch (IOException e) {
    e.printStackTrace();
  }
    
  }
  
  
  
  int GetShapeCount(){
    return this.numberofMeshes;
  }
  
  int GetLightCount(){
    return this.numberofLights;
  }
  
  
  
  void DrawScene()
  {
    // TODO: Draw all the information in this scene
    /*
      Just like using draw() with a regular sketch, things you would need to do
      Clear the screen with background()
      Set up any lights in this scene
      Draw each object in the correct location
    */
    
    //first add the background color
    background(RGBBackground.get(0), RGBBackground.get(1), RGBBackground.get(2));
    
    //second set up the lights
    int currentlightindex = 0;
    
    while(LightPosition.size() != currentlightindex){
    
      
    PVector lightposition = LightPosition.get(currentlightindex);
    PVector lightrgbcolor = LightColor.get(currentlightindex);
    pointLight(lightrgbcolor.x, lightrgbcolor.y, lightrgbcolor.z, lightposition.x, lightposition.y, lightposition.z);
    currentlightindex++;
    }
    
    // third add all of the shapes
    int currentindex = 0;
    
    while(MeshName.size() != currentindex){
    
    
    PShape s = loadShape("models/" + MeshName.get(currentindex) + ".obj");
    PVector translation = MeshPosition.get(currentindex);
    PVector rgbcolor = MeshColor.get(currentindex);
    
    s.setStroke(true);
    s.setStroke(color(rgbcolor.x, rgbcolor.y, rgbcolor.z));
    
    s.setFill(color(rgbcolor.x, rgbcolor.y, rgbcolor.z));
    
    pushMatrix();
    translate(translation.x,translation.y, translation.z );
    shape(s);
    popMatrix();
    
    currentindex++;
    
    }
    
    
    
  }
}
