package hotpointgame.gview
{
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   import hotpointgame.utils.gameloader.*;
   
   public class PinFengC
   {
      
      private static var self:PinFengC = new PinFengC();
      
      private static var curs:int = 0;
      
      private var mc:MovieClip;
      
      private var ggod:String = "无钱";
      
      private var gexp:String = "没经";
      
      private var gach:String = "星点";
      
      private var _jishiq:VT = VT.createVT(-1);
      
      private var _jishihi:VT = VT.createVT(GS.a20);
      
      private var achA:Array;
      
      private var oldach:Number = 0;
      
      private var curach:Number = 0;
      
      private var achjihi:Number = 10;
      
      public function PinFengC()
      {
         super();
      }
      
      public static function open() : void
      {
         if(curs == 0)
         {
            self.reset();
            curs = 1;
         }
      }
      
      public static function close() : void
      {
         self.leave();
      }
      
      public function reset() : void
      {
         var _loc1_:Class = null;
         if(this.mc == null)
         {
            _loc1_ = LoaderManager.getSwfClass("pinfeng") as Class;
            this.mc = new _loc1_() as MovieClip;
            this.mc.stop();
            this.mc.x = 19563;
            this.mc.y = 29563;
         }
         this.ggod = "无钱";
         this.gexp = "没经";
         this.gach = "星点";
         this.jishiq = -1;
         this.mc.x = 0;
         this.mc.y = 0;
         this.mc.gotoAndPlay(1);
         this.oldach = 0;
         this.curach = 0;
         this.achjihi = 0;
         this.mc.addEventListener(Event.ENTER_FRAME,this.frameH);
         GM.cbGview.addChild(this.mc);
      }
      
      public function leave() : void
      {
         if(curs == 1)
         {
            curs = 0;
            this.mc.x = 19563;
            this.mc.y = 29563;
            this.achA = null;
            this.oldach = 0;
            this.curach = 0;
            this.achjihi = 0;
            this.mc.removeEventListener(Event.ENTER_FRAME,this.frameH);
            GM.cbGview.removeChild(this.mc);
         }
      }
      
      public function frameH(param1:Event) : void
      {
         var _loc2_:Array = null;
         var _loc3_:Array = null;
         var _loc4_:Array = null;
         var _loc5_:Array = null;
         if(this.jishiq != -1)
         {
            ++this.jishiq;
            if(this.jishiq == 1)
            {
               (this.mc["pfshengyushengming"] as TextField).text = "_";
               (this.mc["baoxians"] as TextField).text = "_";
               (this.mc["pfbeijicishu"] as TextField).text = "_";
               (this.mc["pfjinbi"] as TextField).text = "_";
               (this.mc["pfjingyan"] as TextField).text = "_";
               (this.mc["pfdianshu"] as TextField).text = "_";
               (this.mc["pfjinbi2"] as TextField).text = "_";
               (this.mc["pfjingyan2"] as TextField).text = "_";
               (this.mc["pfdianshu2"] as TextField).text = "_";
               (this.mc["pfewaijiangli1"] as MovieClip).visible = false;
               (this.mc["pfewaijiangli2"] as MovieClip).visible = false;
               (this.mc["pfewaijiangli3"] as MovieClip).visible = false;
               this.achA = GM.levelm.curLevel.getAchSlipData();
               this.oldach = this.achA[0];
               this.setAchSlip(this.achA);
            }
            if(this.jishiq == this.jishihi * 1)
            {
               _loc2_ = GM.levelm.curLevel.getHpRat();
               (this.mc["pfshengyushengming"] as TextField).text = _loc2_[0] + "%";
               if(_loc2_[1] != 0)
               {
                  (this.mc["pfewaijiangli1"] as MovieClip).visible = true;
               }
            }
            if(this.jishiq == this.jishihi * 2)
            {
               _loc2_ = GM.levelm.curLevel.getKillBaoWu();
               (this.mc["baoxians"] as TextField).text = "" + _loc2_[0];
               if(_loc2_[1] != 0)
               {
                  (this.mc["pfewaijiangli2"] as MovieClip).visible = true;
               }
            }
            if(this.jishiq == this.jishihi * 3)
            {
               _loc2_ = GM.levelm.curLevel.getByHitNum();
               (this.mc["pfbeijicishu"] as TextField).text = "" + _loc2_[0];
               if(_loc2_[1] != 0)
               {
                  (this.mc["pfewaijiangli3"] as MovieClip).visible = true;
               }
            }
            if(this.jishiq == this.jishihi * 4)
            {
               if(this.ggod == "无钱")
               {
                  this.ggod = "";
                  _loc3_ = GM.levelm.curLevel.getAgod();
                  (this.mc["pfjinbi"] as TextField).text = "" + _loc3_[0];
                  (this.mc["pfjinbi2"] as TextField).text = "+" + _loc3_[1];
               }
               else
               {
                  GM.findCheatMax(GS.a12);
               }
            }
            if(this.jishiq == this.jishihi * 5)
            {
               if(this.gexp == "没经")
               {
                  this.gexp = "";
                  _loc4_ = GM.levelm.curLevel.getAexp();
                  (this.mc["pfjingyan"] as TextField).text = "" + _loc4_[0];
                  (this.mc["pfjingyan2"] as TextField).text = "+" + _loc4_[1];
               }
               else
               {
                  GM.findCheatMax(GS.a13);
               }
            }
            if(this.jishiq == this.jishihi * 6)
            {
               if(this.gach == "星点")
               {
                  _loc5_ = GM.levelm.curLevel.getAach();
                  (this.mc["pfdianshu"] as TextField).text = "" + _loc5_[0];
                  (this.mc["pfdianshu2"] as TextField).text = "+" + _loc5_[1];
                  this.curach = _loc5_[2];
                  this.achjihi = (this.curach - this.oldach) / 30;
                  this.gach = "";
               }
               else
               {
                  GM.findCheatMax(GS.a14);
               }
            }
            if(this.jishiq > this.jishihi * 6)
            {
               if(this.oldach < this.curach)
               {
                  this.oldach += this.achjihi;
                  if(this.oldach > this.curach)
                  {
                     this.oldach = this.curach;
                  }
                  this.achA[0] = int(this.oldach);
                  this.setAchSlipb(this.achA);
               }
            }
            if(this.jishiq == this.jishihi * 16)
            {
               this.leave();
               KaiPaiC.open();
            }
         }
         if(this.jishiq == -1 && this.mc.currentFrame == this.mc.totalFrames)
         {
            this.mc.stop();
            this.jishiq = 0;
         }
      }
      
      private function setAchSlip(param1:Array) : void
      {
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         (this.mc["pfjianglijinbi1"] as MovieClip).visible = false;
         (this.mc["pfjianglijinbi2"] as MovieClip).visible = false;
         (this.mc["pfjianglijinbi3"] as MovieClip).visible = false;
         (this.mc["pfjianglijinbi4"] as MovieClip).visible = false;
         (this.mc["pfjianglijingyan1"] as MovieClip).visible = false;
         (this.mc["pfjianglijingyan2"] as MovieClip).visible = false;
         (this.mc["pfjianglijingyan3"] as MovieClip).visible = false;
         (this.mc["pfjianglijingyan4"] as MovieClip).visible = false;
         (this.mc["pfshadidianshuzi"] as TextField).text = "" + param1[0] + "/" + param1[1];
         var _loc2_:int = GS.a100 * param1[0] / param1[1];
         if(_loc2_ < 1)
         {
            _loc2_ = 1;
         }
         if(_loc2_ > 100)
         {
            _loc2_ = 100;
         }
         (this.mc["pfchengjiutiao"]["pftiaojian"] as MovieClip).scaleX = _loc2_ / 100;
         var _loc3_:Number = 481;
         var _loc4_:Number = 426.9;
         var _loc5_:Array = param1[2];
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_.length)
         {
            (this.mc["pfjianglijingyan" + (_loc6_ + 1)] as MovieClip).visible = true;
            _loc9_ = 0;
            if(param1[0] >= _loc5_[_loc6_])
            {
               _loc9_ = 1;
            }
            else
            {
               _loc9_ = 2;
            }
            (this.mc["pfjianglijingyan" + (_loc6_ + 1)] as MovieClip).gotoAndStop(_loc9_);
            (this.mc["pfjianglijingyan" + (_loc6_ + 1)] as MovieClip).x = _loc4_ * _loc5_[_loc6_] / param1[1] + _loc3_;
            (this.mc["pfjianglijingyan" + (_loc6_ + 1)]["svalue"] as TextField).text = param1[3][_loc6_];
            _loc6_++;
         }
         _loc5_ = param1[4];
         var _loc7_:int = 0;
         while(_loc7_ < _loc5_.length)
         {
            (this.mc["pfjianglijinbi" + (_loc7_ + 1)] as MovieClip).visible = true;
            _loc10_ = 0;
            if(param1[0] >= _loc5_[_loc7_])
            {
               _loc10_ = 1;
            }
            else
            {
               _loc10_ = 2;
            }
            (this.mc["pfjianglijinbi" + (_loc7_ + 1)] as MovieClip).gotoAndStop(_loc10_);
            (this.mc["pfjianglijinbi" + (_loc7_ + 1)] as MovieClip).x = _loc4_ * _loc5_[_loc7_] / param1[1] + _loc3_;
            (this.mc["pfjianglijinbi" + (_loc7_ + 1)]["svalue"] as TextField).text = param1[5][_loc7_];
            _loc7_++;
         }
         var _loc8_:int = 0;
         if(param1[0] >= param1[6])
         {
            _loc8_ = 1;
         }
         else
         {
            _loc8_ = 2;
         }
         (this.mc["pfkaiqi"] as MovieClip).x = _loc4_ * param1[6] / param1[1] + _loc3_;
         (this.mc["pfkaiqi"] as MovieClip).gotoAndStop(_loc8_);
      }
      
      private function setAchSlipb(param1:Array) : void
      {
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         (this.mc["pfshadidianshuzi"] as TextField).text = "" + param1[0] + "/" + param1[1];
         var _loc2_:int = GS.a100 * param1[0] / param1[1];
         if(_loc2_ < 1)
         {
            _loc2_ = 1;
         }
         if(_loc2_ > 100)
         {
            _loc2_ = 100;
         }
         (this.mc["pfchengjiutiao"]["pftiaojian"] as MovieClip).scaleX = _loc2_ / 100;
         var _loc3_:Number = 460;
         var _loc4_:Number = 426;
         var _loc5_:Array = param1[2];
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_.length)
         {
            _loc9_ = 0;
            if(param1[0] >= _loc5_[_loc6_])
            {
               _loc9_ = 1;
            }
            else
            {
               _loc9_ = 2;
            }
            (this.mc["pfjianglijingyan" + (_loc6_ + 1)] as MovieClip).gotoAndStop(_loc9_);
            _loc6_++;
         }
         _loc5_ = param1[4];
         var _loc7_:int = 0;
         while(_loc7_ < _loc5_.length)
         {
            _loc10_ = 0;
            if(param1[0] >= _loc5_[_loc7_])
            {
               _loc10_ = 1;
            }
            else
            {
               _loc10_ = 2;
            }
            (this.mc["pfjianglijinbi" + (_loc7_ + 1)] as MovieClip).gotoAndStop(_loc10_);
            _loc7_++;
         }
         var _loc8_:int = 0;
         if(param1[0] >= param1[6])
         {
            _loc8_ = 1;
         }
         else
         {
            _loc8_ = 2;
         }
         (this.mc["pfkaiqi"] as MovieClip).gotoAndStop(_loc8_);
      }
      
      public function get jishiq() : int
      {
         return this._jishiq.getValue();
      }
      
      public function set jishiq(param1:int) : void
      {
         this._jishiq.setValue(param1);
      }
      
      public function get jishihi() : int
      {
         return this._jishihi.getValue();
      }
      
      public function set jishihi(param1:int) : void
      {
         this._jishihi.setValue(param1);
      }
   }
}

