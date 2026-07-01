package hotpointgame.gaction
{
   import hotpointgame.gMonster.*;
   import hotpointgame.gameobj.ZtC;
   
   public class CActionZhaohuanDaPao extends CAction
   {
      
      private var zhaohuanObj:Object;
      
      private var pointArr:Array = new Array([3678,1948],[3678,1712],[4222,2198],[4714,1982],[4714,1720]);
      
      public function CActionZhaohuanDaPao(param1:String)
      {
         super(param1);
      }
      
      override public function setData(param1:Object) : void
      {
         this.zhaohuanObj = param1.others.zo;
         super.setData(param1);
      }
      
      override protected function beforeByBullet(param1:ZtC) : void
      {
         var _loc2_:Array = null;
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         if(this.zhaohuanObj[currentFrameNum])
         {
            _loc2_ = this.zhaohuanObj[currentFrameNum];
            _loc3_ = this.getRandomarr();
            _loc4_ = 0;
            while(_loc4_ < _loc2_.length)
            {
               (param1 as CMonsterZhaoHuangByHitAndDaPao).addDaPao(MonsterManager.creatMonster(_loc2_[_loc4_],this.pointArr[_loc3_[_loc4_]][0],this.pointArr[_loc3_[_loc4_]][1]));
               _loc4_++;
            }
         }
      }
      
      override public function keYiUse(param1:ZtC) : Boolean
      {
         if(!cdisOver())
         {
            return false;
         }
         if((param1 as CMonsterZhaoHuangByHitAndDaPao).daPaoNum() > 0)
         {
            return false;
         }
         return true;
      }
      
      private function getRandomarr() : Array
      {
         var _loc4_:int = 0;
         var _loc1_:Array = new Array();
         var _loc2_:Array = [0,1,2,3,4];
         var _loc3_:* = int(_loc2_.length);
         while(_loc3_ > 0)
         {
            _loc4_ = int(Math.random() * _loc3_);
            _loc1_.push(_loc2_[_loc4_]);
            _loc2_.splice(_loc4_,1);
            _loc3_--;
         }
         return _loc1_;
      }
   }
}

