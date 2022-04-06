
/* *** English version under construction *** 
 *  For more information feel free to contact me
 * 
 * Projekt iz predmeta Elektroakustika - Radarski sustav 
 */

import processing.serial.*;     //biblioteka za serijsku komunikaciju
import java.awt.event.KeyEvent; //biblioteka za citanje podataka sa Serial porta
import java.io.IOException;

Serial myPort;                  // definiranje serijskog porta


// deklaracija varijabli
String kut="";
String udaljenost="";
String data="";
String noObject;
float pixsUdaljenost;
int iAngle, iDistance;
int index1=0;
int index2=0;
PFont orcFont;



void setup() {

    size (1920, 1080); 
    
    smooth();
    myPort = new Serial(this, "COM5", 9600);     // zapocni serijsku komunikaciju, definiranje porta COM5, BAUDRATE 9600
    myPort.bufferUntil('.');                     // citaj podatke od serijskog porta do znaka '.', odnosno procitaj: kut, udaljenost
    //orcFont = loadFont("OCRAExtended-30.vlw");
}


//funkcija za crtanje u kojoj se pozivaju sve ostale funkcije - cijelo vrijeme se izvršava
void draw() {

    fill(98, 245, 31);
    //textFont(orcFont);
    
    //  simulirano zamucenje pokreta i polagano nestajanje pokretne crte
    noStroke();
    fill(0, 4); 
    rect(0, 0, width, 1010);
  
  
    fill(98, 245, 31); // zelena boja kod ispisa
    
    // pozivanje funkcija za crtanje radara
    crtanje_radara_Fja(); 
    fja_crtanje_linija();
    crtanje_objekta_Fja();
    fja_ispis_teksta();
}



void serialEvent (Serial myPort) { // pocni citati podatke sa Serial Porta
  
    // cita podatke s serijskog ulaza to znaka '.', i sprema ih u varijablu tipa String (niz)
    data = myPort.readStringUntil('.');
    data = data.substring(0, data.length()-1);
  
    index1 = data.indexOf(",");                            // pronalazi znak ',' i stavlja ga u varijablu "index1"
    kut= data.substring(0, index1);                        // cita podatke od pozicije "0" do pozicije varijable "index1", te to predstavlja vrijednost kuta koji je Arduino plocica poslala na Serial port
    udaljenost= data.substring(index1+1, data.length());   // ocitava podatke od pozicije "index1" do kraja, i to sprema u varijablu "udaljenost" te to predstavlja udaljenost
  
    // pretvara varijable tipa String u Intiger
    iAngle = int(kut);
    iDistance = int(udaljenost);
}


// funkcija za crtanje radarskog sucelja
void crtanje_radara_Fja() {
    pushMatrix();
    translate(960, 1000);         // pomicanje pocetne koordinate na novu lokaciju
    noFill();
    strokeWeight(2);
    stroke(98, 245, 31);
    
    
    // crtanje zakrivljenih linija - lukova
    arc(0, 0, 1800, 1800, PI, TWO_PI);
    arc(0, 0, 1400, 1400, PI, TWO_PI);
    arc(0, 0, 1000, 1000, PI, TWO_PI);
    arc(0, 0, 600, 600, PI, TWO_PI);
    
    
    // crta linije kuta
    line(-960, 0, 960, 0);
    line(0, 0, -960*cos(radians(30)), -960*sin(radians(30)));
    line(0, 0, -960*cos(radians(60)), -960*sin(radians(60)));
    line(0, 0, -960*cos(radians(90)), -960*sin(radians(90)));
    line(0, 0, -960*cos(radians(120)), -960*sin(radians(120)));
    line(0, 0, -960*cos(radians(150)), -960*sin(radians(150)));
    line(-960*cos(radians(30)), 0, 960, 0);
    popMatrix();
}



void crtanje_objekta_Fja() {
    pushMatrix();
    translate(960, 1000);                // pomicanje pocetne koordinate na novu lokaciju
    strokeWeight(9);
    stroke(255, 10, 10);                 // oznaka crvene boja
    pixsUdaljenost = iDistance*22.5;     // pretvaranje udaljenost dobivenu od senzora iz cm u piksele
    
    // limitiranje domet na 40 cm
    if (iDistance<40) {
        
        // crta objekt na temelju vrijednosti kuta i udaljenosti 
        line(pixsUdaljenost*cos(radians(iAngle)), -pixsUdaljenost*sin(radians(iAngle)), 950*cos(radians(iAngle)), -950*sin(radians(iAngle)));
    }
    
    popMatrix();
}

void fja_crtanje_linija() {
    pushMatrix();
    strokeWeight(9);
    stroke(30, 250, 60);
    translate(960, 1000);                                            // pomicanje pocetne koordinate na novu lokaciju
    line(0, 0, 950*cos(radians(iAngle)), -950*sin(radians(iAngle))); // crtanje linije na temelju vrijednosti kuta
    popMatrix();
}



void fja_ispis_teksta() { // crtanje - ispisivanje tekst na zaslon

    pushMatrix();
    
    //ispisivanje rezultata za vrijednosti vecih udaljenijih od 40 cm
    if (iDistance>40) {
      noObject = "Izvan dometa";
    } else {
      noObject = "U dometu";
    }
    fill(0, 0, 0);
    noStroke();
    rect(0, 1010, width, 1080);
    fill(98, 245, 31);
    textSize(25);
    text("10cm", 1180, 990);
    text("20cm", 1380, 990);
    text("30cm", 1580, 990);
    text("40cm", 1780, 990);
    textSize(40);
    text("Objekt: " + noObject, 240, 1045);
    text("Kut: " + iAngle +" °", 1050, 1045);
    text("Udaljenost: ", 1380, 1045);
    
    
     //ispisivanje rezultata za vrijednosti na udaljenosti do 40 cm
    if (iDistance<40) {
      text("        " + iDistance +" cm", 1650, 1045);
      }
    textSize(25);
    fill(98, 245, 60);
    translate(961+960*cos(radians(30)), 982-960*sin(radians(30)));
    rotate(-radians(-60));
    text("30°", 0, 0);
    resetMatrix();
    translate(954+960*cos(radians(60)), 984-960*sin(radians(60)));
    rotate(-radians(-30));
    text("60°", 0, 0);
    resetMatrix();
    translate(945+960*cos(radians(90)), 990-960*sin(radians(90)));
    rotate(radians(0));
    text("90°", 0, 0);
    resetMatrix();
    translate(935+960*cos(radians(120)), 1003-960*sin(radians(120)));
    rotate(radians(-30));
    text("120°", 0, 0);
    resetMatrix();
    translate(940+960*cos(radians(150)), 1018-960*sin(radians(150)));
    rotate(radians(-60));
    text("150°", 0, 0);
    popMatrix();
}
