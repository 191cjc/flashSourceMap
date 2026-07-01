package hotpointgame.gview
{
   import flash.display.*;
   import flash.text.*;
   import hotpointgame.Control.*;
   import hotpointgame.utils.gameloader.*;
   
   public class BoosHpTiaoC
   {
      
      public static var self:BoosHpTiaoC = new BoosHpTiaoC();
      
      private static var curs:int = 0;
      
      private static var openbossnum:int = 0;
      
      private var mc:MovieClip;
      
      public function BoosHpTiaoC()
      {
         super();
      }
      
      public static function opennum() : void
      {
         ++openbossnum;
         open();
      }
      
      private static function open() : void
      {
         if(curs == 0)
         {
            self.reset();
            curs = 1;
         }
      }
      
      public static function close() : void
      {
         --openbossnum;
         if(openbossnum == 0)
         {
            self.leave();
         }
      }
      
      public function reset() : void
      {
         var _loc1_:Class = null;
         if(this.mc == null)
         {
            _loc1_ = LoaderManager.getSwfClass("bossxuetiao") as Class;
            this.mc = new _loc1_() as MovieClip;
            this.mc.stop();
            (this.mc["bosstouxiang"] as MovieClip).gotoAndStop(1);
            (this.mc["bossxuetiao1"] as MovieClip).gotoAndStop(100);
            (this.mc["zhuwuxinga"] as MovieClip).gotoAndStop(1);
            this.mc.x = 19563;
            this.mc.y = 29563;
         }
         this.mc.x = 0;
         this.mc.y = 0;
         GM.cb.addChild(this.mc);
      }
      
      public function leave() : void
      {
         if(curs == 1)
         {
            this.mc.x = 19563;
            this.mc.y = 29563;
            GM.cb.removeChild(this.mc);
            curs = 0;
         }
      }
      
      public function update(param1:int, param2:int, param3:int, param4:int, param5:String, param6:int, param7:int, param8:int) : void
      {
         (this.mc["bosstouxiang"] as MovieClip).gotoAndStop(param1);
         (this.mc["bossziti3"] as TextField).text = "Lv." + param4;
         (this.mc["bossziti4"] as TextField).text = "" + param5;
         (this.mc["chengji"] as TextField).text = "X" + param6;
         (this.mc["bossxuetiao1"] as MovieClip).gotoAndStop(param7);
         (this.mc["zhuwuxinga"] as MovieClip).gotoAndStop(param8 + 1);
      }
   }
}

