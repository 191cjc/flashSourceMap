package hotpointgame.gMonster
{
   import flash.display.MovieClip;
   import hotpointgame.Control.*;
   import hotpointgame.gaction.*;
   import hotpointgame.gameobj.ZhangDouT;
   
   public class CMonsterZhaoHuangByHitAndDaPao extends CMonsterZhaoHuangByHit
   {
      
      protected var daPaoarr:Vector.<CMonster> = new Vector.<CMonster>();
      
      public function CMonsterZhaoHuangByHitAndDaPao(param1:MovieClip, param2:Number, param3:Number, param4:Object)
      {
         super(param1,param2,param3,param4);
      }
      
      public function addDaPao(param1:ZhangDouT) : void
      {
         this.daPaoarr.push(param1);
      }
      
      public function daPaoNum() : int
      {
         return this.daPaoarr.length;
      }
      
      override protected function otherUpdate() : void
      {
         var _loc4_:CMonster = null;
         var _loc5_:CAction = null;
         var _loc1_:int = int(this.daPaoarr.length);
         var _loc2_:Boolean = false;
         var _loc3_:* = int(_loc1_ - 1);
         while(_loc3_ >= 0)
         {
            if(!this.daPaoarr[_loc3_].isLive())
            {
               _loc2_ = true;
               break;
            }
            _loc3_--;
         }
         if(_loc2_)
         {
            for each(_loc4_ in this.daPaoarr)
            {
               _loc4_.killMe();
            }
            this.daPaoarr.length = 0;
         }
         if(_loc2_ && this.daPaoarr.length == 0)
         {
            for each(_loc5_ in aActionArr)
            {
               if(_loc5_ is CActionZhaohuanDaPao)
               {
                  _loc5_.setccd(GM.frameTime);
               }
            }
         }
         super.otherUpdate();
      }
      
      override public function remove() : void
      {
         this.daPaoarr.length = 0;
         super.remove();
      }
   }
}

