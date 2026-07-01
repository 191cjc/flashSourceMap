package hotpointgame.gBullet
{
   import flash.display.*;
   import hotpointgame.Control.*;
   import hotpointgame.gameobj.*;
   import hotpointgame.utils.*;
   import hotpointgame.utils.gameloader.*;
   
   public class CBombaKuanBullet extends CBombaKuan
   {
      
      private var bulletObj:Object;
      
      public function CBombaKuanBullet(param1:MovieClip, param2:ZhangDouT, param3:Object, param4:int = 0)
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
         var _loc7_:Array = null;
         var _loc8_:Vector.<ZhangDouT> = null;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:* = undefined;
         var _loc12_:ZhangDouT = null;
         var _loc13_:MovieClip = null;
         var _loc14_:Class = null;
         var _loc15_:ZtB = null;
         if(this.bulletObj[currentFrameNum])
         {
            _loc2_ = ZtBFactory.getBulletData(this.bulletObj[currentFrameNum]);
            _loc3_ = LoaderManager.getSwfClass(_loc2_.flaname) as Class;
            _loc4_ = mc.numChildren;
            _loc5_ = [];
            _loc6_ = 0;
            while(_loc6_ < _loc4_)
            {
               _loc11_ = mc.getChildAt(_loc6_);
               if(_loc11_ is _loc3_)
               {
                  if(_forth != fz.getXforth())
                  {
                     (_loc11_ as MovieClip).rotation += 180;
                  }
                  _loc5_[_loc5_.length] = _loc11_;
               }
               _loc6_++;
            }
            _loc7_ = this.nSelectx(param1.length,_loc5_.length);
            _loc8_ = new Vector.<ZhangDouT>();
            for each(_loc9_ in _loc7_)
            {
               _loc8_[_loc8_.length] = param1[_loc9_];
            }
            _loc10_ = 0;
            while(_loc10_ < _loc5_.length)
            {
               _loc12_ = _loc8_.pop();
               _loc13_ = _loc5_[_loc10_];
               if(_loc12_)
               {
                  _loc14_ = ClassGet.getClassByNameAndAlias(_loc2_.classname) as Class;
                  _loc15_ = new _loc14_(_loc13_,fz,_loc2_,_loc12_) as ZtB;
                  GM.levelm.addBullet(_loc15_);
               }
               _loc10_++;
            }
         }
      }
      
      private function nSelectx(param1:int, param2:int) : Array
      {
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc3_:Array = [];
         var _loc4_:Array = [];
         var _loc5_:int = 0;
         while(_loc5_ < param1)
         {
            _loc3_[_loc3_.length] = _loc5_;
            _loc5_++;
         }
         if(param1 > param2)
         {
            _loc6_ = 0;
            while(_loc6_ < param2)
            {
               _loc7_ = Math.random() * _loc3_.length;
               _loc4_[_loc4_.length] = _loc3_[_loc7_];
               _loc3_.splice(_loc7_,1);
               _loc6_++;
            }
            return _loc4_;
         }
         return _loc3_;
      }
      
      override public function remove() : void
      {
         this.bulletObj = null;
         super.remove();
      }
   }
}

