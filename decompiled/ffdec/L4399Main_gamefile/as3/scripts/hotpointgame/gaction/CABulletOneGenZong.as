package hotpointgame.gaction
{
   import flash.utils.getDefinitionByName;
   import hotpointgame.Control.*;
   import hotpointgame.gBullet.*;
   import hotpointgame.gameobj.*;
   import hotpointgame.utils.*;
   
   public class CABulletOneGenZong extends CAction
   {
      
      private var bulletObj:Object;
      
      public function CABulletOneGenZong(param1:String)
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
         if(this.bulletObj[currentFrameNum])
         {
            if(param2.length > 0)
            {
               _loc3_ = ZtBFactory.getBulletData(this.bulletObj[currentFrameNum]);
               _loc4_ = ClassGet.getClassByNameAndAlias(_loc3_.classname) as Class;
               _loc5_ = new _loc4_(param1.getBullet(_loc3_.flaname),param1,_loc3_,param2[0]) as ZtB;
               GM.levelm.addBullet(_loc5_);
            }
         }
      }
   }
}

