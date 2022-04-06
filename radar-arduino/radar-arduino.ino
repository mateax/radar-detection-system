
/* *** English version under construction *** 
 *  For more information feel free to contact me
 * 
 * Projekt iz predmeta Elektroakustika - Radarski sustav 
 */


#include <Servo.h>. //pozivanje servo biblioteke

//  Deklariranje  i inicijalizacija varijabli za Trigger i Echo pin na Ultrasonic senzoru
//  Trigger  - spajamo na ulaz 10 od Arduina
//  Echo     - spajamo na ulaz 11 od Arduina

const int trigPin = 10; 
const int echoPin = 11;
 


//  Deklaracija varijable za trajanje i udaljenost
long trajanje;    // Varijabla 'trajanje', sprema vrijeme izmedu emisije i prijema signala
int udaljenost;   // Varijabla 'udaljenost', sprema vrijeme izmedu emisije i prijema signala
   
Servo myServo;  // kreiramo servo objekt za upravljanje motorom
                // library podržava maksimalno 8 motora

void setup() {              //zapocinjem serijsku komunikaciju
  pinMode(trigPin, OUTPUT); // postavlja varijablu trigPin kao OUTPUT (izlaz)
  pinMode(echoPin, INPUT);  // postavlja varijablu echoPin kao INPUT (ulaz)
  Serial.begin(9600);       // Funkcija koja zapocinje komunikaciju s 9600 baud-rateova, isti BAUD Rate potrebno postaviti u monitoru
  myServo.attach(12);   // Definira na koji signalni PWM pin je pricvrscen servo motor
}



void loop() {
  // funkcija koja rotira servo motor od 15 do 165 stupnjeva
  
  for(int i=15;i<=165;i++){                         //  motor se okrece od 15 do 165 stupnjeva, u koracima od jednog stupnja, varijabla 'i' predstavlja jedan stupanj
  myServo.write(i);                                 //  kazemo da servo motor provjeri varijablu i za poziciju
  delay(30);                                        //  cekamo 30ms da motor dode na zadanu poziciju

  //za svaki stupanj izracunavamo udaljenost
  udaljenost = izracunavanje_udaljenosti_F();       //  poziva funkciju za izracunavanje udaljenosti, izmjerene ultrazvucnim senzorom za svaki stupanj
 

  //vrijednosti saljemo na serijski port koje ce kasnije biti primjene i obradene u processingu
   
  Serial.print(i);                // Salje trenutnu vrijednost stupnja na Serial Port
  Serial.print(",");              // Salje dodatni (obicni) znak (character) "," odmah do prethodne vrijednosti (potrebno za kasnje u Processing IDE-u za indeksiranje)
  Serial.print(udaljenost);       // Salje vrijednost udaljenosti na Serial Port
  Serial.print(".");              // Salje dodatni (obicni) znak (character) "." odmah do prethodne vrijednosti (potrebno za kasnje u Processing IDE-u za indeksiranje)
  } 


  
  // Izracunavanje udaljenosti od 165 do 15 stupnjeva
  
  for(int i=165;i>15;i--){  
  myServo.write(i);
  delay(30);
  udaljenost = izracunavanje_udaljenosti_F();
  Serial.print(i);
  Serial.print(",");
  Serial.print(udaljenost);
  Serial.print(".");
  }
  
}


// Funkcija za izracunavanje udaljenosti izmjerene UltraSonic senzorom
int izracunavanje_udaljenosti_F(){ 
  
  digitalWrite(trigPin, LOW); 
  delayMicroseconds(2);
  
  digitalWrite(trigPin, HIGH);   // Postavlja trigPin na HIGH stanje (5V) na 10 mikro sekundi
  delayMicroseconds(10);
  digitalWrite(trigPin, LOW);    // Postavlja trigPin na LOW (0V) stanje 

  trajanje = pulseIn(echoPin, HIGH); // Ocitava vrijednosti varijable echoPin, vraca valnu brzinu zvuka u mikrosekundama
  udaljenost= trajanje*0.034/2;
  return udaljenost;
}
