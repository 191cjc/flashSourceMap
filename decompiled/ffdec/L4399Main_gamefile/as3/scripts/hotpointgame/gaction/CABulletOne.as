package hotpointgame.gaction
{
   import hotpointgame.Control.*;
   import hotpointgame.gBullet.*;
   import hotpointgame.gameobj.*;
   import hotpointgame.utils.*;
   
   public class CABulletOne extends CAction
   {
      
      private var bulletObj:Object;
      
      public function CABulletOne(param1:String)
      {
         super(param1);
      }
      
      override public function setData(param1:Object) : void
      {
         this.bulletObj = param1.bo;
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
   }
}

