package hotpointgame.glevel
{
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   
   public class CScene
   {
      
      private var id:Number = 0;
      
      private var _name:String = "大道";
      
      private var _mcclass:String = "map_1_1";
      
      private var _sceSpeed:Array;
      
      private var _touPx:Number = 700;
      
      private var _touPy:Number = 100;
      
      private var _swfList:Array;
      
      private var doorList:Array;
      
      private var roomObj:Object;
      
      private var waitDoor:Vector.<SendDoor>;
      
      private var effectDoor:Vector.<SendDoor>;
      
      private var lstar:int = 0;
      
      public function CScene(param1:Object)
      {
         var _loc3_:String = null;
         var _loc4_:String = null;
         this._sceSpeed = [0.5,1,0.7,1];
         this._swfList = new Array();
         this.doorList = new Array();
         this.roomObj = new Object();
         this.waitDoor = new Vector.<SendDoor>();
         this.effectDoor = new Vector.<SendDoor>();
         super();
         this.id = param1.id;
         this._name = param1._name;
         this._swfList = param1.swfList;
         this.mcclass = param1.mcclass;
         this._touPx = param1._touPx;
         this._touPy = param1._touPy;
         this.lstar = (param1.lstar as VT).getValue();
         var _loc2_:Array = param1.roomObj;
         for each(_loc3_ in _loc2_)
         {
            this.roomObj[_loc3_] = LevelDataManager.getCroom(_loc3_ + this.lstar);
         }
         this._sceSpeed = param1._sceSpeed;
         this.doorList = param1.doorList;
         for each(_loc4_ in this.doorList)
         {
            this.waitDoor.push(LevelDataManager.getSeedDoor(_loc4_));
         }
      }
      
      public function gmUpdate(param1:CLevel) : void
      {
         var _loc7_:SendDoor = null;
         var _loc8_:Object = null;
         var _loc2_:Boolean = false;
         var _loc3_:Number = Number(GM.cp.getZx());
         var _loc4_:Number = Number(GM.cp.getZy());
         var _loc5_:int = int(this.effectDoor.length);
         var _loc6_:* = int(_loc5_ - 1);
         while(_loc6_ >= 0)
         {
            _loc7_ = this.effectDoor[_loc6_];
            _loc8_ = _loc7_.useDoor(_loc3_,_loc4_,_loc2_);
            if(_loc7_.useTimesCur <= 0)
            {
               this.effectDoor.splice(_loc6_,1);
               param1.getvs().removeDoorMcByn(_loc7_.name);
            }
            if(_loc8_ != null)
            {
               if(param1.name != _loc8_.gqm)
               {
                  return;
               }
               if(this.name != _loc8_.cjm)
               {
                  param1.changeSceneData(_loc8_);
                  return;
               }
               if(param1.curroom.name != _loc8_.fjm)
               {
                  param1.changeRoomDataBySend(_loc8_);
                  return;
               }
               param1.inRoomSend(_loc8_);
               return;
            }
            _loc6_--;
         }
      }
      
      public function updateDoorEnterScene(param1:CLevel) : void
      {
         var _loc2_:int = int(this.waitDoor.length);
         var _loc3_:* = int(_loc2_ - 1);
         while(_loc3_ >= 0)
         {
            if(this.waitDoor[_loc3_].isChuXian(param1))
            {
               param1.getvs().addDoorMc(this.waitDoor[_loc3_].getDoorMc());
               this.effectDoor.push(this.waitDoor[_loc3_]);
               this.waitDoor.splice(_loc3_,1);
            }
            _loc3_--;
         }
      }
      
      public function addDoorEnterScene(param1:CLevel) : void
      {
         var _loc2_:SendDoor = null;
         for each(_loc2_ in this.effectDoor)
         {
            param1.getvs().addDoorMc(_loc2_.getDoorMc());
         }
      }
      
      public function getRoom(param1:String) : CRoom
      {
         return this.roomObj[param1] as CRoom;
      }
      
      public function exitLevelClear() : void
      {
         var _loc1_:CRoom = null;
         this._swfList = null;
         this.doorList = null;
         this.waitDoor.length = 0;
         this.effectDoor.length = 0;
         for each(_loc1_ in this.roomObj)
         {
            _loc1_.exitLevelClear();
         }
         this.roomObj = null;
      }
      
      public function exitCscene() : void
      {
      }
      
      public function enterScene(param1:CLevel) : void
      {
         this.addDoorEnterScene(param1);
         this.updateDoorEnterScene(param1);
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      public function set name(param1:String) : void
      {
         this._name = param1;
      }
      
      public function get touPx() : Number
      {
         return this._touPx;
      }
      
      public function set touPx(param1:Number) : void
      {
         this._touPx = param1;
      }
      
      public function get touPy() : Number
      {
         return this._touPy;
      }
      
      public function set touPy(param1:Number) : void
      {
         this._touPy = param1;
      }
      
      public function get sceSpeed() : Array
      {
         return this._sceSpeed;
      }
      
      public function set sceSpeed(param1:Array) : void
      {
         this._sceSpeed = param1;
      }
      
      public function get mcclass() : String
      {
         return this._mcclass;
      }
      
      public function set mcclass(param1:String) : void
      {
         this._mcclass = param1;
      }
      
      public function get swfList() : Array
      {
         return this._swfList;
      }
      
      public function set swfList(param1:Array) : void
      {
         this._swfList = param1;
      }
      
      public function addSwfPk(param1:Array) : void
      {
         var _loc2_:String = null;
         for each(_loc2_ in param1)
         {
            if(this.swfList.indexOf(_loc2_) == -1)
            {
               this.swfList.push(_loc2_);
            }
         }
      }
   }
}

