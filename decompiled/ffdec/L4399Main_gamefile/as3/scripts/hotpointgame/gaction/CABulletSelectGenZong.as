package hotpointgame.gaction
{
   import flash.utils.getDefinitionByName;
   import hotpointgame.Control.*;
   import hotpointgame.gBullet.*;
   import hotpointgame.gameobj.*;
   import hotpointgame.utils.*;
   import hotpointgame.utils.gameloader.*;
   
   public class CABulletSelectGenZong extends CAction
   {
      
      private var bulletObj:Object;
      
      public function CABulletSelectGenZong(param1:String)
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
         var _loc5_:Array = null;
         var _loc6_:Class = null;
         var _loc7_:Array = null;
         var _loc8_:int = 0;
         var _loc9_:ZtB = null;
         if(this.bulletObj[currentFrameNum])
         {
            _loc3_ = ZtBFactory.getBulletData(this.bulletObj[currentFrameNum]);
            _loc4_ = LoaderManager.getSwfClass(_loc3_.flaname) as Class;
            _loc5_ = param1.getAllBulletByClass(_loc4_);
            _loc6_ = ClassGet.getClassByNameAndAlias(_loc3_.classname) as Class;
            _loc7_ = this.getenemyarr(_loc5_.length,param2.length);
            _loc8_ = 0;
            while(_loc8_ < _loc5_.length)
            {
               if(_loc7_[_loc8_] != -1)
               {
                  _loc9_ = new _loc6_(_loc5_[_loc8_],param1,_loc3_,param2[_loc7_[_loc8_]]) as ZtB;
               }
               else
               {
                  _loc9_ = new _loc6_(_loc5_[_loc8_],param1,_loc3_,null) as ZtB;
               }
               GM.levelm.addBullet(_loc9_);
               _loc8_++;
            }
         }
      }
      
      private function getenemyarr(param1:int, param2:int) : Array
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:* = 0;
         var _loc9_:int = 0;
         var _loc10_:Array = null;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc13_:Array = null;
         var _loc14_:* = 0;
         var _loc15_:int = 0;
         var _loc16_:int = 0;
         var _loc3_:Array = new Array();
         if(param2 == 0)
         {
            _loc4_ = 0;
            while(_loc4_ < param1)
            {
               _loc3_.push(-1);
               _loc4_++;
            }
         }
         else if(param2 == param1)
         {
            _loc5_ = 0;
            while(_loc5_ < param1)
            {
               _loc3_.push(_loc5_);
               _loc5_++;
            }
         }
         else if(param2 < param1)
         {
            _loc6_ = param1 / param2;
            _loc7_ = 0;
            while(_loc7_ < _loc6_)
            {
               _loc9_ = 0;
               while(_loc9_ < param2)
               {
                  _loc3_.push(_loc9_);
                  _loc9_++;
               }
               _loc7_++;
            }
            _loc8_ = int(param1 - param2 * _loc6_);
            if(_loc8_ > 0)
            {
               _loc10_ = new Array();
               _loc11_ = 0;
               while(_loc11_ < param2)
               {
                  _loc10_.push(_loc11_);
                  _loc11_++;
               }
               while(_loc8_ > 0)
               {
                  _loc12_ = int(Math.random() * _loc10_.length);
                  _loc3_.push(_loc10_[_loc12_]);
                  _loc10_.splice(_loc12_,1);
                  _loc8_--;
               }
            }
         }
         else
         {
            _loc13_ = new Array();
            _loc14_ = param1;
            _loc15_ = 0;
            while(_loc15_ < param2)
            {
               _loc13_.push(_loc15_);
               _loc15_++;
            }
            while(_loc14_ > 0)
            {
               _loc16_ = int(Math.random() * _loc13_.length);
               _loc3_.push(_loc13_[_loc16_]);
               _loc13_.splice(_loc16_,1);
               _loc14_--;
            }
         }
         return _loc3_;
      }
   }
}

