package hotpointgame.repository.task
{
   import hotpointgame.common.*;
   import hotpointgame.models.task.*;
   
   public class TaskBasicData
   {
      
      private var _id:VT;
      
      private var _name:String;
      
      private var _introduction:String;
      
      private var _npc:VT;
      
      private var _bigType:VT;
      
      private var _smallType:VT;
      
      private var _jtTask:VT;
      
      private var _frame:VT;
      
      private var _frameIng:VT;
      
      private var _finishFrame:VT;
      
      private var _finishTime:VT;
      
      private var _isDelete:Boolean;
      
      private var _propesId:Array = [];
      
      private var _propesNum:Array = [];
      
      private var _propesGold:VT;
      
      private var _gkTj:String;
      
      private var _smgkTj:String;
      
      private var _level:VT;
      
      private var _beforeId:VT;
      
      private var _jzId:VT;
      
      private var _needGkId:String;
      
      private var _player:VT;
      
      private var _gk:String;
      
      private var _diffault:VT;
      
      private var _isTg:String;
      
      private var _enemyId:Array = [];
      
      private var _eneName:Array = [];
      
      private var _enemyNum:Array = [];
      
      private var _goodsId:Array = [];
      
      private var _goodsNum:Array = [];
      
      private var _finishType:VT;
      
      private var _needGold:VT;
      
      private var _rewardId:Array = [];
      
      private var _rewardNum:Array = [];
      
      private var _rewardGold:VT;
      
      private var _rewardExp:VT;
      
      private var _rewardGl:Array = [];
      
      private var tged:String = null;
      
      public function TaskBasicData()
      {
         super();
      }
      
      public static function createTaskData(param1:Number, param2:String, param3:String, param4:Number, param5:Number, param6:Number, param7:Number, param8:Number, param9:Number, param10:Number, param11:Number, param12:Boolean, param13:String, param14:String, param15:Number, param16:String, param17:String, param18:Number, param19:Number, param20:Number, param21:String, param22:Number, param23:String, param24:Number, param25:String, param26:String, param27:String, param28:String, param29:String, param30:String, param31:Number, param32:Number, param33:String, param34:String, param35:Number, param36:Number, param37:String) : TaskBasicData
      {
         var _loc38_:TaskBasicData = new TaskBasicData();
         _loc38_._id = VT.createVT(param1);
         _loc38_._name = param2;
         _loc38_._introduction = param3;
         _loc38_._npc = VT.createVT(param4);
         _loc38_._bigType = VT.createVT(param5);
         _loc38_._smallType = VT.createVT(param6);
         _loc38_._jtTask = VT.createVT(param7);
         _loc38_._frame = VT.createVT(param8);
         _loc38_._frameIng = VT.createVT(param9);
         _loc38_._finishFrame = VT.createVT(param10);
         _loc38_._finishTime = VT.createVT(param11);
         _loc38_._isDelete = param12;
         _loc38_._propesId = strToArr(param13);
         _loc38_._propesNum = strToArr(param14);
         _loc38_._propesGold = VT.createVT(param15);
         _loc38_._gkTj = param16;
         _loc38_._smgkTj = param17;
         _loc38_._level = VT.createVT(param18);
         _loc38_._beforeId = VT.createVT(param19);
         _loc38_._jzId = VT.createVT(param20);
         _loc38_._needGkId = param21;
         _loc38_._player = VT.createVT(param22);
         _loc38_._gk = param23;
         _loc38_._diffault = VT.createVT(param24);
         _loc38_._isTg = param25;
         _loc38_._enemyId = strToArr(param26);
         _loc38_._eneName = strToArr(param27);
         _loc38_._enemyNum = strToArr(param28);
         _loc38_._goodsId = strToArr(param29);
         _loc38_._goodsNum = strToArr(param30);
         _loc38_._finishType = VT.createVT(param31);
         _loc38_._needGold = VT.createVT(param32);
         _loc38_._rewardId = strToArr(param33);
         _loc38_._rewardNum = strToArr(param34);
         _loc38_._rewardGold = VT.createVT(param35);
         _loc38_._rewardExp = VT.createVT(param36);
         _loc38_._rewardGl = strToArr(param37);
         return _loc38_;
      }
      
      private static function strToArr(param1:String) : Array
      {
         var _loc2_:Array = param1.split("*");
         var _loc3_:Array = [];
         var _loc4_:uint = 0;
         while(_loc4_ < _loc2_.length)
         {
            if(Number(_loc2_[_loc4_]))
            {
               _loc3_.push(VT.createVT(Number(_loc2_[_loc4_])));
            }
            else
            {
               _loc3_.push(String(_loc2_[_loc4_]));
            }
            _loc4_++;
         }
         return _loc3_;
      }
      
      public function setTged(param1:String) : void
      {
         this.tged = param1;
      }
      
      public function getTged() : String
      {
         return this.tged;
      }
      
      public function clearGkData() : void
      {
         this.tged = null;
      }
      
      public function getId() : Number
      {
         return this._id.getValue();
      }
      
      public function getName() : String
      {
         return this._name;
      }
      
      public function getIntroduction() : String
      {
         return this._introduction;
      }
      
      public function getNpc() : Number
      {
         return this._npc.getValue();
      }
      
      public function getBigType() : Number
      {
         return this._bigType.getValue();
      }
      
      public function getSmallType() : Number
      {
         return this._smallType.getValue();
      }
      
      public function getJtTask() : Number
      {
         return this._jtTask.getValue();
      }
      
      public function getFrame() : Number
      {
         return this._frame.getValue();
      }
      
      public function getFrameIng() : Number
      {
         return this._frameIng.getValue();
      }
      
      public function getFinishFrame() : Number
      {
         return this._finishFrame.getValue();
      }
      
      public function getFinishTime() : Number
      {
         return this._finishTime.getValue();
      }
      
      public function isDelete() : Boolean
      {
         return this._isDelete;
      }
      
      public function getPropesId() : Array
      {
         var _loc1_:Array = [];
         var _loc2_:uint = 0;
         while(_loc2_ < this._propesId.length)
         {
            _loc1_.push(this._propesId[_loc2_].getValue());
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function getPropesNum() : Array
      {
         var _loc1_:Array = [];
         var _loc2_:uint = 0;
         while(_loc2_ < this._propesNum.length)
         {
            _loc1_.push(this._propesNum[_loc2_].getValue());
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function getPropesGold() : Number
      {
         return this._propesGold.getValue();
      }
      
      public function getGkTj() : String
      {
         return this._gkTj;
      }
      
      public function getSmGk() : String
      {
         return this._smgkTj;
      }
      
      public function getLevel() : Number
      {
         return this._level.getValue();
      }
      
      public function getBeforeId() : Number
      {
         return this._beforeId.getValue();
      }
      
      public function getJzId() : Number
      {
         return this._jzId.getValue();
      }
      
      public function getNeedGkId() : String
      {
         return this._needGkId;
      }
      
      public function getPlayer() : Number
      {
         return this._player.getValue();
      }
      
      public function getGk() : String
      {
         return this._gk;
      }
      
      public function getDiffault() : Number
      {
         return this._diffault.getValue();
      }
      
      public function isTg() : String
      {
         return this._isTg;
      }
      
      public function getEnemyId() : Array
      {
         return this._enemyId;
      }
      
      public function getEneName() : Array
      {
         return this._eneName;
      }
      
      public function getEnemyNum() : Array
      {
         return this._enemyNum;
      }
      
      public function getGoodsId() : Array
      {
         var _loc1_:Array = [];
         var _loc2_:uint = 0;
         while(_loc2_ < this._goodsId.length)
         {
            _loc1_.push(this._goodsId[_loc2_].getValue());
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function getGoodsNum() : Array
      {
         var _loc1_:Array = [];
         var _loc2_:uint = 0;
         while(_loc2_ < this._goodsNum.length)
         {
            _loc1_.push(this._goodsNum[_loc2_].getValue());
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function getFinishType() : Number
      {
         return this._finishType.getValue();
      }
      
      public function getNeedGold() : Number
      {
         return this._needGold.getValue();
      }
      
      public function getRewardId() : Array
      {
         var _loc1_:Array = [];
         var _loc2_:uint = 0;
         while(_loc2_ < this._rewardId.length)
         {
            _loc1_.push(this._rewardId[_loc2_].getValue());
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function getRewardGl() : Array
      {
         var _loc1_:Array = [];
         var _loc2_:uint = 0;
         while(_loc2_ < this._rewardGl.length)
         {
            _loc1_.push(this._rewardGl[_loc2_].getValue());
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function getReardNum() : Array
      {
         var _loc1_:Array = [];
         var _loc2_:uint = 0;
         while(_loc2_ < this._rewardNum.length)
         {
            _loc1_.push(this._rewardNum[_loc2_].getValue());
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function getRewardExp() : Number
      {
         return this._rewardExp.getValue();
      }
      
      public function getRewardGold() : Number
      {
         return this._rewardGold.getValue();
      }
      
      public function createTask() : Task
      {
         var _loc2_:Number = NaN;
         var _loc4_:uint = 0;
         var _loc1_:Object = new Object();
         var _loc3_:Array = [];
         if(this._bigType.getValue() == -1)
         {
            if(this._enemyId[0] is String)
            {
               _loc2_ = Number(this._enemyId.length);
               _loc4_ = 0;
               while(_loc4_ < _loc2_)
               {
                  _loc3_.push(VT.createVT(0));
                  _loc4_++;
               }
               _loc1_ = {"ea":_loc3_};
            }
         }
         else if(this._enemyId[0] is VT)
         {
            _loc1_ = {"ot":VT.createVT(0)};
         }
         else
         {
            _loc2_ = Number(this._enemyId.length);
            _loc4_ = 0;
            while(_loc4_ < _loc2_)
            {
               _loc3_.push(VT.createVT(0));
               _loc4_++;
            }
            _loc1_ = {
               "ot":VT.createVT(0),
               "ea":_loc3_
            };
         }
         return Task.createTask(this._id.getValue(),_loc1_);
      }
   }
}

