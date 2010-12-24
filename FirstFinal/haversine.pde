// from http://www.arduino.cc/cgi-bin/yabb2/YaBB.pl?num=1289758124/15
float haverSine(float lat1, float lon1, float lat2, float lon2)
{
  float ToRad = PI / 180.0;
//  float R = 6371;   // radius earth in Km, change for other planets :)
  float R = 6371000; // radius earth in meters
  
  float dLat = (lat2-lat1) * ToRad;
  float dLon = (lon2-lon1) * ToRad;
  
  float a = sin(dLat/2) * sin(dLat/2) +
        cos(lat1 * ToRad) * cos(lat2 * ToRad) *
        sin(dLon/2) * sin(dLon/2);
        
  float c = 2 * atan2(sqrt(a), sqrt(1-a));
  
  float d = R * c;
  return d;
}


float distance_to_target(float lat1, float lon1){
  // to get the gps coordinates of a location you are viewing in google maps.  
// from http://forums.gpsreview.net/viewtopic.php?t=3632
// javascript:void(prompt('',gApplication.getMap().getCenter()));

// lift coffee  (37.547084, -77.444196)
//  float my_lat = 37.547084;
//  float my_lon = -77.444196;

// top of mom and dad's driveway, 4900 old buckingham road // (37.52361393, -77.99548119)
//  float my_lat = 37.52361393;
//  float my_lon = -77.99548119;
  
// pillar south west of byrd park
// (37.541307496385436, -77.48317390680313)
// 37.54131, -77.48323
//  float my_lat = 37.54131;
//  float my_lon = -77.48323;

// Rocks on north west side of Bell Isle
// (37.52795129999892, -77.45742872357368)
// 37.527951299, -77.457428723
// 37.52799, -77.4576
  float my_lat = 37.52799;
  float my_lon = -77.4576;

  float result = haverSine(lat1, lon1, my_lat, my_lon);
  return result;
}

float distance_to_home(float lat1, float lon1){
  // home being my house at 6526 stuart ave, 23226
  float my_lat = 37.58555;
  float my_lon = -77.52729;

  float result = haverSine(lat1, lon1, my_lat, my_lon);
  return result;
}


