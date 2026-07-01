package hotpointgame.gBullet
{
   import flash.display.MovieClip;
   import flash.geom.Point;
   import hotpointgame.Control.*;
   import hotpointgame.gameobj.ZhangDouT;
   import hotpointgame.gameobj.ZtB;
   import hotpointgame.utils.*;
   
   public class CBYeRenWang extends ZtB
   {
      
      private var stopf:Number = 16;
      
      private var stopflag:Boolean = false;
      
      public function CBYeRenWang(param1:MovieClip, param2:ZhangDouT, param3:Object, param4:int = 0)
      {
         super(param1,param2,param3,param4);
      }
      
      override protected function dataInit(param1:Object) : void
      {
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
                  bSpeed = 0;
                  mc.gotoAndPlay(this.stopf + 1);
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
                  bSpeed = 0;
                  mc.gotoAndPlay(this.stopf + 1);
                  return;
               }
            }
         }
      }
      
      override protected function mcUpdate() : void
      {
         ++currentFrameNum;
         if(runState == 0 && bSpeed != 0 && currentFrameNum == this.stopf)
         {
            mc.gotoAndStop(this.stopf);
         }
         if(runState == 0 && runMaxNum == currentFrameNum)
         {
            if(runMaxOver == 0)
            {
               enterRunStataOne();
            }
            if(runMaxOver == 1)
            {
               enterRunStataTwo();
            }
         }
         if(runState == 0 && mc.currentLabel != "飞行")
         {
            if(runStateOver == 0)
            {
               mc.gotoAndStop(mc.currentFrame - 1);
            }
            if(runStateOver == 1)
            {
               enterRunStataOne();
            }
         }
         if(runState == 1 && mc.totalFrames == mc.currentFrame)
         {
            enterRunStataTwo();
         }
      }
   }
}

