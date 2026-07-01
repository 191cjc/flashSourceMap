package hotpointgame.pet
{
   import flash.display.MovieClip;
   import flash.geom.*;
   import hotpointgame.gxiaodongxi.*;
   
   public class VPet extends MovieClip
   {
      
      private var _mc:MovieClip;
      
      private var bHeight:Number;
      
      private var bWidth:Number;
      
      public function VPet(param1:MovieClip)
      {
         super();
         this._mc = param1;
         this.getMc("mbyhit").visible = false;
         this.getMc("mahit").visible = false;
         this.bHeight = this._mc.height;
         this.bWidth = this._mc.width;
         addChild(this._mc);
      }
      
      public function gotoAndStopFrame(param1:Object) : void
      {
         this._mc.gotoAndStop(param1);
      }
      
      public function gotoAndPlayFrame(param1:Object) : void
      {
         this._mc.gotoAndPlay(param1);
      }
      
      public function getCurrentFrameNum() : int
      {
         return this._mc.currentFrame;
      }
      
      public function getFrameLabel() : String
      {
         return this._mc.currentLabel;
      }
      
      public function setAlpha(param1:Number) : void
      {
         this._mc.alpha = param1;
      }
      
      public function changeForth(param1:int) : void
      {
         this._mc.scaleX = param1;
      }
      
      public function getMc(param1:String) : MovieClip
      {
         return this._mc[param1];
      }
      
      public function getAllBulletByClass(param1:Class) : Array
      {
         var _loc5_:* = undefined;
         var _loc2_:int = int(this._mc.numChildren);
         var _loc3_:Array = [];
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_)
         {
            _loc5_ = this._mc.getChildAt(_loc4_);
            if(_loc5_ is param1)
            {
               _loc3_[_loc3_.length] = _loc5_;
            }
            _loc4_++;
         }
         return _loc3_;
      }
      
      public function addHitFlashEMc(param1:MovieClip) : void
      {
         this.getMc("genzonkuang").addChild(param1);
         XiaoXiaoManager.addCGX(new CGXFrame(param1,null));
      }
      
      public function addBuffer(param1:MovieClip) : void
      {
         this.getMc("genzonkuang").addChild(param1);
      }
      
      public function removeBuffer(param1:MovieClip) : void
      {
         this.getMc("genzonkuang").removeChild(param1);
      }
      
      public function allMcStop() : void
      {
         this._mc.stop();
      }
      
      public function allMcPlay() : void
      {
         this._mc.play();
      }
      
      public function remove() : void
      {
         this._mc.stop();
         removeChild(this._mc);
         this.parent.removeChild(this);
      }
      
      public function changeColor() : void
      {
         this._mc.transform.colorTransform = new ColorTransform(0.3,0.3,0.3,0.3,0,0,0,0);
      }
   }
}

