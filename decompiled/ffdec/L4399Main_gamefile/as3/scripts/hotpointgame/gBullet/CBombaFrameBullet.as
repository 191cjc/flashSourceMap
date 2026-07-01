package hotpointgame.gBullet
{
   import flash.display.MovieClip;
   import hotpointgame.Control.*;
   import hotpointgame.gameobj.*;
   import hotpointgame.utils.*;
   
   public class CBombaFrameBullet extends CBombaFrame
   {
      
      private var bulletObj:Object;
      
      public function CBombaFrameBullet(param1:MovieClip, param2:ZhangDouT, param3:Object, param4:int = 0)
      {
         super(param1,param2,param3,param4);
      }
      
      override protected function dataInit(param1:Object) : void
      {
         this.bulletObj = param1.others.bo;
         super.dataInit(param1);
      }
      
      override protected function beforeUpdate(param1:Vector.<ZhangDouT>) : void
      {
         var _loc2_:Object = null;
         var _loc3_:Class = null;
         var _loc4_:ZtB = null;
         if(this.bulletObj[currentFrameNum])
         {
            _loc2_ = ZtBFactory.getBulletData(this.bulletObj[currentFrameNum]);
            _loc3_ = ClassGet.getClassByNameAndAlias(_loc2_.classname) as Class;
            _loc4_ = new _loc3_(getOtherAhit(_loc2_.flaname),fz,_loc2_,_forth) as ZtB;
            GM.levelm.addBullet(_loc4_);
         }
      }
      
      override public function remove() : void
      {
         this.bulletObj = null;
         super.remove();
      }
   }
}

