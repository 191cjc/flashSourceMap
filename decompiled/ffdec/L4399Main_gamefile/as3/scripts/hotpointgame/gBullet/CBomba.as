package hotpointgame.gBullet
{
   import flash.display.MovieClip;
   import flash.geom.Point;
   import hotpointgame.Control.*;
   import hotpointgame.gameobj.ZhangDouT;
   import hotpointgame.gameobj.ZtB;
   import hotpointgame.utils.*;
   
   public class CBomba extends ZtB
   {
      
      private var chuanMonster:int = 0;
      
      private var anglechang:int = 0;
      
      public function CBomba(param1:MovieClip, param2:ZhangDouT, param3:Object, param4:int = 0)
      {
         super(param1,param2,param3,param4);
      }
      
      override protected function dataInit(param1:Object) : void
      {
         this.chuanMonster = param1.chuanMonster;
         this.anglechang = param1.others.anglechang;
         super.dataInit(param1);
      }
      
      override protected function moveAndTestHit(param1:Vector.<ZhangDouT>) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:* = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Point = null;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:Boolean = false;
         var _loc15_:ZhangDouT = null;
         var _loc16_:ZhangDouT = null;
         if(runState == 0 && bSpeed != 0)
         {
            _loc2_ = bSpeed * bCos;
            _loc3_ = bSpeed * bSin;
            _loc5_ = _loc4_ = int(bSpeed / testInterval);
            _loc6_ = bSpeed % testInterval;
            _loc7_ = testInterval * bCos;
            _loc8_ = testInterval * bSin;
            _loc9_ = Pos.l_To_G(mc);
            _loc10_ = _loc9_.x;
            _loc11_ = _loc9_.y;
            _loc12_ = _loc10_;
            _loc13_ = _loc11_;
            _loc14_ = false;
            while(_loc4_ > 0)
            {
               if(_loc4_ == 1 && _loc6_ == 0)
               {
                  break;
               }
               _loc10_ += _loc7_;
               _loc11_ += _loc8_;
               if(GM.levelm.hitTestByBullet(_loc10_,_loc11_,fda.flag))
               {
                  _loc14_ = true;
               }
               if(!_loc14_ && this.chuanMonster == 0)
               {
                  for each(_loc15_ in param1)
                  {
                     if(_loc15_.bhitTestByPoint(_loc10_,_loc11_))
                     {
                        _loc14_ = true;
                        break;
                     }
                  }
               }
               if(_loc14_)
               {
                  this.enterRunStataOne();
                  mc.x += _loc10_ - _loc12_;
                  mc.y += _loc11_ - _loc13_;
                  break;
               }
               _loc4_--;
            }
            if(bSpeed != 0)
            {
               _loc10_ = _loc12_ + _loc2_;
               _loc11_ = _loc13_ + _loc3_;
               mc.x += _loc2_;
               mc.y += _loc3_;
               if(GM.levelm.hitTestByBullet(_loc10_,_loc11_,fda.flag))
               {
                  this.enterRunStataOne();
                  return;
               }
               if(this.chuanMonster == 0)
               {
                  for each(_loc16_ in param1)
                  {
                     if(_loc16_.bhitTestByObject(getAhit()))
                     {
                        this.enterRunStataOne();
                        return;
                     }
                  }
               }
            }
         }
         if(runState == 1)
         {
            this.bombaAttack(param1);
         }
      }
      
      protected function bombaAttack(param1:Vector.<ZhangDouT>) : void
      {
      }
      
      override protected function enterRunStataOne() : void
      {
         if(this.anglechang == 1)
         {
            if(_forth == 1 && fz.getZTType() == 1 || _forth == -1 && fz.getZTType() == 2)
            {
               mc.rotation = 0;
            }
            else
            {
               mc.rotation = 180;
            }
         }
         super.enterRunStataOne();
      }
   }
}

