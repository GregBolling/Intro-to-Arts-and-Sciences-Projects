float hexRadius = 30; // Size of each hexagon

float startingX = 0;  // X "origin" of the hex group
float startingY = 0;  // Y "origin" of the hex group

// How many hexes in each direction (positive and negative
// Final count for any axis will be (hexCount*2 + 1)
int hexCount = 4; 

void setup()
{
  size(800, 800);
  pixelDensity(1);
  
  // Arbitrary starting point other than (0, 0) or (width/2, height/2)
  startingX = 300;
  startingY = 325;
}

void draw()
{
  background(128);
  
  // TODO: Uncomment this to make the hexes follow your mouse!
  //startingX = mouseX;
  //startingY = mouseY;
  
  // Draw a batch of hexes. The green one should be in the middle (hex coordinate: 0, 0)
  for (int j = -hexCount; j <= hexCount; j++)
  {
    float yStart = startingY + sin(radians(270)) * sqrt(3) * (j*hexRadius);
    for (int i = -hexCount; i <= hexCount; i++)
    {
        float xValue = startingX + cos(radians(30)) * sqrt(3) * (i*hexRadius);
        float yValue = yStart + sin(radians(30)) * sqrt(3) * (i*hexRadius);
        if (j == 0 && i == 0)
          fill(0, 200, 0);
        else
          fill(100);
        DrawHex(xValue, yValue, hexRadius);
    }
  }
  
  // This is the function you want to use in your project
  // TODO: replace mouseX/mouseY with the location of the hexagon you're drawing 
  //CartesianToHex(mouseX, mouseY, hexRadius, 1.0f, startingX, startingY);
  
  /*===== Test/Verify =====*/
  // Get a hex coordinate from the mouse cursor
  PVector hexCoordinate = CartesianToHex(mouseX, mouseY, hexRadius, 1.0f, startingX, startingY);
  
  fill(255);
  textSize(40);
  text("Coords: " + hexCoordinate.x + ", " + hexCoordinate.y, mouseX, mouseY);
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

// Convert a Cartesian X/Y coordinate to a hex coordinate
// Inputs:
//    x         -- The x-coordinate to be converted
//    y         -- The y-coordinate to be converted
//    hexRadius -- The radius of the hexagons
//    stepScale -- The scale of a "step" between hexagons (1.0f should be the default, higher if there is any gap)
//    xOrigin   -- The x "origin" of your coordinates, if you're starting from somewhere other than 0, 0
//    yOrigin   -- The y "origin" of your coordinates, if you're starting from somewhere other than 0, 0
//
// Return: A PVector containing the x, y value of an equivalent hex
//
/* Usage examples -- assuming:
    - a radius of 30,
    - no "gap" between hexes (i.e. a scale of 1.0f)
    - the first hexagon is centered at 0, 0,
    - then you could call this function with:
    CartesianToHex(anyX, anyY, 30, 1.0f, 0, 0);
    
    Given:
    - a radius of 42,
    - setting the "gap" to 5% of the distance between polygons (i.e. a scale of 1.05f)
    - the first hexagon is centered at the screen center (width/2, height/2),
    - then you could call this function with:
    CartesianToHex(anyX, anyY, 42, 1.05f, width/2, height/2);
*/
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
