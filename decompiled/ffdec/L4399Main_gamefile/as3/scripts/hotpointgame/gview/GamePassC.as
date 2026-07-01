package hotpointgame.gview
{
   import flash.display.*;
   import flash.events.*;
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   import hotpointgame.ginit.*;
   import hotpointgame.utils.gameloader.*;
   
   public class GamePassC
   {
      
      private static var self:GamePassC = new GamePassC();
      
      private static var curs:int = 0;
      
      private var mc:MovieClip;
      
      private var mcMO:Object = new Object();
      
      public function GamePassC()
      {
         super();
      }
      
      public static function open() : void
      {
         if(curs == 0)
         {
            self.reset();
            curs = 1;
         }
      }
      
      public static function close() : void
      {
         self.leave();
      }
      
      public function reset() : void
      {
         var _loc2_:Class = null;
         if(this.mc == null)
         {
            _loc2_ = LoaderManager.getSwfClass("guoguanxuanze") as Class;
            this.mc = new _loc2_() as MovieClip;
            this.mc.stop();
            this.mc.x = 19563;
            this.mc.y = 29563;
         }
         this.mc.x = 0;
         this.mc.y = 0;
         var _loc1_:McBtnLianDong = new McBtnLianDong();
         _loc1_.addBtnLianDong(new McBtn(this.mc["jixutiaozhan"]));
         _loc1_.addBtnLianDong(new McBtn(this.mc["xuanzheguanka"]));
         _loc1_.addBtnLianDong(new McBtn(this.mc["fanhuijidi"]));
         this.mcMO["btnbtn"] = _loc1_;
         GM.cbGview.addChild(this.mc);
         this.mc.addEventListener(MouseEvent.CLICK,this.mcClick);
      }
      
      public function leave() : void
      {
         if(curs == 1)
         {
            curs = 0;
            this.mc.x = 19563;
            this.mc.y = 29563;
            (this.mcMO["btnbtn"] as McBtnLianDong).remove();
            this.mcMO = new Object();
            this.mc.removeEventListener(MouseEvent.CLICK,this.mcClick);
            GM.cbGview.removeChild(this.mc);
         }
      }
      
      private function mcClick(param1:MouseEvent) : void
      {
         if(param1.target.name != null && Boolean((this.mcMO["btnbtn"] as McBtnLianDong).isFlase(param1.target.name)))
         {
            switch(param1.target.name)
            {
               case "jixutiaozhan":
                  GM.levelm.changeLevelBySelf();
                  this.leave();
                  break;
               case "xuanzheguanka":
                  if(GM.levelm.curLevel.id > GS.a2000 && GM.levelm.curLevel.id < GS.a2000 + GS.a100)
                  {
                     ClevelChooseNew.open();
                  }
                  else
                  {
                     CLevelChoose.open();
                  }
                  this.leave();
                  break;
               case "fanhuijidi":
                  GM.levelm.changeLevelBackCity();
                  this.leave();
            }
         }
      }
   }
}

