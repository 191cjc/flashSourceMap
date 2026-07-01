package hotpointgame.gMonster
{
   import flash.display.*;
   import flash.geom.*;
   import hotpointgame.gxiaodongxi.*;
   import hotpointgame.utils.*;
   import hotpointgame.utils.gameloader.*;
   
   public class VMonster extends MovieClip
   {
      
      private var _mc:MovieClip;
      
      private var mblood:MovieClip;
      
      private var bHeight:Number;
      
      private var bWidth:Number;
      
      public function VMonster(param1:MovieClip, param2:int)
      {
         var _loc3_:String = null;
         var _loc4_:Class = null;
         super();
         this._mc = param1;
         this.getMc("mbyhit").visible = false;
         this.getMc("mahit").visible = false;
         this.bHeight = this._mc.height;
         this.bWidth = this._mc.width;
         addChild(this._mc);
         if(param2 != 3 && param2 != 4 && param2 != 5 && param2 != 6)
         {
            _loc3_ = "guaiwuxuetiao";
            if(param2 == 1)
            {
               _loc3_ = "wguaiwuxuetiao";
            }
            _loc4_ = LoaderManager.getSwfClass(_loc3_) as Class;
            this.mblood = new _loc4_() as MovieClip;
            this.mblood.x = this.getMc("genzonkuang").x;
            this.mblood.y = this.getMc("genzonkuang").y - this.bHeight / 10 * 7;
            addChild(this.mblood);
         }
      }
      
      public function hpUpdate(param1:Number) : void
      {
         var _loc2_:MovieClip = null;
         var _loc3_:Point = null;
         if(this.mblood != null)
         {
            _loc2_ = this.getMc("genzonkuang");
            _loc3_ = Pos.displayA_x_y_To_displayB(_loc2_,this);
            this.mblood.x = _loc3_.x - 30;
            this.mblood.y = _loc3_.y - this.bHeight / 10 * 7;
            this.mblood["guaiwuxuetiaoa"].scaleX = param1;
         }
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
      
      public function remove() : void
      {
         this._mc.stop();
         if(this.mblood != null)
         {
            this.mblood.stop();
            removeChild(this.mblood);
            this.mblood = null;
         }
         removeChild(this._mc);
         this.parent.removeChild(this);
      }
      
      public function changeColor() : void
      {
         this._mc.transform.colorTransform = new ColorTransform(0.3,0.3,0.3,0.3,0,0,0,0);
      }
   }
}

