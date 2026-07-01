package hotpointgame.gbuffer
{
   import flash.display.MovieClip;
   import hotpointgame.common.*;
   import hotpointgame.gameobj.ZhangDouT;
   import hotpointgame.gameobj.ZtC;
   
   public class ZtcBufferJiangSu extends ZtcBuffer
   {
      
      public function ZtcBufferJiangSu(param1:MovieClip, param2:ZtC, param3:Object)
      {
         super(param1,param2,param3);
         param2.jiansu = hurt;
      }
      
      override public function attack(param1:ZtC, param2:Vector.<ZhangDouT>) : void
      {
      }
      
      override public function remove(param1:ZtC) : void
      {
         param1.jiansu = GS.a1;
         super.remove(param1);
      }
   }
}

