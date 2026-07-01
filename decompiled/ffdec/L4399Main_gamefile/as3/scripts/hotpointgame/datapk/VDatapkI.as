package hotpointgame.datapk
{
   import flash.display.*;
   import flash.filters.*;
   import flash.text.*;
   import hotpointgame.utils.gameloader.*;
   
   public class VDatapkI extends MovieClip
   {
      
      private var titlemc:MovieClip;
      
      private var nameMc:MovieClip;
      
      protected var ya:Number = 112;
      
      protected var yb:Number = -62;
      
      public function VDatapkI()
      {
         super();
      }
      
      public function iniTitleName(param1:String, param2:String, param3:int, param4:String = "") : void
      {
         var _loc5_:Class = LoaderManager.getSwfClass("zrwmc") as Class;
         this.nameMc = new _loc5_() as MovieClip;
         var _loc6_:TextField = this.nameMc["rwmc"];
         var _loc7_:Number = param2.length;
         _loc7_ = (_loc7_ + 1) / 2;
         _loc6_.text = param2;
         _loc6_.setTextFormat(new TextFormat("宋体",15,16711680));
         this.nameMc.x = this.getGenzonkuang().x - _loc7_ * 10;
         this.nameMc.y = this.getGenzonkuang().y - this.yb;
         (this.nameMc["gdfg"] as MovieClip).gotoAndStop(param3 + 1);
         if(param4 != "")
         {
            param4 = "【军团】" + param4;
         }
         var _loc8_:TextField = new TextField();
         _loc8_.autoSize = TextFieldAutoSize.CENTER;
         _loc8_.text = param4;
         _loc8_.setTextFormat(new TextFormat("宋体",15,6750003));
         _loc8_.x = -_loc8_.width / 2;
         _loc8_.y = this.getGenzonkuang().y - this.yb + 20;
         var _loc9_:Array = _loc8_.filters;
         _loc9_.push(new GlowFilter(1454848,1,5,5,8,1,false,false));
         _loc8_.filters = _loc9_;
         addChild(this.nameMc);
         addChild(_loc8_);
      }
      
      public function delNmaemc() : void
      {
         if(this.nameMc != null)
         {
            this.nameMc.stop();
            removeChild(this.nameMc);
            this.nameMc = null;
         }
      }
      
      public function delTitle() : void
      {
         if(this.titlemc != null)
         {
            this.titlemc.stop();
            removeChild(this.titlemc);
            this.titlemc = null;
         }
      }
      
      public function getGenzonkuang() : MovieClip
      {
         return null;
      }
      
      public function remove() : void
      {
      }
      
      public function allMcStop() : void
      {
      }
      
      public function allMcPlay() : void
      {
      }
      
      public function gotoAndStopFrame(param1:Object) : void
      {
      }
      
      public function gotoAndPlayFrame(param1:Object) : void
      {
      }
      
      public function setAlpha(param1:Number) : void
      {
      }
      
      public function changeForth(param1:int) : void
      {
      }
      
      public function getCurrentFrameNum() : int
      {
         return 0;
      }
      
      public function getFrameLabel() : String
      {
         return "";
      }
      
      public function getXiaZhiMc(param1:String) : MovieClip
      {
         return null;
      }
      
      public function getAhit() : MovieClip
      {
         return null;
      }
      
      public function getByhit() : MovieClip
      {
         return null;
      }
      
      public function addHitFlashEMc(param1:MovieClip) : void
      {
      }
      
      public function addBuffer(param1:MovieClip) : void
      {
      }
      
      public function removeBuffer(param1:MovieClip) : void
      {
      }
      
      public function getBullet(param1:String) : MovieClip
      {
         return null;
      }
      
      public function getAllBulletByClassByJineng(param1:Class) : Array
      {
         return null;
      }
      
      public function getAllBulletByClassByMapgun(param1:Class) : Array
      {
         return null;
      }
   }
}

