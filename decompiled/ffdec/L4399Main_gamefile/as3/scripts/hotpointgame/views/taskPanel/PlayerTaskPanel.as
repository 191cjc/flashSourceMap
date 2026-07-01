package hotpointgame.views.taskPanel
{
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   import flash.utils.*;
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   import hotpointgame.common.basicBtn.*;
   import hotpointgame.common.event.*;
   import hotpointgame.common.newBasicBtn.*;
   import hotpointgame.models.bag.*;
   import hotpointgame.models.goods.Goods;
   import hotpointgame.models.task.*;
   import hotpointgame.repository.goods.*;
   import hotpointgame.repository.task.*;
   import hotpointgame.utils.gameloader.*;
   import hotpointgame.views.sxPanel.*;
   import hotpointgame.views.vipPanel.*;
   
   public class PlayerTaskPanel extends MovieClip
   {
      
      public static var operatingMc:MovieClip;
      
      private static var _instance:PlayerTaskPanel;
      
      private var taskData:TaskData;
      
      private var taskingList:Array = [];
      
      private var slot:taskSlot;
      
      private var currentId:Number;
      
      private var taskMcPanel:TaskMcPanel;
      
      private var taskBtn:SameChangeBtn;
      
      private var deTask:Task = null;
      
      private var _sxDisplay:SxPanel;
      
      private var tbBoxArr:Array = [];
      
      private var tian:int = 0;
      
      private var shi:int = 0;
      
      private var fen:int = 0;
      
      private var miao:int = 0;
      
      private var k:int = 86400;
      
      private var time:Timer;
      
      public function PlayerTaskPanel()
      {
         super();
      }
      
      public static function open() : void
      {
         var _loc1_:Array = null;
         GoodsManger.allPanelClose();
         if(_instance == null)
         {
            if(GM.loaderM.keYiUse())
            {
               _loc1_ = new Array();
               _loc1_.push("playertaskpanel");
               _loc1_.push("sxpanel");
               _loc1_.push("t_box");
               GM.loaderM.setLoadData(_loc1_);
               GM.loaderM.completeF = loadPtaskOver;
               GM.loaderM.startLoadDataJieM();
               return;
            }
            return;
         }
         _instance.visible = true;
         _instance.x = 0;
         _instance.initPanel();
      }
      
      private static function loadPtaskOver() : void
      {
         var _loc5_:MovieClip = null;
         var _loc6_:GoodsBtnX = null;
         var _loc1_:Object = LoaderManager.getSwfClass("player_TaskPanel") as Class;
         var _loc2_:Object = LoaderManager.getSwfClass("T_Box") as Class;
         var _loc3_:MovieClip = new _loc1_();
         operatingMc = _loc3_;
         _instance = new PlayerTaskPanel();
         _instance.addChild(operatingMc);
         GM.bagJm.addChild(PlayerTaskPanel._instance);
         var _loc4_:uint = 0;
         while(_loc4_ < 4)
         {
            _loc5_ = new _loc2_();
            _loc5_.name = "gt_" + _loc4_;
            _loc6_ = new GoodsBtnX(_loc5_,operatingMc["gx_" + (_loc4_ + 2)].x,operatingMc["gx_" + (_loc4_ + 2)].y);
            _instance.addChild(_loc6_);
            _instance.tbBoxArr.push(_loc6_);
            _loc4_++;
         }
         _instance.initMcBtn();
         _instance.taskData = TaskData.createTaskData();
         _instance.slot = taskSlot.createSlot(5);
         _instance.taskMcPanel = TaskMcPanel.createTaskMcpanel();
         _instance._sxDisplay = SxPanel.createSxpanel();
         _instance.time = new Timer(GS.a100,GS.a0);
         _instance.visible = true;
         _instance.x = 0;
         _instance.initPanel();
      }
      
      public static function close() : void
      {
         if(_instance != null && Boolean(_instance.visible))
         {
            _instance.closeData();
            _instance.removeEvent();
            _instance.visible = false;
            _instance.x = 5000;
         }
      }
      
      private function initPanel() : void
      {
         TaskData.isGoodsNoOk();
         this.initSxDisplay();
         this.addEvent();
         this.initDisplay();
         operatingMc.btnTs.visible = false;
      }
      
      private function initSxDisplay() : void
      {
         addChild(this._sxDisplay);
         this._sxDisplay.init();
      }
      
      private function initDisplay() : void
      {
         TaskData.initTaskStateing();
         this.taskingList = TaskData.taskIngList;
         this.initSlot();
         this.initFrame();
         this.textDisplay(0);
         this.jiangliDisplay(0);
         this.finishBtn(0);
         this.currentId = 0;
         this.deTask = null;
         this.taskBtn.btnOk(this.currentId);
         this.jdTaskDisplay(0);
      }
      
      private function finishBtn(param1:Number) : void
      {
         var _loc2_:Task = null;
         operatingMc.delete_btn.visible = false;
         operatingMc.finish_btn.visible = false;
         operatingMc.kfwancheng.visible = false;
         if(this.slot.getTask(param1) != null)
         {
            _loc2_ = this.slot.getTask(param1);
            if(_loc2_.getState() == 3)
            {
               operatingMc.finish_btn.visible = true;
               operatingMc.kfwancheng.visible = true;
            }
            if(_loc2_.isDelete() == true)
            {
               operatingMc.delete_btn.visible = true;
            }
         }
      }
      
      private function jiangliDisplay(param1:Number) : void
      {
         var _loc3_:Task = null;
         var _loc4_:Array = null;
         var _loc5_:Array = null;
         var _loc2_:uint = 0;
         while(_loc2_ < 6)
         {
            operatingMc["gx_" + _loc2_].visible = false;
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < 4)
         {
            (this.tbBoxArr[_loc2_] as GoodsBtnX).visible = false;
            (this.tbBoxArr[_loc2_] as GoodsBtnX).getSmMc().gx_mc.visible = false;
            (this.tbBoxArr[_loc2_] as GoodsBtnX).getSmMc().mask_mc.gotoAndStop(1);
            (this.tbBoxArr[_loc2_] as GoodsBtnX).getSmMc().d_mc.visible = false;
            _loc2_++;
         }
         operatingMc["gx_" + 0].t_txt.text = "";
         operatingMc["gx_" + 1].t_txt.text = "";
         if(this.slot.getTask(param1) != null)
         {
            _loc3_ = this.slot.getTask(param1);
            if(_loc3_.getJzId() == -1 && _loc3_.getBigType() == -1)
            {
               _loc4_ = _loc3_.getRewardId();
               _loc5_ = _loc3_.getReardNum();
               if(_loc4_[0] != -1)
               {
                  _loc2_ = 0;
                  while(_loc2_ < _loc4_.length)
                  {
                     (this.tbBoxArr[_loc2_] as GoodsBtnX).visible = true;
                     (this.tbBoxArr[_loc2_] as GoodsBtnX).getSmMc().gotoAndStop(GoodsFactory.getGoodsById(_loc4_[_loc2_]).getFrame());
                     if(_loc5_[_loc2_] > 1)
                     {
                        (this.tbBoxArr[_loc2_] as GoodsBtnX).getSmMc().t_txt.text = String(_loc5_[_loc2_]);
                     }
                     _loc2_++;
                  }
               }
               if(_loc3_.getRewardGold() != -1)
               {
                  operatingMc["gx_" + 0].visible = true;
                  operatingMc["gx_" + 0].gotoAndStop(3);
                  operatingMc["gx_" + 0].t_txt.text = String(_loc3_.getRewardGold());
               }
               if(_loc3_.getRewardExp() != -1)
               {
                  operatingMc["gx_" + 1].visible = true;
                  operatingMc["gx_" + 1].gotoAndStop(4);
                  operatingMc["gx_" + 1].t_txt.text = String(_loc3_.getRewardExp());
               }
            }
            else if(_loc3_.getJzId() != -1)
            {
               _loc2_ = 0;
               while(_loc2_ < 6)
               {
                  operatingMc["gx_" + _loc2_].visible = true;
                  operatingMc["gx_" + _loc2_].gotoAndStop(2);
                  _loc2_++;
               }
            }
            else if(_loc3_.getBigType() != -1)
            {
               if(_loc3_.getRewardGold() != -1)
               {
                  operatingMc["gx_" + 0].visible = true;
                  operatingMc["gx_" + 0].gotoAndStop(3);
                  operatingMc["gx_" + 0].t_txt.text = String(_loc3_.getRewardGold() * TaskData.getGodByTimes(_loc3_.getJtTask()));
               }
               if(_loc3_.getRewardExp() != -1)
               {
                  operatingMc["gx_" + 1].visible = true;
                  operatingMc["gx_" + 1].gotoAndStop(4);
                  operatingMc["gx_" + 1].t_txt.text = String(_loc3_.getRewardExp() * TaskData.getGodByTimes(_loc3_.getJtTask()));
               }
               _loc2_ = 2;
               while(_loc2_ < 6)
               {
                  operatingMc["gx_" + _loc2_].visible = true;
                  operatingMc["gx_" + _loc2_].gotoAndStop(2);
                  _loc2_++;
               }
            }
         }
      }
      
      private function textDisplay(param1:Number) : void
      {
         var _loc3_:Task = null;
         var _loc4_:Array = null;
         operatingMc.name_text.text = "";
         operatingMc.js_text.text = "";
         var _loc2_:uint = 0;
         while(_loc2_ < 3)
         {
            operatingMc["m_" + _loc2_].text = "";
            _loc2_++;
         }
         if(this.slot.getTask(param1) != null)
         {
            _loc3_ = this.slot.getTask(param1);
            operatingMc.name_text.text = _loc3_.getName();
            (operatingMc.js_text as TextField).embedFonts = true;
            (operatingMc.js_text as TextField).htmlText = _loc3_.getIntroduction();
            (operatingMc.js_text as TextField).setTextFormat(new TextFormat(GM.fzfont.fontName,14));
            _loc4_ = _loc3_.getTaskMbStr();
            _loc2_ = 0;
            while(_loc2_ < _loc4_.length)
            {
               operatingMc["m_" + _loc2_].text = String(_loc3_.getTaskMbStr()[_loc2_]);
               _loc2_++;
            }
         }
      }
      
      private function initSlot() : void
      {
         this.slot.clearTask();
         var _loc1_:uint = 0;
         while(_loc1_ < this.taskingList.length)
         {
            this.slot.addSlot(this.taskingList[_loc1_] as Task);
            _loc1_++;
         }
      }
      
      private function initFrame() : void
      {
         var _loc2_:Task = null;
         var _loc1_:uint = 0;
         while(_loc1_ < 5)
         {
            operatingMc["task_" + _loc1_].visible = false;
            operatingMc["task_" + _loc1_].name_text.text = "";
            operatingMc["task_" + _loc1_].ftx.text = "";
            if(this.slot.getTask(_loc1_) != null)
            {
               _loc2_ = this.slot.getTask(_loc1_);
               operatingMc["task_" + _loc1_].visible = true;
               operatingMc["task_" + _loc1_].name_text.text = _loc2_.getName();
               if(_loc2_.getState() == 3)
               {
                  operatingMc["task_" + _loc1_].ftx.text = "完成";
               }
            }
            _loc1_++;
         }
      }
      
      private function jtTaskHandle(param1:UnEvent) : void
      {
         if(String(param1.obj) == "true")
         {
            GoodsManger.dataList.unionData.addGxValue(GS.a20);
            GoodsManger.cwTs("军团任务完成了,军团增加了20贡献");
            FlowInterface.saveDataByKai();
         }
      }
      
      private function errorHandle(param1:UnEvent) : void
      {
         GoodsManger.cwTs(String(param1.obj));
      }
      
      private function addEvent() : void
      {
         addEventListener(BtnEvent.DO_SAME_CHANGE,this.sameChangeHandle);
         addEventListener(BtnEvent.DO_CLICK,this.clickHandle);
         addEventListener(BtnEvent.DO_CLOSE,this.closeHandle);
         addEventListener(BtnEvent.DO_OVER,this.overHandle);
         addEventListener(BtnEvent.DO_OUT,this.outHandle);
         Main.self.addEventListener(UnEvent.TASK_OVER,this.jtTaskHandle);
         Main.self.addEventListener(UnEvent.ERROR_UNION,this.errorHandle);
         this.time.addEventListener(TimerEvent.TIMER,this.timeHandle);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(BtnEvent.DO_SAME_CHANGE,this.sameChangeHandle);
         removeEventListener(BtnEvent.DO_CLICK,this.clickHandle);
         removeEventListener(BtnEvent.DO_CLOSE,this.closeHandle);
         removeEventListener(BtnEvent.DO_OVER,this.overHandle);
         Main.self.removeEventListener(UnEvent.TASK_OVER,this.jtTaskHandle);
         Main.self.removeEventListener(UnEvent.ERROR_UNION,this.errorHandle);
         this.taskMcPanel.removeEventListener(MouseEvent.MOUSE_DOWN,this.stageClickHandle);
         this.time.removeEventListener(TimerEvent.TIMER,this.timeHandle);
      }
      
      private function outHandle(param1:BtnEvent) : void
      {
         if(param1.name == "tmBtn")
         {
            operatingMc.btnTs.visible = false;
         }
      }
      
      private function overHandle(param1:BtnEvent) : void
      {
         var _loc2_:Task = null;
         var _loc3_:Array = null;
         var _loc4_:Goods = null;
         if(param1.name == "gt")
         {
            _loc2_ = this.slot.getTask(this.currentId);
            _loc3_ = _loc2_.getRewardId();
            if(_loc3_[0] != -1)
            {
               _loc4_ = GoodsFactory.createGoodsById(_loc3_[param1.id]);
               this.taskMcPanel.dispatchEvent(new GoodsEvent(GoodsEvent.DO_DISPLAY,_loc4_));
            }
         }
         else if(param1.name == "tmBtn")
         {
            operatingMc.btnTs.visible = true;
            operatingMc.btnTs.x = mouseX;
            operatingMc.btnTs.y = mouseY;
            addChildAt(operatingMc.btnTs,numChildren - 1);
         }
      }
      
      private function closeHandle(param1:BtnEvent) : void
      {
         close();
      }
      
      private function clickHandle(param1:BtnEvent) : void
      {
         var _loc2_:Task = null;
         if(param1.name == "delete")
         {
            operatingMc.delete_mc.visible = true;
         }
         else if(param1.name == "finish")
         {
            _loc2_ = this.slot.getTask(this.currentId);
            this.deTask = _loc2_;
            if(_loc2_.getState() == 3)
            {
               if(_loc2_.getFinishFrame() == -1)
               {
                  this.getFinishFun();
               }
               else
               {
                  this.taskMcPanel.open(TaskFactory.getTalkFrameByTaskIdAndType(_loc2_.getId(),3));
                  this.taskMcPanel.addEventListener(MouseEvent.MOUSE_DOWN,this.stageClickHandle);
               }
            }
         }
         else if(param1.name == "de")
         {
            if(param1.id == 0)
            {
               _loc2_ = this.slot.getTask(this.currentId);
               if(_loc2_.getNpc() == 0 && _loc2_.getJzId() != -1)
               {
                  _loc2_.setState(0);
               }
               else
               {
                  _loc2_.setState(1);
               }
               this.initDisplay();
            }
            operatingMc.delete_mc.visible = false;
         }
         else if(param1.name == "hehe")
         {
            _loc2_ = this.slot.getTask(this.currentId);
            this.deTask = _loc2_;
            if(_loc2_.getBigType() != -1)
            {
               if(_loc2_.getJtTask() == 0)
               {
                  if(VipData.vip.getValue() > GS.a6)
                  {
                     if(_loc2_.getFinishFrame() == -1)
                     {
                        this.getFinishFun();
                     }
                     else
                     {
                        this.taskMcPanel.open(TaskFactory.getTalkFrameByTaskIdAndType(_loc2_.getId(),3));
                        this.taskMcPanel.addEventListener(MouseEvent.MOUSE_DOWN,this.stageClickHandle);
                     }
                  }
               }
               else if(_loc2_.getJtTask() == 1)
               {
                  if(VipData.vip.getValue() > GS.a7)
                  {
                     if(_loc2_.getFinishFrame() == -1)
                     {
                        this.getFinishFun();
                     }
                     else
                     {
                        this.taskMcPanel.open(TaskFactory.getTalkFrameByTaskIdAndType(_loc2_.getId(),3));
                        this.taskMcPanel.addEventListener(MouseEvent.MOUSE_DOWN,this.stageClickHandle);
                     }
                  }
               }
            }
         }
      }
      
      private function stageClickHandle(param1:MouseEvent) : void
      {
         if(this.taskMcPanel.mcGoto())
         {
            this.getFinishFun();
            this.taskMcPanel.removeEventListener(MouseEvent.MOUSE_DOWN,this.stageClickHandle);
         }
      }
      
      private function getFinishFun() : void
      {
         var _loc1_:Task = null;
         var _loc2_:Array = null;
         var _loc3_:Array = null;
         var _loc4_:VT = null;
         var _loc5_:VT = null;
         var _loc6_:Array = null;
         var _loc7_:Array = null;
         var _loc8_:Array = null;
         var _loc9_:Array = null;
         var _loc10_:Array = null;
         var _loc11_:VT = null;
         var _loc12_:VT = null;
         var _loc13_:uint = 0;
         var _loc14_:uint = 0;
         if(this.deTask != null)
         {
            _loc1_ = this.deTask;
            _loc2_ = _loc1_.getRewardId();
            _loc3_ = _loc1_.getReardNum();
            _loc4_ = VT.createVT(_loc1_.getRewardGold());
            _loc5_ = VT.createVT(_loc1_.getRewardExp());
            _loc6_ = _loc1_.getGoodsId();
            _loc7_ = _loc1_.getGoodsNum();
            if(_loc2_.length > 0 && _loc2_[0] != -1)
            {
               if(_loc1_.getBigType() != -1)
               {
                  if(!BagFactory.onlyBagOne())
                  {
                     GoodsManger.cwTs("背包已满");
                     return;
                  }
                  if(_loc1_.getJtTask() == 0)
                  {
                     GoodsManger.dataList.evData.setJd(GS.a1);
                  }
                  else if(_loc1_.getJtTask() == 1)
                  {
                     GM.testapi.overTask("7");
                     TaskData.addTimes(1);
                     GoodsManger.dataList.evData.setJd(GS.a14);
                  }
                  _loc8_ = _loc1_.getReardGl();
                  _loc9_ = [];
                  _loc10_ = [];
                  _loc11_ = VT.createVT(int(Math.random() * GS.a10000));
                  _loc12_ = VT.createVT(GS.a0);
                  _loc13_ = 0;
                  while(_loc13_ < _loc8_.length)
                  {
                     _loc12_.setValue(_loc12_.getValue() + _loc8_[_loc13_]);
                     if(_loc12_.getValue() >= _loc11_.getValue())
                     {
                        _loc9_.push(_loc2_[_loc13_]);
                        _loc10_.push(_loc3_[_loc13_]);
                        break;
                     }
                     _loc13_++;
                  }
                  _loc2_ = _loc9_;
                  _loc3_ = _loc10_;
               }
               if(BagFactory.addSameInBag(_loc2_,_loc3_))
               {
                  if(_loc6_[0] != -1)
                  {
                     if(_loc1_.getBigType() == -1)
                     {
                        _loc14_ = 0;
                        while(_loc14_ < _loc6_.length)
                        {
                           BagFactory.deteleGoods(_loc6_[_loc14_],_loc7_[_loc14_]);
                           _loc14_++;
                        }
                     }
                     else if(_loc1_.getJtTask() == 0)
                     {
                        if(TaskData.getjsTime() > GS.a0)
                        {
                           _loc14_ = 0;
                           while(_loc14_ < _loc6_.length)
                           {
                              BagFactory.deteleGoods(_loc6_[_loc14_],_loc7_[_loc14_]);
                              _loc14_++;
                           }
                        }
                     }
                     else if(_loc1_.getJtTask() == 1)
                     {
                        _loc14_ = 0;
                        while(_loc14_ < _loc6_.length)
                        {
                           BagFactory.deteleGoods(_loc6_[_loc14_],_loc7_[_loc14_]);
                           _loc14_++;
                        }
                     }
                  }
                  if(_loc4_.getValue() != -1)
                  {
                     if(_loc1_.getBigType() != -1)
                     {
                        FlowInterface.addGodByRole(TaskData.getGodByTimes(_loc1_.getJtTask()) * _loc4_.getValue());
                     }
                     else
                     {
                        FlowInterface.addGodByRole(_loc4_.getValue());
                     }
                  }
                  if(_loc5_.getValue() != -1)
                  {
                     if(_loc1_.getBigType() != -1)
                     {
                        FlowInterface.addExpByRole(TaskData.getGodByTimes(_loc1_.getJtTask()) * _loc5_.getValue());
                     }
                     else
                     {
                        FlowInterface.addExpByRole(_loc5_.getValue());
                     }
                  }
                  if(_loc1_.getSmallType() == 0)
                  {
                     _loc1_.setState(4);
                  }
                  else if(_loc1_.getSmallType() == 1)
                  {
                     _loc1_.setState(1);
                  }
                  _loc1_.addFinishNum();
                  _loc1_.deleteTaskData();
                  FlowInterface.saveDataByKai();
                  this.initDisplay();
               }
            }
            else
            {
               if(_loc1_.getBigType() != -1)
               {
                  if(_loc1_.getJtTask() == 0)
                  {
                     GoodsManger.dataList.evData.setJd(GS.a1);
                  }
                  else if(_loc1_.getJtTask() == 1)
                  {
                     GM.testapi.overTask("7");
                     TaskData.addTimes(1);
                     GoodsManger.dataList.evData.setJd(GS.a14);
                  }
               }
               if(_loc6_[0] != -1)
               {
                  if(_loc1_.getBigType() == -1)
                  {
                     _loc14_ = 0;
                     while(_loc14_ < _loc6_.length)
                     {
                        BagFactory.deteleGoods(_loc6_[_loc14_],_loc7_[_loc14_]);
                        _loc14_++;
                     }
                  }
                  else if(_loc1_.getJtTask() == 0)
                  {
                     if(TaskData.getjsTime() > GS.a0)
                     {
                        _loc14_ = 0;
                        while(_loc14_ < _loc6_.length)
                        {
                           BagFactory.deteleGoods(_loc6_[_loc14_],_loc7_[_loc14_]);
                           _loc14_++;
                        }
                     }
                  }
                  else if(_loc1_.getJtTask() == 1)
                  {
                     _loc14_ = 0;
                     while(_loc14_ < _loc6_.length)
                     {
                        BagFactory.deteleGoods(_loc6_[_loc14_],_loc7_[_loc14_]);
                        _loc14_++;
                     }
                  }
               }
               if(_loc4_.getValue() != -1)
               {
                  if(_loc1_.getBigType() != -1)
                  {
                     FlowInterface.addGodByRole(TaskData.getGodByTimes(_loc1_.getJtTask()) * _loc4_.getValue());
                  }
                  else
                  {
                     FlowInterface.addGodByRole(_loc4_.getValue());
                  }
               }
               if(_loc5_.getValue() != -1)
               {
                  if(_loc1_.getBigType() != -1)
                  {
                     FlowInterface.addExpByRole(TaskData.getGodByTimes(_loc1_.getJtTask()) * _loc5_.getValue());
                  }
                  else
                  {
                     FlowInterface.addExpByRole(_loc5_.getValue());
                  }
               }
               if(_loc1_.getSmallType() == 0)
               {
                  _loc1_.setState(4);
               }
               else if(_loc1_.getSmallType() == 1)
               {
                  _loc1_.setState(1);
               }
               _loc1_.addFinishNum();
               _loc1_.deleteTaskData();
               FlowInterface.saveDataByKai();
               this.initDisplay();
            }
            NpcTaskPanel.open(0);
         }
      }
      
      private function closeData() : void
      {
         if(!this.taskMcPanel.mcGoto() && this.deTask != null)
         {
            this.taskMcPanel.close();
            this.getFinishFun();
            this.deTask = null;
         }
         operatingMc.delete_mc.visible = false;
      }
      
      private function sameChangeHandle(param1:BtnEvent) : void
      {
         this.currentId = param1.id;
         this.textDisplay(param1.id);
         this.jiangliDisplay(param1.id);
         this.finishBtn(param1.id);
         this.jdTaskDisplay(param1.id);
      }
      
      private function jdTaskDisplay(param1:Number) : void
      {
         var _loc2_:Task = null;
         operatingMc.time_mc.visible = false;
         operatingMc.hehe_0.visible = false;
         operatingMc.btnTs.visible = false;
         if(this.slot.getTask(param1) != null)
         {
            _loc2_ = this.slot.getTask(param1);
            if(_loc2_.getBigType() != -1 && _loc2_.getJtTask() == 0)
            {
               operatingMc.time_mc.visible = true;
               operatingMc.btnTs.visible = false;
               this.time.start();
               if(VipData.vip.getValue() >= GS.a7)
               {
                  operatingMc.hehe_0.visible = true;
               }
            }
            else
            {
               if(_loc2_.getJtTask() == 1)
               {
                  if(VipData.vip.getValue() >= GS.a8)
                  {
                     operatingMc.hehe_0.visible = true;
                  }
               }
               this.time.stop();
            }
         }
         else
         {
            this.time.stop();
         }
      }
      
      private function timeHandle(param1:TimerEvent) : void
      {
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc2_:Number = Number(TaskData.getjsTime());
         this.tian = _loc2_ / this.k;
         this.shi = (_loc2_ - this.tian * this.k) / 3600;
         this.fen = (_loc2_ - this.tian * this.k - this.shi * 3600) / 60;
         this.miao = _loc2_ - this.tian * this.k - this.shi * 3600 - this.fen * 60;
         if(this.shi >= 10)
         {
            _loc3_ = String(this.shi);
         }
         else
         {
            _loc3_ = "0" + this.shi;
         }
         if(this.fen >= 10)
         {
            _loc4_ = String(this.fen);
         }
         else
         {
            _loc4_ = "0" + this.fen;
         }
         if(this.miao >= 10)
         {
            _loc5_ = String(this.miao);
         }
         else
         {
            _loc5_ = "0" + this.miao;
         }
         operatingMc.time_mc.time_tx.text = _loc4_ + ":" + _loc5_;
      }
      
      private function initMcBtn() : void
      {
         var _loc7_:BasicClickBtn = null;
         var _loc8_:TextField = null;
         var _loc9_:TextField = null;
         operatingMc.delete_mc.visible = false;
         operatingMc.time_mc.visible = false;
         this.taskBtn = SameChangeBtn.createSameChangeBtn(new Array(operatingMc.task_0,operatingMc.task_1,operatingMc.task_2,operatingMc.task_3,operatingMc.task_4));
         addChild(this.taskBtn);
         var _loc1_:BasicClickBtn = new BasicClickBtn(operatingMc.finish_btn);
         addChild(_loc1_);
         var _loc2_:BasicClickBtn = new BasicClickBtn(operatingMc.delete_btn);
         addChild(_loc2_);
         var _loc3_:BasicClickBtn = new BasicClickBtn(operatingMc.tmBtn_0);
         addChild(_loc3_);
         var _loc4_:uint = 0;
         while(_loc4_ < 2)
         {
            _loc7_ = new BasicClickBtn(operatingMc.delete_mc["de_" + _loc4_]);
            addChild(_loc7_);
            _loc4_++;
         }
         var _loc5_:BasicClickBtn = new BasicClickBtn(operatingMc.hehe_0);
         addChild(_loc5_);
         var _loc6_:CloseBtn = new CloseBtn(operatingMc.close_btn);
         addChild(_loc6_);
         _loc4_ = 0;
         while(_loc4_ < 3)
         {
            _loc8_ = new TextField();
            _loc8_ = operatingMc["m_" + _loc4_] as TextField;
            _loc8_.embedFonts = true;
            _loc8_.defaultTextFormat = new TextFormat(GM.fzfont.fontName,14);
            _loc4_++;
         }
         _loc4_ = 0;
         while(_loc4_ < 5)
         {
            _loc9_ = new TextField();
            _loc9_ = operatingMc["task_" + _loc4_].name_text as TextField;
            _loc9_.embedFonts = true;
            _loc9_.defaultTextFormat = new TextFormat(GM.fzfont.fontName,14);
            operatingMc["task_" + _loc4_].ftx.embedFonts = true;
            operatingMc["task_" + _loc4_].ftx.defaultTextFormat = new TextFormat(GM.fzfont.fontName,14);
            _loc4_++;
         }
         _loc4_ = 0;
         while(_loc4_ < 6)
         {
            operatingMc["gx_" + _loc4_].gotoAndStop(1);
            _loc4_++;
         }
         (operatingMc.name_text as TextField).embedFonts = true;
         (operatingMc.name_text as TextField).defaultTextFormat = new TextFormat(GM.fzfont.fontName,14);
         (operatingMc.js_text as TextField).embedFonts = true;
         (operatingMc.js_text as TextField).setTextFormat(new TextFormat(GM.fzfont.fontName,24));
         operatingMc.kfwancheng.visible = false;
         (operatingMc.kfwancheng as MovieClip).mouseChildren = false;
         (operatingMc.kfwancheng as MovieClip).mouseEnabled = false;
      }
   }
}

