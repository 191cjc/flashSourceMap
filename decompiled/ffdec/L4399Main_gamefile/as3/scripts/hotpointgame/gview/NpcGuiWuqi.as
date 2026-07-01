package hotpointgame.gview
{
   import flash.display.*;
   import flash.events.*;
   import flash.utils.*;
   import hotpointgame.Control.*;
   import hotpointgame.utils.gameloader.*;
   
   public class NpcGuiWuqi
   {
      
      private static var self:NpcGuiWuqi = new NpcGuiWuqi();
      
      private static var curs:int = 0;
      
      private var mc:MovieClip;
      
      public function NpcGuiWuqi()
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
         var _loc1_:Class = LoaderManager.getSwfClass("yindao1") as Class;
         this.mc = new _loc1_() as MovieClip;
         this.mc.gotoAndStop(1);
         this.mc.x = 0;
         this.mc.y = 0;
         this.mc.addEventListener(MouseEvent.CLICK,this.clickH);
         GM.cbGview.addChild(this.mc);
      }
      
      public function leave() : void
      {
         if(curs == 1)
         {
            curs = 0;
            this.mc.x = 19563;
            this.mc.y = 29563;
            this.mc.removeEventListener(MouseEvent.CLICK,this.clickH);
            GM.cbGview.removeChild(this.mc);
            this.mc = null;
         }
      }
      
      private function clickH(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         if(getQualifiedClassName(param1.target) == "flash.display::SimpleButton")
         {
            _loc2_ = int((param1.target.name as String).substr(1));
            if(_loc2_ == 5)
            {
               this.leave();
            }
            else if(_loc2_ == 6)
            {
               this.mc.gotoAndStop(1);
            }
            else
            {
               this.mc.gotoAndStop(_loc2_ + 1);
            }
         }
      }
   }
}

