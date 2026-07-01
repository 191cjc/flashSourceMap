package hotpointgame.utils.gsound
{
   import flash.media.*;
   import hotpointgame.utils.*;
   import hotpointgame.utils.gameloader.*;
   
   public class SoundManager
   {
      
      private static var s:Sound;
      
      private static var sc:SoundChannel;
      
      private static var curs:String = "";
      
      private static var frameArr:Object = new Object();
      
      public function SoundManager()
      {
         super();
      }
      
      public static function playSenceSound(param1:String) : void
      {
         if(param1 != "")
         {
            if(curs != param1)
            {
               if(curs != "")
               {
                  if(sc != null)
                  {
                     sc.stop();
                  }
               }
               curs = param1;
               if(param1 == "mp3kaichang")
               {
                  s = new (ClassGet.getClassByName(param1))() as Sound;
               }
               else
               {
                  s = new (LoaderManager.getSwfClass(param1))() as Sound;
               }
               sc = s.play(0,99999999);
            }
         }
      }
      
      public static function playOnlySound(param1:String) : void
      {
         var _loc2_:Sound = new (LoaderManager.getSwfClass(param1))() as Sound;
         _loc2_.play();
      }
      
      public static function playOnlySoundByMain(param1:String) : void
      {
         var _loc2_:Sound = new (ClassGet.getClassByName(param1))() as Sound;
         _loc2_.play();
      }
      
      public static function gmUpdate() : void
      {
         var _loc1_:String = null;
         for(_loc1_ in frameArr)
         {
            playOnlySound(_loc1_);
         }
         frameArr = new Object();
      }
      
      public static function addOnlySound(param1:String) : void
      {
         frameArr[param1] = param1;
      }
   }
}

