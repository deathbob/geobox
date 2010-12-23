#include <NewSoftSerial.h>
#include <TinyGPS.h>
#include <LiquidCrystal.h>
#include <Servo.h>
// Had to copy old version of Servo library over from Arduino 16, because there's a conflict between the newer servo libary and 
// NewSoftSerial http://buildsomething.net/Projectblog/?p=37

// to get the gps coordinates of a location you are viewing in google maps.  
// from http://forums.gpsreview.net/viewtopic.php?t=3632
// javascript:void(prompt('',gApplication.getMap().getCenter()));

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
  lcd.print("Hello");
  lcd.setCursor(0,1);
  lcd.print("Mom and Dad");
  
}

void loop() {
  bool newdata = false;
  long lat = 0;
  long lon = 0;
  unsigned long age;
  String slat, slon;
  boolean they_won = false;
  float flat, flon, meters_away;
  float close_to_home;

  unsigned long start = millis();

  // Every 5 seconds we print an update
  while (millis() - start < 5000){
    if (feedgps()){
      newdata = true;
    }
  }
  
  attempts += 1;  
  Serial.println(attempts);
  
  if((attempts > 30) && (!newdata)){
  // we're probably inside, not getting a good gps signal
    Serial.println("Waiting for newdata");
    lcd.clear();
    lcd.print("Turn off, go");
    lcd.setCursor(0,1);
    lcd.print("outside, retry.");
    //         0123456789123456
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
    
    flat = lat / 100000.0;
    flon = lon / 100000.0;
    meters_away = distance_to_target(flat, flon);
    close_to_home = distance_to_home(flat, flon);
    
    Serial.println(meters_away);
        
    if ((meters_away < 18) || (close_to_home < 20)){
//      if ((meters_away < 18)){
      they_won = true;
      Serial.println("Unlock");
    
      lcd.clear();
  //    lcd.autoscroll();
      lcd.setCursor(0,0);
      lcd.print("You Win");
      lcd.setCursor(0,1);
      lcd.print("Box Unlocked!");
      myservo.write(130);

    }else{
      they_won = false;
   // Need to output to user how far they are
      Serial.println("Lock");

      lcd.clear();
      String foo;
      foo = String("Distance: ");
      foo += (long)meters_away;
      lcd.print(foo);
      
      lcd.setCursor(0,1);
      lcd.print("Meters");

      Serial.println(foo);

      myservo.write(0);      
    }
  }
  else{
    Serial.println("Nothing");
    lcd.clear();
    String bar;
    bar = String("Warming Up ");
//    bar += attempts;
    lcd.print(bar);
    lcd.setCursor(0,1);
    String pie;
    int bill = (attempts % 5);
    if(bill == 1){
      pie = String(".");
    }else if(bill == 2){
      pie = String("..");
    }else if(bill == 3){
      pie = String("...");
    }else if(bill == 4){
      pie = String("....");
    }else{
      pie = String(".....");
    }
    lcd.print(pie);
//    Serial.println(bill);
//    switch (bill){
//      case 0:
//        pie = String('.');
//        break;
//      case 1:
//        pie = String('..');
//        break;
//      case 2:
//        pie = String('...');
//        break;
//      case 3:
//        pie = String('....');
//        break;
//      case 4:
//        pie = String('.....');
//        break;
//      default:
//        pie = String('......');
//        break;
//    }  
//       lcd.print(pie);
  }


} // end loop


