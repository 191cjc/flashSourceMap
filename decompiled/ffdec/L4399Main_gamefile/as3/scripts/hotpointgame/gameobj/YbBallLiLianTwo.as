package hotpointgame.gameobj
{
   import flash.display.MovieClip;
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   
   public class YbBallLiLianTwo extends YbBall
   {
      
      public function YbBallLiLianTwo(param1:MovieClip, param2:Number, param3:Number, param4:Number)
      {
         super(param1,param2,param3,param4);
      }
      
      override public function attackEnemy(param1:Vector.<ZhangDouT>) : void
      {
         var _loc2_:ZhangDouT = null;
         for each(_loc2_ in param1)
         {
            if(hitEnemy.indexOf(_loc2_) == -1)
            {
               if(_loc2_.bhitTestByObject(getHitRangle()))
               {
                  hitEnemy[hitEnemy.length] = _loc2_;
                  _loc2_.bhitHp(attvalue.getValue() * (GS.a05 + xspeed * GS.a01));
                  (_loc2_ as ZtC).bufEffectH(0,FlowInterface.getGoodsSkillById(GS.a100 + GS.a54));
               }
            }
         }
      }
   }
}

