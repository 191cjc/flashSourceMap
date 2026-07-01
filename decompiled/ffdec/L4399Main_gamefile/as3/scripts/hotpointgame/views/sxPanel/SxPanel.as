package hotpointgame.views.sxPanel
{
   import flash.display.MovieClip;
   import flash.events.*;
   import flash.text.*;
   import flash.utils.*;
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   import hotpointgame.common.event.*;
   import hotpointgame.models.bag.*;
   import hotpointgame.models.goods.*;
   import hotpointgame.repository.goods.*;
   import hotpointgame.utils.gameloader.*;
   
   public class SxPanel extends MovieClip
   {
      
      private static var _instance:SxPanel;
      
      public static var _sxMc:MovieClip;
      
      private var _textFormatArr:Array = [];
      
      private var colorArr:Array = [["名称","0xFF33FF"],["职业","0x33CCFF"],["等级","0xFFFFFF"],["部位","0xFFFFFF"],["到期时间","0xF1D35B"],["固定属性","0x00FF00"],["完美度","0x00FF00"],["完美说明","0x00FF00"],["强化","0x00FF00"],["五行抗性","0xFFFF00"],["宝石槽","0xFFFF00"],["攻击改造","0x33CCFF"],["防御改造","0x33CCFF"],["副炮改造","0x78E035"],["说明","0x33CCFF"],["价格","0xFFFF00"],["小提示","0xFFFFFF"]];
      
      private var _textFormat1:TextFormat;
      
      private var _textFormat2:TextFormat;
      
      private var _textFormat3:TextFormat;
      
      public var timer:Timer;
      
      public var timerNum:Number;
      
      private var gs:Goods;
      
      private var cwid:Number;
      
      internal var num:Number = 0;
      
      public function SxPanel()
      {
         super();
      }
      
      public static function createSxpanel() : SxPanel
      {
         var _loc1_:Object = null;
         var _loc2_:MovieClip = null;
         if(_instance == null)
         {
            _loc1_ = LoaderManager.getSwfClass("Sx_Panel") as Class;
            _loc2_ = new _loc1_();
            _sxMc = _loc2_;
            _instance = new SxPanel();
         }
         _instance.init();
         return _instance;
      }
      
      private function removeEvent() : void
      {
      }
      
      public function init() : void
      {
         this.addChild(_sxMc);
         _sxMc.visible = false;
         GM.bagJm.addChild(this);
         this.initForMat();
         this.timer = new Timer(200);
         this.addEvent();
         var _loc1_:uint = 0;
         while(_loc1_ < 3)
         {
            _sxMc.s_0["slot_" + _loc1_].gotoAndStop(1);
            _loc1_++;
         }
      }
      
      private function initForMat() : void
      {
         var _loc2_:TextFormat = null;
         var _loc1_:uint = 0;
         while(_loc1_ < this.colorArr.length)
         {
            _loc2_ = new TextFormat();
            _loc2_.color = this.colorArr[_loc1_][1];
            this._textFormatArr.push(new Array(this.colorArr[_loc1_][0],_loc2_));
            _loc1_++;
         }
         this._textFormat1 = new TextFormat();
         this._textFormat2 = new TextFormat();
         this._textFormat3 = new TextFormat();
         this._textFormat1.color = "0x999999";
         this._textFormat2.color = "0x00FF00";
      }
      
      private function addEvent() : void
      {
         Main.self.addEventListener(GoodsEvent.DO_DISPLAY,this.overHandle);
         Main.self.addEventListener(BtnEvent.DO_OUT,this.outHandle);
      }
      
      private function outHandle(param1:BtnEvent) : void
      {
         _sxMc.visible = false;
         this.timer.stop();
         this.timer.removeEventListener(TimerEvent.TIMER,this.timerHandle);
         this.gs = null;
      }
      
      private function overHandle(param1:GoodsEvent) : void
      {
         this.timerNum = 0;
         this.gs = param1.goods;
         this.cwid = param1.cwId;
         this.timer.addEventListener(TimerEvent.TIMER,this.timerHandle);
         this.timer.start();
      }
      
      private function doFun() : void
      {
         var _loc5_:String = null;
         var _loc10_:String = null;
         _sxMc.visible = true;
         _sxMc.x = mouseX + 50;
         _sxMc.y = mouseY + 10;
         var _loc1_:Goods = this.gs;
         var _loc2_:Number = Number(this.cwid);
         var _loc3_:Array = [];
         var _loc4_:Array = [];
         _sxMc.s_1.visible = false;
         if(_loc1_.getSuiteId() != -1)
         {
            _sxMc.s_1.visible = true;
            this.suitFunction(_loc1_.getSuiteId(),_loc2_);
         }
         switch(_loc1_.getColor())
         {
            case 0:
               _loc5_ = "ffffff";
               break;
            case 1:
               _loc5_ = "0066ff";
               break;
            case 2:
               _loc5_ = "FF33FF";
               break;
            case 3:
               _loc5_ = "ffcc00";
               break;
            case 4:
               _loc5_ = "ff0000";
         }
         var _loc6_:String = "";
         if(_loc1_.isStrengBo() != -1 && _loc1_.getStrengLevel() > 0)
         {
            _loc6_ = String(" " + "强化+" + _loc1_.getStrengLevel());
            _loc6_ = "<font color=\"#" + "00ff00" + "\">" + _loc6_ + "</font>";
         }
         var _loc7_:String = "<font color=\"#" + _loc5_ + "\">" + _loc1_.getName() + "</font>";
         _loc3_.push(new Array("名称",_loc7_ + _loc6_));
         if(_loc1_.getJobForStr() != null)
         {
            _loc3_.push(new Array("职业","职业:" + _loc1_.getJobForStr()));
         }
         _loc3_.push(new Array("等级","等级:" + String(_loc1_.getUseLevel())));
         if(_loc1_.getSmallTypeForStr() != null)
         {
            _loc4_.push(new Array("部位","部位:" + _loc1_.getSmallTypeForStr()));
         }
         if(_loc1_.getOverTimer() != -1)
         {
            _loc3_.push(new Array("到期时间","剩余:" + _loc1_.getCurrOverTimer() + "小时"));
         }
         if(_loc1_.getFixAtSxForStr() != null)
         {
            _loc3_.push(new Array("固定属性",_loc1_.getFixAtSxForStr()));
         }
         if(_loc1_.getIsWm() != -1 && _loc1_.getWmLevel() > GS.a0)
         {
            _loc3_.push(new Array("完美度","完美度:" + _loc1_.getWmLevel() + "/" + _loc1_.getWmMax()));
            _loc3_.push(new Array("完美说明","装备基础属性额外*" + _loc1_.getWmLevel() * 5 + "%"));
         }
         if(_loc1_.getQhforStr() != null)
         {
            _loc3_.push(new Array("强化","强化:" + _loc1_.getQhforStr()));
         }
         if(_loc1_.getFiveSxFstr() != null)
         {
            _loc3_.push(new Array("五行抗性",_loc1_.getFiveSxFstr()));
         }
         if(_loc1_.getGemFstr() != null)
         {
            _loc3_.push(new Array("宝石槽",_loc1_.getGemFstr()));
         }
         if(_loc1_.getAttChangeFstr() != null)
         {
            _loc3_.push(new Array("攻击改造",_loc1_.getAttChangeFstr()));
         }
         if(_loc1_.getAttChangeFstr() != null)
         {
            _loc3_.push(new Array("防御改造",_loc1_.getDefenseFstr()));
         }
         if(_loc1_.getAttChangeFstr() != null)
         {
            _loc3_.push(new Array("副炮改造",_loc1_.getCannonFstr()));
         }
         var _loc8_:String = _loc1_.getDirections();
         var _loc9_:int = _loc8_.lastIndexOf("*");
         if(_loc9_ != -1)
         {
            _loc10_ = _loc8_.substr(0,_loc9_);
         }
         else
         {
            _loc10_ = _loc8_;
         }
         _loc3_.push(new Array("说明",_loc10_));
         _loc3_.push(new Array("价格","价格:" + String(_loc1_.getPrice())));
         if(_loc9_ != -1)
         {
            _loc3_.push(new Array("小提示","(小提示:单击使用物品)"));
         }
         this.bwTestDisplay(_loc4_);
         this.textDisplay(_loc3_,_loc1_);
         this.hitStage(_loc1_);
      }
      
      private function timerHandle(param1:TimerEvent) : void
      {
         if(this.timerNum != 1)
         {
            ++this.timerNum;
         }
         else if(this.gs != null)
         {
            this.doFun();
            this.timer.stop();
            this.timer.removeEventListener(TimerEvent.TIMER,this.timerHandle);
         }
      }
      
      private function suitFunction(param1:Number, param2:Number) : void
      {
         var _loc6_:Array = null;
         var _loc7_:uint = 0;
         var _loc8_:Number = NaN;
         var _loc3_:Number = 1;
         _sxMc.s_1.name_text.text = SuitEquipFactory.getName(param1);
         var _loc4_:uint = 0;
         while(_loc4_ < 6)
         {
            _sxMc.s_1["bw_" + _loc4_].text = "";
            _loc4_++;
         }
         var _loc5_:Array = GoodsFactory.getSuitName(param1);
         _loc4_ = 0;
         while(_loc4_ < _loc5_.length)
         {
            _loc3_ += 1;
            _sxMc.s_1["bw_" + _loc4_].text = _loc5_[_loc4_];
            if(param2 == 0)
            {
               if(!BagFactory.equipSlot.isInEquipSlotByName(_loc5_[_loc4_]))
               {
                  _sxMc.s_1["bw_" + _loc4_].setTextFormat(this._textFormat1);
               }
               else
               {
                  _sxMc.s_1["bw_" + _loc4_].setTextFormat(this._textFormat2);
               }
            }
            else if(GM.aSaveData.petm.getPetById(this.cwid).pbag.isInEquipSlotByName(_loc5_[_loc4_]))
            {
               _sxMc.s_1["bw_" + _loc4_].setTextFormat(this._textFormat2);
            }
            else
            {
               _sxMc.s_1["bw_" + _loc4_].setTextFormat(this._textFormat1);
            }
            _loc4_++;
         }
         if(_loc5_.length < 6)
         {
            _sxMc.s_1.tz_text.y = _sxMc.s_1["bw_" + _loc5_.length].y;
         }
         else
         {
            _sxMc.s_1.tz_text.y = _sxMc.s_1["bw_" + 5].y + 20;
         }
         _loc4_ = 1;
         while(_loc4_ < 7)
         {
            _sxMc.s_1["sx_" + _loc4_].text = "";
            _sxMc.s_1["sx_" + _loc4_].width = 165;
            _sxMc.s_1["sx_" + _loc4_].wordWrap = true;
            _sxMc.s_1["sx_" + _loc4_].autoSize = TextFieldAutoSize.LEFT;
            _loc4_++;
         }
         _loc4_ = 1;
         while(_loc4_ < 7)
         {
            if(SuitEquipFactory.getSxSm(param1,_loc4_) != null)
            {
               _loc6_ = SuitEquipFactory.getSxSm(param1,_loc4_);
               _loc7_ = 0;
               while(_loc7_ < _loc6_.length)
               {
                  _loc3_ += 1;
                  _sxMc.s_1["sx_" + _loc4_].appendText(_loc6_[_loc7_] + "\n");
                  _loc7_++;
               }
            }
            _loc4_++;
         }
         _loc4_ = 1;
         while(_loc4_ < 7)
         {
            if(this.cwid == 0)
            {
               _loc8_ = Number(BagFactory.equipSlot.getSuitEquiping(param1));
            }
            else
            {
               _loc8_ = Number(GM.aSaveData.petm.getPetById(this.cwid).pbag.getSuitEquiping(param1));
            }
            if(_loc4_ <= _loc8_)
            {
               _sxMc.s_1["sx_" + _loc4_].setTextFormat(this._textFormat2);
            }
            else
            {
               _sxMc.s_1["sx_" + _loc4_].setTextFormat(this._textFormat1);
            }
            _loc4_++;
         }
         _loc4_ = 1;
         while(_loc4_ < 7)
         {
            if(_loc4_ == 1)
            {
               _sxMc.s_1["sx_" + _loc4_].y = _sxMc.s_1.tz_text.y + _sxMc.s_1.tz_text.height;
            }
            if(_loc4_ > 1)
            {
               if(_sxMc.s_1["sx_" + (_loc4_ - 1)].text != "")
               {
                  _sxMc.s_1["sx_" + _loc4_].y = _sxMc.s_1["sx_" + (_loc4_ - 1)].y + _sxMc.s_1["sx_" + (_loc4_ - 1)].height;
               }
               else
               {
                  _sxMc.s_1["sx_" + _loc4_].y = _sxMc.s_1["sx_" + (_loc4_ - 1)].y;
               }
            }
            _loc4_++;
         }
         if(_sxMc.s_1["sx_" + 6].text == "")
         {
            _sxMc.s_1.jn_text.y = _sxMc.s_1["sx_" + 6].y;
         }
         else
         {
            _sxMc.s_1.jn_text.y = _sxMc.s_1["sx_" + 6].y + _sxMc.s_1["sx_" + 6].height;
         }
         _loc4_ = 1;
         while(_loc4_ <= 4)
         {
            _sxMc.s_1["jn_" + _loc4_].text = "";
            _sxMc.s_1["jn_" + _loc4_].width = 165;
            _sxMc.s_1["jn_" + _loc4_].wordWrap = true;
            _sxMc.s_1["jn_" + _loc4_].autoSize = TextFieldAutoSize.LEFT;
            _loc4_++;
         }
         _loc4_ = 1;
         while(_loc4_ <= 4)
         {
            if(SuitEquipFactory.getJnSm(param1,_loc4_).length != 0)
            {
               _loc3_ += 1;
               _loc6_ = SuitEquipFactory.getJnSm(param1,_loc4_);
               _loc7_ = 0;
               while(_loc7_ < _loc6_.length)
               {
                  _sxMc.s_1["jn_" + _loc4_].appendText(_loc6_[_loc7_] + "\n");
                  _loc7_++;
               }
            }
            _loc4_++;
         }
         _loc4_ = 1;
         while(_loc4_ <= 4)
         {
            if(this.cwid == 0)
            {
               _loc8_ = Number(BagFactory.equipSlot.getSuitEquiping(param1));
            }
            else
            {
               _loc8_ = Number(GM.aSaveData.petm.getPetById(this.cwid).pbag.getSuitEquiping(param1));
            }
            if(_loc4_ <= _loc8_)
            {
               _sxMc.s_1["jn_" + _loc4_].setTextFormat(this._textFormat2);
            }
            else
            {
               _sxMc.s_1["jn_" + _loc4_].setTextFormat(this._textFormat1);
            }
            _loc4_++;
         }
         _loc4_ = 1;
         while(_loc4_ <= 4)
         {
            if(_loc4_ == 1)
            {
               _sxMc.s_1["jn_" + _loc4_].y = _sxMc.s_1.jn_text.y + _sxMc.s_1.jn_text.height;
            }
            if(_loc4_ > 1)
            {
               if(_sxMc.s_1["jn_" + (_loc4_ - 1)].text != "")
               {
                  _sxMc.s_1["jn_" + _loc4_].y = _sxMc.s_1["jn_" + (_loc4_ - 1)].y + _sxMc.s_1["jn_" + (_loc4_ - 1)].height;
               }
               else
               {
                  _sxMc.s_1["jn_" + _loc4_].y = _sxMc.s_1["jn_" + (_loc4_ - 1)].y;
               }
            }
            _loc4_++;
         }
         if(this.gs.getJob() != GS.a5)
         {
            _sxMc.s_1.m_mc.height = _loc3_ * 18 + _loc3_ * 6;
         }
         else
         {
            _sxMc.s_1.m_mc.height = _loc3_ * 18 + _loc3_ * 6 + 18;
         }
         _sxMc.s_1.d_mc.y = _sxMc.s_1.m_mc.y + _sxMc.s_1.m_mc.height;
      }
      
      private function bwTestDisplay(param1:Array) : void
      {
         if(param1.length != 0)
         {
            _sxMc.s_0["tt_" + 3].visible = true;
            _sxMc.s_0["tt_" + 3].text = param1[0][1];
            _sxMc.s_0["tt_" + 3].setTextFormat(this.getColorByType(param1[0][0]));
         }
         else
         {
            _sxMc.s_0["tt_" + 3].visible = false;
         }
      }
      
      private function textDisplay(param1:Array, param2:Goods) : void
      {
         var _loc4_:Number = NaN;
         var _loc5_:uint = 0;
         var _loc6_:EquipGemSlot = null;
         var _loc7_:Goods = null;
         var _loc8_:Array = null;
         var _loc9_:uint = 0;
         var _loc3_:uint = 0;
         while(_loc3_ < 3)
         {
            _sxMc.s_0["slot_" + _loc3_].visible = false;
            _sxMc.s_0["slot_" + _loc3_].qiukaifeng.visible = false;
            _loc3_++;
         }
         _loc3_ = 0;
         while(_loc3_ < 18)
         {
            _sxMc.s_0["t_" + _loc3_].text = "";
            _sxMc.s_0["t_" + _loc3_].width = 165;
            _sxMc.s_0["t_" + _loc3_].wordWrap = true;
            _sxMc.s_0["t_" + _loc3_].autoSize = TextFieldAutoSize.LEFT;
            _loc3_++;
         }
         if(param1.length != 0)
         {
            _loc3_ = 0;
            while(_loc3_ < param1.length)
            {
               if(param1[_loc3_][1] is String)
               {
                  if(param1[_loc3_][0] != "名称" && param1[_loc3_][0] != "说明")
                  {
                     _sxMc.s_0["t_" + _loc3_].text = param1[_loc3_][1];
                  }
                  else
                  {
                     (_sxMc.s_0["t_" + _loc3_] as TextField).htmlText = param1[_loc3_][1];
                  }
               }
               else if(param1[_loc3_][1] is Array)
               {
                  _loc5_ = 0;
                  while(_loc5_ < param1[_loc3_][1].length)
                  {
                     _sxMc.s_0["t_" + _loc3_].appendText(param1[_loc3_][1][_loc5_] + "\n");
                     _loc5_++;
                  }
               }
               else if(param1[_loc3_][1] is EquipGemSlot)
               {
                  _loc6_ = param1[_loc3_][1];
                  _loc5_ = 0;
                  while(_loc5_ < _loc6_.getSlotNum())
                  {
                     _sxMc.s_0["slot_" + _loc5_].gotoAndStop(1);
                     if(_loc6_.getGem(_loc5_) == null)
                     {
                        if(_loc6_.getSlot(_loc5_) == 0)
                        {
                           _sxMc.s_0["t_" + _loc3_].appendText("      " + "未打孔" + "\n");
                           _sxMc.s_0["slot_" + _loc5_]["qiukaifeng"].visible = true;
                        }
                        else
                        {
                           _sxMc.s_0["t_" + _loc3_].appendText("      " + "未镶嵌" + "\n");
                        }
                     }
                     else
                     {
                        _loc7_ = _loc6_.getGem(_loc5_);
                        _loc8_ = _loc7_.getFixAtSxForStr();
                        _sxMc.s_0["slot_" + _loc5_].gotoAndStop(_loc7_.getFrame());
                        _loc9_ = 0;
                        while(_loc9_ < _loc8_.length)
                        {
                           _sxMc.s_0["t_" + _loc3_].appendText("      " + _loc8_[_loc9_] + "\n");
                           if(_loc9_ > 1)
                           {
                           }
                           _loc9_++;
                        }
                     }
                     _loc5_++;
                  }
               }
               if(param1[_loc3_][0] != "名称" && param1[_loc3_][0] != "说明")
               {
                  _sxMc.s_0["t_" + _loc3_].setTextFormat(this.getColorByType(param1[_loc3_][0],param2));
               }
               _loc3_++;
            }
            _loc3_ = 0;
            while(_loc3_ < param1.length)
            {
               if(_loc3_ > 1)
               {
                  if(param1[_loc3_ - 1][1] is EquipGemSlot)
                  {
                     _sxMc.s_0["t_" + _loc3_].y = _sxMc.s_0["t_" + (_loc3_ - 1)].y + _sxMc.s_0["t_" + (_loc3_ - 1)].height + 15;
                  }
                  else
                  {
                     _sxMc.s_0["t_" + _loc3_].y = _sxMc.s_0["t_" + (_loc3_ - 1)].y + _sxMc.s_0["t_" + (_loc3_ - 1)].height + 4;
                  }
               }
               _loc3_++;
            }
            _loc3_ = 0;
            while(_loc3_ < param1.length)
            {
               if(param1[_loc3_][1] is EquipGemSlot)
               {
                  _loc5_ = 0;
                  while(_loc5_ < _loc6_.getSlotNum())
                  {
                     _sxMc.s_0["slot_" + _loc5_].visible = true;
                     _sxMc.s_0["slot_" + _loc5_].y = _sxMc.s_0["t_" + _loc3_].y + 1;
                     _sxMc.s_0["slot_" + _loc5_].x = _sxMc.s_0["t_" + _loc3_].x;
                     if(_loc5_ > 0)
                     {
                        _sxMc.s_0["slot_" + _loc5_].y = _sxMc.s_0["slot_" + (_loc5_ - 1)].y + _sxMc.s_0["slot_" + (_loc5_ - 1)].height;
                        _sxMc.s_0["slot_" + _loc5_].x = _sxMc.s_0["slot_" + (_loc5_ - 1)].x;
                     }
                     _loc5_++;
                  }
               }
               _loc3_++;
            }
            _loc4_ = 0;
            _loc3_ = 0;
            while(_loc3_ < param1.length)
            {
               _loc4_ += _sxMc.s_0["t_" + _loc3_].height;
               _loc3_++;
            }
            _sxMc.s_0.m_mc.height = _loc4_ + 5 * param1.length;
            _sxMc.s_0.d_mc.y = _sxMc.s_0.m_mc.y + _sxMc.s_0.m_mc.height;
         }
      }
      
      private function hitStage(param1:Goods) : void
      {
         var _loc2_:Number = 0;
         if(param1.getSuiteId() != -1)
         {
            _loc2_ = _sxMc.width;
         }
         else
         {
            _loc2_ = _sxMc.width / 2;
         }
         if(_sxMc.x + _loc2_ >= 960)
         {
            _sxMc.x = 960 - _loc2_;
         }
         if(param1.getSuiteId() != -1)
         {
            if(_sxMc.y + _sxMc.height >= 600)
            {
               _sxMc.y = 600 - _sxMc.height;
            }
         }
         else if(_sxMc.y + _sxMc.s_0.height >= 600)
         {
            _sxMc.y = 600 - _sxMc.s_0.height;
         }
         if(_sxMc.hitTestPoint(mouseX,mouseY))
         {
            _sxMc.x = mouseX - _loc2_ - 20;
         }
      }
      
      private function getColorByType(param1:String, param2:Goods = null) : TextFormat
      {
         var _loc3_:uint = 0;
         while(_loc3_ < this._textFormatArr.length)
         {
            if(param1 == this._textFormatArr[_loc3_][0])
            {
               if(param1 == "宝石槽")
               {
                  (this._textFormatArr[_loc3_][1] as TextFormat).leading = 15;
               }
               else
               {
                  (this._textFormatArr[_loc3_][1] as TextFormat).leading = 2;
               }
               if(param1 == "名称")
               {
                  this._textFormatArr[_loc3_][1] = param2.getColorStr();
               }
               else if(param1 == "职业")
               {
                  if(param2.getJob() != 5)
                  {
                     if(param2.getJob() != FlowInterface.getJobByRole())
                     {
                        (this._textFormatArr[_loc3_][1] as TextFormat).color = "0xFF0000";
                     }
                     else
                     {
                        (this._textFormatArr[_loc3_][1] as TextFormat).color = "0x33CCFF";
                     }
                  }
                  else
                  {
                     (this._textFormatArr[_loc3_][1] as TextFormat).color = "0x33CCFF";
                  }
               }
               else if(param1 == "等级")
               {
                  if(param2.getJob() != 5)
                  {
                     if(param2.getType() == 0 && param2.getUseLevel() > FlowInterface.getLevelByRole())
                     {
                        (this._textFormatArr[_loc3_][1] as TextFormat).color = "0xFF0000";
                     }
                     else
                     {
                        (this._textFormatArr[_loc3_][1] as TextFormat).color = "0xFFFFFF";
                     }
                  }
                  else if(this.cwid != 0)
                  {
                     if(param2.getType() == 0 && param2.getUseLevel() > GM.aSaveData.petm.getPetById(this.cwid).lv)
                     {
                        (this._textFormatArr[_loc3_][1] as TextFormat).color = "0xFF0000";
                     }
                     else
                     {
                        (this._textFormatArr[_loc3_][1] as TextFormat).color = "0xFFFFFF";
                     }
                  }
                  else
                  {
                     (this._textFormatArr[_loc3_][1] as TextFormat).color = "0xFF0000";
                  }
               }
               return this._textFormatArr[_loc3_][1];
            }
            _loc3_++;
         }
         return null;
      }
   }
}

