package hotpointgame.gview
{
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   import flash.utils.*;
   import hotpointgame.Control.*;
   import hotpointgame.utils.gameloader.*;
   
   public class GPkPingFeng
   {
      
      private static var self:GPkPingFeng = new GPkPingFeng();
      
      private static var curs:int = 0;
      
      private var mc:MovieClip;
      
      public function GPkPingFeng()
      {
         super();
      }
      
      public static function open(param1:int, param2:int, param3:int, param4:int, param5:int, param6:int, param7:int) : void
      {
         if(curs == 0)
         {
            self.reset(param1,param2,param3,param4,param5,param6,param7);
         }
      }
      
      public static function close() : void
      {
         self.leave();
      }
      
      public function reset(param1:int, param2:int, param3:int, param4:int, param5:int, param6:int, param7:int) : void
      {
         var _loc8_:Class = null;
         var _loc9_:Array = null;
         if(this.mc == null)
         {
            if(!LoaderManager.isLoadedBySwfname("map_0_4"))
            {
               if(GM.loaderM.keYiUse())
               {
                  _loc9_ = new Array();
                  _loc9_.push("map_0_4");
                  GM.loaderM.setLoadData(_loc9_);
                  GM.loaderM.completeF = open;
                  GM.loaderM.startLoadDataJieM();
                  return;
               }
               return;
            }
            _loc8_ = LoaderManager.getSwfClass("sjpkjs") as Class;
            this.mc = new _loc8_() as MovieClip;
            this.mc.stop();
            this.mc.x = 19563;
            this.mc.y = 29563;
         }
         curs = 1;
         this.mc.x = 0;
         this.mc.y = 0;
         (this.mc["sbabc"] as MovieClip).gotoAndStop(param1);
         (this.mc["jb"] as TextField).text = String(param2);
         (this.mc["jiashu"] as TextField).text = "连胜奖励: " + param3;
         (this.mc["jiashudj"] as TextField).text = "战力等级: " + param4;
         (this.mc["lsjl"] as TextField).text = String("" + param5 + "/" + param6);
         (this.mc["gwjsxgxiaotiao"]["xgxiaotiaoa"] as MovieClip).scaleX = param5 / param6;
         (this.mc["pkhao"] as TextField).text = "本场得分" + param7;
         this.mc.addEventListener(MouseEvent.CLICK,this.mcClick);
         GM.cbGview.addChild(this.mc);
      }
      
      public function leave() : void
      {
         if(curs == 1)
         {
            curs = 0;
            this.mc.x = 19563;
            this.mc.y = 29563;
            this.mc.removeEventListener(MouseEvent.CLICK,this.mcClick);
            GM.cbGview.removeChild(this.mc);
            this.mc = null;
         }
      }
      
      private function mcClick(param1:MouseEvent) : void
      {
         if(getQualifiedClassName(param1.target) == "snew")
         {
            close();
            GM.levelm.changeLevelBackCity();
         }
      }
   }
}

