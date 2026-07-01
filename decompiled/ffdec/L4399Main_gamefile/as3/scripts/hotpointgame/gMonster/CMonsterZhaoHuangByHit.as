package hotpointgame.gMonster
{
   import flash.display.MovieClip;
   import hotpointgame.gameobj.*;
   
   public class CMonsterZhaoHuangByHit extends CMonster
   {
      
      protected var xiaoDe:Vector.<ZhangDouT> = new Vector.<ZhangDouT>();
      
      public function CMonsterZhaoHuangByHit(param1:MovieClip, param2:Number, param3:Number, param4:Object)
      {
         super(param1,param2,param3,param4);
      }
      
      public function addXiaoDe(param1:ZhangDouT) : void
      {
         this.xiaoDe.push(param1);
      }
      
      public function xiaoDeNum() : int
      {
         return this.xiaoDe.length;
      }
      
      override protected function otherUpdate() : void
      {
         var _loc1_:int = int(this.xiaoDe.length);
         var _loc2_:Boolean = false;
         var _loc3_:* = int(_loc1_ - 1);
         while(_loc3_ >= 0)
         {
            if(!this.xiaoDe[_loc3_].isLive())
            {
               this.xiaoDe.splice(_loc3_,1);
               _loc2_ = true;
            }
            _loc3_--;
         }
      }
      
      override public function remove() : void
      {
         this.xiaoDe.length = 0;
         super.remove();
      }
   }
}

