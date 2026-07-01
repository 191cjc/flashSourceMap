package hotpointgame.gbuffer
{
   import flash.display.MovieClip;
   import hotpointgame.gameobj.ZhangDouT;
   import hotpointgame.gameobj.ZtC;
   
   public class ZtcBuffer
   {
      
      protected var _bname:String;
      
      protected var bmc:MovieClip;
      
      public var bnum:int;
      
      protected var bhi:int;
      
      protected var bhijishi:int = -1;
      
      public var hurt:Number = 20;
      
      public function ZtcBuffer(param1:MovieClip, param2:ZtC, param3:Object)
      {
         super();
         this._bname = param3.name;
         this.bnum = param3.bnum;
         this.bmc = param1;
         this.bmc.stop();
         this.bhi = param3.bhi;
         this.hurt = param3.hurt;
         param2.addBufferMc(this.bmc);
      }
      
      public function gmUpdate(param1:ZtC) : int
      {
         ++this.bhijishi;
         --this.bnum;
         return this.bnum;
      }
      
      public function attack(param1:ZtC, param2:Vector.<ZhangDouT>) : void
      {
         if(this.bnum >= 0 && this.bhijishi % this.bhi == 0)
         {
            param1.bhitHp(this.hurt);
         }
      }
      
      public function remove(param1:ZtC) : void
      {
         param1.removeBufferMc(this.bmc);
         this.bmc = null;
      }
      
      public function get bname() : String
      {
         return this._bname;
      }
   }
}

