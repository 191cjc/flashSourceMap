package hotpointgame.gaction
{
   import hotpointgame.Control.*;
   import hotpointgame.gBullet.*;
   import hotpointgame.gameobj.*;
   import hotpointgame.utils.*;
   
   public class CAShunYi extends CAction
   {
      
      private var bulletObj:Object;
      
      private var moveFnum:int = 25;
      
      private var hitFrame:Array;
      
      public function CAShunYi(param1:String)
      {
         super(param1);
      }
      
      override public function setData(param1:Object) : void
      {
         this.bulletObj = param1.bo;
         this.moveFnum = param1.others.mfnum;
         this.hitFrame = param1.others.hf;
         super.setData(param1);
      }
      
      override protected function beforeByBullet(param1:ZtC) : void
      {
         var _loc2_:Object = null;
         var _loc3_:Class = null;
         var _loc4_:ZtB = null;
         if(this.bulletObj[currentFrameNum])
         {
            _loc2_ = ZtBFactory.getBulletData(this.bulletObj[currentFrameNum]);
            _loc3_ = ClassGet.getClassByNameAndAlias(_loc2_.classname) as Class;
            _loc4_ = new _loc3_(param1.getBullet(_loc2_.flaname),param1,_loc2_) as ZtB;
            GM.levelm.addBullet(_loc4_);
         }
      }
      
      override public function attack(param1:ZtC, param2:Vector.<ZhangDouT>) : void
      {
         var _loc3_:int = 0;
         var _loc4_:Array = null;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:ZhangDouT = null;
         if(currentFrameNum == this.moveFnum)
         {
            if(param2.length > 0)
            {
               _loc3_ = param2[0].getXforth();
               _loc4_ = GM.levelm.getRoomLockm();
               if(_loc3_ > 0)
               {
                  _loc5_ = param2[0].getZx() - 200;
                  if(_loc5_ <= _loc4_[0])
                  {
                     _loc5_ = _loc4_[0] + 10;
                  }
                  param1.setZx(_loc5_);
                  param1.setZy(param2[0].getZy());
                  param1.setForth(_loc3_);
               }
               else
               {
                  _loc6_ = param2[0].getZx() + 200;
                  if(_loc6_ >= _loc4_[1])
                  {
                     _loc6_ = _loc4_[1] - 10;
                  }
                  param1.setZx(_loc6_);
                  param1.setZy(param2[0].getZy());
                  param1.setForth(_loc3_);
               }
            }
         }
         if(currentFrameNum >= this.hitFrame[0] && currentFrameNum <= this.hitFrame[1])
         {
            for each(_loc7_ in param2)
            {
               if(hitEnemy.indexOf(_loc7_) == -1)
               {
                  if(_loc7_.bhitByObject(param1.getAhit(),fda,param1) != -1)
                  {
                     hitEnemy[hitEnemy.length] = _loc7_;
                  }
               }
            }
         }
      }
   }
}

