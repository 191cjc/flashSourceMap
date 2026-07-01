package hotpointgame.gaction
{
   import hotpointgame.Control.*;
   import hotpointgame.gBullet.*;
   import hotpointgame.gameobj.*;
   import hotpointgame.utils.*;
   
   public class CABulletOneMore extends CAction
   {
      
      private var bulletObj:Object;
      
      public function CABulletOneMore(param1:String)
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
         var _loc2_:Array = null;
         var _loc3_:String = null;
         var _loc4_:Object = null;
         var _loc5_:Class = null;
         var _loc6_:ZtB = null;
         if(this.bulletObj[currentFrameNum])
         {
            _loc2_ = this.bulletObj[currentFrameNum];
            for each(_loc3_ in _loc2_)
            {
               _loc4_ = ZtBFactory.getBulletData(_loc3_);
               _loc5_ = ClassGet.getClassByNameAndAlias(_loc4_.classname) as Class;
               _loc6_ = new _loc5_(param1.getBullet(_loc4_.flaname),param1,_loc4_) as ZtB;
               GM.levelm.addBullet(_loc6_);
            }
         }
      }
   }
}

