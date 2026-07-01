package hotpointgame.utils
{
   import flash.display.Sprite;
   import flash.system.*;
   import flash.text.*;
   import flash.utils.*;
   
   public class FpsCounter extends Sprite
   {
      
      public static var frameStartTime:uint = 0;
      
      private var textBox:TextField;
      
      private var textBox2:TextField;
      
      private var countRate:int = 30;
      
      private var avgCount:int = 30;
      
      private var timeCount:int = 0;
      
      private var oldT:uint;
      
      private var textBox3:TextField;
      
      private var frameTimeCount:int = 0;
      
      public function FpsCounter(param1:int)
      {
         super();
         this.countRate = this.avgCount = param1;
         this.textBox = new TextField();
         this.textBox.text = "...";
         this.textBox.width = 300;
         this.textBox.textColor = 0;
         this.textBox.selectable = false;
         this.textBox2 = new TextField();
         this.textBox2.text = "...";
         this.textBox2.width = 300;
         this.textBox2.textColor = 0;
         this.textBox2.selectable = false;
         this.textBox2.y = 15;
         this.textBox3 = new TextField();
         this.textBox3.text = "...";
         this.textBox3.width = 2000;
         this.textBox3.textColor = 0;
         this.textBox3.selectable = false;
         this.textBox3.y = 30;
         this.oldT = getTimer();
         addChild(this.textBox);
         addChild(this.textBox2);
         addChild(this.textBox3);
      }
      
      public function gmUpdate() : void
      {
         var _loc1_:uint = uint(getTimer());
         var _loc2_:uint = _loc1_ - this.oldT;
         this.timeCount += _loc2_;
         var _loc3_:uint = _loc1_ - FpsCounter.frameStartTime;
         this.frameTimeCount += _loc3_;
         if(this.avgCount < 1)
         {
            this.textBox.text = String(Math.round(1000 * this.countRate / this.timeCount) + " fps /  " + this.countRate + "/FrameEvent:  " + this.frameTimeCount);
            this.avgCount = this.countRate;
            this.timeCount = 0;
            this.textBox3.text = "";
            this.frameTimeCount = 0;
         }
         --this.avgCount;
         this.oldT = getTimer();
         this.textBox2.text = Math.round(System.totalMemory / (1024 * 1024)) + " MB used";
         this.textBox3.appendText("-" + String(_loc3_));
      }
   }
}

