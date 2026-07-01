package hotpointgame.grole
{
   import flash.display.*;
   import flash.filters.*;
   import flash.text.*;
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   import hotpointgame.utils.gameloader.*;
   
   public class Vplayer extends MovieClip
   {
      
      private var titlemc:MovieClip;
      
      private var nameMc:MovieClip;
      
      protected var ya:Number = 112;
      
      protected var yb:Number = -62;
      
      public function Vplayer()
      {
         super();
      }
      
      public function iniTitleName() : void
      {
         var _loc8_:Class = null;
         var _loc1_:String = FlowInterface.getEquipMcName(GS.a16);
         if(_loc1_ != "")
         {
            _loc8_ = LoaderManager.getSwfClass(_loc1_) as Class;
            this.titlemc = new _loc8_() as MovieClip;
            this.titlemc.x = this.getGenzonkuang().x - 65;
            this.titlemc.y = this.getGenzonkuang().y - this.ya;
            addChild(this.titlemc);
         }
         var _loc2_:Class = LoaderManager.getSwfClass("zrwmc") as Class;
         this.nameMc = new _loc2_() as MovieClip;
         var _loc3_:TextField = this.nameMc["rwmc"];
         var _loc4_:Number = Number(GM.testapi.userName.length);
         _loc4_ = (_loc4_ + 1) / 2;
         _loc3_.text = GM.testapi.userName;
         _loc3_.setTextFormat(new TextFormat("宋体",15,16777215));
         this.nameMc.x = this.getGenzonkuang().x - _loc4_ * 10;
         this.nameMc.y = this.getGenzonkuang().y - this.yb;
         (this.nameMc["gdfg"] as MovieClip).gotoAndStop(GM.aSaveData.pksd.oldawTitleb + 1);
         var _loc5_:String = GoodsManger.dataList.unionData.getUname();
         if(_loc5_ != "")
         {
            _loc5_ = "【军团】" + _loc5_;
         }
         var _loc6_:TextField = new TextField();
         _loc6_.autoSize = TextFieldAutoSize.CENTER;
         _loc6_.text = _loc5_;
         _loc6_.setTextFormat(new TextFormat("宋体",15,6750003));
         _loc6_.x = -_loc6_.width / 2;
         _loc6_.y = this.getGenzonkuang().y - this.yb + 20;
         var _loc7_:Array = _loc6_.filters;
         _loc7_.push(new GlowFilter(1454848,1,5,5,8,1,false,false));
         _loc6_.filters = _loc7_;
         addChild(this.nameMc);
         addChild(_loc6_);
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
      
      public function delAddTitle(param1:String) : void
      {
         var _loc2_:Class = null;
         if(param1 != "")
         {
            _loc2_ = LoaderManager.getSwfClass(param1) as Class;
            this.titlemc = new _loc2_() as MovieClip;
            this.titlemc.x = this.getGenzonkuang().x - 65;
            this.titlemc.y = this.getGenzonkuang().y - this.ya;
            addChild(this.titlemc);
         }
      }
      
      public function getGenzonkuang() : MovieClip
      {
         return null;
      }
      
      public function typeShowAndH(param1:int, param2:Boolean) : void
      {
      }
      
      public function changeByEquipSlot(param1:int, param2:String) : void
      {
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
      
      public function baseToMap(param1:String) : void
      {
      }
      
      public function mapToBase() : void
      {
      }
      
      public function mapToMap(param1:String) : void
      {
      }
      
      public function lostMapWeapon() : void
      {
      }
      
      public function enterActionChange(param1:Boolean) : void
      {
      }
      
      public function getCurrentFrameNum() : int
      {
         return 1;
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
      
      public function getMapGunBullet(param1:String) : MovieClip
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

