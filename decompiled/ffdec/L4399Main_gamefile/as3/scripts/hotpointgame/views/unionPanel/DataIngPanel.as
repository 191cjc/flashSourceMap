package hotpointgame.views.unionPanel
{
   import flash.display.MovieClip;
   import flash.text.*;
   import hotpointgame.Control.*;
   import hotpointgame.utils.gameloader.*;
   
   public class DataIngPanel extends MovieClip
   {
      
      private static var _instance:DataIngPanel;
      
      private var tsMc:MovieClip;
      
      public function DataIngPanel()
      {
         super();
      }
      
      public static function open(param1:String = "数据加载中") : void
      {
         var _loc2_:Object = null;
         if(_instance == null)
         {
            _instance = new DataIngPanel();
            _loc2_ = LoaderManager.getSwfClass("oTs_2") as Class;
            _instance.tsMc = new _loc2_();
            _instance.addChild(_instance.tsMc);
            _instance.tsMc.textName.embedFonts = true;
            _instance.tsMc.textName.defaultTextFormat = new TextFormat(GM.fzfont.fontName,22);
         }
         GM.fone.addChild(_instance);
         _instance.tsMc.textName.text = param1;
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

