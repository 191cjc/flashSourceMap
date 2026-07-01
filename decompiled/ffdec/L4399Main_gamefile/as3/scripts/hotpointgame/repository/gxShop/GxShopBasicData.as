package hotpointgame.repository.gxShop
{
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   
   public class GxShopBasicData
   {
      
      private var _id:VT;
      
      private var _name:String;
      
      private var _gxNum:VT;
      
      private var _pmNum:VT;
      
      private var _goodsId:Array;
      
      private var _goodsNum:Array;
      
      private var _sxNum:VT;
      
      public function GxShopBasicData()
      {
         super();
      }
      
      public static function createGxShop(param1:Number, param2:String, param3:Number, param4:Number, param5:String, param6:String, param7:Number) : GxShopBasicData
      {
         var _loc8_:GxShopBasicData = new GxShopBasicData();
         _loc8_._id = VT.createVT(param1);
         _loc8_._name = param2;
         _loc8_._gxNum = VT.createVT(param3);
         _loc8_._pmNum = VT.createVT(param4);
         _loc8_._goodsId = strToArr(param5);
         _loc8_._goodsNum = strToArr(param6);
         _loc8_._sxNum = VT.createVT(param7);
         return _loc8_;
      }
      
      private static function strToArr(param1:String) : Array
      {
         var _loc2_:Array = param1.split("*");
         var _loc3_:Array = [];
         var _loc4_:uint = 0;
         while(_loc4_ < _loc2_.length)
         {
            if(Boolean(Number(_loc2_[_loc4_])) || _loc2_[_loc4_] == 0)
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
      
      public function getId() : Number
      {
         return this._id.getValue();
      }
      
      public function getName() : String
      {
         return this._name;
      }
      
      public function getGxNum() : Number
      {
         return this._gxNum.getValue();
      }
      
      public function getPmNum() : Number
      {
         return this._pmNum.getValue();
      }
      
      public function getGoodsId() : Number
      {
         return this._goodsId[FlowInterface.getJobByRole() - 1].getValue();
      }
      
      public function getGoodsNum() : Number
      {
         return this._goodsNum[FlowInterface.getJobByRole() - 1].getValue();
      }
      
      public function getSxNum() : Number
      {
         return this._sxNum.getValue();
      }
      
      public function get id() : VT
      {
         return this._id;
      }
      
      public function set id(param1:VT) : void
      {
         this._id = param1;
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      public function set name(param1:String) : void
      {
         this._name = param1;
      }
      
      public function get gxNum() : VT
      {
         return this._gxNum;
      }
      
      public function set gxNum(param1:VT) : void
      {
         this._gxNum = param1;
      }
      
      public function get pmNum() : VT
      {
         return this._pmNum;
      }
      
      public function set pmNum(param1:VT) : void
      {
         this._pmNum = param1;
      }
      
      public function get sxNum() : VT
      {
         return this._sxNum;
      }
      
      public function set sxNum(param1:VT) : void
      {
         this._sxNum = param1;
      }
      
      public function get goodsId() : Array
      {
         return this._goodsId;
      }
      
      public function set goodsId(param1:Array) : void
      {
         this._goodsId = param1;
      }
      
      public function get goodsNum() : Array
      {
         return this._goodsNum;
      }
      
      public function set goodsNum(param1:Array) : void
      {
         this._goodsNum = param1;
      }
   }
}

