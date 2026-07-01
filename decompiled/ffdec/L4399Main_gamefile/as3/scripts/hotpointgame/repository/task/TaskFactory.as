package hotpointgame.repository.task
{
   import hotpointgame.models.task.Task;
   
   public class TaskFactory
   {
      
      private static var taskDataList:Array = [];
      
      public static var taskList:Array = [];
      
      public static var talkArr:Array = [];
      
      public function TaskFactory()
      {
         super();
      }
      
      public static function creatSayFactory(param1:XML) : void
      {
         var _loc5_:XML = null;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:String = null;
         var _loc9_:String = null;
         var _loc10_:String = null;
         var _loc11_:String = null;
         var _loc12_:String = null;
         var _loc13_:String = null;
         var _loc14_:NpcTalkData = null;
         var _loc2_:String = param1.toXMLString();
         var _loc3_:RegExp = /&lt;/g;
         var _loc4_:RegExp = /&gt;/g;
         _loc2_ = _loc2_.replace(_loc3_,"<");
         _loc2_ = _loc2_.replace(_loc4_,">");
         param1 = new XML(_loc2_);
         for each(_loc5_ in param1.对话)
         {
            _loc6_ = Number(_loc5_.id);
            _loc7_ = Number(_loc5_.任务id);
            _loc8_ = String(_loc5_.接任务NPC头像);
            _loc9_ = String(_loc5_.接任务对话);
            _loc10_ = String(_loc5_.任务中NPC头像);
            _loc11_ = String(_loc5_.任务中对话);
            _loc12_ = String(_loc5_.任务结束NPC头像);
            _loc13_ = String(_loc5_.任务结束对话);
            _loc14_ = NpcTalkData.createNpcTalk(_loc6_,_loc7_,_loc8_,_loc9_,_loc10_,_loc11_,_loc12_,_loc13_);
            talkArr.push(_loc14_);
         }
      }
      
      public static function getSayByTaskId(param1:Number) : NpcTalkData
      {
         var _loc2_:NpcTalkData = null;
         for each(_loc2_ in talkArr)
         {
            if(_loc2_.getTaskId() == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public static function getTalkFrameByTaskIdAndType(param1:Number, param2:Number) : Array
      {
         var _loc3_:NpcTalkData = getSayByTaskId(param1);
         if(param2 == 1)
         {
            return [_loc3_.getNpca(),_loc3_.getTalka()];
         }
         if(param2 == 2)
         {
            return [_loc3_.getNpcb(),_loc3_.getTalkb()];
         }
         if(param2 == 3)
         {
            return [_loc3_.getNpcc(),_loc3_.getTalkc()];
         }
         return [];
      }
      
      public static function creatTaskFactory(param1:XML) : void
      {
         var _loc5_:XML = null;
         var _loc6_:Number = NaN;
         var _loc7_:String = null;
         var _loc8_:String = null;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc16_:Number = NaN;
         var _loc17_:Boolean = false;
         var _loc18_:* = undefined;
         var _loc19_:* = undefined;
         var _loc20_:* = undefined;
         var _loc21_:String = null;
         var _loc22_:String = null;
         var _loc23_:Number = NaN;
         var _loc24_:Number = NaN;
         var _loc25_:Number = NaN;
         var _loc26_:String = null;
         var _loc27_:Number = NaN;
         var _loc28_:String = null;
         var _loc29_:Number = NaN;
         var _loc30_:String = null;
         var _loc31_:String = null;
         var _loc32_:String = null;
         var _loc33_:String = null;
         var _loc34_:String = null;
         var _loc35_:String = null;
         var _loc36_:Number = NaN;
         var _loc37_:Number = NaN;
         var _loc38_:String = null;
         var _loc39_:String = null;
         var _loc40_:Number = NaN;
         var _loc41_:Number = NaN;
         var _loc42_:String = null;
         var _loc43_:TaskBasicData = null;
         var _loc2_:String = param1.toXMLString();
         var _loc3_:RegExp = /&lt;/g;
         var _loc4_:RegExp = /&gt;/g;
         _loc2_ = _loc2_.replace(_loc3_,"<");
         _loc2_ = _loc2_.replace(_loc4_,">");
         param1 = new XML(_loc2_);
         for each(_loc5_ in param1.任务)
         {
            _loc6_ = Number(_loc5_.id);
            _loc7_ = String(_loc5_.名称);
            _loc8_ = String(_loc5_.介绍);
            _loc9_ = Number(_loc5_.npc);
            _loc10_ = Number(_loc5_.阶段);
            _loc11_ = Number(_loc5_.类型);
            _loc12_ = Number(_loc5_.军团);
            _loc13_ = Number(_loc5_.接受帧);
            _loc14_ = Number(_loc5_.进行帧);
            _loc15_ = Number(_loc5_.完成帧);
            _loc16_ = Number(_loc5_.完成时间);
            _loc17_ = (_loc5_.删除.toString() == "true") as Boolean;
            _loc18_ = String(_loc5_.道具.道具id);
            _loc19_ = String(_loc5_.道具.道具数量);
            _loc20_ = Number(_loc5_.道具.道具金币);
            _loc21_ = String(_loc5_.出现.关卡条件);
            _loc22_ = String(_loc5_.出现.小关卡条件);
            _loc23_ = Number(_loc5_.出现.等级);
            _loc24_ = Number(_loc5_.出现.前置id);
            _loc25_ = Number(_loc5_.出现.卷轴id);
            _loc26_ = String(_loc5_.出现.关卡ok);
            _loc27_ = Number(_loc5_.出现.角色);
            _loc28_ = String(_loc5_.完成.关卡要求);
            _loc29_ = Number(_loc5_.完成.难度要求);
            _loc30_ = String(_loc5_.完成.通关关卡);
            _loc31_ = String(_loc5_.完成.怪物id);
            _loc32_ = String(_loc5_.完成.怪物名);
            _loc33_ = String(_loc5_.完成.怪物数量);
            _loc34_ = String(_loc5_.完成.物品id);
            _loc35_ = String(_loc5_.完成.物品数量);
            _loc36_ = Number(_loc5_.完成.系统类型);
            _loc37_ = Number(_loc5_.完成.完成金币);
            _loc38_ = String(_loc5_.奖励.奖励id);
            _loc39_ = String(_loc5_.奖励.奖励数量);
            _loc40_ = Number(_loc5_.奖励.奖励金币);
            _loc41_ = Number(_loc5_.奖励.奖励经验);
            _loc42_ = String(_loc5_.奖励.奖励概率);
            _loc43_ = TaskBasicData.createTaskData(_loc6_,_loc7_,_loc8_,_loc9_,_loc10_,_loc11_,_loc12_,_loc13_,_loc14_,_loc15_,_loc16_,_loc17_,_loc18_,_loc19_,_loc20_,_loc21_,_loc22_,_loc23_,_loc24_,_loc25_,_loc26_,_loc27_,_loc28_,_loc29_,_loc30_,_loc31_,_loc32_,_loc33_,_loc34_,_loc35_,_loc36_,_loc37_,_loc38_,_loc39_,_loc40_,_loc41_,_loc42_);
            taskDataList[_loc6_] = _loc43_;
            taskList[_loc6_] = _loc43_.createTask();
         }
      }
      
      public static function getDataById(param1:Number) : TaskBasicData
      {
         if(taskDataList[param1] != null)
         {
            return taskDataList[param1];
         }
         throw new Error("不存在此任务ID" + param1);
      }
      
      public static function getTaskById(param1:Number) : Task
      {
         if(taskList[param1] != null)
         {
            return taskList[param1];
         }
         throw new Error("不存在此任务ID" + param1);
      }
   }
}

