package hotpointgame.gaction
{
   import hotpointgame.Control.*;
   import hotpointgame.gBullet.*;
   import hotpointgame.gameobj.*;
   import hotpointgame.utils.*;
   import hotpointgame.utils.gameloader.*;
   
   public class CABulletSelect extends CAction
   {
      
      private var bulletObj:Object;
      
      public function CABulletSelect(param1:String)
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
         var _loc4_:Array = null;
         var _loc5_:Class = null;
         var _loc6_:int = 0;
         var _loc7_:ZtB = null;
         if(this.bulletObj[currentFrameNum])
         {
            _loc2_ = ZtBFactory.getBulletData(this.bulletObj[currentFrameNum]);
            _loc3_ = LoaderManager.getSwfClass(_loc2_.flaname) as Class;
            _loc4_ = param1.getAllBulletByClass(_loc3_);
            _loc5_ = ClassGet.getClassByNameAndAlias(_loc2_.classname) as Class;
            _loc6_ = 0;
            while(_loc6_ < _loc4_.length)
            {
               _loc7_ = new _loc5_(_loc4_[_loc6_],param1,_loc2_) as ZtB;
               GM.levelm.addBullet(_loc7_);
               _loc6_++;
            }
         }
      }
   }
}

