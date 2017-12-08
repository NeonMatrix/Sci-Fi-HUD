class MapStar
{
 boolean hab;
 String displayName;
 float distance;
 float xg, yg, zg;
 float mag;

 
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