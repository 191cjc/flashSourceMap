package hotpointgame.grole
{
   import flash.display.MovieClip;
   import hotpointgame.gxiaodongxi.*;
   
   public class VPlayerJA extends Vplayer
   {
      
      private var skinMc:MovieClip;
      
      public function VPlayerJA(param1:MovieClip)
      {
         super();
         ya = 136;
         yb = -86;
         this.skinMc = param1;
         addChild(this.skinMc);
         iniTitleName();
         this.getAhit().visible = false;
         this.getByhit().visible = false;
      }
      
      override public function getGenzonkuang() : MovieClip
      {
         return this.skinMc["genzonkuang"];
      }
      
      override public function remove() : void
      {
         delTitle();
         delNmaemc();
         this.skinMc.parent.removeChild(this.skinMc);
         this.skinMc = null;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
      
      override public function allMcStop() : void
      {
         this.skinMc.stop();
      }
      
      override public function allMcPlay() : void
      {
         this.skinMc.play();
      }
      
      override public function gotoAndStopFrame(param1:Object) : void
      {
         this.skinMc.gotoAndStop(param1);
      }
      
      override public function gotoAndPlayFrame(param1:Object) : void
      {
         this.skinMc.gotoAndPlay(param1);
      }
      
      override public function setAlpha(param1:Number) : void
      {
      }
      
      override public function changeForth(param1:int) : void
      {
         this.skinMc.scaleX = param1;
      }
      
      override public function getCurrentFrameNum() : int
      {
         return this.skinMc.currentFrame;
      }
      
      override public function getFrameLabel() : String
      {
         return this.skinMc.currentLabel;
      }
      
      override public function getXiaZhiMc(param1:String) : MovieClip
      {
         return this.skinMc[param1];
      }
      
      override public function getAhit() : MovieClip
      {
         return this.skinMc["rahit"];
      }
      
      override public function getByhit() : MovieClip
      {
         return this.skinMc["rbyhit"];
      }
      
      override public function addHitFlashEMc(param1:MovieClip) : void
      {
         this.skinMc["genzonkuang"].addChild(param1);
         XiaoXiaoManager.addCGX(new CGXFrame(param1,null));
      }
      
      override public function addBuffer(param1:MovieClip) : void
      {
         this.skinMc["genzonkuang"].addChild(param1);
      }
      
      override public function removeBuffer(param1:MovieClip) : void
      {
         this.skinMc["genzonkuang"].removeChild(param1);
      }
      
      override public function getBullet(param1:String) : MovieClip
      {
         return this.skinMc[param1];
      }
      
      override public function getAllBulletByClassByJineng(param1:Class) : Array
      {
         var _loc5_:* = undefined;
         var _loc2_:int = int(this.skinMc.numChildren);
         var _loc3_:Array = [];
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_)
         {
            _loc5_ = this.skinMc.getChildAt(_loc4_);
            if(_loc5_ is param1)
            {
               _loc3_[_loc3_.length] = _loc5_;
            }
            _loc4_++;
         }
         return _loc3_;
      }
      
      override public function getAllBulletByClassByMapgun(param1:Class) : Array
      {
         var _loc5_:* = undefined;
         var _loc2_:int = int(this.skinMc.numChildren);
         var _loc3_:Array = [];
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_)
         {
            _loc5_ = this.skinMc.getChildAt(_loc4_);
            if(_loc5_ is param1)
            {
               _loc3_[_loc3_.length] = _loc5_;
            }
            _loc4_++;
         }
         return _loc3_;
      }
   }
}

