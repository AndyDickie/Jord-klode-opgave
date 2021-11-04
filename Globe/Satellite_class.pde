class Satellite {
  String NoradID, name;
  color c;
  float speed;
  
  //Variable for de 2 punkters vektorer samt krydsproduktet mellem vektorerne.
  PVector position1;
  PVector position2;
  PVector kryds;
  
  //Variable til vinklem mellem vektoerne.
  float a;

  Satellite(String NoradID_, color c_) {
    NoradID = NoradID_;
    c = c_;
    JSONObject j = loadJSONObject("https://api.n2yo.com/rest/v1/satellite/positions/" + NoradID + "/41.702/-76.014/0/2/&apiKey=E32S8H-SKGVV7-33UCWE-4SPN");
    //Longtituden og lattituden hentes fra JSONObjectet
    float sat1Lon = j.getJSONArray("positions").getJSONObject(0).getFloat("satlongitude");
    float sat1Lat = j.getJSONArray("positions").getJSONObject(0).getFloat("satlatitude");
    float sat2Lon = j.getJSONArray("positions").getJSONObject(1).getFloat("satlongitude");
    float sat2Lat = j.getJSONArray("positions").getJSONObject(1).getFloat("satlatitude");
    
    //timestamp hentes fra JSON
    startUnixTime = j.getJSONArray("positions").getJSONObject(1).getLong("timestamp");
    
    //Navnet af satellitten hentes
    name = j.getJSONObject("info").getString("satname");

    //Højden af satelitten hentes og omregnes til km over overfladen (jordens radius er 6371 km)
    float h = ((6371 + j.getJSONArray("positions").getJSONObject(1).getFloat("sataltitude"))/6371) * r;
    
    //Latitude og longtitude omregnes til to PVector
    float theta1 = radians(sat1Lat);
    float phi1 = radians(sat1Lon) + PI;
    float theta2 = radians(sat2Lat);
    float phi2 = radians(sat2Lon) + PI;
    
    //De kartesiske koordinaer kan nu beregnes. Dette laves til to PVectorer
    position1 = new PVector(h * cos(theta1) * cos(phi1), -h * sin(theta1), -h * cos(theta1) * sin(phi1));
    position2 = new PVector(h * cos(theta2) * cos(phi2), -h * sin(theta2), -h * cos(theta2) * sin(phi2));
    
    //Vinklem mellem de to vektorer findes
    a = PVector.angleBetween(position1, position2);
    
    //krydsprodukt
    kryds = position1.cross(position2);
    
    //speed er en konstant der tillæges vinklen a. Det betyder at for hver frame, går der 5 sekunder i virkeligheden
    speed = a * 5;
  }
  
  void update(){
    //Hastigheden lægges til vinklen for at få satelliten til at bevæge sig
    a += speed;
    
    //Satelittens roterer med vinklen a om kloden
    pushMatrix();
    rotate(a, kryds.x, kryds.y, kryds.z);
    translate(position1.x, position1.y, position1.z);
    fill(c);
    box(20);
    popMatrix();
  }
}
