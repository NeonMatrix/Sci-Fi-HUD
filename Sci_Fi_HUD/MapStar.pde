// This is a class for the stars you see on the star map
class MapStar
{
 boolean hab;
 String displayName;
 float distance;
 float xg, yg, zg;
 float mag;

 
 // this is the constructor which assigns each stars data from the data in the .csv file
 MapStar(TableRow row)
 {
   displayName = row.getString("Display Name");
   distance = row.getFloat("Distance");
   xg = row.getFloat("Xg");
   yg = row.getFloat("Yg");
   zg = row.getFloat("Zg");
   mag = row.getFloat("AbsMag");
 }
 
}