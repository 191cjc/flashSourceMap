package hotpointgame.repository.fb
{
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   import hotpointgame.models.fb.*;
   
   public class FbBasicData
   {
      
      private var _id:VT;
      
      private var _name:String;
      
      private var _type:VT;
      
      private var _fbId:VT;
      
      private var _gkId:VT;
      
      private var _keyId:VT;
      
      private var _needId:VT;
      
      private var _goodsId:Array = [];
      
      private var _goodsIdb:Array = [];
      
      private var _goodsIdc:Array = [];
      
      private var _goodsIdd:Array = [];
      
      private var _frame:VT;
      
      public function FbBasicData()
      {
         super();
      }
      
      public static function createFbBasicData(param1:Number, param2:String, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number, param8:String, param9:String, param10:String, param11:String, param12:Number) : FbBasicData
      {
         var _loc13_:FbBasicData = new FbBasicData();
         _loc13_._id = VT.createVT(param1);
         _loc13_._name = param2;
         _loc13_._type = VT.createVT(param3);
         _loc13_._fbId = VT.createVT(param4);
         _loc13_._gkId = VT.createVT(param5);
         _loc13_._keyId = VT.createVT(param6);
         _loc13_._needId = VT.createVT(param7);
         _loc13_._goodsId = strToArr(param8);
         _loc13_._goodsIdb = strToArr(param9);
         _loc13_._goodsIdc = strToArr(param10);
         _loc13_._goodsIdd = strToArr(param11);
         _loc13_._frame = VT.createVT(param12);
         return _loc13_;
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
      
      public function getType() : Number
      {
         return this._type.getValue();
      }
      
      public function getFbId() : Number
      {
         return this._fbId.getValue();
      }
      
      public function getGkId() : Number
      {
         return this._gkId.getValue();
      }
      
      public function getKeyId() : Number
      {
         return this._keyId.getValue();
      }
      
      public function getNeedId() : Number
      {
         return this._needId.getValue();
      }
      
      public function getFrame() : Number
      {
         return this._frame.getValue();
      }
      
      public function getGoodsId() : Array
      {
         var _loc1_:Array = [];
         var _loc2_:Array = [];
         var _loc3_:Array = [];
         var _loc4_:Array = [];
         var _loc5_:uint = 0;
         while(_loc5_ < this._goodsId.length)
         {
            _loc1_[_loc5_] = this._goodsId[_loc5_].getValue();
            _loc5_++;
         }
         _loc5_ = 0;
         while(_loc5_ < this._goodsIdb.length)
         {
            _loc2_[_loc5_] = this._goodsIdb[_loc5_].getValue();
            _loc5_++;
         }
         _loc5_ = 0;
         while(_loc5_ < this._goodsIdc.length)
         {
            _loc3_[_loc5_] = this._goodsIdc[_loc5_].getValue();
            _loc5_++;
         }
         _loc5_ = 0;
         while(_loc5_ < this._goodsIdd.length)
         {
            _loc4_[_loc5_] = this._goodsIdd[_loc5_].getValue();
            _loc5_++;
         }
         var _loc6_:Array = [_loc1_,_loc2_,_loc3_,_loc4_];
         return _loc6_[FlowInterface.getJobByRole() - 1];
      }
      
      public function createFb() : Fb
      {
         return Fb.createFb(this._id.getValue());
      }
   }
}

