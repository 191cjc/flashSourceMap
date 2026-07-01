package hotpointgame.views.unionPanel
{
   import flash.display.MovieClip;
   import hotpointgame.Control.*;
   import hotpointgame.utils.*;
   
   public class DataIngPanelXX extends MovieClip
   {
      
      private static var _instance:DataIngPanelXX;
      
      private var tsMc:MovieClip;
      
      public function DataIngPanelXX()
      {
         super();
      }
      
      public static function open() : void
      {
         var _loc1_:Object = null;
         if(_instance == null)
         {
            _instance = new DataIngPanelXX();
            _loc1_ = ClassGet.getClassByName("oTs_m");
            _instance.tsMc = new _loc1_();
            _instance.addChild(_instance.tsMc);
            GM.fone.addChild(_instance);
         }
         _instance.visible = true;
         _instance.x = 0;
         _instance.y = 0;
      }
      
      public static function close() : void
      {
         _instance.visible = false;
         _instance.x = 5000;
         _instance.y = 5000;
      }
   }
}

