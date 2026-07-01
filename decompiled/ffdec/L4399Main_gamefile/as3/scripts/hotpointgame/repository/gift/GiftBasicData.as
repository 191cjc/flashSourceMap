package hotpointgame.repository.gift
{
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   import hotpointgame.models.gift.*;
   
   public class GiftBasicData
   {
      
      private var _id:VT;
      
      private var _type:VT;
      
      private var _smType:VT;
      
      private var _name:String;
      
      private var _resultId:VT;
      
      private var _need:VT;
      
      private var _st:String;
      
      private var _ot:String;
      
      private var _http:String;
      
      private var _frame:VT;
      
      private var _rewardId:Array;
      
      private var _sm:String;
      
      private var _save:VT;
      
      private var _xiaj:VT;
      
      public function GiftBasicData()
      {
         super();
      }
      
      public static function createGiftBasicData(param1:Number, param2:Number, param3:Number, param4:String, param5:Number, param6:Number, param7:String, param8:String, param9:String, param10:Number, param11:String, param12:String, param13:Number, param14:Number) : GiftBasicData
      {
         var _loc15_:GiftBasicData = new GiftBasicData();
         _loc15_._id = VT.createVT(param1);
         _loc15_._type = VT.createVT(param2);
         _loc15_._smType = VT.createVT(param3);
         _loc15_._name = param4;
         _loc15_._resultId = VT.createVT(param5);
         _loc15_._need = VT.createVT(param6);
         _loc15_._st = param7;
         _loc15_._ot = param8;
         _loc15_._http = param9;
         _loc15_._frame = VT.createVT(param10);
         _loc15_._rewardId = strToArr(param11);
         _loc15_._sm = param12;
         _loc15_._save = VT.createVT(param13);
         _loc15_._xiaj = VT.createVT(param14);
         return _loc15_;
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
      
      public function getType() : Number
      {
         return this._type.getValue();
      }
      
      public function getSmType() : Number
      {
         return this._smType.getValue();
      }
      
      public function getName() : String
      {
         return this._name;
      }
      
      public function getResultId() : Number
      {
         return this._resultId.getValue();
      }
      
      public function getNeed() : Number
      {
         return this._need.getValue();
      }
      
      public function getSt() : String
      {
         return this._st;
      }
      
      public function getOt() : String
      {
         return this._ot;
      }
      
      public function getHttp() : String
      {
         return this._http;
      }
      
      public function getFrame() : Number
      {
         return this._frame.getValue();
      }
      
      public function getRewardId() : Number
      {
         return this._rewardId[FlowInterface.getJobByRole() - 1].getValue();
      }
      
      public function createGift() : Gift
      {
         return Gift.createGift(this.getId());
      }
      
      public function getSm() : String
      {
         return this._sm;
      }
      
      public function getSave() : Number
      {
         return this._save.getValue();
      }
      
      public function getXiaJia() : Number
      {
         return this._xiaj.getValue();
      }
   }
}

