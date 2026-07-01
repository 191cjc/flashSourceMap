package hotpointgame.views.taskPanel
{
   import flash.utils.*;
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   import hotpointgame.models.bag.*;
   import hotpointgame.models.task.*;
   import hotpointgame.repository.task.*;
   import hotpointgame.utils.*;
   import hotpointgame.views.vipPanel.*;
   
   public class TaskData
   {
      
      private static var taskData:TaskData;
      
      public static var saveArr:Array = [];
      
      private static var taskArr:Array = [];
      
      private static var jdTaskList:Array = [];
      
      private static var ptTaskList:Array = [];
      
      private static var npc4List:Array = [];
      
      private static var npc1List:Array = [];
      
      private static var npc2List:Array = [];
      
      private static var npc3List:Array = [];
      
      private static var npc5List:Array = [];
      
      private static var zdList:Array = [];
      
      public static var taskIngList:Array = [];
      
      public static var taskState2List:Array = [];
      
      private static var times:VT = VT.createVT(GS.a0);
      
      public static var jtTimes:VT = VT.createVT(GS.a0);
      
      public static var jtMaxTimes:VT = VT.createVT(GS.a10);
      
      public static var maxTimes:VT = VT.createVT(GS.a5);
      
      private static var jsTimes:VT = VT.createVT(GS.a0);
      
      private static var mbTimes:VT = VT.createVT(GS.a0);
      
      private static var goldArr:Array = [GS.a1,GS.a2,GS.a3,GS.a4,GS.a5];
      
      private static var jtGoldArr:Array = [GS.a1,GS.a2,GS.a2,GS.a3,GS.a3,GS.a4,GS.a5,GS.a6,GS.a6];
      
      private static var evbo:VT = VT.createVT(GS.a0);
      
      public function TaskData()
      {
         super();
      }
      
      public static function getGodByTimes(param1:Number = 0) : Number
      {
         if(param1 == 0)
         {
            if(times.getValue() > 5)
            {
               return GS.a5;
            }
            if(times.getValue() != 0)
            {
               return goldArr[times.getValue() - GS.a1];
            }
         }
         else if(param1 == 1)
         {
            if(jtTimes.getValue() >= jtMaxTimes.getValue())
            {
               return GS.a6;
            }
            if(jtTimes.getValue() != 0)
            {
               return jtGoldArr[jtTimes.getValue() - GS.a1];
            }
         }
         return GS.a1;
      }
      
      public static function getTimes() : Number
      {
         return times.getValue();
      }
      
      public static function setTimes(param1:Number) : void
      {
         times.setValue(param1);
      }
      
      public static function setJtTimes(param1:Number) : void
      {
         jtTimes.setValue(param1);
      }
      
      public static function maxFun() : void
      {
         maxTimes.setValue(GS.a5);
         if(VipData.vip.getValue() != -1 && VipData.vip.getValue() != GS.a1)
         {
            if(VipData.vip.getValue() < GS.a6)
            {
               maxTimes.setValue(maxTimes.getValue() + VipData.vip.getValue() - GS.a1);
            }
            else
            {
               maxTimes.setValue(maxTimes.getValue() + GS.a5);
            }
         }
      }
      
      public static function addTimes(param1:Number = 0) : void
      {
         if(param1 == 0)
         {
            if(times.getValue() < maxTimes.getValue())
            {
               times.setValue(times.getValue() + GS.a1);
            }
         }
         else if(param1 == 1)
         {
            if(jtTimes.getValue() < jtMaxTimes.getValue())
            {
               jtTimes.setValue(jtTimes.getValue() + GS.a1);
            }
         }
      }
      
      public static function setJsTime(param1:Number) : void
      {
         jsTimes.setValue(param1);
      }
      
      public static function setMbTime(param1:Number) : void
      {
         mbTimes.setValue(param1);
      }
      
      public static function getMbTime() : Number
      {
         return mbTimes.getValue();
      }
      
      public static function getjsTime() : Number
      {
         return jsTimes.getValue();
      }
      
      public static function createTaskData() : TaskData
      {
         if(TaskData.taskData == null)
         {
            taskData = new TaskData();
         }
         return taskData;
      }
      
      public static function save() : Object
      {
         var _loc3_:Task = null;
         var _loc1_:Object = new Object();
         var _loc2_:Array = [];
         for each(_loc3_ in taskArr)
         {
            if(_loc3_.getBigType() == -1)
            {
               if(_loc3_.getJzId() == -1)
               {
                  if(_loc3_.getState() != 1)
                  {
                     _loc2_.push(_loc3_.saveTask());
                  }
               }
               else if(_loc3_.getState() != 0)
               {
                  _loc2_.push(_loc3_.saveTask());
               }
            }
            else if(_loc3_.getState() != 1)
            {
               _loc2_.push(_loc3_.saveTask());
            }
         }
         _loc1_["ts"] = _loc2_;
         _loc1_["te"] = times.getValue();
         _loc1_["jt"] = jtTimes.getValue();
         return _loc1_;
      }
      
      public static function read(param1:Object) : void
      {
         var _loc3_:* = undefined;
         saveArr.length = 0;
         var _loc2_:Array = param1["ts"];
         for each(_loc3_ in _loc2_)
         {
            saveArr.push(Task.readTask(_loc3_));
         }
         if(param1["te"] != null)
         {
            setTimes(param1["te"]);
         }
         if(param1["jt"] != null)
         {
            setJtTimes(param1["jt"]);
         }
         evbo.setValue(GS.a0);
      }
      
      public static function clearSaveDate() : void
      {
         evbo.setValue(GS.a1);
      }
      
      public static function openJz(param1:Number) : Boolean
      {
         var _loc2_:Task = null;
         for each(_loc2_ in taskArr)
         {
            if(_loc2_.getJzId() != -1)
            {
               if(param1 == _loc2_.getJzId())
               {
                  if(_loc2_.getState() != 1 && _loc2_.getState() != 2 && _loc2_.getState() != 3)
                  {
                     _loc2_.setState(1);
                     NpcTaskPanel.open(0);
                     return true;
                  }
               }
            }
         }
         return false;
      }
      
      public static function closeData() : void
      {
         saveArr.length = 0;
         times.setValue(GS.a0);
         jsTimes.setValue(GS.a0);
         mbTimes.setValue(GS.a0);
         evbo.setValue(GS.a0);
         jtTimes.setValue(GS.a0);
      }
      
      public static function initTaskData() : void
      {
         var _loc1_:Task = null;
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:Task = null;
         var _loc5_:Array = null;
         var _loc6_:Array = null;
         var _loc7_:uint = 0;
         taskArr.length = 0;
         jdTaskList.length = 0;
         ptTaskList.length = 0;
         npc4List.length = 0;
         npc1List.length = 0;
         npc2List.length = 0;
         npc3List.length = 0;
         npc5List.length = 0;
         zdList.length = 0;
         taskIngList.length = 0;
         taskState2List.length = 0;
         taskArr = DeepCopyUtil.clone(TaskFactory.taskList);
         if(saveArr.length != 0)
         {
            _loc2_ = 0;
            while(_loc2_ < taskArr.length)
            {
               _loc3_ = 0;
               while(_loc3_ < saveArr.length)
               {
                  if(taskArr[_loc2_] as Task != null && (taskArr[_loc2_] as Task).getId() == (saveArr[_loc3_] as Task).getId())
                  {
                     _loc4_ = saveArr[_loc3_] as Task;
                     if(_loc4_.getId() == 44)
                     {
                        if(_loc4_.getState() == 4 && _loc4_.getFinishNum() == 0)
                        {
                           _loc5_ = _loc4_.getGoodsId();
                           _loc6_ = _loc4_.getGoodsNum();
                           if(_loc5_[0] != -1)
                           {
                              _loc7_ = 0;
                              while(_loc7_ < _loc5_.length)
                              {
                                 BagFactory.deteleGoods(_loc5_[_loc7_],_loc6_[_loc7_]);
                                 _loc7_++;
                              }
                           }
                           BagFactory.addInBagById(GS.a511075,GS.a1,GS.a0);
                           _loc4_.addFinishNum();
                        }
                     }
                     if(evbo.getValue() == GS.a1 && _loc4_.getBigType() != -1)
                     {
                        _loc4_.setState(GS.a1);
                     }
                     taskArr[_loc2_] = _loc4_;
                     break;
                  }
                  _loc3_++;
               }
               _loc2_++;
            }
         }
         for each(_loc1_ in taskArr)
         {
            if(_loc1_ != null)
            {
               if(_loc1_.getBigType() == -1)
               {
                  ptTaskList.push(_loc1_);
               }
               else
               {
                  jdTaskList.push(_loc1_);
               }
            }
         }
         for each(_loc1_ in ptTaskList)
         {
            if(_loc1_.getNpc() == 0)
            {
               zdList.push(_loc1_);
            }
            else if(_loc1_.getNpc() == 1)
            {
               npc1List.push(_loc1_);
            }
            else if(_loc1_.getNpc() == 2)
            {
               npc2List.push(_loc1_);
            }
            else if(_loc1_.getNpc() == 3)
            {
               npc3List.push(_loc1_);
            }
            else if(_loc1_.getNpc() == 4)
            {
               npc4List.push(_loc1_);
            }
            else if(_loc1_.getNpc() == 5)
            {
               npc5List.push(_loc1_);
            }
         }
         initTaskStateing();
         readTaskTime();
         saveArr.length = 0;
         evbo.setValue(GS.a0);
         maxFun();
      }
      
      public static function readTaskTime() : void
      {
         var _loc1_:Task = null;
         for each(_loc1_ in taskState2List)
         {
            if(_loc1_.getBigType() != -1)
            {
               setJsTime(_loc1_.getFinishTime() * GS.a60 + getTimer() / GS.a1000);
               setMbTime(_loc1_.getFinishTime() * GS.a60 + getTimer() / GS.a1000);
               return;
            }
         }
      }
      
      public static function getJdTaskXX() : Task
      {
         var _loc1_:Task = null;
         for each(_loc1_ in taskState2List)
         {
            if(_loc1_.getBigType() != -1 && _loc1_.getJtTask() == 0)
            {
               return _loc1_;
            }
         }
         return null;
      }
      
      public static function getJdTasking(param1:Number = 0) : Task
      {
         var _loc2_:Task = null;
         for each(_loc2_ in taskIngList)
         {
            if(_loc2_.getBigType() != -1 && _loc2_.getJtTask() == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public static function getJdByLevel(param1:Number = 0) : Task
      {
         var _loc3_:Task = null;
         var _loc4_:Number = NaN;
         var _loc2_:Array = [];
         for each(_loc3_ in jdTaskList)
         {
            if(_loc3_.getBigType() == getJd() && _loc3_.getPlayer() == FlowInterface.getJobByRole() && _loc3_.getJtTask() == param1)
            {
               _loc2_.push(_loc3_);
            }
         }
         if(_loc2_.length != 0)
         {
            _loc4_ = int(Math.random() * _loc2_.length);
            return _loc2_[_loc4_];
         }
         return null;
      }
      
      public static function getJd() : Number
      {
         if(FlowInterface.getLevelByRole() >= GS.a1 && FlowInterface.getLevelByRole() <= GS.a15)
         {
            return GS.a1;
         }
         if(FlowInterface.getLevelByRole() >= GS.a16 && FlowInterface.getLevelByRole() <= GS.a35)
         {
            return GS.a2;
         }
         if(FlowInterface.getLevelByRole() >= GS.a36 && FlowInterface.getLevelByRole() <= GS.a55)
         {
            return GS.a3;
         }
         if(FlowInterface.getLevelByRole() >= GS.a56 && FlowInterface.getLevelByRole() <= GS.a80)
         {
            return GS.a4;
         }
         return 1;
      }
      
      public static function getNpcNum(param1:Number) : Number
      {
         var _loc2_:Array = null;
         var _loc3_:Array = null;
         var _loc4_:Array = null;
         var _loc5_:uint = 0;
         var _loc6_:Task = null;
         if(param1 != 3 && param1 != 9)
         {
            return getGotoNum(getTaskByNpc(param1));
         }
         if(param1 == 3)
         {
            if(times.getValue() < maxTimes.getValue())
            {
               _loc2_ = getTaskByNpc(3);
               _loc3_ = [];
               _loc4_ = [];
               _loc5_ = 0;
               while(_loc5_ < _loc2_.length)
               {
                  _loc4_.push(_loc2_[_loc5_]);
                  _loc5_++;
               }
               for each(_loc6_ in jdTaskList)
               {
                  if(_loc6_.getBigType() == getJd() && _loc6_.getJtTask() == 0)
                  {
                     _loc3_.push(_loc6_);
                  }
               }
               _loc5_ = 0;
               while(_loc5_ < _loc3_.length)
               {
                  _loc4_.push(_loc3_[_loc5_]);
                  _loc5_++;
               }
               return getGotoNum(_loc4_);
            }
            return 1;
         }
         if(param1 == 9)
         {
            if(jtTimes.getValue() < jtMaxTimes.getValue())
            {
               _loc2_ = getTaskByNpc(9);
               _loc3_ = [];
               _loc4_ = [];
               _loc5_ = 0;
               while(_loc5_ < _loc2_.length)
               {
                  _loc4_.push(_loc2_[_loc5_]);
                  _loc5_++;
               }
               for each(_loc6_ in jdTaskList)
               {
                  if(_loc6_.getBigType() == getJd() && _loc6_.getJtTask() == 1)
                  {
                     _loc3_.push(_loc6_);
                  }
               }
               _loc5_ = 0;
               while(_loc5_ < _loc3_.length)
               {
                  _loc4_.push(_loc3_[_loc5_]);
                  _loc5_++;
               }
               return getGotoNum(_loc4_);
            }
            return 1;
         }
         return getGotoNum(getTaskByNpc(param1));
      }
      
      private static function getGotoNum(param1:Array) : Number
      {
         var _loc2_:Task = null;
         if(param1.length != 0)
         {
            for each(_loc2_ in param1)
            {
               if(_loc2_.getState() == 3)
               {
                  return 2;
               }
            }
            for each(_loc2_ in param1)
            {
               if(_loc2_.getState() == 1)
               {
                  return 4;
               }
            }
            for each(_loc2_ in param1)
            {
               if(_loc2_.getState() == 2)
               {
                  return 3;
               }
            }
         }
         return 1;
      }
      
      public static function initTaskStateing() : void
      {
         var _loc1_:Task = null;
         taskIngList = [];
         taskState2List = [];
         for each(_loc1_ in taskArr)
         {
            if(_loc1_ != null)
            {
               if(_loc1_.getState() == 2 || _loc1_.getState() == 3)
               {
                  taskIngList.push(_loc1_);
               }
               if(_loc1_.getState() == 2)
               {
                  taskState2List.push(_loc1_);
               }
            }
         }
      }
      
      public static function isEnemyOk(param1:String) : void
      {
         var _loc2_:Task = null;
         for each(_loc2_ in taskState2List)
         {
            if(_loc2_.getGk() == "-1" || _loc2_.getGk() == String(FlowInterface.getLevelName()[2]))
            {
               if(_loc2_.getDiffault() == -1 || _loc2_.getDiffault() == Number(FlowInterface.getLevelName()[0]))
               {
                  if(_loc2_.getEnemyId()[0] is String)
                  {
                     _loc2_.addEnemy(param1);
                     _loc2_.isOk();
                  }
               }
            }
         }
      }
      
      public static function isGkOk(param1:String) : void
      {
         var _loc2_:Task = null;
         for each(_loc2_ in taskState2List)
         {
            if(_loc2_.getGk() == "-1" || _loc2_.getGk() == String(FlowInterface.getLevelName()[2]))
            {
               if(_loc2_.getDiffault() == -1 || _loc2_.getDiffault() == Number(FlowInterface.getLevelName()[0]))
               {
                  if(_loc2_.isTg() != "-1")
                  {
                     _loc2_.setTgNum(param1);
                     _loc2_.isOk();
                  }
               }
            }
         }
      }
      
      public static function isTaskOk() : void
      {
         var _loc1_:Task = null;
         for each(_loc1_ in taskState2List)
         {
            if(_loc1_.getGk() == "-1" || _loc1_.getGk() == String(FlowInterface.getLevelName()[2]))
            {
               if(_loc1_.getDiffault() == -1 || _loc1_.getDiffault() == Number(FlowInterface.getLevelName()[0]))
               {
                  _loc1_.isOk();
               }
            }
         }
      }
      
      public static function isXtOk(param1:Number) : void
      {
         var _loc2_:Task = null;
         for each(_loc2_ in taskState2List)
         {
            if(_loc2_.getFinishType() != -1)
            {
               _loc2_.isOk(param1);
            }
         }
      }
      
      public static function isGoodsNoOk() : void
      {
         var _loc1_:Task = null;
         for each(_loc1_ in taskIngList)
         {
            _loc1_.isDeleOk();
         }
      }
      
      public static function isGoodsOk(param1:Number = 0) : void
      {
         var _loc2_:Task = null;
         for each(_loc2_ in taskState2List)
         {
            if(_loc2_.getGk() == "-1" || _loc2_.getGk() == String(FlowInterface.getLevelName()[2]))
            {
               if(_loc2_.getDiffault() == -1 || _loc2_.getDiffault() == Number(FlowInterface.getLevelName()[0]))
               {
                  if(_loc2_.getGoodsId()[0] != -1)
                  {
                     _loc2_.addGoods(param1);
                     _loc2_.isOk();
                  }
               }
            }
         }
      }
      
      public static function getTaskByNpc(param1:Number) : Array
      {
         if(param1 == 0)
         {
            return getArrByTj(zdList);
         }
         if(param1 == 1)
         {
            return getArrByTj(npc1List);
         }
         if(param1 == 2)
         {
            return getArrByTj(npc2List);
         }
         if(param1 == 3)
         {
            return getArrByTj(npc3List);
         }
         if(param1 == 4)
         {
            return getArrByTj(npc4List);
         }
         if(param1 == 5)
         {
            return getArrByTj(npc5List);
         }
         return [];
      }
      
      private static function getArrByTj(param1:Array) : Array
      {
         var _loc3_:Task = null;
         var _loc2_:Array = [];
         for each(_loc3_ in param1)
         {
            if(_loc3_.isTjOk())
            {
               _loc2_.push(_loc3_);
            }
         }
         return _loc2_;
      }
      
      public static function taskTestOk(param1:Number) : void
      {
         var _loc2_:Task = null;
         for each(_loc2_ in taskArr)
         {
            if(_loc2_ != null)
            {
               if(_loc2_.getId() == param1)
               {
                  taskIngList.push(_loc2_);
                  taskState2List.push(_loc2_);
                  break;
               }
            }
         }
         for each(_loc2_ in taskState2List)
         {
            if(_loc2_.getId() == param1)
            {
               _loc2_.setState(3);
               break;
            }
         }
      }
      
      public static function isTaskIngById(param1:Number) : Boolean
      {
         var _loc2_:Task = null;
         if(taskState2List.length != 0)
         {
            for each(_loc2_ in taskState2List)
            {
               if(_loc2_.getId() == param1)
               {
                  return true;
               }
            }
         }
         return false;
      }
      
      public static function getFinishTimerById(param1:Number) : Number
      {
         var _loc2_:Task = null;
         for each(_loc2_ in taskArr)
         {
            if(_loc2_ != null)
            {
               if(_loc2_.getId() == param1)
               {
                  return _loc2_.getFinishNum();
               }
            }
         }
         return 0;
      }
   }
}

