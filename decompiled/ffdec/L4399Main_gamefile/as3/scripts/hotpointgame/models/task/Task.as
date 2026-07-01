package hotpointgame.models.task
{
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   import hotpointgame.models.bag.*;
   import hotpointgame.repository.goods.*;
   import hotpointgame.repository.task.*;
   import hotpointgame.views.taskPanel.*;
   
   public class Task
   {
      
      private var _id:VT;
      
      private var _state:VT = VT.createVT(0);
      
      private var _obj:Object = new Object();
      
      private var _finishNum:VT = VT.createVT(0);
      
      public function Task()
      {
         super();
      }
      
      public static function readTask(param1:Object) : Task
      {
         var _loc4_:String = null;
         var _loc5_:Array = null;
         var _loc6_:Array = null;
         var _loc7_:uint = 0;
         var _loc2_:Task = new Task();
         _loc2_._id = VT.createVT(param1["id"]);
         _loc2_._state = VT.createVT(param1["sa"]);
         _loc2_._finishNum = VT.createVT(param1["ft"]);
         var _loc3_:Object = param1["ob"];
         for(_loc4_ in _loc3_)
         {
            if(_loc4_ == "ea")
            {
               _loc5_ = (_loc3_[_loc4_] as Array).slice();
               _loc6_ = [];
               _loc7_ = 0;
               while(_loc7_ < _loc5_.length)
               {
                  _loc6_.push(VT.createVT(_loc5_[_loc7_]));
                  _loc7_++;
               }
               _loc2_._obj[_loc4_] = _loc6_.slice();
            }
            else
            {
               _loc2_._obj[_loc4_] = VT.createVT(_loc3_[_loc4_]);
            }
         }
         return _loc2_;
      }
      
      public static function createTask(param1:Number, param2:Object) : Task
      {
         var _loc3_:Task = new Task();
         _loc3_._id = VT.createVT(param1);
         _loc3_._obj = param2;
         _loc3_._finishNum = VT.createVT(0);
         _loc3_.initState();
         return _loc3_;
      }
      
      public function saveTask() : Object
      {
         var _loc3_:String = null;
         var _loc4_:Array = null;
         var _loc5_:Array = null;
         var _loc6_:uint = 0;
         var _loc1_:Object = new Object();
         _loc1_["id"] = this._id.getValue();
         _loc1_["sa"] = this._state.getValue();
         _loc1_["ft"] = this._finishNum.getValue();
         var _loc2_:Object = new Object();
         for(_loc3_ in this._obj)
         {
            if(_loc3_ == "ea")
            {
               _loc4_ = [];
               _loc5_ = this._obj[_loc3_];
               _loc6_ = 0;
               while(_loc6_ < _loc5_.length)
               {
                  _loc4_.push(_loc5_[_loc6_].getValue());
                  _loc6_++;
               }
               _loc2_[_loc3_] = _loc4_.slice();
            }
            else
            {
               _loc2_[_loc3_] = (this._obj[_loc3_] as VT).getValue();
            }
         }
         _loc1_["ob"] = _loc2_;
         return _loc1_;
      }
      
      public function setFt() : void
      {
         this._finishNum.setValue(GS.a1);
      }
      
      public function initState() : void
      {
         if(this.getJzId() == -1)
         {
            this._state.setValue(1);
         }
         else
         {
            this._state.setValue(0);
         }
      }
      
      public function getState() : Number
      {
         return this._state.getValue();
      }
      
      public function setState(param1:Number) : void
      {
         this._state.setValue(param1);
      }
      
      public function getId() : Number
      {
         return this._id.getValue();
      }
      
      public function getFinishNum() : Number
      {
         return this._finishNum.getValue();
      }
      
      public function addFinishNum() : void
      {
         this._finishNum.setValue(this._finishNum.getValue() + GS.a1);
      }
      
      public function deleteTaskData() : void
      {
         var _loc2_:uint = 0;
         var _loc1_:Array = this.getEnemyId();
         if(_loc1_[0] is String)
         {
            (this._obj.ea as Array).length = 0;
            _loc2_ = 0;
            while(_loc2_ < _loc1_.length)
            {
               (this._obj.ea as Array).push(VT.createVT(0));
               _loc2_++;
            }
         }
         this.createTgData();
      }
      
      public function addFinishTime(param1:Number) : void
      {
         if(this.getBigType() == -1)
         {
            if(this.getSmallType() == 1)
            {
               (this._obj.ot as VT).setValue(param1);
            }
         }
         else
         {
            (this._obj.ot as VT).setValue(param1);
         }
      }
      
      public function addEnemy(param1:String) : void
      {
         var _loc4_:Array = null;
         var _loc5_:uint = 0;
         var _loc2_:Array = this.getEnemyId();
         var _loc3_:Array = this.getEnemyNum();
         if(_loc2_[0] is String && this.getState() == 2)
         {
            _loc4_ = this._obj.ea;
            _loc5_ = 0;
            while(_loc5_ < _loc2_.length)
            {
               if(_loc2_[_loc5_] == param1)
               {
                  if(_loc4_[_loc5_].getValue() < _loc3_[_loc5_].getValue())
                  {
                     _loc4_[_loc5_].setValue(_loc4_[_loc5_].getValue() + GS.a1);
                     GoodsManger.taskTs(this,2);
                     break;
                  }
               }
               _loc5_++;
            }
         }
      }
      
      public function addGoods(param1:Number) : void
      {
         var _loc4_:uint = 0;
         var _loc2_:Array = this.getGoodsId();
         var _loc3_:Array = this.getGoodsNum();
         if(_loc2_[0] != -1 && this.getState() == 2)
         {
            _loc4_ = 0;
            while(_loc4_ < _loc2_.length)
            {
               if(param1 == _loc2_[_loc4_])
               {
                  if(this.getState() != 3 && this.getState() != 4)
                  {
                     GoodsManger.taskTs(this,2);
                     break;
                  }
               }
               _loc4_++;
            }
         }
      }
      
      public function setTgNum(param1:String) : void
      {
         if(this.isTg() != "-1")
         {
            this.getTaskData().setTged(param1);
         }
      }
      
      public function createTgData() : void
      {
         if(this.isTg() != "-1" && this.getTaskData().getTged() != null)
         {
            this.getTaskData().clearGkData();
         }
      }
      
      public function setJzState(param1:Number) : Boolean
      {
         if(this.getJzId() != -1)
         {
            if(this.getState() != 2 || this.getState() != 3)
            {
               if(param1 == this.getJzId())
               {
                  this.setState(1);
                  return true;
               }
            }
         }
         return false;
      }
      
      public function updateTask() : void
      {
         if(this.getSmallType() == 1)
         {
            if(GM.getCurrentTime() > this._obj.ot.getValue())
            {
               if(this.getState() != 0)
               {
                  this.setState(1);
               }
            }
         }
      }
      
      public function isGkTjOk() : Boolean
      {
         if(this.getGkTj() == "-1")
         {
            return true;
         }
         if(this.getGkTj() == FlowInterface.getLevelName()[2])
         {
            return true;
         }
         return false;
      }
      
      public function isSmGkTjOk() : Boolean
      {
         if(this.getSmGkTj() == "-1")
         {
            return true;
         }
         if(this.getSmGkTj() == FlowInterface.getLevelName()[1])
         {
            return true;
         }
         return false;
      }
      
      public function isLevelOk() : Boolean
      {
         if(this.getLevel() == -1)
         {
            return true;
         }
         if(this.getLevel() <= FlowInterface.getLevelByRole())
         {
            return true;
         }
         return false;
      }
      
      public function isBeforeOk() : Boolean
      {
         if(this.getBeforeId() == -1)
         {
            return true;
         }
         if(TaskData.getFinishTimerById(this.getBeforeId()) > 0)
         {
            return true;
         }
         return false;
      }
      
      public function isJzOk() : Boolean
      {
         if(this.getJzId() == -1)
         {
            return true;
         }
         if(this.getState() == 1)
         {
            return true;
         }
         return false;
      }
      
      public function isNeedGkOk() : Boolean
      {
         if(this.getNeedGkId() == "-1")
         {
            return true;
         }
         return FlowInterface.isOverLevel(this.getNeedGkId());
      }
      
      public function isStateOk() : Boolean
      {
         if(this.getNpc() != 0)
         {
            if(this._state.getValue() != 0 && this._state.getValue() != 4)
            {
               return true;
            }
         }
         else if(this._state.getValue() == 1)
         {
            return true;
         }
         return false;
      }
      
      public function isPlayerOk() : Boolean
      {
         if(this.getPlayer() == -1)
         {
            return true;
         }
         if(this.getPlayer() == FlowInterface.getJobByRole())
         {
            return true;
         }
         return false;
      }
      
      public function isTjOk() : Boolean
      {
         this.updateTask();
         if(this.isStateOk() && this.isGkTjOk() && this.isSmGkTjOk() && this.isNeedGkOk() && this.isJzOk() && this.isBeforeOk() && this.isLevelOk() && this.isPlayerOk())
         {
            return true;
         }
         return false;
      }
      
      private function isGkOk() : Boolean
      {
         if(this.getGk() == "-1")
         {
            return true;
         }
         if(this.getGk() == FlowInterface.getLevelName()[2])
         {
            return true;
         }
         return false;
      }
      
      private function isDiffaultOk() : Boolean
      {
         if(this.getDiffault() == -1)
         {
            return true;
         }
         if(this.getDiffault() == FlowInterface.getLevelName()[0])
         {
            return true;
         }
         return false;
      }
      
      private function isTgOk() : Boolean
      {
         if(this.isTg() == "-1")
         {
            return true;
         }
         if(this.isTg() == this.getTaskData().getTged())
         {
            return true;
         }
         return false;
      }
      
      private function isEnemyOk() : Boolean
      {
         var _loc3_:Array = null;
         var _loc4_:uint = 0;
         var _loc1_:Array = this.getEnemyId();
         var _loc2_:Array = this.getEnemyNum();
         if(_loc1_[0] is VT)
         {
            return true;
         }
         _loc3_ = this._obj.ea;
         _loc4_ = 0;
         while(_loc4_ < _loc1_.length)
         {
            if(_loc2_[_loc4_].getValue() != _loc3_[_loc4_].getValue())
            {
               return false;
            }
            _loc4_++;
         }
         return true;
      }
      
      private function isGoodsOk() : Boolean
      {
         var _loc3_:uint = 0;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc1_:Array = this.getGoodsId();
         var _loc2_:Array = this.getGoodsNum();
         if(_loc1_[0] == -1)
         {
            return true;
         }
         _loc3_ = 0;
         while(_loc3_ < _loc1_.length)
         {
            _loc4_ = Number(_loc1_[_loc3_]);
            _loc5_ = Number(_loc2_[_loc3_]);
            _loc6_ = Number(GoodsFactory.getBagNum(_loc4_));
            if(_loc6_ == 0)
            {
               if(BagFactory.equipBag.getGoodsNumById(_loc4_) < _loc5_)
               {
                  return false;
               }
            }
            else if(_loc6_ == 1)
            {
               if(BagFactory.gemBag.getGoodsNumById(_loc4_) < _loc5_)
               {
                  return false;
               }
            }
            if(_loc6_ == 2)
            {
               if(BagFactory.otherBag.getGoodsNumById(_loc4_) < _loc5_)
               {
                  return false;
               }
            }
            if(_loc6_ == 3)
            {
               if(BagFactory.clothesBag.getGoodsNumById(_loc4_) < _loc5_)
               {
                  return false;
               }
            }
            _loc3_++;
         }
         return true;
      }
      
      private function isGoldOk() : Boolean
      {
         if(this.getNeedGold() == -1)
         {
            return true;
         }
         return true;
      }
      
      public function isDeleOk() : void
      {
         if(this.getState() == GS.a3)
         {
            if(this.getGoodsId()[0] != -1)
            {
               if(this.isGoodsOk() == false)
               {
                  this.setState(GS.a2);
               }
            }
         }
      }
      
      public function isOk(param1:Number = -1) : void
      {
         if(this.getState() == 2)
         {
            if(this.getFinishType() == -1)
            {
               if(Boolean(this.isGkOk()) && Boolean(this.isDiffaultOk()) && Boolean(this.isGoldOk()) && Boolean(this.isGoodsOk()) && Boolean(this.isEnemyOk()) && Boolean(this.isTgOk()))
               {
                  if(this.getNpc() == 0 && this.getFinishFrame() == -1)
                  {
                     NpcTaskPanel.addRew(this);
                     this.deleteTaskData();
                     NpcTaskPanel.open(0);
                     return;
                  }
                  this.setState(3);
                  TaskData.initTaskStateing();
                  GoodsManger.taskTs(this,1);
               }
               else
               {
                  this.createTgData();
               }
            }
            else if(this.getFinishType() == param1)
            {
               this.setState(3);
               GoodsManger.taskTs(this,1);
            }
         }
      }
      
      public function getName() : String
      {
         return this.getTaskData().getName();
      }
      
      public function getIntroduction() : String
      {
         return this.getTaskData().getIntroduction();
      }
      
      public function getNpc() : Number
      {
         return this.getTaskData().getNpc();
      }
      
      public function getBigType() : Number
      {
         return this.getTaskData().getBigType();
      }
      
      public function getSmallType() : Number
      {
         return this.getTaskData().getSmallType();
      }
      
      public function getFrame() : Number
      {
         return this.getTaskData().getFrame();
      }
      
      public function getFrameIng() : Number
      {
         return this.getTaskData().getFrameIng();
      }
      
      public function getFinishFrame() : Number
      {
         return this.getTaskData().getFinishFrame();
      }
      
      public function getFinishTime() : Number
      {
         return this.getTaskData().getFinishTime();
      }
      
      public function isDelete() : Boolean
      {
         return this.getTaskData().isDelete();
      }
      
      public function getPropesId() : Array
      {
         return this.getTaskData().getPropesId();
      }
      
      public function getPropesNum() : Array
      {
         return this.getTaskData().getPropesNum();
      }
      
      public function getPropesGold() : Number
      {
         return this.getTaskData().getPropesGold();
      }
      
      public function getGkTj() : String
      {
         return this.getTaskData().getGkTj();
      }
      
      public function getSmGkTj() : String
      {
         return this.getTaskData().getSmGk();
      }
      
      public function getLevel() : Number
      {
         return this.getTaskData().getLevel();
      }
      
      public function getBeforeId() : Number
      {
         return this.getTaskData().getBeforeId();
      }
      
      public function getJzId() : Number
      {
         return this.getTaskData().getJzId();
      }
      
      public function getNeedGkId() : String
      {
         return this.getTaskData().getNeedGkId();
      }
      
      public function getGk() : String
      {
         return this.getTaskData().getGk();
      }
      
      public function getDiffault() : Number
      {
         return this.getTaskData().getDiffault();
      }
      
      public function isTg() : String
      {
         return this.getTaskData().isTg();
      }
      
      public function getEnemyId() : Array
      {
         return this.getTaskData().getEnemyId();
      }
      
      public function getEneName() : Array
      {
         return this.getTaskData().getEneName();
      }
      
      public function getEnemyNum() : Array
      {
         return this.getTaskData().getEnemyNum();
      }
      
      public function getGoodsId() : Array
      {
         return this.getTaskData().getGoodsId();
      }
      
      public function getGoodsNum() : Array
      {
         return this.getTaskData().getGoodsNum();
      }
      
      public function getFinishType() : Number
      {
         return this.getTaskData().getFinishType();
      }
      
      public function getNeedGold() : Number
      {
         return this.getTaskData().getNeedGold();
      }
      
      public function getRewardId() : Array
      {
         return this.getTaskData().getRewardId();
      }
      
      public function getReardNum() : Array
      {
         return this.getTaskData().getReardNum();
      }
      
      public function getReardGl() : Array
      {
         return this.getTaskData().getRewardGl();
      }
      
      public function getRewardExp() : Number
      {
         return this.getTaskData().getRewardExp();
      }
      
      public function getRewardGold() : Number
      {
         return this.getTaskData().getRewardGold();
      }
      
      public function getTaskData() : TaskBasicData
      {
         return TaskFactory.getDataById(this._id.getValue());
      }
      
      public function getPlayer() : Number
      {
         return this.getTaskData().getPlayer();
      }
      
      public function compareById(param1:Number) : Boolean
      {
         if(this._id.getValue() == param1)
         {
            return true;
         }
         return false;
      }
      
      public function getTaskMbStr() : Array
      {
         var _loc8_:Array = null;
         var _loc9_:uint = 0;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc1_:Array = this.getEnemyId();
         var _loc2_:Array = this.getEnemyNum();
         var _loc3_:Array = this.getEneName();
         if(_loc1_[0] is String)
         {
            _loc8_ = this._obj.ea;
         }
         var _loc4_:Array = this.getGoodsId();
         var _loc5_:Array = this.getGoodsNum();
         var _loc6_:Array = [];
         if(_loc4_[0] != -1)
         {
            _loc9_ = 0;
            while(_loc9_ < _loc4_.length)
            {
               _loc10_ = Number(_loc4_[_loc9_]);
               _loc11_ = Number(_loc5_[_loc9_]);
               _loc12_ = Number(GoodsFactory.getBagNum(_loc10_));
               if(_loc12_ == 0)
               {
                  _loc6_.push(BagFactory.equipBag.getGoodsNumById(_loc10_));
               }
               else if(_loc12_ == 1)
               {
                  _loc6_.push(BagFactory.gemBag.getGoodsNumById(_loc10_));
               }
               if(_loc12_ == 2)
               {
                  _loc6_.push(BagFactory.otherBag.getGoodsNumById(_loc10_));
               }
               if(_loc12_ == 3)
               {
                  _loc6_.push(BagFactory.clothesBag.getGoodsNumById(_loc10_));
               }
               _loc9_++;
            }
         }
         var _loc7_:Array = [];
         if(_loc1_[0] is String)
         {
            _loc9_ = 0;
            while(_loc9_ < _loc1_.length)
            {
               _loc7_.push(_loc3_[_loc9_] + ":" + _loc8_[_loc9_].getValue() + "/" + _loc2_[_loc9_].getValue());
               _loc9_++;
            }
         }
         if(_loc4_[0] != -1)
         {
            _loc9_ = 0;
            while(_loc9_ < _loc4_.length)
            {
               _loc7_.push(GoodsFactory.getGoodsById(_loc4_[_loc9_]).getName() + ":" + _loc6_[_loc9_] + "/" + _loc5_[_loc9_]);
               _loc9_++;
            }
         }
         return _loc7_;
      }
      
      public function getJtTask() : Number
      {
         return this.getTaskData().getJtTask();
      }
      
      public function get id() : VT
      {
         return this._id;
      }
      
      public function set id(param1:VT) : void
      {
         this._id = param1;
      }
      
      public function get state() : VT
      {
         return this._state;
      }
      
      public function set state(param1:VT) : void
      {
         this._state = param1;
      }
      
      public function get obj() : Object
      {
         return this._obj;
      }
      
      public function set obj(param1:Object) : void
      {
         this._obj = param1;
      }
      
      public function get finishNum() : VT
      {
         return this._finishNum;
      }
      
      public function set finishNum(param1:VT) : void
      {
         this._finishNum = param1;
      }
   }
}

