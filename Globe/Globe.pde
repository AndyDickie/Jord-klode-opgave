float r;
Satellite iss;
PShape globe;
float time = 0;
ArrayList<Satellite> satellites = new ArrayList<Satellite>();
float rotationY = 0.01;

void setup() {
  noStroke();

  //Variable til skabelse af jorden og radius for satelitten, radius er i forholdet 1:10 km
  r = 637.1;
  PImage earth = loadImage("earth.jpeg");
  globe = createShape(SPHERE, r);
  globe.setTexture(earth);

  //Kamera og skærm laves
  size(1000, 1000, P3D);
  translate(0, 0, 0);
  camera(0, 0, 3000, 0, 0, 0, 0, 1, 0);

  //satelitterne oprettes
  satellites.add(new Satellite("25544", color(255, 204, 0)));
  satellites.add(new Satellite("23415", color(100, 204, 200)));
}

void draw() {
  Rotate();

  //tegn kloden
  background(0);
  rotateY(rotationY);
  shape(globe);
  rotateY(-rotationY);

  //tegn satelitterne og 
  for (int i = 0; i <= satellites.size()-1; i++) {
    Satellite s = satellites.get(i);
    rotateY(rotationY);
    s.update();
    rotateY(-rotationY);
  }
  
  //Textfelt med den forløbne tid
  textSize(100);
  text(time + " seconds", -1000, -1000);
  time += 5;
}

//funktionen roterer satelitterne og kloden om y aksen
void Rotate() {
  if (keyPressed) {
    if (keyCode == LEFT) {
      rotationY += 0.01;
    }
    if (keyCode == RIGHT) {
      rotationY -= 0.01;
    }
  }
}
