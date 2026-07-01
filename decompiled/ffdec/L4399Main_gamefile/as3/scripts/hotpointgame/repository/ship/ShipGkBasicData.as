package hotpointgame.repository.ship
{
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   
   public class ShipGkBasicData
   {
      
      private var _id:VT;
      
      private var _type:VT;
      
      private var _gkId:VT;
      
      private var _gkLv:VT;
      
      private var _frame:VT;
      
      private var _needTl:VT;
      
      private var _needGs:VT;
      
      private var _needNum:VT;
      
      private var _gsId:Array;
      
      private var _gsIdb:Array;
      
      private var _gsIdc:Array;
      
      private var _gsIdd:Array;
      
      private var _dlId:Array;
      
      private var _gsNum:Array;
      
      private var _gl:Array;
      
      private var _gold:VT;
      
      private var _exp:VT;
      
      public function ShipGkBasicData()
      {
         super();
      }
      
      public static function createShipGkData(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number, param8:Number, param9:String, param10:String, param11:String, param12:String, param13:String, param14:String, param15:String, param16:Number, param17:Number) : ShipGkBasicData
      {
         var _loc18_:ShipGkBasicData = new ShipGkBasicData();
         _loc18_._id = VT.createVT(param1);
         _loc18_._type = VT.createVT(param2);
         _loc18_._gkId = VT.createVT(param3);
         _loc18_._gkLv = VT.createVT(param4);
         _loc18_._frame = VT.createVT(param5);
         _loc18_._needTl = VT.createVT(param6);
         _loc18_._needGs = VT.createVT(param7);
         _loc18_._needNum = VT.createVT(param8);
         _loc18_._gsId = strToArr(param9);
         _loc18_._gsIdb = strToArr(param10);
         _loc18_._gsIdc = strToArr(param11);
         _loc18_._gsIdd = strToArr(param12);
         _loc18_._dlId = strToArr(param13);
         _loc18_._gsNum = strToArr(param14);
         _loc18_._gl = strToArr(param15);
         _loc18_._gold = VT.createVT(param16);
         _loc18_._exp = VT.createVT(param17);
         return _loc18_;
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
      
      public function getNeedGs() : Number
      {
         return this._needGs.getValue();
      }
      
      public function getNeedNum() : Number
      {
         return this._needNum.getValue();
      }
      
      public function getId() : Number
      {
         return this._id.getValue();
      }
      
      public function getType() : Number
      {
         return this._type.getValue();
      }
      
      public function getGkId() : Number
      {
         return this._gkId.getValue();
      }
      
      public function getGkLv() : Number
      {
         return this._gkLv.getValue();
      }
      
      public function getFrame() : Number
      {
         return this._frame.getValue();
      }
      
      public function getNeedTl() : Number
      {
         return this._needTl.getValue();
      }
      
      public function getGold() : Number
      {
         return this._gold.getValue();
      }
      
      public function getExp() : Number
      {
         return this._exp.getValue();
      }
      
      public function getGsId() : Array
      {
         var _loc1_:Array = [];
         var _loc2_:Array = [];
         var _loc3_:Array = [];
         var _loc4_:Array = [];
         var _loc5_:uint = 0;
         while(_loc5_ < this._gsId.length)
         {
            _loc1_[_loc5_] = this._gsId[_loc5_].getValue();
            _loc5_++;
         }
         _loc5_ = 0;
         while(_loc5_ < this._gsIdb.length)
         {
            _loc2_[_loc5_] = this._gsIdb[_loc5_].getValue();
            _loc5_++;
         }
         _loc5_ = 0;
         while(_loc5_ < this._gsIdc.length)
         {
            _loc3_[_loc5_] = this._gsIdc[_loc5_].getValue();
            _loc5_++;
         }
         _loc5_ = 0;
         while(_loc5_ < this._gsIdd.length)
         {
            _loc4_[_loc5_] = this._gsIdd[_loc5_].getValue();
            _loc5_++;
         }
         var _loc6_:Array = [_loc1_,_loc2_,_loc3_,_loc4_];
         return _loc6_[FlowInterface.getJobByRole() - 1];
      }
      
      public function getDlId() : Array
      {
         var _loc1_:Array = [];
         var _loc2_:uint = 0;
         while(_loc2_ < this._dlId.length)
         {
            _loc1_[_loc2_] = this._dlId[_loc2_].getValue();
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function getGsNum() : Array
      {
         var _loc1_:Array = [];
         var _loc2_:uint = 0;
         while(_loc2_ < this._gsNum.length)
         {
            _loc1_[_loc2_] = this._gsNum[_loc2_].getValue();
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function getGl() : Array
      {
         var _loc1_:Array = [];
         var _loc2_:uint = 0;
         while(_loc2_ < this._gl.length)
         {
            _loc1_[_loc2_] = this._gl[_loc2_].getValue();
            _loc2_++;
         }
         return _loc1_;
      }
   }
}

