package hotpointgame.utils.gameloader
{
   import flash.display.*;
   import flash.text.*;
   import hotpointgame.Control.*;
   
   public class LoaderProMcMin extends LoaderProMc
   {
      
      private var lmc:MovieClip;
      
      private var preloadmc:MovieClip;
      
      private var pretext:TextField;
      
      public function LoaderProMcMin(param1:MovieClip)
      {
         super();
         this.lmc = param1;
         this.preloadmc = this.lmc["preloader"] as MovieClip;
         this.pretext = this.lmc["pretext"] as TextField;
         this.preloadmc.gotoAndStop(1);
         GM.einit.addChild(this.lmc);
      }
      
      override public function gmUpdate(param1:String, param2:int) : void
      {
         if(param2 <= 0)
         {
            param2 = 1;
         }
         if(param2 > 100)
         {
            param2 = 100;
         }
         this.pretext.text = param1;
         this.preloadmc.gotoAndStop(param2);
      }
      
      override public function remove() : void
      {
         this.preloadmc = null;
         this.pretext = null;
         GM.einit.removeChild(this.lmc);
         this.lmc = null;
      }
   }
}

