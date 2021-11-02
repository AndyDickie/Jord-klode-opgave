//Variable til skabelse af jorden og radius for satelitten
float r = 200;
PImage earth;
PShape globe;

//Variable for hentning af data fra json fil.
JSONObject j;
JSONArray positionsJson;
JSONObject pos1;
JSONObject pos2;
float sat1Lon;
float sat1Lat;
float sat2Lon;
float sat2Lat;

//Variable til at finde x,y,z koordinator til først punkt.
float theta1;
float phi1;
float x1;
float y1;
float z1;

//Variable til at finde x,y,z koordinator til andet punkt.
float theta2;
float phi2;
float x2;
float y2;
float z2;

//Variable for de 2 punkters vektorer. 
PVector sat1;
PVector sat2;

//Variable for forskellige vinkler. 
float a;
float vinkel;
float angle;

void setup(){
  size(600, 600, P3D);
  earth = loadImage("earth.jpeg");
  j = loadJSONObject("https://api.n2yo.com/rest/v1/satellite/positions/25544/41.702/-76.014/0/2/&apiKey=E32S8H-SKGVV7-33UCWE-4SPN");
  positionsJson = j.getJSONArray("positions");
  pos1 = positionsJson.getJSONObject(0);
  pos2 = positionsJson.getJSONObject(1);
  sat1Lon = pos1.getFloat("satlongitude");
  sat1Lat = pos1.getFloat("satlatitude");
  sat2Lon = pos2.getFloat("satlongitude");
  sat2Lat = pos2.getFloat("satlatitude");
  noStroke();
  globe = createShape(SPHERE, r);
  globe.setTexture(earth);
  frameRate(120);
  //println(sat1Lon,sat1Lat);
  //println(sat2Lon,sat2Lat);
  //println(degrees(a));
  //println(Kryds);
  // timestamp ...
  // new Date(timestamp * 1000)
}

void draw() {
  background(51);
  lights();
  fill(200);
  noStroke();

//Vinklen som både jorden og satelitten drejer rundt med. 
  angle += 0.0001; 
  
//Rotering af jord kloden 
  pushMatrix();
  translate(width*0.5, height*0.5);
  rotateY(angle);
  shape(globe);
  popMatrix();
  
//Latitude og lonitude fra første punkt bliver lavet om til x,y,z koordinator. 
  theta1 = radians(sat1Lat);
  phi1 = radians(sat1Lon) + PI;
  x1 = (r+12) * cos(theta1) * cos(phi1);
  y1 = -(r+12) * sin(theta1);
  z1 = -(r+12) * cos(theta1) * sin(phi1);

//Latitude og lonitude fra andet punkt bliver lavet om til x,y,z koordinator. 
  theta2 = radians(sat2Lat);
  phi2 = radians(sat2Lon) + PI;
  x2 = (r+12) * cos(theta2) * cos(phi2);
  y2 = -(r+12) * sin(theta2);
  z2 = -(r+12) * cos(theta2) * sin(phi2);
  
//Laver vektor til de 2 punkter og finder vinkel mellem. 
  sat1 = new PVector(x1,y1,z1);
  sat2 = new PVector(x2,y2,z2);
  a = PVector.angleBetween(sat1,sat2);
 
//Her findes den krydsproduktet af de 2 vektorer så den kan dreje rundt 
   PVector Kryds = sat2.cross(sat1);
 
//Her laves vinklen så den bliver ved med at dreje rundt og ikke kører en fikst bane
  vinkel = vinkel + a;

//Her tegnes satelitten hvor den så bliver roteret rundt om kloden. 
   pushMatrix();
   translate(width/2,height/2);
   rotateY(angle);
   rotate(-vinkel, Kryds.x,Kryds.y,Kryds.z);
   translate(sat2.x,sat2.y,sat2.y);
   fill(255,0,204);
   box(2);
   popMatrix();
}
