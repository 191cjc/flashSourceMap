package hotpointgame.views.playerPanel
{
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   import flash.ui.*;
   import flash.utils.*;
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   import hotpointgame.common.basicBtn.*;
   import hotpointgame.common.event.*;
   import hotpointgame.common.newBasicBtn.*;
   import hotpointgame.gxiaodongxi.*;
   import hotpointgame.models.bag.*;
   import hotpointgame.models.goods.EquipGemSlot;
   import hotpointgame.models.goods.Goods;
   import hotpointgame.repository.analysis.*;
   import hotpointgame.utils.*;
   import hotpointgame.utils.gameloader.*;
   import hotpointgame.views.chongwu.*;
   import hotpointgame.views.comPanel.*;
   import hotpointgame.views.insertPanel.*;
   import hotpointgame.views.shipPanel.*;
   import hotpointgame.views.strengPanel.*;
   import hotpointgame.views.taskPanel.*;
   import hotpointgame.views.wareroomPanel.*;
   import hotpointgame.views.wmdPanel.*;
   import hotpointgame.views.zenfuPanel.*;
   
   public class BagDisplay extends MovieClip
   {
      
      public static var operatingMc:MovieClip;
      
      private static var _instance:BagDisplay;
      
      private static var fjSave:Boolean = false;
      
      public var _bagState:Number = 0;
      
      public var _typeState:Number = 0;
      
      private var _moveMc:MovieClip;
      
      private var _currentGird:Gird = null;
      
      private var _moveCurrGird:Gird = null;
      
      private var _moveCurrId:Number;
      
      private var _bag:Bag;
      
      private var _typeBtn:SameChangeBtn;
      
      private var _operatingBtn:SameChangeBtn;
      
      private var _instance:BagDisplay;
      
      private var _timerNum:Number = 0;
      
      private var _timer:Timer;
      
      private var _pos:Number = 0;
      
      public var _parentMc:Object;
      
      private var zlBtn:SlideChangeBtn;
      
      private var _currentId:Number;
      
      private var jBtn1:SlideChangeBtn;
      
      private var jBtn2:SlideChangeBtn;
      
      private var idXX:Number;
      
      private var numXX:Number;
      
      private var tbBoxArr:Array = [];
      
      private var ckGoodsBtn:GoodsBtnX;
      
      private var posXX:VT = VT.createVT(-1);
      
      private var xzGid:VT = VT.createVT(-1);
      
      private var xzNum:VT = VT.createVT(-1);
      
      public function BagDisplay()
      {
         super();
      }
      
      public static function createBagDisplay(param1:Number, param2:Number) : BagDisplay
      {
         var _loc3_:Object = null;
         var _loc4_:MovieClip = null;
         var _loc5_:Object = null;
         var _loc6_:uint = 0;
         var _loc7_:MovieClip = null;
         var _loc8_:MovieClip = null;
         var _loc9_:GoodsBtnX = null;
         if(_instance == null)
         {
            _loc3_ = LoaderManager.getSwfClass("Bag_panel") as Class;
            _loc4_ = new _loc3_();
            operatingMc = _loc4_;
            _loc5_ = LoaderManager.getSwfClass("T_Box") as Class;
            _instance = new BagDisplay();
            _instance.addChild(operatingMc);
            _instance._moveMc = new _loc5_();
            _instance.addChild(_instance._moveMc);
            _loc6_ = 0;
            while(_loc6_ < 20)
            {
               _loc8_ = new _loc5_();
               _loc8_.name = "g_" + _loc6_;
               _loc9_ = new GoodsBtnX(_loc8_,operatingMc["bd_" + _loc6_].x,operatingMc["bd_" + _loc6_].y);
               _instance.tbBoxArr.push(_loc9_);
               _instance.addChild(_loc9_);
               _loc6_++;
            }
            _loc7_ = new _loc5_();
            _loc7_.name = "xx_0";
            _instance.ckGoodsBtn = new GoodsBtnX(_loc7_,461,262);
            operatingMc.gn_Mc.addChild(_instance.ckGoodsBtn);
            _instance.initBtn();
         }
         _instance.init();
         _instance.x = param1;
         _instance.y = param2;
         return _instance;
      }
      
      public static function save() : Object
      {
         var _loc1_:Object = new Object();
         _loc1_["fj"] = fjSave;
         return _loc1_;
      }
      
      public static function read(param1:Object) : void
      {
         fjSave = param1["fj"];
      }
      
      private function fjBtnDis() : void
      {
         operatingMc.t_0.visible = false;
         if(FlowInterface.getLevelByRole() >= 9)
         {
            operatingMc.t_0.visible = true;
            if(!fjSave)
            {
               GoodsManger.tsFunction("Ts_49",905,337);
               GoodsManger.cwTs("分解系统已在背包内开启！");
               fjSave = true;
            }
         }
      }
      
      public function maskMcDisplay(param1:uint = 0) : void
      {
         if(param1 == 0)
         {
            operatingMc.maskMc.visible = false;
         }
         else if(param1 == 1)
         {
            operatingMc.maskMc.visible = true;
            addChildAt(operatingMc.maskMc,numChildren - 1);
         }
      }
      
      public function close() : void
      {
         this.visible = false;
         operatingMc.maskMc.visible = false;
         Mouse.show();
         this.posXX.setValue(-1);
         if(operatingMc.gn_Mc.visible)
         {
            operatingMc.gn_Mc.visible = false;
         }
         operatingMc.mcXX.visible = false;
         operatingMc.savexx.visible = false;
         this._currentGird = null;
         this._moveCurrGird = null;
         Main.self.removeEventListener(MouseEvent.MOUSE_MOVE,this.moveHandle);
         removeEventListener(BtnEvent.DO_CLICK,this.clickHandle);
      }
      
      public function init() : void
      {
         BagFactory.deleteTimeGs();
         this.visible = true;
         this._moveMc.stop();
         this._moveMc.visible = false;
         this._bagState = 0;
         this._typeState = 0;
         this._timer = new Timer(0);
         this.initGoodsDisplay(this._bagState);
         this.operatingData();
         this.selloRFJ();
         this._operatingBtn.btnOk(0);
         this._operatingBtn.czArr();
         addEventListener(BtnEvent.DO_SAME_CHANGE,this.changeHandle);
         addEventListener(BtnEvent.DO_CHANGE,this.zhlHandle);
         Main.self.addEventListener(UpdateBagEvent.DO_UPDATE,this.dateHandle);
         addEventListener(BtnEvent.DO_OVER,this.overHandle);
         addEventListener(BtnEvent.DO_OUT,this.outHandle);
         Main.self.addEventListener(MouseEvent.MOUSE_MOVE,this.moveHandle);
         this.getGoldTx();
         this.fjBtnDis();
         operatingMc.maskMc.visible = false;
         operatingMc.mcXX.visible = false;
         operatingMc.savexx.visible = false;
         this.posXX.setValue(-1);
         this._operatingBtn.closeOrOpenBtnById(0,1);
         this._operatingBtn.closeOrOpenBtnById(1,1);
      }
      
      public function getGoldTx() : void
      {
         operatingMc.gold_tx.text = String(FlowInterface.getGodByRole());
         operatingMc.dj_tx.text = String(FlowInterface.getDianJuanByRole());
      }
      
      public function okFjMv() : void
      {
         GoodsManger.saveMoviclip(this.okFj,"Ts_51");
         operatingMc.mcXX.visible = false;
      }
      
      public function okFj() : void
      {
         BagFactory.hdGoodsTs(this.idXX,this.numXX);
         TaskData.isGoodsOk(this.idXX);
      }
      
      private function kaiXz() : void
      {
         (this._parentMc as PlayerBagPanel).cdMc.visible = false;
         GoodsManger.saveMoviclip(this.okKxz,"Ts_144");
      }
      
      private function okKxz() : void
      {
         if(this.xzGid.getValue() != -1)
         {
            BagFactory.hdGoodsTs(this.xzGid.getValue(),this.xzNum.getValue());
         }
         else
         {
            GoodsManger.cwTs("很遗憾,宝箱是空的!");
         }
         this.tbMastMc();
         this.getGoldTx();
         this.initGoodsDisplay(this._bagState);
         this._currentGird = null;
         this.xzGid.setValue(-1);
         this.xzNum.setValue(-1);
      }
      
      private function zhlHandle(param1:BtnEvent) : void
      {
         var _loc2_:Goods = null;
         var _loc3_:VT = null;
         var _loc4_:uint = 0;
         var _loc5_:Array = null;
         var _loc6_:Array = null;
         var _loc7_:Array = null;
         var _loc8_:Array = null;
         var _loc9_:VT = null;
         var _loc10_:VT = null;
         var _loc11_:uint = 0;
         var _loc12_:Array = null;
         var _loc13_:Array = null;
         var _loc14_:VT = null;
         var _loc15_:VT = null;
         var _loc16_:VT = null;
         var _loc17_:uint = 0;
         var _loc18_:VT = null;
         if(param1.name == "t" && param1.id == 2)
         {
            this.zlBtn.okBtn = false;
            if(this._bagState == 0 || this._bagState == 3)
            {
               this.zhenliFunction(new Array("职业","等级","部位","颜色"),new Array(Array.NUMERIC,Array.DESCENDING | Array.NUMERIC,Array.NUMERIC,Array.DESCENDING | Array.NUMERIC));
            }
            else if(this._bagState == 1 || this._bagState == 2)
            {
               this.zhenliFunction(new Array("类型","小类型","等级","颜色"),new Array(Array.NUMERIC,Array.NUMERIC,Array.DESCENDING | Array.NUMERIC,Array.DESCENDING | Array.NUMERIC));
            }
            this.tbMastMc();
         }
         else if(param1.name == "ok")
         {
            operatingMc.gn_Mc.visible = false;
            addChildAt(operatingMc.gn_Mc,numChildren - 2);
            addChildAt(operatingMc.mouse_mc,numChildren - 1);
            if(param1.id == 0 && this._currentGird != null)
            {
               _loc2_ = this._currentGird.getGoods();
               if(this._typeState == 2)
               {
                  _loc3_ = VT.createVT(Number(operatingMc.gn_Mc.num_text.text));
                  if(_loc3_.getValue() > this._currentGird.getGoodsNum())
                  {
                     _loc3_.setValue(this._currentGird.getGoodsNum());
                     operatingMc.gn_Mc.num_text.text = String(_loc3_.getValue());
                  }
                  else if(_loc3_.getValue() == GS.a0)
                  {
                     _loc3_.setValue(GS.a1);
                     operatingMc.gn_Mc.num_text.text = String(_loc3_.getValue());
                  }
                  else if(_loc3_.getValue() < GS.a0)
                  {
                     FlowInterface.findCheat(GS.a105);
                  }
                  this._bag.deleteBag(this._currentId,_loc3_.getValue());
                  FlowInterface.addGodByRole(_loc2_.getPrice() * _loc3_.getValue());
                  this.tbMastMc();
                  this.getGoldTx();
                  this.initGoodsDisplay(this._bagState);
                  this._currentGird = null;
               }
               else if(this._typeState == 1)
               {
                  if(BagFactory.gemBag.getAirGirdNum() > GS.a0 && BagFactory.otherBag.getAirGirdNum() > GS.a0)
                  {
                     _loc4_ = Math.floor(GS.a100 * Math.random());
                     _loc5_ = AnalysisFactory.getAnalysisGoods(_loc2_.getUseLevel(),_loc2_.getColor(),_loc4_);
                     this._bag.deleteBag(this._currentId,GS.a1);
                     BagFactory.addInBagById(_loc5_[0].getValue(),_loc5_[1].getValue(),GS.a0);
                     this.idXX = _loc5_[0].getValue();
                     this.numXX = _loc5_[1].getValue();
                     operatingMc.mcXX.visible = true;
                     FlowInterface.saveDataByKai(this.okFjMv);
                     GoodsManger.dataList.evData.setJd(GS.a17);
                     this.tbMastMc();
                     this.getGoldTx();
                     this.initGoodsDisplay(this._bagState);
                     this._currentGird = null;
                  }
                  else
                  {
                     GoodsManger.cwTs("背包已满");
                  }
               }
               else if(this._typeState == 0)
               {
                  if(_loc2_.isUse())
                  {
                     if(_loc2_.getUseLevel() <= FlowInterface.getLevelByRole())
                     {
                        if(_loc2_.getSmallType() == GS.a5)
                        {
                           if(TaskData.openJz(_loc2_.getId()))
                           {
                              this._bag.deleteBag(this._currentId,GS.a1);
                              this.tbMastMc();
                              this.getGoldTx();
                              this.initGoodsDisplay(this._bagState);
                              this._currentGird = null;
                           }
                        }
                        else if(_loc2_.getSmallType() == GS.a9)
                        {
                           if(FlowInterface.getGodByRole() + _loc2_.getOtherValue() <= FlowInterface.getMaxGodByLevel())
                           {
                              FlowInterface.addGodByRole(_loc2_.getOtherValue());
                              this._bag.deleteBag(this._currentId,GS.a1);
                              this.tbMastMc();
                              this.getGoldTx();
                              this.initGoodsDisplay(this._bagState);
                              this._currentGird = null;
                           }
                           else
                           {
                              GoodsManger.cwTs("超过可携带晶币上限");
                           }
                        }
                        else if(_loc2_.getSmallType() == GS.a11)
                        {
                           if(BagFactory.addSameInBag(_loc2_.getLwId(),_loc2_.getLwNum()))
                           {
                              this._bag.deleteBag(this._currentId,GS.a1);
                              this.tbMastMc();
                              this.getGoldTx();
                              this.initGoodsDisplay(this._bagState);
                              this._currentGird = null;
                           }
                        }
                        else if(_loc2_.getSmallType() == GS.a14)
                        {
                           if(FlowInterface.skillBookIsOk(_loc2_.getJd()))
                           {
                              FlowInterface.useSkillBook(_loc2_.getJd(),_loc2_.getOtherValue());
                              this._bag.deleteBag(this._currentId,GS.a1);
                              GoodsManger.cwTs("你获得了新的技能");
                              FlowInterface.saveDataByKai();
                              this.tbMastMc();
                              this.getGoldTx();
                              this.initGoodsDisplay(this._bagState);
                              this._currentGird = null;
                           }
                           else
                           {
                              GoodsManger.cwTs("元素技能只能学习一个");
                           }
                        }
                        else if(_loc2_.getSmallType() == GS.a15)
                        {
                           if(FlowInterface.useSkillBookByClear(_loc2_.getJd()))
                           {
                              this._bag.deleteBag(this._currentId,GS.a1);
                              GoodsManger.cwTs("元素技能已经被遗忘");
                              FlowInterface.saveDataByKai();
                              this.tbMastMc();
                              this.getGoldTx();
                              this.initGoodsDisplay(this._bagState);
                              this._currentGird = null;
                           }
                           else
                           {
                              GoodsManger.cwTs("暂未学习元素技能");
                           }
                        }
                        else if(_loc2_.getSmallType() == GS.a24)
                        {
                           if(this._parentMc is PlayerBagPanel)
                           {
                              if(int(GM.cp.getToMaxLvExp() / _loc2_.getOtherValue()) > GS.a0)
                              {
                                 (this._parentMc as PlayerBagPanel).expPanel(true,int(GM.cp.getToMaxLvExp() / _loc2_.getOtherValue()),_loc2_);
                                 this.tbMastMc();
                                 this.getGoldTx();
                                 this.initGoodsDisplay(this._bagState);
                                 this._currentGird = null;
                              }
                              else
                              {
                                 GoodsManger.cwTs("角色等级已满");
                              }
                           }
                        }
                        else if(_loc2_.getSmallType() == GS.a25)
                        {
                           if(this._parentMc is PlayerBagPanel)
                           {
                              if(BagFactory.bagOnlyGird())
                              {
                                 (this._parentMc as PlayerBagPanel).cdMc.visible = true;
                                 this._bag.deleteBag(this._currentId,GS.a1);
                                 this.initGoodsDisplay(this._bagState);
                                 _loc6_ = _loc2_.getRewGl();
                                 _loc7_ = _loc2_.getLwId();
                                 _loc8_ = _loc2_.getLwNum();
                                 _loc9_ = VT.createVT(GS.a0);
                                 this.xzGid.setValue(-1);
                                 this.xzNum.setValue(-1);
                                 _loc10_ = VT.createVT(int(Math.random() * GS.a10000));
                                 _loc11_ = 0;
                                 while(_loc11_ < _loc6_.length)
                                 {
                                    _loc9_.setValue(_loc9_.getValue() + _loc6_[_loc11_]);
                                    if(_loc9_.getValue() >= _loc10_.getValue())
                                    {
                                       BagFactory.addInBagById(_loc7_[_loc11_],_loc8_[_loc11_],GS.a0);
                                       this.xzGid.setValue(_loc7_[_loc11_]);
                                       this.xzNum.setValue(_loc8_[_loc11_]);
                                       break;
                                    }
                                    _loc11_++;
                                 }
                                 if(_loc9_.getValue() < _loc10_.getValue())
                                 {
                                    this.xzGid.setValue(-1);
                                    this.xzNum.setValue(-1);
                                 }
                                 FlowInterface.saveDataByKai(this.kaiXz);
                              }
                              else
                              {
                                 GoodsManger.cwTs("背包每栏至少需要一个空格子");
                              }
                           }
                        }
                        else if(_loc2_.getSmallType() == GS.a26)
                        {
                           if(BagFactory.roomSlot.getNoKey() > GS.a1)
                           {
                              this._bag.deleteBag(this._currentId,GS.a1);
                              BagFactory.roomSlot.openBag(GS.a1);
                              this.initGoodsDisplay(this._bagState);
                              this._currentGird = null;
                           }
                        }
                        else if(_loc2_.getSmallType() == GS.a29)
                        {
                           if(ShipData.tl.getValue() < GS.a100)
                           {
                              this._bag.deleteBag(this._currentId,GS.a1);
                              ShipData.addTl(_loc2_.getOtherValue());
                              this.initGoodsDisplay(this._bagState);
                              this._currentGird = null;
                           }
                           else
                           {
                              GoodsManger.cwTs("体力已满");
                           }
                        }
                     }
                     else
                     {
                        GoodsManger.cwTs("人物等级不足");
                     }
                     if(_loc2_.getSmallType() == GS.a18)
                     {
                        _loc12_ = _loc2_.getNeedId();
                        _loc13_ = _loc2_.getRewGl();
                        _loc14_ = VT.createVT(int(Math.random() * (GS.a10000 * GS.a100)));
                        _loc15_ = VT.createVT(GS.a0);
                        _loc16_ = VT.createVT(GS.a0);
                        _loc17_ = 0;
                        while(_loc17_ < _loc13_.length)
                        {
                           _loc15_.setValue(_loc15_.getValue() + _loc13_[_loc17_]);
                           if(_loc15_.getValue() >= _loc14_.getValue())
                           {
                              _loc16_.setValue(_loc12_[_loc17_]);
                              break;
                           }
                           _loc17_++;
                        }
                        if(_loc16_.getValue() <= 0)
                        {
                           return;
                        }
                        if(GM.aSaveData.petm.useEgg(_loc16_.getValue(),_loc2_.getOtherValue(),_loc2_.getColor()))
                        {
                           this._bag.deleteBag(this._currentId,GS.a1);
                           if(this._parentMc is ChongWuPanel)
                           {
                              (this._parentMc as ChongWuPanel).cdMc.visible = true;
                           }
                           else if(this._parentMc is PlayerBagPanel)
                           {
                              (this._parentMc as PlayerBagPanel).cdMc.visible = true;
                           }
                           this.tbMastMc();
                           this.getGoldTx();
                           this.initGoodsDisplay(this._bagState);
                           this._currentGird = null;
                           FlowInterface.saveDataByKai(this.cwSave);
                        }
                        else
                        {
                           GoodsManger.cwTs("宠物栏不足");
                        }
                     }
                  }
               }
               this.sXComJp();
            }
         }
         else if(param1.name == "jt")
         {
            _loc14_ = VT.createVT(Number(operatingMc.gn_Mc.num_text.text));
            _loc18_ = VT.createVT(this._currentGird.getGoodsNum());
            if(_loc14_.getValue() > _loc18_.getValue())
            {
               _loc14_.setValue(_loc18_.getValue());
            }
            if(param1.id == GS.a0)
            {
               _loc14_.setValue(_loc14_.getValue() - GS.a1);
               if(_loc14_.getValue() < GS.a1)
               {
                  _loc14_.setValue(_loc18_.getValue());
               }
            }
            else if(param1.id == GS.a1)
            {
               _loc14_.setValue(_loc14_.getValue() + GS.a1);
               if(_loc14_.getValue() > _loc18_.getValue())
               {
                  _loc14_.setValue(GS.a1);
               }
            }
            operatingMc.gn_Mc.num_text.text = String(_loc14_.getValue());
         }
      }
      
      private function cwSave() : void
      {
         if(this._parentMc is ChongWuPanel)
         {
            (this._parentMc as ChongWuPanel).cdMc.visible = false;
            ChongWuPanel.wdFun();
         }
         else if(this._parentMc is PlayerBagPanel)
         {
            (this._parentMc as PlayerBagPanel).cdMc.visible = false;
         }
      }
      
      private function zhenliFunction(param1:Array, param2:Array) : void
      {
         var _loc7_:Goods = null;
         var _loc9_:Gird = null;
         var _loc10_:Gird = null;
         var _loc11_:Object = null;
         var _loc3_:Array = DeepCopyUtil.clone(this._bag.getBagArr());
         var _loc4_:Array = [];
         var _loc5_:Array = [];
         var _loc6_:Array = [];
         var _loc8_:uint = 0;
         while(_loc8_ < _loc3_.length)
         {
            _loc10_ = _loc3_[_loc8_] as Gird;
            _loc7_ = _loc10_.getGoods();
            if(_loc7_ != null)
            {
               _loc4_.push(_loc10_);
            }
            _loc8_++;
         }
         for each(_loc9_ in _loc4_)
         {
            _loc7_ = _loc9_.getGoods();
            _loc11_ = {
               "girdObj":_loc9_,
               "类型":_loc7_.getType(),
               "小类型":_loc7_.getSmallType(),
               "职业":_loc7_.getJob(),
               "等级":_loc7_.getUseLevel(),
               "部位":_loc7_.getSmallType(),
               "颜色":_loc7_.getColor()
            };
            _loc5_.push(_loc11_);
         }
         _loc5_.sortOn(param1,param2);
         _loc8_ = 0;
         while(_loc8_ < _loc5_.length)
         {
            _loc6_.push(_loc5_[_loc8_].girdObj as Gird);
            _loc8_++;
         }
         if(this._bag.addNewBag(_loc6_))
         {
            this.zlBtn.okBtn = true;
         }
         this.initFrame();
      }
      
      private function dateHandle(param1:UpdateBagEvent) : void
      {
         if(param1.update != -1)
         {
            this._pos = param1.update;
            this._timer.start();
            if(this._parentMc is ComPanel == false)
            {
               this._bagState = param1.updateBag;
            }
            this.initGoodsDisplay(this._bagState);
            if(param1.bo)
            {
               this.gxDisplay(param1.updateBag,param1.update);
               this._timerNum = 0;
               this._timer.addEventListener(TimerEvent.TIMER,this.onTimer);
            }
            this.tbMastMc();
         }
      }
      
      private function gxDisplay(param1:Number, param2:Number) : void
      {
         var _loc3_:uint = 0;
         if(param1 == this._bagState)
         {
            _loc3_ = 0;
            while(_loc3_ < 20)
            {
               if(_loc3_ == param2)
               {
                  (this.tbBoxArr[_loc3_] as GoodsBtnX).getSmMc().gx_mc.visible = true;
               }
               else
               {
                  (this.tbBoxArr[_loc3_] as GoodsBtnX).getSmMc().gx_mc.visible = false;
               }
               _loc3_++;
            }
         }
      }
      
      private function onTimer(param1:TimerEvent) : void
      {
         if(this._timerNum <= 100)
         {
            ++this._timerNum;
         }
         else
         {
            (this.tbBoxArr[this._pos] as GoodsBtnX).getSmMc().gx_mc.visible = false;
            this._pos = 0;
            this._timerNum = 0;
            this._timer.stop();
            this._timer.removeEventListener(TimerEvent.TIMER,this.onTimer);
         }
      }
      
      private function operatingData() : void
      {
         addEventListener(BtnEvent.DO_CLICK,this.clickHandle);
         if(this._typeState == 0)
         {
            addEventListener(BtnEvent.DO_MOUSEMOVE,this.moveGoodsHandle);
            addEventListener(BtnEvent.DO_MOUSEUP_ONE,this.wearGoodsHandle);
            addEventListener(BtnEvent.DO_MOUSEUP_TOW,this.changeGoodsHandle);
            removeEventListener(BtnEvent.DO_CLICK,this.sellHandle);
         }
         else if(this._typeState == 1 || this._typeState == 2)
         {
            removeEventListener(BtnEvent.DO_MOUSEMOVE,this.moveGoodsHandle);
            removeEventListener(BtnEvent.DO_MOUSEUP_ONE,this.wearGoodsHandle);
            removeEventListener(BtnEvent.DO_MOUSEUP_TOW,this.changeGoodsHandle);
            Main.self.addEventListener(MouseEvent.MOUSE_MOVE,this.moveHandle);
            addEventListener(BtnEvent.DO_CLICK,this.sellHandle);
         }
      }
      
      private function clickHandle(param1:BtnEvent) : void
      {
         if(param1.name == "xingzhuang")
         {
            FlowInterface.gotoShopPanel();
         }
      }
      
      private function outHandle(param1:BtnEvent) : void
      {
         if(param1.name == "g")
         {
            (this.tbBoxArr[param1.id] as GoodsBtnX).getSmMc().gx_mc.visible = false;
         }
         else if(param1.name == "jingbi")
         {
            operatingMc.btnTs.visible = false;
         }
      }
      
      private function overHandle(param1:BtnEvent) : void
      {
         var _loc2_:Goods = null;
         if(param1.name == "g")
         {
            _loc2_ = this._bag.getGoods(param1.id);
            Main.self.dispatchEvent(new GoodsEvent(GoodsEvent.DO_DISPLAY,_loc2_));
            (this.tbBoxArr[param1.id] as GoodsBtnX).getSmMc().gx_mc.visible = true;
         }
         else if(param1.name == "xx")
         {
            Main.self.dispatchEvent(new GoodsEvent(GoodsEvent.DO_DISPLAY,this._currentGird.getGoods()));
         }
         else if(param1.name == "jingbi")
         {
            operatingMc.btnTs.visible = true;
            operatingMc.btnTs.jn_3.text = "最大可携带晶币数量:" + FlowInterface.getMaxGodByLevel();
            operatingMc.btnTs.x = mouseX;
            operatingMc.btnTs.y = mouseY;
            this.addChildAt(operatingMc.btnTs,numChildren - 1);
         }
      }
      
      private function sellHandle(param1:BtnEvent) : void
      {
         var _loc2_:Goods = null;
         var _loc3_:int = 0;
         var _loc4_:uint = 0;
         var _loc5_:Array = null;
         var _loc6_:Number = NaN;
         if(param1.name == "g")
         {
            _loc2_ = this._bag.getGoods(param1.id);
            if(this._typeState == 1)
            {
               if(_loc2_.getType() == GS.a0 && _loc2_.getSmallType() != GS.a3 && _loc2_.getSmallType() != GS.a7)
               {
                  this._currentId = param1.id;
                  this._currentGird = this._bag.getGird(param1.id);
                  if(_loc2_.getColor() == 3 || _loc2_.getColor() == 4)
                  {
                     operatingMc.gn_Mc.gotoAndStop(3);
                     operatingMc.gn_Mc.visible = true;
                     addChildAt(operatingMc.gn_Mc,numChildren - 2);
                     this.ckGoodsBtn.visible = false;
                     _loc3_ = 0;
                     while(_loc3_ < 2)
                     {
                        operatingMc.gn_Mc["jt_" + _loc3_].visible = false;
                        _loc3_++;
                     }
                  }
                  else
                  {
                     _loc4_ = 0;
                     _loc4_ = Math.floor(GS.a100 * Math.random());
                     if(BagFactory.gemBag.getAirGirdNum() > 0 && BagFactory.otherBag.getAirGirdNum() > 0)
                     {
                        _loc5_ = AnalysisFactory.getAnalysisGoods(_loc2_.getUseLevel(),_loc2_.getColor(),_loc4_);
                        this._bag.deleteBag(this._currentId,1);
                        BagFactory.addInBagById(_loc5_[0].getValue(),_loc5_[1].getValue(),GS.a0);
                        BagFactory.hdGoodsTs(_loc5_[0].getValue(),_loc5_[1].getValue());
                        TaskData.isGoodsOk(_loc5_[0].getValue());
                        this.initGoodsDisplay(this._bagState);
                        this._currentGird = null;
                        this.sXComJp();
                        GoodsManger.dataList.evData.setJd(GS.a17);
                     }
                     else
                     {
                        GoodsManger.cwTs("背包已满");
                     }
                  }
               }
               else
               {
                  GoodsManger.cwTs("无法分解");
               }
            }
            else if(this._typeState == 2)
            {
               if(_loc2_.isSell())
               {
                  this._currentId = param1.id;
                  this._currentGird = this._bag.getGird(param1.id);
                  _loc6_ = Number(this._currentGird.getGoodsNum());
                  if(_loc2_.getColor() > 2 || _loc6_ > 1)
                  {
                     this.ckGoodsBtn.visible = true;
                     _loc3_ = 0;
                     while(_loc3_ < 2)
                     {
                        operatingMc.gn_Mc["jt_" + _loc3_].visible = true;
                        _loc3_++;
                     }
                     operatingMc.gn_Mc.visible = true;
                     operatingMc.gn_Mc.gotoAndStop(1);
                     addChildAt(operatingMc.gn_Mc,numChildren - 2);
                     this.ckGoodsBtn.getSmMc().gx_mc.visible = false;
                     this.ckGoodsBtn.getSmMc().mask_mc.stop();
                     operatingMc.gn_Mc.num_text.restrict = "0-9";
                     operatingMc.gn_Mc.num_text.maxChars = GS.a3;
                     operatingMc.gn_Mc.num_text.text = String(GS.a1);
                     operatingMc.gn_Mc.name_text.text = _loc2_.getName();
                     (operatingMc.gn_Mc.name_text as TextField).setTextFormat(_loc2_.getColorStr());
                     this.ckGoodsBtn.getSmMc().gotoAndStop(_loc2_.getFrame());
                     if(_loc6_ <= 1)
                     {
                        this.jBtn1.okBtn = false;
                        this.jBtn2.okBtn = false;
                        operatingMc.gn_Mc.num_text.selectable = false;
                     }
                     else
                     {
                        this.jBtn1.okBtn = true;
                        this.jBtn2.okBtn = true;
                        operatingMc.gn_Mc.num_text.selectable = true;
                     }
                  }
                  else
                  {
                     this._bag.deleteBag(this._currentId,_loc6_);
                     this.initGoodsDisplay(this._bagState);
                     this._currentGird = null;
                     FlowInterface.addGodByRole(_loc2_.getPrice());
                     this.getGoldTx();
                     this.sXComJp();
                  }
               }
               else
               {
                  GoodsManger.cwTs("无法出售");
               }
            }
         }
      }
      
      public function initGoodsDisplay(param1:Number) : void
      {
         this._typeBtn.btnOk(param1);
         this.initBagData(param1);
         this.initFrame();
      }
      
      private function initFrame() : void
      {
         var _loc3_:Gird = null;
         var _loc4_:Goods = null;
         var _loc1_:Array = this._bag.getBagArr();
         var _loc2_:uint = 0;
         while(_loc2_ < _loc1_.length)
         {
            _loc3_ = _loc1_[_loc2_] as Gird;
            _loc4_ = _loc3_.getGoods();
            (this.tbBoxArr[_loc2_] as GoodsBtnX).visible = false;
            (this.tbBoxArr[_loc2_] as GoodsBtnX).getSmMc().t_txt.text = "";
            if(_loc4_ != null)
            {
               (this.tbBoxArr[_loc2_] as GoodsBtnX).visible = true;
               (this.tbBoxArr[_loc2_] as GoodsBtnX).getSmMc().gotoAndStop(_loc4_.getFrame());
               if(_loc3_.getGoodsNum() > 1)
               {
                  (this.tbBoxArr[_loc2_] as GoodsBtnX).getSmMc().t_txt.text = String(_loc3_.getGoodsNum());
               }
            }
            _loc2_++;
         }
      }
      
      private function initBagData(param1:*) : void
      {
         switch(param1)
         {
            case 0:
               this._bag = BagFactory.equipBag;
               break;
            case 1:
               this._bag = BagFactory.gemBag;
               break;
            case 2:
               this._bag = BagFactory.otherBag;
               break;
            case 3:
               this._bag = BagFactory.clothesBag;
         }
      }
      
      private function loadZzOver() : void
      {
         var _loc1_:Goods = null;
         if(this.posXX.getValue() != -1)
         {
            _loc1_ = this._bag.getGoods(this.posXX.getValue());
            if(_loc1_ != null && _loc1_.getType() == GS.a0)
            {
               if(_loc1_.getSmallType() == GS.a7)
               {
                  if(FlowInterface.getRoleState() == GS.a1 || FlowInterface.getRoleState() == GS.a2)
                  {
                     this.posXX.setValue(-1);
                     return;
                  }
               }
               else if(_loc1_.getSmallType() == GS.a3)
               {
                  if(FlowInterface.getRoleState() == GS.a2)
                  {
                     this.posXX.setValue(-1);
                     return;
                  }
               }
               if(LoaderManager.isLoadedByMcname(_loc1_.getMcName()))
               {
                  this._bag.deleteBag(this.posXX.getValue(),GS.a1);
                  dispatchEvent(new GoodsEvent(GoodsEvent.DO_WEAR,_loc1_,this.posXX.getValue()));
                  this.initGoodsDisplay(this._bagState);
                  this.tbMastMc();
                  this.posXX.setValue(-1);
               }
            }
            this._operatingBtn.closeOrOpenBtnById(0,1);
            this._operatingBtn.closeOrOpenBtnById(1,1);
         }
      }
      
      private function loadpetZzOver() : void
      {
         var _loc1_:Goods = null;
         if(this.posXX.getValue() != -1)
         {
            _loc1_ = this._bag.getGoods(this.posXX.getValue());
            if(_loc1_ != null && _loc1_.getType() == GS.a0)
            {
               if(LoaderManager.isLoadedByMcname(_loc1_.getMcName()))
               {
                  this._bag.deleteBag(this.posXX.getValue(),GS.a1);
                  dispatchEvent(new GoodsEvent(GoodsEvent.DO_PETWEAR,_loc1_,this.posXX.getValue()));
                  this.initGoodsDisplay(this._bagState);
                  this.tbMastMc();
                  this.posXX.setValue(-1);
               }
            }
            this._operatingBtn.closeOrOpenBtnById(0,1);
            this._operatingBtn.closeOrOpenBtnById(1,1);
         }
      }
      
      private function wearGoodsHandle(param1:BtnEvent) : void
      {
         var _loc2_:Goods = null;
         var _loc3_:Number = NaN;
         var _loc4_:Array = null;
         var _loc5_:Array = null;
         var _loc6_:uint = 0;
         var _loc7_:EquipGemSlot = null;
         var _loc8_:Number = NaN;
         var _loc9_:Boolean = false;
         var _loc10_:uint = 0;
         var _loc11_:Goods = null;
         if(param1.name == "g")
         {
            _loc2_ = this._bag.getGoods(param1.id);
            _loc3_ = Number(this._bag.getGoodsNum(param1.id));
            if((this._parentMc is PlayerBagPanel || this._parentMc is ChongWuPanel || this._parentMc is ZenFuPanel) && _loc2_ != null)
            {
               if(_loc2_.getType() == 0)
               {
                  if(this._parentMc is PlayerBagPanel)
                  {
                     if(_loc2_.getSmallType() >= GS.a25)
                     {
                        GoodsManger.cwTs("请到潜能界面穿戴该物品");
                        return;
                     }
                     if(_loc2_.getJob() == FlowInterface.getJobByRole())
                     {
                        if(_loc2_.getSmallType() == GS.a7)
                        {
                           if(FlowInterface.getRoleState() == GS.a1 || FlowInterface.getRoleState() == GS.a2)
                           {
                              return;
                           }
                        }
                        else if(_loc2_.getSmallType() == GS.a3)
                        {
                           if(FlowInterface.getRoleState() == GS.a2)
                           {
                              return;
                           }
                        }
                        if(_loc2_.getUseLevel() <= FlowInterface.getLevelByRole())
                        {
                           if(_loc2_.getSmallType() == GS.a12 || _loc2_.getSmallType() == GS.a11 || _loc2_.getSmallType() == GS.a1 || _loc2_.getSmallType() == GS.a2 || _loc2_.getSmallType() == GS.a3 || _loc2_.getSmallType() == GS.a7 || _loc2_.getSmallType() == GS.a5 || _loc2_.getSmallType() == GS.a8 || _loc2_.getSmallType() == GS.a10 || _loc2_.getSmallType() == GS.a0 || _loc2_.getSmallType() == GS.a16)
                           {
                              if(_loc2_.getMcName() == null)
                              {
                                 throw new EvalError("xxxxxxxxxxxxxxxx");
                              }
                              if(LoaderManager.isLoadedByMcname(_loc2_.getMcName()))
                              {
                                 this._bag.deleteBag(param1.id,GS.a1);
                                 dispatchEvent(new GoodsEvent(GoodsEvent.DO_WEAR,_loc2_,param1.id));
                              }
                              else
                              {
                                 if(GM.loaderM.keYiUse())
                                 {
                                    this.posXX.setValue(param1.id);
                                    this._operatingBtn.closeOrOpenBtnById(0,0);
                                    this._operatingBtn.closeOrOpenBtnById(1,0);
                                    _loc4_ = new Array();
                                    _loc4_.push(_loc2_.getMcName());
                                    GM.loaderM.setLoadData(_loc4_);
                                    GM.loaderM.completeF = this.loadZzOver;
                                    GM.loaderM.startLoadDataJieM();
                                    return;
                                 }
                                 GoodsManger.cwTs("装备信息加载中……");
                              }
                           }
                           else
                           {
                              this._bag.deleteBag(param1.id,GS.a1);
                              dispatchEvent(new GoodsEvent(GoodsEvent.DO_WEAR,_loc2_,param1.id));
                           }
                        }
                        else
                        {
                           GoodsManger.cwTs("等级不足");
                        }
                     }
                     else
                     {
                        GoodsManger.cwTs("职业不符");
                     }
                  }
                  else if(this._parentMc is ChongWuPanel && (this._parentMc as ChongWuPanel).isPetById() != null && _loc2_.getSmallType() < GS.a25)
                  {
                     if(_loc2_.getSmallType() >= GS.a25)
                     {
                        GoodsManger.cwTs("请到潜能界面穿戴该物品");
                        return;
                     }
                     if(_loc2_.getJob() == GS.a5)
                     {
                        if(_loc2_.getUseLevel() <= (this._parentMc as ChongWuPanel).isPetById().lv)
                        {
                           if(_loc2_.getSmallType() == GS.a12)
                           {
                              if(_loc2_.getMcName() == null)
                              {
                                 throw new EvalError("xxxxxxxxxxxxxxxx");
                              }
                              if(LoaderManager.isLoadedByMcname(_loc2_.getMcName()))
                              {
                                 this._bag.deleteBag(param1.id,GS.a1);
                                 dispatchEvent(new GoodsEvent(GoodsEvent.DO_PETWEAR,_loc2_,param1.id));
                              }
                              else
                              {
                                 if(GM.loaderM.keYiUse())
                                 {
                                    this.posXX.setValue(param1.id);
                                    this._operatingBtn.closeOrOpenBtnById(0,0);
                                    this._operatingBtn.closeOrOpenBtnById(1,0);
                                    _loc5_ = new Array();
                                    _loc5_.push(_loc2_.getMcName());
                                    GM.loaderM.setLoadData(_loc5_);
                                    GM.loaderM.completeF = this.loadpetZzOver;
                                    GM.loaderM.startLoadDataJieM();
                                    return;
                                 }
                                 GoodsManger.cwTs("装备信息加载中……");
                              }
                           }
                           else
                           {
                              this._bag.deleteBag(param1.id,GS.a1);
                              dispatchEvent(new GoodsEvent(GoodsEvent.DO_PETWEAR,_loc2_,param1.id));
                           }
                        }
                        else
                        {
                           GoodsManger.cwTs("等级不足");
                        }
                     }
                     else
                     {
                        GoodsManger.cwTs("职业不符");
                     }
                  }
                  else if(this._parentMc is ZenFuPanel)
                  {
                     if(_loc2_.getJob() == FlowInterface.getJobByRole() || _loc2_.getJob() == GS.a5)
                     {
                        if(_loc2_.getJob() == FlowInterface.getJobByRole() && _loc2_.getUseLevel() > FlowInterface.getLevelByRole())
                        {
                           GoodsManger.cwTs("人物等级不足");
                           return;
                        }
                        if(_loc2_.getSmallType() >= 25 && _loc2_.getSmallType() <= 30)
                        {
                           this._bag.deleteBag(param1.id,GS.a1);
                           dispatchEvent(new GoodsEvent(GoodsEvent.DO_ZENWEAR,_loc2_,param1.id));
                        }
                        else
                        {
                           GoodsManger.cwTs("部位不符");
                        }
                     }
                     else
                     {
                        GoodsManger.cwTs("职业不符");
                     }
                  }
               }
               else if(_loc2_.getType() == 2 && _loc2_.isUse())
               {
                  if(this._typeState == 0)
                  {
                     _loc6_ = 0;
                     while(_loc6_ < 2)
                     {
                        operatingMc.gn_Mc["jt_" + _loc6_].visible = false;
                        _loc6_++;
                     }
                     operatingMc.gn_Mc.gotoAndStop(2);
                     operatingMc.gn_Mc.visible = true;
                     addChildAt(operatingMc.gn_Mc,numChildren - 2);
                     this._currentGird = this._bag.getGird(param1.id);
                     this._currentId = param1.id;
                     this.ckGoodsBtn.visible = false;
                  }
               }
            }
            else if(this._parentMc is InsertPanel)
            {
               if(_loc2_.getType() == 0)
               {
                  if(this._parentMc._state == 0)
                  {
                     if(_loc2_.getGemSlot() != null)
                     {
                        this._bag.deleteBag(param1.id,GS.a1);
                        dispatchEvent(new GoodsEvent(GoodsEvent.DO_INSERT,_loc2_,param1.id));
                        if(this._parentMc.getSlot().getGoods(1) == null)
                        {
                           this._bagState = 1;
                        }
                     }
                     else
                     {
                        GoodsManger.cwTs("该物品无法打孔与镶嵌");
                     }
                  }
                  else if(this._parentMc._state == 1)
                  {
                     if(_loc2_.getGemSlot() != null)
                     {
                        _loc7_ = _loc2_.getGemSlot();
                        _loc8_ = _loc7_.getSlotNum();
                        _loc9_ = false;
                        _loc10_ = 0;
                        while(_loc10_ < _loc8_)
                        {
                           if(_loc7_.getSlot(_loc10_) == 0)
                           {
                              _loc9_ = true;
                           }
                           _loc10_++;
                        }
                        if(_loc9_)
                        {
                           this._bag.deleteBag(param1.id,GS.a1);
                           dispatchEvent(new GoodsEvent(GoodsEvent.DO_INSERT,_loc2_,param1.id));
                           if(this._parentMc.getSlot().getGoods(2) == null)
                           {
                              this._bagState = 2;
                           }
                        }
                        else
                        {
                           GoodsManger.cwTs("该物品无法打孔");
                        }
                     }
                     else
                     {
                        GoodsManger.cwTs("该物品无法打孔与镶嵌");
                     }
                  }
               }
               else if(_loc2_.getType() == 1 && _loc2_.getSmallType() == 0)
               {
                  if(this._parentMc.getSlot().getGoods(0) == null)
                  {
                     this._bag.deleteBag(param1.id,_loc3_);
                     dispatchEvent(new GoodsEvent(GoodsEvent.DO_INSERT,_loc2_,param1.id,0,_loc3_));
                     this._bagState = 0;
                  }
                  else
                  {
                     _loc11_ = this._parentMc.getSlot().getGoods(0);
                     if(_loc11_.getUseLevel() >= _loc2_.getUseLevel())
                     {
                        this._bag.deleteBag(param1.id,_loc3_);
                        dispatchEvent(new GoodsEvent(GoodsEvent.DO_INSERT,_loc2_,param1.id,0,_loc3_));
                     }
                     else
                     {
                        GoodsManger.cwTs("元素星体等级不可高于装备");
                     }
                  }
               }
               else if(_loc2_.getType() == 2 && _loc2_.getSmallType() == 0)
               {
                  if(this._parentMc.getSlot().getGoods(0) == null)
                  {
                     this._bag.deleteBag(param1.id,_loc3_);
                     dispatchEvent(new GoodsEvent(GoodsEvent.DO_INSERT,_loc2_,param1.id,0,_loc3_));
                     this._bagState = 0;
                  }
                  else
                  {
                     _loc11_ = this._parentMc.getSlot().getGoods(0);
                     if(_loc11_.getUseLevel() <= _loc2_.getUseLevel())
                     {
                        this._bag.deleteBag(param1.id,_loc3_);
                        dispatchEvent(new GoodsEvent(GoodsEvent.DO_INSERT,_loc2_,param1.id,0,_loc3_));
                     }
                     else
                     {
                        GoodsManger.cwTs("能源晶块等级不可低于装备");
                     }
                  }
               }
               else
               {
                  GoodsManger.cwTs("该物品无法打孔与镶嵌");
               }
            }
            else if(this._parentMc is StrengthenPanel)
            {
               if(_loc2_.getType() == 0 && _loc2_.getSmallType() != 3 && _loc2_.getSmallType() != 7 && _loc2_.isStrengBo() != -1)
               {
                  if(_loc2_.getStrengLevel() < _loc2_.isStrengBo())
                  {
                     this._bag.deleteBag(param1.id,_loc3_);
                     dispatchEvent(new GoodsEvent(GoodsEvent.DO_STRENGTH,_loc2_,param1.id,0,_loc3_));
                  }
                  else
                  {
                     GoodsManger.cwTs("强化等级已满");
                  }
               }
               else
               {
                  GoodsManger.cwTs("物品无法强化");
               }
            }
            else if(this._parentMc is ComPanel)
            {
               if(_loc2_.getQuality() != -1)
               {
                  this._bag.deleteBag(param1.id,_loc3_);
                  dispatchEvent(new GoodsEvent(GoodsEvent.DO_COM,_loc2_,param1.id,0,_loc3_));
               }
               else
               {
                  GoodsManger.cwTs("该物品无法合成");
               }
            }
            else if(this._parentMc is WareroomPanel)
            {
               if(BagFactory.isfullByRoom(_loc2_,_loc3_))
               {
                  this._bag.deleteBag(param1.id,_loc3_);
                  dispatchEvent(new GoodsEvent(GoodsEvent.DO_ROOM,_loc2_,param1.id,0,_loc3_));
               }
               else
               {
                  GoodsManger.cwTs("仓库已满");
               }
            }
            else if(this._parentMc is WmdPanel)
            {
               if(_loc2_.getType() == 0)
               {
                  if(_loc2_.getIsWm() != -GS.a1)
                  {
                     if(_loc2_.getWmLevel() < _loc2_.getWmMax())
                     {
                        this._bag.deleteBag(param1.id,_loc3_);
                        dispatchEvent(new GoodsEvent(GoodsEvent.DO_WM,_loc2_,param1.id,0,_loc3_));
                     }
                     else
                     {
                        GoodsManger.cwTs("这个物品太高端了无法继续提升");
                     }
                  }
                  else
                  {
                     GoodsManger.cwTs("装备,时装类的物品才能放入");
                  }
               }
               else
               {
                  GoodsManger.cwTs("装备,时装类的物品才能放入");
               }
            }
            this.initGoodsDisplay(this._bagState);
            this.tbMastMc();
         }
      }
      
      private function moveGoodsHandle(param1:BtnEvent) : void
      {
         this._moveCurrGird = this._bag.getGird(param1.id);
         this._moveCurrId = param1.id;
         (this.tbBoxArr[param1.id] as GoodsBtnX).visible = false;
         this._moveMc.visible = true;
         addChildAt(this._moveMc,numChildren - 1);
         this._moveMc.gotoAndStop(this._moveCurrGird.getGoods().getFrame());
         this._moveMc.t_txt.text = String(this._moveCurrGird.getGoodsNum());
         var _loc2_:Number = Number((this.tbBoxArr[param1.id] as GoodsBtnX).getSmMc().mask_mc.currentFrame);
         this._moveMc.mask_mc.gotoAndStop(_loc2_);
         if(this._moveCurrGird.getGoodsNum() == 1)
         {
            this._moveMc.t_txt.text = "";
         }
         this.addChildAt(this._moveMc,numChildren - 1);
         this._moveMc.x = mouseX - this._moveMc.width / 2;
         this._moveMc.y = mouseY - this._moveMc.height / 2;
      }
      
      private function changeGoodsHandle(param1:BtnEvent) : void
      {
         var _loc4_:Goods = null;
         var _loc5_:Gird = null;
         var _loc6_:Number = NaN;
         var _loc7_:VT = null;
         var _loc8_:VT = null;
         this._moveMc.x = 0;
         this._moveMc.y = 0;
         this._moveMc.visible = false;
         var _loc2_:Number = -1;
         var _loc3_:uint = 0;
         while(_loc3_ < 20)
         {
            if(MovieClip(operatingMc["bd_" + _loc3_]).hitTestPoint(this.parent.mouseX,this.parent.mouseY,true))
            {
               _loc2_ = _loc3_;
            }
            _loc3_++;
         }
         if(_loc2_ == this._moveCurrId)
         {
            _loc2_ = -1;
         }
         if(_loc2_ != -1)
         {
            _loc4_ = this._moveCurrGird.getGoods();
            if(_loc4_.getOverlapping() == -1)
            {
               this._bag.changeGird(this._moveCurrGird,param1.id,_loc2_);
            }
            else
            {
               _loc5_ = this._bag.getGird(_loc2_);
               _loc6_ = Number(this._bag.getGirdOne(_loc4_,_loc2_));
               if(_loc5_.compareById(_loc4_.getId()))
               {
                  if(_loc5_.getGirdNum(_loc4_) >= this._moveCurrGird.getGoodsNum())
                  {
                     _loc7_ = VT.createVT(this._moveCurrGird.getGoodsNum());
                     this._bag.addToBag(_loc4_,_loc2_,this._moveCurrGird.getGoodsNum());
                     this._bag.deleteBag(param1.id,_loc7_.getValue());
                  }
                  else if(_loc5_.getGirdNum(_loc4_) > GS.a0)
                  {
                     _loc8_ = VT.createVT(_loc5_.getGirdNum(_loc4_));
                     this._bag.addToBag(_loc4_,_loc2_,_loc5_.getGirdNum(_loc4_));
                     this._bag.deleteBag(param1.id,_loc8_.getValue());
                  }
               }
               else
               {
                  this._bag.changeGird(this._moveCurrGird,param1.id,_loc2_);
               }
            }
         }
         (this.tbBoxArr[param1.id] as GoodsBtnX).visible = true;
         this.initGoodsDisplay(this._bagState);
         this._moveCurrGird = null;
         this.tbMastMc();
      }
      
      private function selloRFJ() : void
      {
         if(this._typeState == 0)
         {
            operatingMc.t_0.gj_tx.text = "分解";
            operatingMc.t_1.sell_tx.text = "出售";
         }
         else if(this._typeState == 1)
         {
            operatingMc.t_0.gj_tx.text = "取消";
            operatingMc.t_1.sell_tx.text = "出售";
         }
         else if(this._typeState == 2)
         {
            operatingMc.t_0.gj_tx.text = "分解";
            operatingMc.t_1.sell_tx.text = "取消";
         }
         if(this._typeState == 0)
         {
            Mouse.show();
            operatingMc.mouse_mc.visible = false;
         }
         else
         {
            Mouse.hide();
            operatingMc.mouse_mc.visible = true;
            addChildAt(operatingMc.mouse_mc,numChildren - 1);
            operatingMc.mouse_mc.mouseEnabled = false;
            operatingMc.mouse_mc.mouseChildren = false;
            if(this._typeState == 1)
            {
               operatingMc.mouse_mc.gotoAndStop(1);
            }
            else if(this._typeState == 2)
            {
               operatingMc.mouse_mc.gotoAndStop(2);
            }
         }
      }
      
      private function changeHandle(param1:BtnEvent) : void
      {
         var _loc2_:Array = null;
         var _loc3_:Number = NaN;
         var _loc4_:uint = 0;
         if(param1.name == "bg")
         {
            this._bagState = param1.id;
            this.initGoodsDisplay(this._bagState);
            this.tbMastMc();
         }
         else if(param1.name == "t")
         {
            _loc2_ = this._operatingBtn.getClickArr();
            _loc3_ = 0;
            _loc4_ = 0;
            while(_loc4_ < _loc2_.length)
            {
               if(_loc2_[_loc4_])
               {
                  _loc3_ = _loc4_ + 1;
                  break;
               }
               _loc4_++;
            }
            this._typeState = _loc3_;
            this.selloRFJ();
            this.operatingData();
            this.tbMastMc();
         }
      }
      
      private function moveHandle(param1:MouseEvent) : void
      {
         operatingMc.mouse_mc.x = mouseX;
         operatingMc.mouse_mc.y = mouseY;
         param1.updateAfterEvent();
      }
      
      private function initBtn() : void
      {
         var _loc7_:MovieClip = null;
         var _loc8_:SlideChangeBtn = null;
         operatingMc.mouse_mc.visible = false;
         operatingMc.mouse_mc.mouseEnabled = false;
         operatingMc.mouse_mc.mouseChildren = false;
         this._moveMc.gotoAndStop(1);
         operatingMc.gn_Mc.gotoAndStop(1);
         operatingMc.gn_Mc.visible = false;
         operatingMc.gn_Mc.num_text.restrict = "0-9";
         operatingMc.gn_Mc.num_text.maxChars = GS.a3;
         this._typeBtn = SameChangeBtn.createSameChangeBtn(new Array(operatingMc.bg_0,operatingMc.bg_1,operatingMc.bg_2,operatingMc.bg_3));
         addChild(this._typeBtn);
         this._operatingBtn = SameChangeBtn.createSameChangeBtn(new Array(operatingMc.t_0,operatingMc.t_1));
         this._operatingBtn.state = true;
         addChild(this._operatingBtn);
         operatingMc.t_0.gj_tx.text = "分解";
         operatingMc.t_1.sell_tx.text = "出售";
         var _loc1_:TextField = new TextField();
         _loc1_ = operatingMc.t_0.gj_tx as TextField;
         _loc1_.embedFonts = true;
         _loc1_.defaultTextFormat = new TextFormat(GM.fzfont.fontName,16);
         var _loc2_:TextField = new TextField();
         _loc2_ = operatingMc.t_1.sell_tx as TextField;
         _loc2_.embedFonts = true;
         _loc2_.defaultTextFormat = new TextFormat(GM.fzfont.fontName,16);
         operatingMc.gold_tx.embedFonts = true;
         operatingMc.gold_tx.defaultTextFormat = new TextFormat(GM.fzfont.fontName,16);
         operatingMc.dj_tx.embedFonts = true;
         operatingMc.dj_tx.defaultTextFormat = new TextFormat(GM.fzfont.fontName,16);
         this.zlBtn = new SlideChangeBtn(operatingMc.t_2);
         addChild(this.zlBtn);
         var _loc3_:OverBtn = new OverBtn(operatingMc.jingbi_0);
         addChild(_loc3_);
         var _loc4_:OverBtn = new OverBtn(operatingMc.xingzhuang_1);
         addChild(_loc4_);
         var _loc5_:BasicClickBtn = new BasicClickBtn(operatingMc.xingzhuang_1);
         addChild(_loc5_);
         var _loc6_:uint = 0;
         while(_loc6_ < this.tbBoxArr.length)
         {
            _loc7_ = (this.tbBoxArr[_loc6_] as GoodsBtnX).getSmMc();
            _loc7_.gx_mc.visible = false;
            _loc7_.mask_mc.gotoAndStop(1);
            _loc6_++;
         }
         _loc6_ = 0;
         while(_loc6_ < 2)
         {
            _loc8_ = new SlideChangeBtn(operatingMc.gn_Mc["ok_" + _loc6_]);
            addChild(_loc8_);
            _loc6_++;
         }
         this.jBtn1 = new SlideChangeBtn(operatingMc.gn_Mc["jt_" + 0]);
         addChild(this.jBtn1);
         this.jBtn2 = new SlideChangeBtn(operatingMc.gn_Mc["jt_" + 1]);
         addChild(this.jBtn2);
         operatingMc.btnTs.visible = false;
      }
      
      public function tbMastMc() : void
      {
         var _loc1_:Goods = null;
         var _loc2_:uint = 0;
         var _loc3_:EquipGemSlot = null;
         var _loc4_:Number = NaN;
         var _loc5_:Boolean = false;
         var _loc6_:uint = 0;
         var _loc7_:Goods = null;
         var _loc8_:Goods = null;
         var _loc9_:Goods = null;
         if(this._typeState == 0)
         {
            if(this._parentMc is ChongWuPanel)
            {
               if(this._bagState == 0)
               {
                  _loc2_ = 0;
                  while(_loc2_ < 20)
                  {
                     _loc1_ = this._bag.getGoods(_loc2_);
                     if(_loc1_ != null)
                     {
                        if(_loc1_.getJob() == 5)
                        {
                           if((this._parentMc as ChongWuPanel).isPetById() != null)
                           {
                              if(_loc1_.getUseLevel() <= (this._parentMc as ChongWuPanel).isPetById().lv)
                              {
                                 (this.tbBoxArr[_loc2_] as GoodsBtnX).getSmMc().mask_mc.gotoAndStop(1);
                              }
                              else
                              {
                                 (this.tbBoxArr[_loc2_] as GoodsBtnX).getSmMc().mask_mc.gotoAndStop(2);
                              }
                           }
                           else
                           {
                              (this.tbBoxArr[_loc2_] as GoodsBtnX).getSmMc().mask_mc.gotoAndStop(2);
                           }
                        }
                        else
                        {
                           (this.tbBoxArr[_loc2_] as GoodsBtnX).getSmMc().mask_mc.gotoAndStop(2);
                        }
                     }
                     _loc2_++;
                  }
               }
               else if(this._bagState == 2)
               {
                  _loc2_ = 0;
                  while(_loc2_ < 20)
                  {
                     _loc1_ = this._bag.getGoods(_loc2_);
                     if(_loc1_ != null)
                     {
                        if(_loc1_.getSmallType() == 18)
                        {
                           (this.tbBoxArr[_loc2_] as GoodsBtnX).getSmMc().mask_mc.gotoAndStop(1);
                        }
                        else if(_loc1_.isUse())
                        {
                           if(_loc1_.getUseLevel() <= FlowInterface.getJobByRole())
                           {
                              (this.tbBoxArr[_loc2_] as GoodsBtnX).getSmMc().mask_mc.gotoAndStop(1);
                           }
                           else
                           {
                              (this.tbBoxArr[_loc2_] as GoodsBtnX).getSmMc().mask_mc.gotoAndStop(2);
                           }
                        }
                        else
                        {
                           (this.tbBoxArr[_loc2_] as GoodsBtnX).getSmMc().mask_mc.gotoAndStop(1);
                        }
                     }
                     _loc2_++;
                  }
               }
            }
            else if(this._parentMc is PlayerBagPanel)
            {
               if(this._bagState == 0)
               {
                  _loc2_ = 0;
                  while(_loc2_ < 20)
                  {
                     _loc1_ = this._bag.getGoods(_loc2_);
                     if(_loc1_ != null)
                     {
                        if(_loc1_.getJob() != 5)
                        {
                           if(_loc1_.getUseLevel() <= FlowInterface.getLevelByRole() && _loc1_.getJob() == FlowInterface.getJobByRole())
                           {
                              (this.tbBoxArr[_loc2_] as GoodsBtnX).getSmMc().mask_mc.gotoAndStop(1);
                           }
                           else
                           {
                              (this.tbBoxArr[_loc2_] as GoodsBtnX).getSmMc().mask_mc.gotoAndStop(2);
                           }
                        }
                        else
                        {
                           (this.tbBoxArr[_loc2_] as GoodsBtnX).getSmMc().mask_mc.gotoAndStop(2);
                        }
                     }
                     _loc2_++;
                  }
               }
               else if(this._bagState == 2)
               {
                  _loc2_ = 0;
                  while(_loc2_ < 20)
                  {
                     _loc1_ = this._bag.getGoods(_loc2_);
                     if(_loc1_ != null)
                     {
                        if(_loc1_.isUse())
                        {
                           if(_loc1_.getSmallType() != 18)
                           {
                              if(_loc1_.getUseLevel() <= FlowInterface.getLevelByRole())
                              {
                                 (this.tbBoxArr[_loc2_] as GoodsBtnX).getSmMc().mask_mc.gotoAndStop(1);
                              }
                              else
                              {
                                 (this.tbBoxArr[_loc2_] as GoodsBtnX).getSmMc().mask_mc.gotoAndStop(2);
                              }
                           }
                           else
                           {
                              (this.tbBoxArr[_loc2_] as GoodsBtnX).getSmMc().mask_mc.gotoAndStop(1);
                           }
                        }
                        else
                        {
                           (this.tbBoxArr[_loc2_] as GoodsBtnX).getSmMc().mask_mc.gotoAndStop(1);
                        }
                     }
                     _loc2_++;
                  }
               }
               else
               {
                  _loc2_ = 0;
                  while(_loc2_ < 20)
                  {
                     _loc1_ = this._bag.getGoods(_loc2_);
                     if(_loc1_ != null)
                     {
                        (this.tbBoxArr[_loc2_] as GoodsBtnX).getSmMc().mask_mc.gotoAndStop(1);
                     }
                     _loc2_++;
                  }
               }
            }
            else if(this._parentMc is InsertPanel)
            {
               if(this._bagState == 0 || this._bagState == 3)
               {
                  if((this._parentMc as InsertPanel)._state == 0)
                  {
                     _loc2_ = 0;
                     while(_loc2_ < 20)
                     {
                        _loc1_ = this._bag.getGoods(_loc2_);
                        if(_loc1_ != null)
                        {
                           if(_loc1_.getType() == 0 && _loc1_.getGemSlot() != null)
                           {
                              (this.tbBoxArr[_loc2_] as GoodsBtnX).getSmMc().mask_mc.gotoAndStop(1);
                           }
                           else
                           {
                              (this.tbBoxArr[_loc2_] as GoodsBtnX).getSmMc().mask_mc.gotoAndStop(2);
                           }
                        }
                        _loc2_++;
                     }
                  }
                  else if((this._parentMc as InsertPanel)._state == 1)
                  {
                     _loc2_ = 0;
                     while(_loc2_ < 20)
                     {
                        _loc1_ = this._bag.getGoods(_loc2_);
                        if(_loc1_ != null)
                        {
                           if(_loc1_.getType() == 0 && _loc1_.getGemSlot() != null)
                           {
                              _loc3_ = _loc1_.getGemSlot();
                              _loc4_ = _loc3_.getSlotNum();
                              _loc5_ = false;
                              _loc6_ = 0;
                              while(_loc6_ < _loc4_)
                              {
                                 if(_loc3_.getSlot(_loc6_) == 0)
                                 {
                                    _loc5_ = true;
                                    break;
                                 }
                                 _loc6_++;
                              }
                              if(_loc5_)
                              {
                                 (this.tbBoxArr[_loc2_] as GoodsBtnX).getSmMc().mask_mc.gotoAndStop(1);
                              }
                              else
                              {
                                 (this.tbBoxArr[_loc2_] as GoodsBtnX).getSmMc().mask_mc.gotoAndStop(2);
                              }
                           }
                           else
                           {
                              (this.tbBoxArr[_loc2_] as GoodsBtnX).getSmMc().mask_mc.gotoAndStop(2);
                           }
                        }
                        _loc2_++;
                     }
                  }
               }
               else if(this._bagState == 1)
               {
                  if(this._parentMc.getSlot().getGoods(0) == null)
                  {
                     _loc2_ = 0;
                     while(_loc2_ < 20)
                     {
                        _loc1_ = this._bag.getGoods(_loc2_);
                        if(_loc1_ != null)
                        {
                           if(_loc1_.getType() == 1 && _loc1_.getSmallType() == 0)
                           {
                              (this.tbBoxArr[_loc2_] as GoodsBtnX).getSmMc().mask_mc.gotoAndStop(1);
                           }
                           else
                           {
                              (this.tbBoxArr[_loc2_] as GoodsBtnX).getSmMc().mask_mc.gotoAndStop(2);
                           }
                        }
                        _loc2_++;
                     }
                  }
                  else
                  {
                     _loc7_ = this._parentMc.getSlot().getGoods(0);
                     _loc2_ = 0;
                     while(_loc2_ < 20)
                     {
                        _loc1_ = this._bag.getGoods(_loc2_);
                        if(_loc1_ != null)
                        {
                           if(_loc1_.getType() == 1 && _loc1_.getSmallType() == 0 && _loc1_.getUseLevel() <= _loc7_.getUseLevel())
                           {
                              (this.tbBoxArr[_loc2_] as GoodsBtnX).getSmMc().mask_mc.gotoAndStop(1);
                           }
                           else
                           {
                              (this.tbBoxArr[_loc2_] as GoodsBtnX).getSmMc().mask_mc.gotoAndStop(2);
                           }
                        }
                        _loc2_++;
                     }
                  }
               }
               else if(this._bagState == 2)
               {
                  if(this._parentMc.getSlot().getGoods(0) == null)
                  {
                     _loc2_ = 0;
                     while(_loc2_ < 20)
                     {
                        _loc1_ = this._bag.getGoods(_loc2_);
                        if(_loc1_ != null)
                        {
                           if(_loc1_.getType() == 2 && _loc1_.getSmallType() == 0)
                           {
                              (this.tbBoxArr[_loc2_] as GoodsBtnX).getSmMc().mask_mc.gotoAndStop(1);
                           }
                           else
                           {
                              (this.tbBoxArr[_loc2_] as GoodsBtnX).getSmMc().mask_mc.gotoAndStop(2);
                           }
                        }
                        _loc2_++;
                     }
                  }
                  else
                  {
                     _loc7_ = this._parentMc.getSlot().getGoods(0);
                     _loc2_ = 0;
                     while(_loc2_ < 20)
                     {
                        _loc1_ = this._bag.getGoods(_loc2_);
                        if(_loc1_ != null)
                        {
                           if(_loc1_.getType() == 2 && _loc1_.getSmallType() == 0 && _loc1_.getUseLevel() >= _loc7_.getUseLevel())
                           {
                              (this.tbBoxArr[_loc2_] as GoodsBtnX).getSmMc().mask_mc.gotoAndStop(1);
                           }
                           else
                           {
                              (this.tbBoxArr[_loc2_] as GoodsBtnX).getSmMc().mask_mc.gotoAndStop(2);
                           }
                        }
                        _loc2_++;
                     }
                  }
               }
            }
            else if(this._parentMc is StrengthenPanel)
            {
               if(this._bagState == 0)
               {
                  _loc2_ = 0;
                  while(_loc2_ < 20)
                  {
                     _loc1_ = this._bag.getGoods(_loc2_);
                     if(_loc1_ != null)
                     {
                        if(_loc1_.getType() == 0 && _loc1_.getSmallType() != 3 && _loc1_.getSmallType() != 7 && _loc1_.isStrengBo() != -1 && _loc1_.getStrengLevel() < _loc1_.isStrengBo())
                        {
                           (this.tbBoxArr[_loc2_] as GoodsBtnX).getSmMc().mask_mc.gotoAndStop(1);
                        }
                        else
                        {
                           (this.tbBoxArr[_loc2_] as GoodsBtnX).getSmMc().mask_mc.gotoAndStop(2);
                        }
                     }
                     _loc2_++;
                  }
               }
               else if(this._bagState == 1)
               {
                  _loc2_ = 0;
                  while(_loc2_ < 20)
                  {
                     _loc1_ = this._bag.getGoods(_loc2_);
                     if(_loc1_ != null)
                     {
                        if(_loc1_.getType() == 1 && _loc1_.getSmallType() == 1)
                        {
                           (this.tbBoxArr[_loc2_] as GoodsBtnX).getSmMc().mask_mc.gotoAndStop(1);
                        }
                        else
                        {
                           (this.tbBoxArr[_loc2_] as GoodsBtnX).getSmMc().mask_mc.gotoAndStop(2);
                        }
                     }
                     _loc2_++;
                  }
               }
               else
               {
                  _loc2_ = 0;
                  while(_loc2_ < 20)
                  {
                     _loc1_ = this._bag.getGoods(_loc2_);
                     if(_loc1_ != null)
                     {
                        (this.tbBoxArr[_loc2_] as GoodsBtnX).getSmMc().mask_mc.gotoAndStop(2);
                     }
                     _loc2_++;
                  }
               }
            }
            else if(this._parentMc is ComPanel)
            {
               _loc2_ = 0;
               while(_loc2_ < 20)
               {
                  _loc1_ = this._bag.getGoods(_loc2_);
                  if(_loc1_ != null)
                  {
                     if(_loc1_.getQuality() != -1)
                     {
                        (this.tbBoxArr[_loc2_] as GoodsBtnX).getSmMc().mask_mc.gotoAndStop(1);
                     }
                     else
                     {
                        (this.tbBoxArr[_loc2_] as GoodsBtnX).getSmMc().mask_mc.gotoAndStop(2);
                     }
                  }
                  _loc2_++;
               }
               if((this._parentMc as ComPanel)._state == 0)
               {
                  if((this._parentMc as ComPanel).getSlot().getGoods(0) != null)
                  {
                     _loc8_ = (this._parentMc as ComPanel).getSlot().getGoods(0);
                     _loc2_ = 0;
                     while(_loc2_ < 20)
                     {
                        _loc1_ = this._bag.getGoods(_loc2_);
                        if(_loc1_ != null)
                        {
                           if(!(_loc1_.getType() == 1 && _loc1_.getSmallType() == 12))
                           {
                              if(_loc1_.getType() == GS.a0)
                              {
                                 if(_loc8_.getType() != _loc1_.getType() || _loc8_.getJob() != _loc1_.getJob() || this.isSz(_loc8_) != this.isSz(_loc1_))
                                 {
                                    (this.tbBoxArr[_loc2_] as GoodsBtnX).getSmMc().mask_mc.gotoAndStop(2);
                                 }
                                 else
                                 {
                                    (this.tbBoxArr[_loc2_] as GoodsBtnX).getSmMc().mask_mc.gotoAndStop(1);
                                 }
                              }
                              else if(_loc8_.getType() != _loc1_.getType() || _loc8_.getSmallType() != _loc1_.getSmallType())
                              {
                                 (this.tbBoxArr[_loc2_] as GoodsBtnX).getSmMc().mask_mc.gotoAndStop(2);
                              }
                              else
                              {
                                 (this.tbBoxArr[_loc2_] as GoodsBtnX).getSmMc().mask_mc.gotoAndStop(1);
                              }
                           }
                        }
                        _loc2_++;
                     }
                  }
               }
            }
            else if(this._parentMc is WareroomPanel)
            {
               _loc2_ = 0;
               while(_loc2_ < 20)
               {
                  _loc1_ = this._bag.getGoods(_loc2_);
                  if(_loc1_ != null)
                  {
                     (this.tbBoxArr[_loc2_] as GoodsBtnX).getSmMc().mask_mc.gotoAndStop(1);
                  }
                  _loc2_++;
               }
            }
            else if(this._parentMc is WmdPanel)
            {
               if(this._bagState == 0 || this._bagState == 3)
               {
                  if((this._parentMc as WmdPanel).getSlotg() != null)
                  {
                     _loc9_ = (this._parentMc as WmdPanel).getSlotg();
                     _loc2_ = 0;
                     while(_loc2_ < 20)
                     {
                        _loc1_ = this._bag.getGoods(_loc2_);
                        if(_loc1_ != null && _loc1_.getId() == _loc9_.getId())
                        {
                           (this.tbBoxArr[_loc2_] as GoodsBtnX).getSmMc().mask_mc.gotoAndStop(1);
                        }
                        else
                        {
                           (this.tbBoxArr[_loc2_] as GoodsBtnX).getSmMc().mask_mc.gotoAndStop(2);
                        }
                        _loc2_++;
                     }
                  }
                  else
                  {
                     _loc2_ = 0;
                     while(_loc2_ < 20)
                     {
                        _loc1_ = this._bag.getGoods(_loc2_);
                        if(_loc1_ != null && _loc1_.getIsWm() != -1)
                        {
                           (this.tbBoxArr[_loc2_] as GoodsBtnX).getSmMc().mask_mc.gotoAndStop(1);
                        }
                        _loc2_++;
                     }
                  }
               }
               else
               {
                  _loc2_ = 0;
                  while(_loc2_ < 20)
                  {
                     _loc1_ = this._bag.getGoods(_loc2_);
                     if(_loc1_ != null)
                     {
                        (this.tbBoxArr[_loc2_] as GoodsBtnX).getSmMc().mask_mc.gotoAndStop(2);
                     }
                     _loc2_++;
                  }
               }
            }
         }
         else if(this._typeState == 1)
         {
            if(this._bagState == 0 || this._bagState == 3)
            {
               _loc2_ = 0;
               while(_loc2_ < 20)
               {
                  _loc1_ = this._bag.getGoods(_loc2_);
                  if(_loc1_ != null)
                  {
                     (this.tbBoxArr[_loc2_] as GoodsBtnX).getSmMc().mask_mc.gotoAndStop(1);
                  }
                  _loc2_++;
               }
            }
            else
            {
               _loc2_ = 0;
               while(_loc2_ < 20)
               {
                  _loc1_ = this._bag.getGoods(_loc2_);
                  if(_loc1_ != null)
                  {
                     (this.tbBoxArr[_loc2_] as GoodsBtnX).getSmMc().mask_mc.gotoAndStop(2);
                  }
                  _loc2_++;
               }
            }
         }
         else if(this._typeState == 2)
         {
            _loc2_ = 0;
            while(_loc2_ < 20)
            {
               _loc1_ = this._bag.getGoods(_loc2_);
               if(_loc1_ != null)
               {
                  if(_loc1_.isSell())
                  {
                     (this.tbBoxArr[_loc2_] as GoodsBtnX).getSmMc().mask_mc.gotoAndStop(1);
                  }
                  else
                  {
                     (this.tbBoxArr[_loc2_] as GoodsBtnX).getSmMc().mask_mc.gotoAndStop(2);
                  }
               }
               _loc2_++;
            }
         }
      }
      
      private function isSz(param1:Goods) : uint
      {
         if(param1.getSmallType() >= 0 && param1.getSmallType() <= 7)
         {
            return 0;
         }
         if(param1.getSmallType() >= 8 && param1.getSmallType() <= 15)
         {
            return 1;
         }
         return 0;
      }
      
      private function sXComJp() : void
      {
         if(this._parentMc is ComPanel)
         {
            (this._parentMc as ComPanel).sXForBag();
         }
      }
   }
}

