package hotpointgame.common
{
   public class GSSVT
   {
      
      public static var ags:GSSVT = new GSSVT();
      
      private var SVTRandom:SVT = SVT.createSVT(700);
      
      private var SVTra:SVT = SVT.createSVT(5);
      
      private var SVTrb:SVT = SVT.createSVT(2);
      
      private var SVTrc:SVT = SVT.createSVT(1);
      
      public function GSSVT()
      {
         super();
      }
      
      public static function get SVTRandomvt() : Number
      {
         return ags.SVTRandom.getValue();
      }
      
      public static function get SVTravt() : Number
      {
         return ags.SVTra.getValue();
      }
      
      public static function get SVTrbvt() : Number
      {
         return ags.SVTrb.getValue();
      }
      
      public static function get SVTrcvt() : Number
      {
         return ags.SVTrc.getValue();
      }
   }
}

