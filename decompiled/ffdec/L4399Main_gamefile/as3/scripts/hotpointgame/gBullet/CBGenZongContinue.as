package hotpointgame.gBullet
{
   import flash.display.MovieClip;
   import flash.geom.Point;
   import hotpointgame.Control.*;
   import hotpointgame.gameobj.ZhangDouT;
   import hotpointgame.gameobj.ZtB;
   import hotpointgame.utils.*;
   
   public class CBGenZongContinue extends ZtB
   {
      
      private var chuanMonster:int = 0;
      
      private var anglechang:Number = 0;
      
      private var changa:Number = 0;
      
      private var onlyt:int = 0;
      
      protected var targetZt:ZhangDouT;
      
      private var hitEnemy:Array = [];
      
      public function CBGenZongContinue(param1:MovieClip, param2:ZhangDouT, param3:Object, param4:int = 0, param5:ZhangDouT = null)
      {
         this.targetZt = param5;
         super(param1,param2,param3,param4);
      }
      
      override protected function dataInit(param1:Object) : void
      {
         this.chuanMonster = param1.chuanMonster;
         this.anglechang = param1.others.anglechang;
         this.changa = param1.others.changa;
         super.dataInit(param1);
      }
      
      override protected function beforeUpdate(param1:Vector.<ZhangDouT>) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         if(runState == 0)
         {
            if(this.targetZt != null)
            {
               if(!this.targetZt.isLive())
               {
                  this.targetZt = null;
                  if(param1.length <= 0)
                  {
                     return;
                  }
                  _loc3_ = int(Math.random() * param1.length);
                  this.targetZt = param1[_loc3_];
               }
            }
            else
            {
               if(param1.length <= 0)
               {
                  return;
               }
               _loc4_ = int(Math.random() * param1.length);
               this.targetZt = param1[_loc4_];
            }
            _loc2_ = Number(this.changetFlashAngle(Math.atan2(this.targetZt.getZy() - 100 - getZy(),this.targetZt.getZx() - getZx()) * 180 / Math.PI));
            if(_loc2_ >= 0 && _loc2_ <= 180)
            {
               if(zhenAnagle >= _loc2_ - 180 && zhenAnagle <= _loc2_)
               {
                  zhenAnagle = this.changetFlashAngle(zhenAnagle + this.changa);
                  if(!(zhenAnagle >= _loc2_ - 180 && zhenAnagle <= _loc2_))
                  {
                     zhenAnagle = _loc2_;
                  }
               }
               else
               {
                  zhenAnagle = this.changetFlashAngle(zhenAnagle - this.changa);
                  if(zhenAnagle >= _loc2_ - 180 && zhenAnagle <= _loc2_)
                  {
                     zhenAnagle = _loc2_;
                  }
               }
            }
            else if(zhenAnagle >= _loc2_ && zhenAnagle <= _loc2_ + 180)
            {
               zhenAnagle = this.changetFlashAngle(zhenAnagle - this.changa);
               if(!(zhenAnagle >= _loc2_ && zhenAnagle <= _loc2_ + 180))
               {
                  zhenAnagle = _loc2_;
               }
            }
            else
            {
               zhenAnagle = this.changetFlashAngle(zhenAnagle + this.changa);
               if(zhenAnagle >= _loc2_ && zhenAnagle <= _loc2_ + 180)
               {
                  zhenAnagle = _loc2_;
               }
            }
            if(fz.getZTType() == 1)
            {
               mc.rotation = zhenAnagle;
            }
            if(fz.getZTType() == 2)
            {
               mc.rotation = 180 + zhenAnagle;
            }
            bCos = Math.cos(zhenAnagle * Math.PI / 180);
            bSin = Math.sin(zhenAnagle * Math.PI / 180);
         }
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
         var _loc14_:int = 0;
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
            _loc14_ = 0;
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
                  _loc14_ = 1;
               }
               if(_loc14_ == 0)
               {
                  if(this.chuanMonster == 0)
                  {
                     for each(_loc15_ in param1)
                     {
                        if(_loc15_.bhitTestByPoint(_loc10_,_loc11_))
                        {
                           _loc14_ = 2;
                           break;
                        }
                     }
                  }
                  else if(this.targetZt != null)
                  {
                     if(this.targetZt.bhitTestByPoint(_loc10_,_loc11_))
                     {
                        _loc14_ = 2;
                     }
                  }
               }
               if(_loc14_ == 1)
               {
                  this.enterRunStataOne();
                  mc.x += _loc10_ - _loc12_;
                  mc.y += _loc11_ - _loc13_;
                  break;
               }
               if(_loc14_ == 2)
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
               else if(this.targetZt != null)
               {
                  if(this.targetZt.bhitTestByObject(getAhit()))
                  {
                     this.enterRunStataOne();
                     return;
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
         var _loc2_:ZhangDouT = null;
         for each(_loc2_ in param1)
         {
            if(this.hitEnemy.indexOf(_loc2_) == -1)
            {
               if(_loc2_.bhitByObject(getAhit(),fda,this) != -1)
               {
                  this.hitEnemy[this.hitEnemy.length] = _loc2_;
               }
            }
         }
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
      
      override public function remove() : void
      {
         this.targetZt = null;
         this.hitEnemy.length = 0;
         super.remove();
      }
      
      private function changetFlashAngle(param1:Number) : Number
      {
         if(param1 > 180)
         {
            return param1 - 360;
         }
         if(param1 <= -180)
         {
            return param1 + 360;
         }
         return param1;
      }
   }
}

