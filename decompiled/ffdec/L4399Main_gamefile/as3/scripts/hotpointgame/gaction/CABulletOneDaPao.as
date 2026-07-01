package hotpointgame.gaction
{
   import flash.display.MovieClip;
   import hotpointgame.Control.*;
   import hotpointgame.gBullet.*;
   import hotpointgame.gameobj.*;
   import hotpointgame.utils.*;
   
   public class CABulletOneDaPao extends CAction
   {
      
      private var bulletObj:Object;
      
      public function CABulletOneDaPao(param1:String)
      {
         super(param1);
      }
      
      override public function enter(param1:ZtC) : void
      {
         super.enter(param1);
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
         var _loc4_:MovieClip = null;
         var _loc5_:MovieClip = null;
         var _loc6_:ZtB = null;
         if(this.bulletObj[currentFrameNum])
         {
            _loc2_ = ZtBFactory.getBulletData(this.bulletObj[currentFrameNum]);
            _loc3_ = ClassGet.getClassByNameAndAlias(_loc2_.classname) as Class;
            _loc4_ = param1.getBullet("zhuantou");
            _loc5_ = _loc4_[_loc2_.flaname];
            _loc5_.rotation = _loc4_.rotation;
            _loc6_ = new _loc3_(_loc5_,param1,_loc2_) as ZtB;
            GM.levelm.addBullet(_loc6_);
         }
      }
   }
}

