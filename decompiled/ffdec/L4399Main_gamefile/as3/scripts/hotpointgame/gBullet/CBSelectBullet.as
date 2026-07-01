package hotpointgame.gBullet
{
   import flash.display.MovieClip;
   import hotpointgame.Control.*;
   import hotpointgame.gameobj.*;
   import hotpointgame.utils.*;
   import hotpointgame.utils.gameloader.*;
   
   public class CBSelectBullet extends ZtB
   {
      
      private var bulletObj:Object;
      
      public function CBSelectBullet(param1:MovieClip, param2:ZhangDouT, param3:Object, param4:int = 0)
      {
         this.bulletObj = param3.others.bo;
         super(param1,param2,param3,param4);
      }
      
      override protected function beforeUpdate(param1:Vector.<ZhangDouT>) : void
      {
         var _loc2_:Object = null;
         var _loc3_:Class = null;
         var _loc4_:int = 0;
         var _loc5_:Array = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:* = undefined;
         var _loc9_:Class = null;
         var _loc10_:ZtB = null;
         if(this.bulletObj[currentFrameNum])
         {
            _loc2_ = ZtBFactory.getBulletData(this.bulletObj[currentFrameNum]);
            _loc3_ = LoaderManager.getSwfClass(_loc2_.flaname) as Class;
            _loc4_ = mc.numChildren;
            _loc5_ = [];
            _loc6_ = 0;
            while(_loc6_ < _loc4_)
            {
               _loc8_ = mc.getChildAt(_loc6_);
               if(_loc8_ is _loc3_)
               {
                  _loc5_[_loc5_.length] = _loc8_;
               }
               _loc6_++;
            }
            _loc7_ = 0;
            while(_loc7_ < _loc5_.length)
            {
               _loc9_ = ClassGet.getClassByNameAndAlias(_loc2_.classname) as Class;
               _loc10_ = new _loc9_(_loc5_[_loc7_],fz,_loc2_,_forth) as ZtB;
               GM.levelm.addBullet(_loc10_);
               _loc7_++;
            }
         }
      }
      
      override public function remove() : void
      {
         this.bulletObj = null;
         super.remove();
      }
   }
}

