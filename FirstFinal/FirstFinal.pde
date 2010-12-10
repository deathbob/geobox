#include <NewSoftSerial.h>
#include <TinyGPS.h>
#include <LiquidCrystal.h>
#include <Servo.h>
// Had to copy old version of Servo library over from Arduino 16, because there's a conflict between the newer servo libary and 
// NewSoftSerial http://buildsomething.net/Projectblog/?p=37

TinyGPS gps;
NewSoftSerial nss(2, 3);
LiquidCrystal lcd(10, 12, 5, 6, 7, 8);
Servo myservo;

void gpsdump(TinyGPS &gps);
bool feedgps();
void printFloat(double f, int digits = 2);
int attempts = 0;
int pos = 0;

void setup()
{
  Serial.begin(115200);
  nss.begin(4800);
  
  myservo.attach(9, 900, 1900);
  myservo.write(0);
  
  // set up the LCD's number of columns and rows: 
  lcd.begin(16, 2);
  // Print a message to the LCD.
  lcd.print("HELLO");
  lcd.setCursor(0,1);
  lcd.print("Mom and Dad");
  
}

void loop() {
  bool newdata = false;
  long lat = 0;
  long lon = 0;
  unsigned long age;
  String slat, slon;

  unsigned long start = millis();

  // Every 5 seconds we print an update
  while (millis() - start < 5000){
    if (feedgps()){
      newdata = true;
    }
    attempts += 1;
  }
  
  if((attempts > 12) && (!newdata)){
  // we're probably inside, not getting a good gps signal
    Serial.println("Waiting for newdata");
    lcd.clear();
    lcd.print("Take Me Outside");
  }else if(newdata){

    gps.get_position(&lat, &lon, &age);
    slat = "Lat: ";
    slon = "Lon: ";
    slat += lat;
    slon += lon;
//    lcd.setCursor(0, 0);
//    lcd.print(slat);
//    lcd.setCursor(0, 1);
//    lcd.print(slon);
    Serial.println(slat);
    Serial.println(slon);
  }
  else{
    Serial.println("Nothing");
    lcd.clear();
    lcd.print("Warming Up");
  }
  
  // Here's where we lock / unlock the box
  
    float flat = lat / 100000.0;
    float flon = lon / 100000.0;
    float meters_away = distance_to_target(flat, flon);
    Serial.println(meters_away);
  
  
  if (meters_away < 11){
//  if (in_range(lat, lon)){
    // unlock
    Serial.println("Unlock");
    
    lcd.clear();
//    lcd.autoscroll();
    lcd.setCursor(0,0);
    lcd.print("You Win");
    lcd.setCursor(0,1);
    lcd.print("Box Unlocked!");
    myservo.write(150);
  }else{
    // Need to output to user how far they are
    Serial.println("Lock");

    lcd.clear();
    lcd.setCursor(0,0);
    lcd.print("Distance: ");
    lcd.setCursor(0,1);
    String foo = "";
    foo += (int)meters_away;
    foo += ' meters'; 
    lcd.print(foo);
    myservo.write(0);
  }

  
//  myservo.write(90);
//  delay(15);
//  myservo.write(145);
//  delay(15);
//  myservo.write(180);
//  delay(15);
} // end loop


