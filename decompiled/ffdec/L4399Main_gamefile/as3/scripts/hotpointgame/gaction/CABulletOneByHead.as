package hotpointgame.gaction
{
   import flash.geom.*;
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   import hotpointgame.gBullet.*;
   import hotpointgame.gameobj.*;
   import hotpointgame.utils.*;
   
   public class CABulletOneByHead extends CAction
   {
      
      private var bulletObj:Object;
      
      public function CABulletOneByHead(param1:String)
      {
         super(param1);
      }
      
      override public function setData(param1:Object) : void
      {
         this.bulletObj = param1.bo;
         super.setData(param1);
      }
      
      override public function attack(param1:ZtC, param2:Vector.<ZhangDouT>) : void
      {
         var _loc3_:Object = null;
         var _loc4_:Class = null;
         var _loc5_:ZtB = null;
         var _loc6_:Point = null;
         if(this.bulletObj[currentFrameNum])
         {
            _loc3_ = ZtBFactory.getBulletData(this.bulletObj[currentFrameNum]);
            _loc4_ = ClassGet.getClassByNameAndAlias(_loc3_.classname) as Class;
            _loc5_ = new _loc4_(param1.getBullet(_loc3_.flaname),param1,_loc3_) as ZtB;
            if(param2.length > 0)
            {
               _loc6_ = GM.levelm.gPointChangeLevel(new Point(0,GS.a100));
               _loc5_.setZx(param2[0].getZx());
               _loc5_.setZy(_loc6_.y);
            }
            GM.levelm.addBullet(_loc5_);
         }
      }
   }
}

