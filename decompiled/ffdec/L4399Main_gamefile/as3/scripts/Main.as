package
{
   import flash.display.*;
   import flash.events.*;
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   
   public class Main extends MovieClip
   {
      
      public static var sg:Stage;
      
      public static var self:Main;
      
      public static var _4399_function_ad_id:String = "92d6cef76cd06829e088932fe9fd819b";
      
      public static var _4399_function_store_id:String = "3885799f65acec467d97b4923caebaae";
      
      public static var serviceHold:* = null;
      
      public static var fps:int = 30;
      
      internal var _4399_function_shop_id:String = "30ea6b51a23275df624b781c3eb43ac6";
      
      internal var _4399_function_payMoney_id:String = "10f73c09b41d9f41e761232f5f322f38";
      
      internal var _4399_function_union_id:String = "7c7a741b186b91e2975006321918345f";
      
      internal var _4399_function_rankList_id:String = "69f52ab6eb1061853a761ee8c26324ae";
      
      public function Main()
      {
         super();
         var _loc1_:int = int(GSSVT.SVTRandomvt);
         var _loc2_:int = int(GS.a0);
         if(stage)
         {
            this.gameinit();
         }
         else
         {
            addEventListener(Event.ADDED_TO_STAGE,this.gameinit);
         }
      }
      
      public function setHold(param1:*) : void
      {
         serviceHold = param1;
      }
      
      public function gameinit(param1:Event = null) : void
      {
         if(param1)
         {
            removeEventListener(Event.ADDED_TO_STAGE,this.gameinit);
         }
         Main.self = this;
         Main.sg = stage;
         Main.sg.quality = StageQuality.HIGH;
         Main.sg.align = StageAlign.TOP_LEFT;
         Main.sg.scaleMode = StageScaleMode.NO_SCALE;
         Main.sg.stageFocusRect = false;
         Main.fps = stage.frameRate;
         Main.sg.focus = Main.self;
         mouseEnabled = false;
         enabled = false;
         var _loc2_:int = int(GSSVT.SVTRandomvt);
         GM.gameInit();
      }
   }
}

