package hotpointgame.datapk
{
   import flash.display.*;
   import hotpointgame.common.*;
   import hotpointgame.gxiaodongxi.*;
   import hotpointgame.utils.gameloader.*;
   
   public class VDatapkWom extends VDatapkI
   {
      
      private var zhuangtaiMc:MovieClip;
      
      private var jinengMc:MovieClip;
      
      private var baseWeaponMc:MovieClip;
      
      private var mapWeaponMc:MovieClip;
      
      private var huwanMc:MovieClip;
      
      private var yaodaiMc:MovieClip;
      
      private var kaijiaMc:MovieClip;
      
      private var skinMc:MovieClip;
      
      private var baseWeaponMcP:MovieClip = new MovieClip();
      
      private var mapWeaponMcP:MovieClip = new MovieClip();
      
      private var huwanMcP:MovieClip = new MovieClip();
      
      private var yaodaiMcP:MovieClip = new MovieClip();
      
      private var kaijiaMcP:MovieClip = new MovieClip();
      
      private var sZxuanguangAMcP:MovieClip = new MovieClip();
      
      private var sZxuanguangBMcP:MovieClip = new MovieClip();
      
      private var sZwuqiMcP:MovieClip = new MovieClip();
      
      private var sZxuanguangAMc:MovieClip;
      
      private var sZxuanguangBMc:MovieClip;
      
      private var sZwuqiMc:MovieClip;
      
      private var sZxuanguangAMcS:String = "";
      
      private var sZxuanguangBMcS:String = "";
      
      private var sZwuqiMcS:String = "";
      
      private var sZyifuaAMcP:MovieClip = new MovieClip();
      
      private var sZyifuaBMcP:MovieClip = new MovieClip();
      
      private var sZjiangbanAMcP:MovieClip = new MovieClip();
      
      private var sZjiangbanBMcP:MovieClip = new MovieClip();
      
      private var sZyifuaAMc:MovieClip;
      
      private var sZyifuaBMc:MovieClip;
      
      private var sZjiangbanAMc:MovieClip;
      
      private var sZjiangbanBMc:MovieClip;
      
      private var sZyifuaAMcS:String = "";
      
      private var sZyifuaBMcS:String = "";
      
      private var sZjiangbanAMcS:String = "";
      
      private var sZjiangbanBMcS:String = "";
      
      private var baseWeaponMcS:String = "";
      
      private var mapWeaponMcS:String = "";
      
      private var huwanMcS:String = "";
      
      private var yaodaiMcS:String = "";
      
      private var kaijiaMcS:String = "";
      
      private var kaijiaMcflag:int = 0;
      
      private var yaodaiMcflag:int = 0;
      
      private var huwanMcflag:int = 0;
      
      private var sZyifuaMcflag:int = 0;
      
      private var sZjiangbanMcflag:int = 0;
      
      public function VDatapkWom(param1:MovieClip, param2:Array, param3:String, param4:int, param5:String = "")
      {
         super();
         this.baseWeaponMcS = param2[GS.a0];
         if(this.baseWeaponMcS == "")
         {
            this.baseWeaponMcS = "WuqiB_xinshoupao";
         }
         var _loc6_:Class = LoaderManager.getSwfClass(this.baseWeaponMcS) as Class;
         this.baseWeaponMc = new _loc6_() as MovieClip;
         this.mapWeaponMcS = "WuqLMH_wnull";
         var _loc7_:Class = LoaderManager.getSwfClass(this.mapWeaponMcS) as Class;
         this.mapWeaponMc = new _loc7_() as MovieClip;
         this.kaijiaMcS = param2[GS.a1];
         if(this.kaijiaMcS == "")
         {
            this.kaijiaMcS = "e_wkaijiachushi";
         }
         var _loc8_:Class = LoaderManager.getSwfClass(this.kaijiaMcS) as Class;
         this.kaijiaMc = new _loc8_() as MovieClip;
         this.huwanMcS = param2[GS.a5];
         if(this.huwanMcS == "")
         {
            this.huwanMcS = "e_whuwanchushi";
         }
         var _loc9_:Class = LoaderManager.getSwfClass(this.huwanMcS) as Class;
         this.huwanMc = new _loc9_() as MovieClip;
         this.yaodaiMcS = param2[GS.a2];
         if(this.yaodaiMcS == "")
         {
            this.yaodaiMcS = "e_wyaodaichushi";
         }
         this.sZyifuaAMcS = param2[GS.a8];
         if(this.sZyifuaAMcS == "")
         {
            this.sZyifuaAMcS = "WuqLMH_wnull";
            this.sZyifuaBMcS = "WuqLMH_wnull";
         }
         else
         {
            this.sZyifuaBMcS = this.sZyifuaAMcS + "b";
         }
         var _loc10_:Class = LoaderManager.getSwfClass(this.sZyifuaAMcS) as Class;
         this.sZyifuaAMc = new _loc10_() as MovieClip;
         _loc10_ = LoaderManager.getSwfClass(this.sZyifuaBMcS) as Class;
         this.sZyifuaBMc = new _loc10_() as MovieClip;
         this.sZwuqiMcS = param2[GS.a11];
         if(this.sZwuqiMcS == "")
         {
            this.sZwuqiMcS = "WuqLMH_wnull";
         }
         var _loc11_:Class = LoaderManager.getSwfClass(this.sZwuqiMcS) as Class;
         this.sZwuqiMc = new _loc11_() as MovieClip;
         this.sZxuanguangAMcS = param2[GS.a12];
         if(this.sZxuanguangAMcS == "")
         {
            this.sZxuanguangAMcS = "WuqLMH_wnull";
            this.sZxuanguangBMcS = "WuqLMH_wnull";
         }
         else
         {
            this.sZxuanguangBMcS = this.sZxuanguangAMcS + "b";
         }
         var _loc12_:Class = LoaderManager.getSwfClass(this.sZxuanguangAMcS) as Class;
         this.sZxuanguangAMc = new _loc12_() as MovieClip;
         _loc12_ = LoaderManager.getSwfClass(this.sZxuanguangBMcS) as Class;
         this.sZxuanguangBMc = new _loc12_() as MovieClip;
         this.sZjiangbanAMcS = param2[GS.a10];
         if(this.sZjiangbanAMcS == "")
         {
            this.sZjiangbanAMcS = "WuqLMH_wnull";
            this.sZjiangbanBMcS = "WuqLMH_wnull";
         }
         else
         {
            this.sZjiangbanBMcS = this.sZjiangbanAMcS + "b";
         }
         var _loc13_:Class = LoaderManager.getSwfClass(this.sZjiangbanAMcS) as Class;
         this.sZjiangbanAMc = new _loc13_() as MovieClip;
         _loc13_ = LoaderManager.getSwfClass(this.sZjiangbanBMcS) as Class;
         this.sZjiangbanBMc = new _loc13_() as MovieClip;
         var _loc14_:Class = LoaderManager.getSwfClass(this.yaodaiMcS) as Class;
         this.yaodaiMc = new _loc14_() as MovieClip;
         var _loc15_:Class = LoaderManager.getSwfClass("e_wjineng") as Class;
         this.jinengMc = new _loc15_() as MovieClip;
         var _loc16_:Class = LoaderManager.getSwfClass("e_wzhuangtai") as Class;
         this.zhuangtaiMc = new _loc16_() as MovieClip;
         this.skinMc = param1;
         this.allshowAndH();
         iniTitleName(param2[GS.a16],param3,param4,param5);
         this.kaijiaMcP.addChild(this.kaijiaMc);
         this.yaodaiMcP.addChild(this.yaodaiMc);
         this.baseWeaponMcP.addChild(this.baseWeaponMc);
         this.mapWeaponMcP.addChild(this.mapWeaponMc);
         this.huwanMcP.addChild(this.huwanMc);
         this.sZjiangbanBMcP.addChild(this.sZjiangbanBMc);
         this.sZyifuaBMcP.addChild(this.sZyifuaBMc);
         this.sZjiangbanAMcP.addChild(this.sZjiangbanAMc);
         this.sZyifuaAMcP.addChild(this.sZyifuaAMc);
         this.sZxuanguangAMcP.addChild(this.sZxuanguangAMc);
         this.sZxuanguangBMcP.addChild(this.sZxuanguangBMc);
         this.sZwuqiMcP.addChild(this.sZwuqiMc);
         addChild(this.sZxuanguangBMcP);
         addChild(this.skinMc);
         addChild(this.sZjiangbanBMcP);
         addChild(this.kaijiaMcP);
         addChild(this.yaodaiMcP);
         addChild(this.sZyifuaBMcP);
         addChild(this.sZjiangbanAMcP);
         addChild(this.baseWeaponMcP);
         addChild(this.mapWeaponMcP);
         addChild(this.sZwuqiMcP);
         addChild(this.sZyifuaAMcP);
         addChild(this.huwanMcP);
         addChild(this.zhuangtaiMc);
         addChild(this.sZxuanguangAMcP);
         addChild(this.jinengMc);
         this.mapWeaponMcP.visible = false;
         this.getAhit().visible = false;
         this.getByhit().visible = false;
      }
      
      override public function getGenzonkuang() : MovieClip
      {
         return this.zhuangtaiMc["genzonkuang"];
      }
      
      private function allshowAndH() : void
      {
         var _loc1_:Array = new Array();
         var _loc2_:int = 0;
         while(_loc2_ < 30)
         {
            _loc1_[_loc2_] = false;
            _loc2_++;
         }
         if(this.sZyifuaAMcS == "WuqLMH_wnull")
         {
            this.kaijiaMcP.visible = true;
            this.yaodaiMcP.visible = true;
            this.huwanMcP.visible = true;
            this.sZyifuaAMcP.visible = false;
            this.sZyifuaBMcP.visible = false;
         }
         else
         {
            this.kaijiaMcP.visible = false;
            this.yaodaiMcP.visible = false;
            this.huwanMcP.visible = false;
            this.sZyifuaAMcP.visible = true;
            this.sZyifuaBMcP.visible = true;
         }
         if(this.sZwuqiMcS == "WuqLMH_wnull")
         {
            this.sZwuqiMcP.visible = false;
            this.baseWeaponMcP.visible = true;
         }
         else
         {
            this.sZwuqiMcP.visible = true;
            this.baseWeaponMcP.visible = false;
         }
         if(this.sZxuanguangAMcS != "WuqLMH_wnull")
         {
            this.sZxuanguangAMcP.visible = true;
            this.sZxuanguangBMcP.visible = true;
         }
         else
         {
            this.sZxuanguangAMcP.visible = false;
            this.sZxuanguangBMcP.visible = false;
         }
         if(this.sZjiangbanAMcS != "WuqLMH_wnull")
         {
            this.sZjiangbanAMcP.visible = true;
            this.sZjiangbanBMcP.visible = true;
         }
         else
         {
            this.sZjiangbanAMcP.visible = false;
            this.sZjiangbanBMcP.visible = false;
         }
      }
      
      override public function remove() : void
      {
         delTitle();
         delNmaemc();
         this.zhuangtaiMc.parent.removeChild(this.zhuangtaiMc);
         this.jinengMc.parent.removeChild(this.jinengMc);
         this.baseWeaponMc.parent.removeChild(this.baseWeaponMc);
         this.huwanMc.parent.removeChild(this.huwanMc);
         this.yaodaiMc.parent.removeChild(this.yaodaiMc);
         this.kaijiaMc.parent.removeChild(this.kaijiaMc);
         this.skinMc.parent.removeChild(this.skinMc);
         this.mapWeaponMc.parent.removeChild(this.mapWeaponMc);
         this.sZjiangbanBMc.parent.removeChild(this.sZjiangbanBMc);
         this.sZyifuaBMc.parent.removeChild(this.sZyifuaBMc);
         this.sZjiangbanAMc.parent.removeChild(this.sZjiangbanAMc);
         this.sZyifuaAMc.parent.removeChild(this.sZyifuaAMc);
         this.sZxuanguangAMc.parent.removeChild(this.sZxuanguangAMc);
         this.sZxuanguangBMc.parent.removeChild(this.sZxuanguangBMc);
         this.sZwuqiMc.parent.removeChild(this.sZwuqiMc);
         this.sZxuanguangAMc = null;
         this.sZxuanguangBMc = null;
         this.sZwuqiMc = null;
         this.sZjiangbanBMcP = null;
         this.sZyifuaBMcP = null;
         this.sZjiangbanAMcP = null;
         this.sZyifuaAMcP = null;
         this.sZjiangbanBMc = null;
         this.sZyifuaBMc = null;
         this.sZjiangbanAMc = null;
         this.sZyifuaAMc = null;
         this.zhuangtaiMc = null;
         this.jinengMc = null;
         this.baseWeaponMc = null;
         this.huwanMc = null;
         this.yaodaiMc = null;
         this.kaijiaMc = null;
         this.skinMc = null;
         this.mapWeaponMc = null;
         this.baseWeaponMcP = null;
         this.mapWeaponMcP = null;
         this.huwanMcP = null;
         this.yaodaiMcP = null;
         this.kaijiaMcP = null;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
      
      override public function allMcStop() : void
      {
         this.zhuangtaiMc.stop();
         this.jinengMc.stop();
         this.baseWeaponMc.stop();
         this.huwanMc.stop();
         this.yaodaiMc.stop();
         this.kaijiaMc.stop();
         this.skinMc.stop();
         this.mapWeaponMc.stop();
         this.sZjiangbanBMc.stop();
         this.sZyifuaBMc.stop();
         this.sZjiangbanAMc.stop();
         this.sZyifuaAMc.stop();
         this.sZxuanguangAMc.stop();
         this.sZxuanguangBMc.stop();
         this.sZwuqiMc.stop();
      }
      
      override public function allMcPlay() : void
      {
         this.zhuangtaiMc.play();
         this.jinengMc.play();
         this.baseWeaponMc.play();
         this.huwanMc.play();
         this.yaodaiMc.play();
         this.kaijiaMc.play();
         this.skinMc.play();
         this.mapWeaponMc.play();
         this.sZjiangbanBMc.play();
         this.sZyifuaBMc.play();
         this.sZjiangbanAMc.play();
         this.sZyifuaAMc.play();
         this.sZxuanguangAMc.play();
         this.sZxuanguangBMc.play();
         this.sZwuqiMc.play();
      }
      
      override public function gotoAndStopFrame(param1:Object) : void
      {
         this.zhuangtaiMc.gotoAndStop(param1);
         this.jinengMc.gotoAndStop(param1);
         this.baseWeaponMc.gotoAndStop(param1);
         this.huwanMc.gotoAndStop(param1);
         this.yaodaiMc.gotoAndStop(param1);
         this.kaijiaMc.gotoAndStop(param1);
         this.skinMc.gotoAndStop(param1);
         this.mapWeaponMc.gotoAndStop(param1);
         this.sZjiangbanBMc.gotoAndStop(param1);
         this.sZyifuaBMc.gotoAndStop(param1);
         this.sZjiangbanAMc.gotoAndStop(param1);
         this.sZyifuaAMc.gotoAndStop(param1);
         this.sZxuanguangAMc.gotoAndStop(param1);
         this.sZxuanguangBMc.gotoAndStop(param1);
         this.sZwuqiMc.gotoAndStop(param1);
      }
      
      override public function gotoAndPlayFrame(param1:Object) : void
      {
         this.zhuangtaiMc.gotoAndPlay(param1);
         this.jinengMc.gotoAndPlay(param1);
         this.baseWeaponMc.gotoAndPlay(param1);
         this.huwanMc.gotoAndPlay(param1);
         this.yaodaiMc.gotoAndPlay(param1);
         this.kaijiaMc.gotoAndPlay(param1);
         this.skinMc.gotoAndPlay(param1);
         this.mapWeaponMc.gotoAndPlay(param1);
         this.sZjiangbanBMc.gotoAndPlay(param1);
         this.sZyifuaBMc.gotoAndPlay(param1);
         this.sZjiangbanAMc.gotoAndPlay(param1);
         this.sZyifuaAMc.gotoAndPlay(param1);
         this.sZxuanguangAMc.gotoAndPlay(param1);
         this.sZxuanguangBMc.gotoAndPlay(param1);
         this.sZwuqiMc.gotoAndPlay(param1);
      }
      
      override public function setAlpha(param1:Number) : void
      {
      }
      
      override public function changeForth(param1:int) : void
      {
         this.zhuangtaiMc.scaleX = this.jinengMc.scaleX = this.baseWeaponMc.scaleX = this.huwanMc.scaleX = this.yaodaiMc.scaleX = this.kaijiaMc.scaleX = this.skinMc.scaleX = this.mapWeaponMc.scaleX = this.sZjiangbanBMc.scaleX = this.sZyifuaBMc.scaleX = this.sZjiangbanAMc.scaleX = this.sZyifuaAMc.scaleX = this.sZxuanguangAMc.scaleX = this.sZxuanguangBMc.scaleX = this.sZwuqiMc.scaleX = param1;
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
         return this.zhuangtaiMc[param1];
      }
      
      override public function getAhit() : MovieClip
      {
         return this.jinengMc["rahit"];
      }
      
      override public function getByhit() : MovieClip
      {
         return this.skinMc["rbyhit"];
      }
      
      override public function addHitFlashEMc(param1:MovieClip) : void
      {
         this.zhuangtaiMc["genzonkuang"].addChild(param1);
         XiaoXiaoManager.addCGX(new CGXFrame(param1,null));
      }
      
      override public function addBuffer(param1:MovieClip) : void
      {
         this.zhuangtaiMc["genzonkuang"].addChild(param1);
      }
      
      override public function removeBuffer(param1:MovieClip) : void
      {
         this.zhuangtaiMc["genzonkuang"].removeChild(param1);
      }
      
      override public function getBullet(param1:String) : MovieClip
      {
         var _loc2_:MovieClip = null;
         var _loc3_:MovieClip = null;
         if(param1 == "abullet" || param1 == "abulletb")
         {
            _loc2_ = this.baseWeaponMc[param1];
            if(this.baseWeaponMcS == "WuqiB_yueguangjuezhe")
            {
               _loc2_.gotoAndStop((8 - 1) * 5 + 1);
            }
            else
            {
               _loc2_.gotoAndStop(1);
            }
            _loc3_ = _loc2_.getChildAt(0) as MovieClip;
            _loc3_.rotation = Math.round(_loc2_.rotation);
            _loc3_.x = _loc2_.x;
            _loc3_.y = _loc2_.y;
            _loc2_.parent.addChild(_loc3_);
            return _loc3_;
         }
         if(param1 == "abullet_pugong")
         {
            return this.baseWeaponMc[param1];
         }
         return this.jinengMc[param1];
      }
      
      override public function getAllBulletByClassByJineng(param1:Class) : Array
      {
         var _loc5_:* = undefined;
         var _loc2_:int = int(this.jinengMc.numChildren);
         var _loc3_:Array = [];
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_)
         {
            _loc5_ = this.jinengMc.getChildAt(_loc4_);
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
         var _loc2_:int = int(this.mapWeaponMc.numChildren);
         var _loc3_:Array = [];
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_)
         {
            _loc5_ = this.mapWeaponMc.getChildAt(_loc4_);
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

