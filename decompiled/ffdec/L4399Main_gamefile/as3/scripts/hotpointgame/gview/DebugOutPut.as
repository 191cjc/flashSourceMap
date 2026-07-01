package hotpointgame.gview
{
   import flash.text.*;
   import hotpointgame.Control.*;
   
   public class DebugOutPut
   {
      
      public static var self:DebugOutPut = new DebugOutPut();
      
      private static var curs:int = 0;
      
      private var mc:TextField = new TextField();
      
      public function DebugOutPut()
      {
         super();
         this.mc.multiline = true;
         this.mc.wordWrap = true;
         this.mc.background = true;
         this.mc.selectable = false;
         this.mc.textColor = 0;
         this.mc.width = 300;
         this.mc.height = 500;
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
         this.mc.x = 750;
         this.mc.y = 850;
         GM.fone.addChild(this.mc);
      }
      
      public function leave() : void
      {
         if(curs == 1)
         {
            curs = 0;
            GM.fone.removeChild(this.mc);
         }
      }
      
      public function apptext(param1:String = "aaaaa") : void
      {
         this.mc.htmlText += param1;
      }
      
      public function cleartext() : void
      {
         this.mc.htmlText = "";
      }
   }
}

