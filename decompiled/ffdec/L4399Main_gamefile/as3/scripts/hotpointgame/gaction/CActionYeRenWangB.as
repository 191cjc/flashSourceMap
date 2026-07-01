package hotpointgame.gaction
{
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   import hotpointgame.gBullet.*;
   import hotpointgame.gMonster.*;
   import hotpointgame.gameobj.*;
   import hotpointgame.utils.*;
   import hotpointgame.utils.gameloader.*;
   
   public class CActionYeRenWangB extends CAction
   {
      
      private var bulletObj:Object;
      
      private var bhi:VT = VT.createVT(0);
      
      private var hurt:VT = VT.createVT(0);
      
      public function CActionYeRenWangB(param1:String)
      {
         super(param1);
      }
      
      override public function setData(param1:Object) : void
      {
         this.bulletObj = param1.bo;
         this.bhi.setValue((param1.othersvt.bhi as VT).getValue());
         this.hurt.setValue((param1.othersvt.hurt as VT).getValue());
         super.setData(param1);
      }
      
      override protected function beforeByBullet(param1:ZtC) : void
      {
         var _loc2_:Object = null;
         var _loc3_:Class = null;
         var _loc4_:Array = null;
         var _loc5_:Class = null;
         var _loc6_:int = 0;
         var _loc7_:Object = null;
         var _loc8_:ZtB = null;
         if(this.bulletObj[currentFrameNum])
         {
            _loc2_ = ZtBFactory.getBulletData(this.bulletObj[currentFrameNum]);
            _loc3_ = LoaderManager.getSwfClass(_loc2_.flaname) as Class;
            _loc4_ = param1.getAllBulletByClass(_loc3_);
            _loc5_ = ClassGet.getClassByNameAndAlias(_loc2_.classname) as Class;
            _loc6_ = 0;
            while(_loc6_ < _loc4_.length)
            {
               _loc8_ = new _loc5_(_loc4_[_loc6_],param1,_loc2_) as ZtB;
               (param1 as CMonsterZHBullet).addXiaoDe(_loc8_);
               GM.levelm.addBullet(_loc8_);
               _loc6_++;
            }
            _loc7_ = new Object();
            _loc7_.flaname = "BulletM_yerenegjb";
            _loc7_.name = "片伤";
            _loc7_.classname = "fferTuTeng";
            _loc7_.bhi = this.bhi.getValue();
            _loc7_.hurt = this.hurt.getValue();
            _loc7_.bnum = 2;
            param1.bhitBuffer(_loc7_);
         }
      }
      
      override public function keYiUse(param1:ZtC) : Boolean
      {
         if(!cdisOver())
         {
            return false;
         }
         if((param1 as CMonsterZHBullet).xiaoDeNum() > 0)
         {
            return false;
         }
         return true;
      }
   }
}

