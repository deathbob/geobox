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
  float my_lat = 37.58555;
  float my_lon = -77.52729;

  float result = haverSine(lat1, lon1, my_lat, my_lon);
  return result;
}
