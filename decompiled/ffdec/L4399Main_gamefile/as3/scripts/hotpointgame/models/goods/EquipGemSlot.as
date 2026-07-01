package hotpointgame.models.goods
{
   import hotpointgame.common.*;
   
   public class EquipGemSlot
   {
      
      private var _slotNum:VT;
      
      private var _slotStateArr:Array = [];
      
      private var _slotArr:Array = [];
      
      public function EquipGemSlot()
      {
         super();
      }
      
      public static function readData(param1:Object) : EquipGemSlot
      {
         var _loc4_:* = undefined;
         var _loc2_:EquipGemSlot = new EquipGemSlot();
         _loc2_.slotNum = VT.createVT(param1["sn"]);
         _loc2_.slotStateArr = (param1["ss"] as Array).slice();
         var _loc3_:Array = param1["sa"] as Array;
         for each(_loc4_ in _loc3_)
         {
            if(_loc4_ != "null")
            {
               _loc2_._slotArr.push(Goods.readData(_loc4_));
            }
            else
            {
               _loc2_._slotArr.push(null);
            }
         }
         return _loc2_;
      }
      
      public static function createSlot(param1:Number) : EquipGemSlot
      {
         var _loc2_:EquipGemSlot = null;
         if(param1 != -1)
         {
            _loc2_ = new EquipGemSlot();
            _loc2_._slotNum = VT.createVT(param1);
            _loc2_.initSlotState();
            _loc2_.initSlot();
            return _loc2_;
         }
         return null;
      }
      
      public function save() : Object
      {
         var _loc3_:* = undefined;
         var _loc1_:Object = new Object();
         _loc1_["sn"] = this.getSlotNum();
         _loc1_["ss"] = this._slotStateArr.slice();
         var _loc2_:Array = new Array();
         for each(_loc3_ in this._slotArr)
         {
            if(_loc3_ != null)
            {
               _loc2_.push((_loc3_ as Goods).save());
            }
            else
            {
               _loc2_.push("null");
            }
         }
         _loc1_["sa"] = _loc2_;
         return _loc1_;
      }
      
      private function initSlotState() : void
      {
         var _loc1_:uint = 0;
         while(_loc1_ < this._slotNum.getValue())
         {
            this._slotStateArr[_loc1_] = 0;
            _loc1_++;
         }
         this._slotStateArr[0] = 1;
      }
      
      public function getSlotNum() : Number
      {
         return this._slotNum.getValue();
      }
      
      private function initSlot() : void
      {
         var _loc1_:uint = 0;
         while(_loc1_ < this._slotNum.getValue())
         {
            this._slotArr[_loc1_] = null;
            _loc1_++;
         }
      }
      
      public function setSlot(param1:Number) : void
      {
         if(this._slotStateArr[param1] == 0)
         {
            this._slotStateArr[param1] = 1;
         }
      }
      
      public function getSlot(param1:Number) : Number
      {
         return this._slotStateArr[param1];
      }
      
      public function getGem(param1:Number) : Goods
      {
         return this._slotArr[param1];
      }
      
      public function addGemInEquip(param1:Number, param2:Goods) : void
      {
         if(this._slotStateArr[param1] != 0)
         {
            this._slotArr[param1] = param2;
            this._slotStateArr[param1] = 2;
         }
      }
      
      public function get slotNum() : VT
      {
         return this._slotNum;
      }
      
      public function set slotNum(param1:VT) : void
      {
         this._slotNum = param1;
      }
      
      public function get slotStateArr() : Array
      {
         return this._slotStateArr;
      }
      
      public function set slotStateArr(param1:Array) : void
      {
         this._slotStateArr = param1;
      }
      
      public function get slotArr() : Array
      {
         return this._slotArr;
      }
      
      public function set slotArr(param1:Array) : void
      {
         this._slotArr = param1;
      }
   }
}

