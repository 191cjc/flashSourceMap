package hotpointgame.gaction
{
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   import hotpointgame.gBullet.*;
   import hotpointgame.gameobj.*;
   import hotpointgame.utils.*;
   
   public class CABulletOneSrandom extends CAction
   {
      
      private var bulletObj:Object;
      
      private var curb:int = 0;
      
      private var allb:int = 0;
      
      public function CABulletOneSrandom(param1:String)
      {
         super(param1);
      }
      
      override public function enter(param1:ZtC) : void
      {
         this.curb = Math.random() * this.allb + GS.a1;
         super.enter(param1);
      }
      
      override public function setData(param1:Object) : void
      {
         this.bulletObj = param1.bo;
         this.allb = this.bulletObj.bm;
         super.setData(param1);
      }
      
      override protected function beforeByBullet(param1:ZtC) : void
      {
         var _loc2_:Object = null;
         var _loc3_:Class = null;
         var _loc4_:ZtB = null;
         if(this.bulletObj[this.curb][currentFrameNum])
         {
            _loc2_ = ZtBFactory.getBulletData(this.bulletObj[this.curb][currentFrameNum]);
            _loc3_ = ClassGet.getClassByNameAndAlias(_loc2_.classname) as Class;
            _loc4_ = new _loc3_(param1.getBullet(_loc2_.flaname),param1,_loc2_) as ZtB;
            GM.levelm.addBullet(_loc4_);
         }
      }
   }
}

