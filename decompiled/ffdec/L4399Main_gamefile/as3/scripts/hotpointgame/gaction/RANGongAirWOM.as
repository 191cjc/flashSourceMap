package hotpointgame.gaction
{
   public class RANGongAirWOM extends RANGong
   {
      
      public function RANGongAirWOM(param1:String)
      {
         super(param1);
         nameA = "跳射1";
         nameB = "跳射2";
         nameC = "跳射3";
         nameD = "跳射4";
         pauseKey = {
            "跳射1":15,
            "跳射2":15,
            "跳射3":15,
            "跳射4":12
         };
      }
   }
}

