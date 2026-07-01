package hotpointgame.gaction
{
   public class RANGongAir extends RANGong
   {
      
      public function RANGongAir(param1:String)
      {
         super(param1);
         nameA = "跳射1";
         nameB = "跳射2";
         nameC = "跳射3";
         nameD = "跳射4";
         pauseKey = {
            "跳射1":9,
            "跳射2":6,
            "跳射3":17,
            "跳射4":14
         };
      }
   }
}

