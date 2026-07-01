package hotpointgame.views.taskPanel
{
   import flash.display.MovieClip;
   import flash.events.*;
   import flash.net.*;
   import flash.text.*;
   import flash.utils.*;
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   import hotpointgame.common.basicBtn.*;
   import hotpointgame.common.event.*;
   import hotpointgame.gview.*;
   import hotpointgame.models.bag.*;
   import hotpointgame.models.task.*;
   import hotpointgame.repository.task.*;
   import hotpointgame.utils.gameloader.*;
   import hotpointgame.views.attPanel.*;
   import hotpointgame.views.comPanel.*;
   import hotpointgame.views.fbPanel.*;
   import hotpointgame.views.geneChangePanel.*;
   import hotpointgame.views.insertPanel.*;
   import hotpointgame.views.shopPanel.*;
   import hotpointgame.views.strengPanel.*;
   import hotpointgame.views.tzpanel.*;
   import hotpointgame.views.unionPanel.*;
   import hotpointgame.views.wareroomPanel.*;
   import hotpointgame.views.wmdPanel.*;
   
   public class NpcTaskPanel extends MovieClip
   {
      
      public static var operatingMc:MovieClip;
      
      private static var _instance:NpcTaskPanel;
      
      private static var taskMcPanel:TaskMcPanel;
      
      private static var slot:taskSlot;
      
      private static var npcType:Number = 0;
      
      private static var currentTask:Task = null;
      
      private var taskData:TaskData;
      
      private var taskNum:Number = 3;
      
      private var npcGs:Number = 24;
      
      public function NpcTaskPanel()
      {
         super();
      }
      
      public static function open(param1:Number) : void
      {
         var _loc2_:Array = null;
         var _loc3_:Array = null;
         if(taskMcPanel == null)
         {
            slot = taskSlot.createSlot(3);
            taskMcPanel = TaskMcPanel.createTaskMcpanel();
         }
         if(param1 == 0)
         {
            _loc2_ = TaskData.getTaskByNpc(param1);
            if(_loc2_.length == 0)
            {
               return;
            }
            npcType = param1;
            GoodsManger.allPanelClose();
            initSlot();
            zdFunction();
         }
         else
         {
            npcType = param1;
            GoodsManger.allPanelClose();
            if(_instance == null)
            {
               if(GM.loaderM.keYiUse())
               {
                  _loc3_ = new Array();
                  _loc3_.push("npcpanel");
                  GM.loaderM.setLoadData(_loc3_);
                  GM.loaderM.completeF = loadNpctaskOver;
                  GM.loaderM.startLoadDataJieM();
                  return;
               }
               return;
            }
            _instance.visible = true;
            _instance.x = 0;
            _instance.initPanel();
         }
      }
      
      private static function loadNpctaskOver() : void
      {
         var _loc1_:Object = LoaderManager.getSwfClass("Npc_Panel") as Class;
         var _loc2_:MovieClip = new _loc1_();
         operatingMc = _loc2_;
         _instance = new NpcTaskPanel();
         _instance.addChild(operatingMc);
         GM.bagJm.addChild(_instance);
         _instance.initMcBtn();
         _instance.visible = true;
         _instance.x = 0;
         _instance.initPanel();
      }
      
      public static function close() : void
      {
         if(npcType == 0)
         {
            closeData();
            currentTask = null;
            if(_instance != null)
            {
               _instance.visible = false;
               _instance.x = 5000;
            }
         }
         else if(_instance != null)
         {
            closeData();
            currentTask = null;
            _instance.removeEvent();
            _instance.visible = false;
            _instance.x = 5000;
         }
      }
      
      private static function zdFunction() : void
      {
         if(slot.getTask(0) != null)
         {
            currentTask = slot.getTask(0);
            if(currentTask.getState() == 1)
            {
               taskMcPanel.open(TaskFactory.getTalkFrameByTaskIdAndType(currentTask.getId(),1));
               taskMcPanel.addEventListener(MouseEvent.MOUSE_DOWN,stageClickHandle);
            }
         }
         if(slot.getTask(1) != null)
         {
            throw new Error("自动弹出任务同时只能有一个");
         }
      }
      
      private static function stageClickHandle(param1:MouseEvent) : void
      {
         if(taskMcPanel.mcGoto())
         {
            closeData();
            taskMcPanel.removeEventListener(MouseEvent.MOUSE_DOWN,stageClickHandle);
            if(npcType != 0)
            {
               open(npcType);
            }
            open(0);
         }
      }
      
      private static function closeData() : void
      {
         var _loc1_:Array = null;
         var _loc2_:Array = null;
         var _loc3_:Number = NaN;
         var _loc4_:Array = null;
         var _loc5_:Array = null;
         var _loc6_:VT = null;
         var _loc7_:VT = null;
         var _loc8_:Array = null;
         var _loc9_:Array = null;
         var _loc10_:Array = null;
         var _loc11_:Array = null;
         var _loc12_:Array = null;
         var _loc13_:VT = null;
         var _loc14_:VT = null;
         var _loc15_:uint = 0;
         var _loc16_:uint = 0;
         if(currentTask != null)
         {
            if(currentTask.getState() == 1)
            {
               _loc1_ = currentTask.getPropesId();
               _loc2_ = currentTask.getPropesNum();
               _loc3_ = Number(currentTask.getPropesGold());
               if(daoJuInBag(_loc1_,_loc2_))
               {
                  if(_loc3_ != -1)
                  {
                     FlowInterface.addGodByRole(_loc3_);
                  }
                  currentTask.setState(2);
                  TaskData.initTaskStateing();
                  if(currentTask.getBigType() != -1)
                  {
                     if(currentTask.getJtTask() == 0)
                     {
                        TaskData.setJsTime(currentTask.getFinishTime() * GS.a60 + getTimer() / GS.a1000);
                        TaskData.setMbTime(currentTask.getFinishTime() * GS.a60 + getTimer() / GS.a1000);
                        TaskData.addTimes(0);
                     }
                     FlowInterface.saveDataByKai();
                  }
                  GoodsManger.taskTs(currentTask,0);
               }
               TaskData.isTaskOk();
               currentTask = null;
            }
            else if(currentTask.getState() == 3)
            {
               _loc4_ = currentTask.getRewardId();
               _loc5_ = currentTask.getReardNum();
               if(_loc4_[0] != -1 && currentTask.getBigType() != -1)
               {
                  if(!BagFactory.onlyBagOne())
                  {
                     GoodsManger.cwTs("背包已满");
                     return;
                  }
                  _loc10_ = currentTask.getReardGl();
                  _loc11_ = [];
                  _loc12_ = [];
                  _loc13_ = VT.createVT(int(Math.random() * GS.a10000));
                  _loc14_ = VT.createVT(GS.a0);
                  _loc15_ = 0;
                  while(_loc15_ < _loc10_.length)
                  {
                     _loc14_.setValue(_loc14_.getValue() + _loc10_[_loc15_]);
                     if(_loc14_.getValue() >= _loc13_.getValue())
                     {
                        _loc11_.push(_loc4_[_loc15_]);
                        _loc12_.push(_loc5_[_loc15_]);
                        break;
                     }
                     _loc15_++;
                  }
                  _loc4_ = _loc11_;
                  _loc5_ = _loc12_;
               }
               _loc6_ = VT.createVT(currentTask.getRewardGold());
               _loc7_ = VT.createVT(currentTask.getRewardExp());
               _loc8_ = currentTask.getGoodsId();
               _loc9_ = currentTask.getGoodsNum();
               if(daoJuInBag(_loc4_,_loc5_))
               {
                  if(currentTask.getBigType() != -1)
                  {
                     if(currentTask.getJtTask() == 0)
                     {
                        GoodsManger.dataList.evData.setJd(GS.a1);
                     }
                     else if(currentTask.getJtTask() == 1)
                     {
                        TaskData.addTimes(1);
                        GM.testapi.overTask("7");
                        GoodsManger.dataList.evData.setJd(GS.a14);
                     }
                  }
                  if(_loc8_[0] != -1)
                  {
                     if(currentTask.getBigType() == -1)
                     {
                        _loc16_ = 0;
                        while(_loc16_ < _loc8_.length)
                        {
                           BagFactory.deteleGoods(_loc8_[_loc16_],_loc9_[_loc16_]);
                           _loc16_++;
                        }
                     }
                     else if(currentTask.getJtTask() == 0)
                     {
                        if(TaskData.getjsTime() > GS.a0)
                        {
                           _loc16_ = 0;
                           while(_loc16_ < _loc8_.length)
                           {
                              BagFactory.deteleGoods(_loc8_[_loc16_],_loc9_[_loc16_]);
                              _loc16_++;
                           }
                        }
                     }
                     else if(currentTask.getJtTask() == 1)
                     {
                        _loc16_ = 0;
                        while(_loc16_ < _loc8_.length)
                        {
                           BagFactory.deteleGoods(_loc8_[_loc16_],_loc9_[_loc16_]);
                           _loc16_++;
                        }
                     }
                  }
                  if(_loc6_.getValue() != -1)
                  {
                     if(currentTask.getBigType() != -1)
                     {
                        FlowInterface.addGodByRole(TaskData.getGodByTimes(currentTask.getJtTask()) * _loc6_.getValue());
                     }
                     else
                     {
                        FlowInterface.addGodByRole(_loc6_.getValue());
                     }
                  }
                  if(_loc7_.getValue() != -1)
                  {
                     if(currentTask.getBigType() != -1)
                     {
                        FlowInterface.addExpByRole(TaskData.getGodByTimes(currentTask.getJtTask()) * _loc7_.getValue());
                     }
                     else
                     {
                        FlowInterface.addExpByRole(_loc7_.getValue());
                     }
                  }
                  if(currentTask.getSmallType() == 0)
                  {
                     currentTask.setState(4);
                  }
                  else if(currentTask.getSmallType() == 1)
                  {
                     currentTask.setState(1);
                  }
                  currentTask.addFinishNum();
                  currentTask.deleteTaskData();
                  TaskData.initTaskStateing();
                  FlowInterface.saveDataByKai();
               }
               currentTask = null;
            }
            taskMcPanel.close();
         }
      }
      
      public static function addRew(param1:Task) : void
      {
         var _loc2_:Array = null;
         var _loc3_:Array = null;
         var _loc4_:VT = null;
         var _loc5_:VT = null;
         var _loc6_:Array = null;
         var _loc7_:Array = null;
         var _loc8_:uint = 0;
         if(param1.getState() != GS.a4)
         {
            _loc2_ = param1.getRewardId();
            _loc3_ = param1.getReardNum();
            _loc4_ = VT.createVT(param1.getRewardGold());
            _loc5_ = VT.createVT(param1.getRewardExp());
            _loc6_ = param1.getGoodsId();
            _loc7_ = param1.getGoodsNum();
            if(_loc2_[0] != -1)
            {
               if(BagFactory.isFullBag(_loc2_,_loc3_))
               {
                  param1.setState(4);
                  param1.addFinishNum();
                  if(_loc6_[0] != -1)
                  {
                     _loc8_ = 0;
                     while(_loc8_ < _loc6_.length)
                     {
                        BagFactory.deteleGoods(_loc6_[_loc8_],_loc7_[_loc8_]);
                        _loc8_++;
                     }
                  }
                  if(_loc4_.getValue() != -1)
                  {
                     FlowInterface.addGodByRole(_loc4_.getValue());
                  }
                  if(_loc5_.getValue() != -1)
                  {
                     FlowInterface.addExpByRole(_loc5_.getValue());
                  }
                  BagFactory.addBagArr(_loc2_,_loc3_);
               }
               else
               {
                  param1.setState(3);
                  GoodsManger.cwTs("背包已满");
               }
            }
            else
            {
               if(_loc6_[0] != -1)
               {
                  _loc8_ = 0;
                  while(_loc8_ < _loc6_.length)
                  {
                     BagFactory.deteleGoods(_loc6_[_loc8_],_loc7_[_loc8_]);
                     _loc8_++;
                  }
               }
               if(_loc4_.getValue() != -1)
               {
                  FlowInterface.addGodByRole(_loc4_.getValue());
               }
               if(_loc5_.getValue() != -1)
               {
                  FlowInterface.addExpByRole(_loc5_.getValue());
               }
               param1.setState(4);
               param1.addFinishNum();
            }
         }
      }
      
      private static function daoJuInBag(param1:Array, param2:Array) : Boolean
      {
         if(currentTask != null)
         {
            if(param1.length > 0 && param1[0] != -1)
            {
               return BagFactory.addSameInBag(param1,param2);
            }
            return true;
         }
         return false;
      }
      
      private static function initSlot() : void
      {
         var _loc1_:Array = TaskData.getTaskByNpc(npcType);
         slot.clearTask();
         var _loc2_:uint = 0;
         while(_loc2_ < _loc1_.length)
         {
            slot.addSlot(_loc1_[_loc2_] as Task);
            _loc2_++;
         }
      }
      
      private function initPanel() : void
      {
         this.addEvent();
         if(npcType == GS.a8)
         {
            DataIngPanel.open("数据加载中");
            GM.testapi.getMyselfUnion();
         }
         else
         {
            operatingMc["b_" + 13].visible = false;
            operatingMc["b_" + 14].visible = false;
            operatingMc["b_" + 15].visible = false;
            operatingMc["b_" + 16].visible = false;
         }
         TaskData.isGoodsNoOk();
         this.initDisplay();
         this.npcDisplay();
         this.jdText();
      }
      
      private function unionHandle(param1:UnEvent) : void
      {
         GoodsManger.dataList.unionData.setMyUnion(param1.obj);
         DataIngPanel.close();
         operatingMc.b_14.visible = false;
         operatingMc.b_13.visible = false;
         operatingMc.b_15.visible = false;
         operatingMc["b_" + 16].visible = true;
         if(GoodsManger.dataList.unionData.getMyUnion() != null)
         {
            operatingMc.b_14.visible = true;
         }
         else
         {
            operatingMc.b_13.visible = true;
            operatingMc.b_15.visible = true;
            GoodsManger.dataList.unionData.clearData();
         }
      }
      
      private function jdText() : void
      {
         if(npcType == GS.a3)
         {
            if(TaskData.getJdTasking() != null)
            {
               if(TaskData.getJdTasking().getState() == 2)
               {
                  operatingMc.jdBtn_0.state_tx.text = "每日使命进行中";
               }
               else if(TaskData.getJdTasking().getState() == 3)
               {
                  operatingMc.jdBtn_0.state_tx.text = "每日使命已完成";
               }
            }
            else
            {
               operatingMc.jdBtn_0.state_tx.text = "接受每日使命";
            }
         }
         else if(npcType == GS.a9)
         {
            if(TaskData.getJdTasking(1) != null)
            {
               if(TaskData.getJdTasking(1).getState() == 2)
               {
                  operatingMc.jdBtn_1.state_tx.text = "军团任务进行中";
               }
               else if(TaskData.getJdTasking(1).getState() == 3)
               {
                  operatingMc.jdBtn_1.state_tx.text = "军团任务已完成";
               }
            }
            else
            {
               operatingMc.jdBtn_1.state_tx.text = "接受军团任务";
            }
         }
      }
      
      private function closeHandle(param1:BtnEvent) : void
      {
         close();
      }
      
      private function npcDisplay() : void
      {
         operatingMc.p_mc.gotoAndStop(npcType);
         operatingMc.jdBtn_0.visible = false;
         operatingMc.jdBtn_1.visible = false;
         var _loc1_:uint = 0;
         while(_loc1_ <= this.npcGs)
         {
            if(_loc1_ != 13 && _loc1_ != 14 && _loc1_ != 15 && _loc1_ != 16)
            {
               operatingMc["b_" + _loc1_].visible = false;
            }
            _loc1_++;
         }
         if(npcType == 1)
         {
            operatingMc.b_0.visible = true;
            operatingMc.b_1.visible = true;
            operatingMc.b_2.visible = false;
            if(GM.levelSD.getOverProcess(GS.a6) != -1)
            {
               operatingMc.b_7.visible = true;
               operatingMc.b_22.visible = true;
            }
            if(GM.levelSD.getOverProcess(GS.a5) != -1)
            {
               operatingMc.b_3.visible = true;
            }
         }
         else if(npcType == 2)
         {
            operatingMc.b_4.visible = true;
            operatingMc.b_18.visible = true;
         }
         else if(npcType == 3)
         {
            operatingMc.b_5.visible = true;
            if(FlowInterface.getLevelByRole() >= 14)
            {
               operatingMc.jdBtn_0.visible = true;
            }
         }
         else if(npcType == 4)
         {
            if(GM.levelSD.getOverProcess(GS.a6) != -1)
            {
               operatingMc.b_8.visible = true;
            }
            if(GM.levelSD.getOverProcess(GS.a9) != -1)
            {
               operatingMc.b_10.visible = true;
            }
            operatingMc.b_24.visible = true;
         }
         else if(npcType == 5)
         {
            operatingMc.b_9.visible = true;
            operatingMc.b_12.visible = true;
         }
         else if(npcType == 6)
         {
            operatingMc.b_11.visible = true;
         }
         else if(npcType == 7)
         {
            operatingMc.b_6.visible = true;
            operatingMc.b_23.visible = true;
         }
         else if(npcType == 9)
         {
            operatingMc.jdBtn_1.visible = true;
            operatingMc.b_19.visible = true;
         }
         else if(npcType == 10)
         {
            operatingMc.b_17.visible = true;
         }
         else if(npcType == 11)
         {
            operatingMc.b_20.visible = true;
            operatingMc.b_21.visible = true;
         }
      }
      
      private function initDisplay() : void
      {
         initSlot();
         this.initFrame();
      }
      
      private function addEvent() : void
      {
         addEventListener(BtnEvent.DO_CLICK,this.clickHandle);
         addEventListener(BtnEvent.DO_CLOSE,this.closeHandle);
         Main.self.addEventListener(UnEvent.MY_UNION,this.unionHandle);
         Main.self.addEventListener(UnEvent.TASK_OVER,this.jtTaskHandle);
         Main.self.addEventListener(UnEvent.ERROR_UNION,this.errorHandle);
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
      
      private function removeEvent() : void
      {
         removeEventListener(BtnEvent.DO_CLICK,this.clickHandle);
         removeEventListener(BtnEvent.DO_CLOSE,this.closeHandle);
         Main.self.removeEventListener(UnEvent.MY_UNION,this.unionHandle);
         taskMcPanel.removeEventListener(MouseEvent.MOUSE_DOWN,stageClickHandle);
         Main.self.removeEventListener(UnEvent.TASK_OVER,this.jtTaskHandle);
         Main.self.removeEventListener(UnEvent.ERROR_UNION,this.errorHandle);
      }
      
      private function clickHandle(param1:BtnEvent) : void
      {
         var _loc2_:URLRequest = null;
         if(param1.name == "mc")
         {
            currentTask = slot.getTask(param1.id);
            this.taskFunxx();
         }
         else if(param1.name == "jdBtn")
         {
            if(TaskData.getJdTasking(param1.id) != null)
            {
               currentTask = TaskData.getJdTasking(param1.id);
               this.taskFunxx();
            }
            else if(param1.id == 0)
            {
               if(TaskData.getTimes() < TaskData.maxTimes.getValue())
               {
                  currentTask = TaskData.getJdByLevel(param1.id);
                  this.taskFunxx();
               }
               else
               {
                  GoodsManger.cwTs("每日最多接取5个每日任务");
               }
            }
            else if(param1.id == 1)
            {
               if(TaskData.jtTimes.getValue() < TaskData.jtMaxTimes.getValue())
               {
                  currentTask = TaskData.getJdByLevel(param1.id);
                  this.taskFunxx();
               }
               else
               {
                  GoodsManger.cwTs("今天不能再做军团任务了");
               }
            }
         }
         else if(param1.name == "b")
         {
            if(param1.id == 0)
            {
               InsertPanel.open();
            }
            else if(param1.id == 1)
            {
               StrengthenPanel.open();
            }
            else if(param1.id == 4)
            {
               ShopPanel.open();
            }
            else if(param1.id == 5)
            {
               FlowInterface.openSkillUp();
            }
            else if(param1.id == 3)
            {
               ComPanel.open();
            }
            else if(param1.id == 6)
            {
               WareroomPanel.open();
            }
            else if(param1.id == 7)
            {
               GeneChangePanel.open();
            }
            else if(param1.id == 8)
            {
               FbPanel.open();
            }
            else if(param1.id == 9)
            {
               GdataPK.open();
            }
            else if(param1.id == 10)
            {
               GenterTZT.open();
            }
            else if(param1.id == 11)
            {
               if(GM.levelSD.getOverProcess(GS.a9) != -1)
               {
                  GM.levelm.changeLevelDataByIdAndLs(GS.a9997 - GS.a1,1);
               }
               else
               {
                  GoodsManger.cwTs("获得暗黑之海进入权限才可以进入");
               }
            }
            else if(param1.id == 12)
            {
               GPkOldAw.open();
            }
            else if(param1.id == 13)
            {
               UnionSqPanel.open(GS.a0);
            }
            else if(param1.id == 14)
            {
               GM.levelm.changeLevelDataByIdAndLs(GS.a9997 - GS.a2,1);
            }
            else if(param1.id == 15)
            {
               ChangeUnPanel.open();
            }
            else if(param1.id == 16)
            {
               _loc2_ = new URLRequest("http://my.4399.com/forums-mtag-tagid-81881.html");
               navigateToURL(_loc2_,"_blank");
            }
            else if(param1.id == 17)
            {
               UnionShopPanel.open();
            }
            else if(param1.id == 18)
            {
               BagFactory.bcLb();
            }
            else if(param1.id == 19)
            {
               AddUnZJPanel.open();
            }
            else if(param1.id == 20)
            {
               UnJsPanel.open();
            }
            else if(param1.id == 21)
            {
               AddUnJsPanel.open();
            }
            else if(param1.id == 22)
            {
               WmdPanel.open();
            }
            else if(param1.id == 23)
            {
               AttZdlPanel.open();
            }
            else if(param1.id == 24)
            {
               TzPanel.open();
            }
         }
      }
      
      private function taskFunxx() : void
      {
         var _loc1_:Array = null;
         var _loc2_:Array = null;
         var _loc3_:VT = null;
         var _loc4_:VT = null;
         var _loc5_:Array = null;
         var _loc6_:Array = null;
         var _loc7_:Array = null;
         var _loc8_:Array = null;
         var _loc9_:Array = null;
         var _loc10_:VT = null;
         var _loc11_:VT = null;
         var _loc12_:uint = 0;
         var _loc13_:uint = 0;
         if(currentTask != null)
         {
            if(currentTask.getState() == 1)
            {
               taskMcPanel.open(TaskFactory.getTalkFrameByTaskIdAndType(currentTask.getId(),1));
               taskMcPanel.addEventListener(MouseEvent.MOUSE_DOWN,stageClickHandle);
               this.visible = false;
            }
            else if(currentTask.getState() == 2)
            {
               taskMcPanel.open(TaskFactory.getTalkFrameByTaskIdAndType(currentTask.getId(),2));
               taskMcPanel.addEventListener(MouseEvent.MOUSE_DOWN,stageClickHandle);
               this.visible = false;
            }
            else if(currentTask.getState() == 3)
            {
               if(currentTask.getFinishFrame() != -1)
               {
                  taskMcPanel.open(TaskFactory.getTalkFrameByTaskIdAndType(currentTask.getId(),3));
                  taskMcPanel.addEventListener(MouseEvent.MOUSE_DOWN,stageClickHandle);
                  this.visible = false;
               }
               else
               {
                  _loc1_ = currentTask.getRewardId();
                  _loc2_ = currentTask.getReardNum();
                  _loc3_ = VT.createVT(currentTask.getRewardGold());
                  _loc4_ = VT.createVT(currentTask.getRewardExp());
                  _loc5_ = currentTask.getGoodsId();
                  _loc6_ = currentTask.getGoodsNum();
                  if(_loc1_[0] != -1 && currentTask.getBigType() != -1)
                  {
                     if(!BagFactory.onlyBagOne())
                     {
                        GoodsManger.cwTs("背包已满");
                        return;
                     }
                     _loc7_ = currentTask.getReardGl();
                     _loc8_ = [];
                     _loc9_ = [];
                     _loc10_ = VT.createVT(int(Math.random() * GS.a10000));
                     _loc11_ = VT.createVT(GS.a0);
                     _loc12_ = 0;
                     while(_loc12_ < _loc7_.length)
                     {
                        _loc11_.setValue(_loc11_.getValue() + _loc7_[_loc12_]);
                        if(_loc11_.getValue() >= _loc10_.getValue())
                        {
                           _loc8_.push(_loc1_[_loc12_]);
                           _loc9_.push(_loc2_[_loc12_]);
                           break;
                        }
                        _loc12_++;
                     }
                     _loc1_ = _loc8_;
                     _loc2_ = _loc9_;
                  }
                  if(daoJuInBag(_loc1_,_loc2_))
                  {
                     if(currentTask.getBigType() != -1)
                     {
                        if(currentTask.getJtTask() == 0)
                        {
                           GoodsManger.dataList.evData.setJd(GS.a1);
                        }
                        else if(currentTask.getJtTask() == 1)
                        {
                           TaskData.addTimes(1);
                           GM.testapi.overTask("7");
                           GoodsManger.dataList.evData.setJd(GS.a14);
                        }
                     }
                     if(_loc5_[0] != -1)
                     {
                        if(currentTask.getBigType() == -1)
                        {
                           _loc13_ = 0;
                           while(_loc13_ < _loc5_.length)
                           {
                              BagFactory.deteleGoods(_loc5_[_loc13_],_loc6_[_loc13_]);
                              _loc13_++;
                           }
                        }
                        else if(currentTask.getJtTask() == 0)
                        {
                           if(TaskData.getjsTime() > GS.a0)
                           {
                              _loc13_ = 0;
                              while(_loc13_ < _loc5_.length)
                              {
                                 BagFactory.deteleGoods(_loc5_[_loc13_],_loc6_[_loc13_]);
                                 _loc13_++;
                              }
                           }
                        }
                        else if(currentTask.getJtTask() == 1)
                        {
                           _loc13_ = 0;
                           while(_loc13_ < _loc5_.length)
                           {
                              BagFactory.deteleGoods(_loc5_[_loc13_],_loc6_[_loc13_]);
                              _loc13_++;
                           }
                        }
                     }
                     if(_loc3_.getValue() != -1)
                     {
                        if(currentTask.getBigType() != -1)
                        {
                           FlowInterface.addGodByRole(TaskData.getGodByTimes(currentTask.getJtTask()) * _loc3_.getValue());
                        }
                        else
                        {
                           FlowInterface.addGodByRole(_loc3_.getValue());
                        }
                     }
                     if(_loc4_.getValue() != -1)
                     {
                        if(currentTask.getBigType() != -1)
                        {
                           FlowInterface.addExpByRole(TaskData.getGodByTimes(currentTask.getJtTask()) * _loc4_.getValue());
                        }
                        else
                        {
                           FlowInterface.addExpByRole(_loc4_.getValue());
                        }
                     }
                     if(currentTask.getSmallType() == 0)
                     {
                        currentTask.setState(4);
                     }
                     else if(currentTask.getSmallType() == 1)
                     {
                        currentTask.setState(1);
                     }
                     currentTask.addFinishNum();
                     currentTask.deleteTaskData();
                     TaskData.initTaskStateing();
                     FlowInterface.saveDataByKai();
                     currentTask = null;
                  }
                  open(npcType);
               }
            }
         }
      }
      
      private function initFrame() : void
      {
         var _loc2_:Task = null;
         var _loc1_:uint = 0;
         while(_loc1_ < this.taskNum)
         {
            operatingMc["mc_" + _loc1_].visible = false;
            operatingMc["w_" + _loc1_].visible = false;
            if(slot.getTask(_loc1_) != null)
            {
               _loc2_ = slot.getTask(_loc1_);
               operatingMc["mc_" + _loc1_].visible = true;
               operatingMc["mc_" + _loc1_].txt.text = _loc2_.getName();
               operatingMc["w_" + _loc1_].visible = true;
               if(_loc2_.getState() == 1)
               {
                  operatingMc["w_" + _loc1_].gotoAndStop(3);
               }
               else if(_loc2_.getState() == 2)
               {
                  operatingMc["w_" + _loc1_].gotoAndStop(2);
               }
               else if(_loc2_.getState() == 3)
               {
                  operatingMc["w_" + _loc1_].gotoAndStop(1);
               }
            }
            _loc1_++;
         }
      }
      
      private function initMcBtn() : void
      {
         var _loc3_:BasicClickBtn = null;
         var _loc4_:BasicClickBtn = null;
         var _loc5_:TextField = null;
         var _loc6_:BasicClickBtn = null;
         var _loc1_:int = 0;
         while(_loc1_ < 3)
         {
            _loc3_ = new BasicClickBtn(operatingMc["mc_" + _loc1_]);
            addChild(_loc3_);
            _loc1_++;
         }
         operatingMc.p_mc.gotoAndStop(1);
         _loc1_ = 0;
         while(_loc1_ <= this.npcGs)
         {
            _loc4_ = new BasicClickBtn(operatingMc["b_" + _loc1_]);
            addChild(_loc4_);
            _loc1_++;
         }
         var _loc2_:CloseBtn = new CloseBtn(operatingMc.close_btn);
         addChild(_loc2_);
         _loc1_ = 0;
         while(_loc1_ < 3)
         {
            _loc5_ = new TextField();
            _loc5_ = operatingMc["mc_" + _loc1_].txt as TextField;
            _loc5_.embedFonts = true;
            _loc5_.defaultTextFormat = new TextFormat(GM.fzfont.fontName,12);
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < 2)
         {
            operatingMc["jdBtn_" + _loc1_].state_tx.embedFonts = true;
            operatingMc["jdBtn_" + _loc1_].state_tx.defaultTextFormat = new TextFormat(GM.fzfont.fontName,12);
            _loc6_ = new BasicClickBtn(operatingMc["jdBtn_" + _loc1_]);
            addChild(_loc6_);
            _loc1_++;
         }
      }
   }
}

