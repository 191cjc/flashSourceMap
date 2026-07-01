package hotpointgame.gview
{
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   import flash.utils.*;
   import hotpointgame.Control.*;
   import hotpointgame.utils.gameloader.*;
   
   public class GgfPingFeng
   {
      
      private static var self:GgfPingFeng = new GgfPingFeng();
      
      private static var curs:int = 0;
      
      private var mc:MovieClip;
      
      public function GgfPingFeng()
      {
         super();
      }
      
      public static function open(param1:int) : void
      {
         if(curs == 0)
         {
            self.reset(param1);
         }
      }
      
      public static function close() : void
      {
         self.leave();
      }
      
      public function reset(param1:int) : void
      {
         var _loc2_:Class = null;
         var _loc3_:Array = null;
         if(this.mc == null)
         {
            if(!LoaderManager.isLoadedBySwfname("map_0_9"))
            {
               if(GM.loaderM.keYiUse())
               {
                  _loc3_ = new Array();
                  _loc3_.push("map_0_9");
                  GM.loaderM.setLoadData(_loc3_);
                  GM.loaderM.completeF = open;
                  GM.loaderM.startLoadDataJieM();
                  return;
               }
               return;
            }
            _loc2_ = LoaderManager.getSwfClass("jtzjl") as Class;
            this.mc = new _loc2_() as MovieClip;
            this.mc.stop();
            this.mc.x = 19563;
            this.mc.y = 29563;
         }
         curs = 1;
         this.mc.x = 0;
         this.mc.y = 0;
         (this.mc["pkhao"] as TextField).text = "" + param1;
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
         if(getQualifiedClassName(param1.target) == "snewb")
         {
            close();
            GM.levelm.changeLevelBackCity();
         }
      }
   }
}

