package hotpointgame.repository.unionVip
{
   import hotpointgame.common.*;
   
   public class UnionVipData
   {
      
      private var _vipId:VT;
      
      private var _needNum:VT;
      
      private var _hp:VT;
      
      private var _att:VT;
      
      private var _fy:VT;
      
      private var _bj:VT;
      
      private var _fx:VT;
      
      private var _exp:VT;
      
      private var _cwE:VT;
      
      private var _gold:VT;
      
      private var _goodsId:Array = [];
      
      private var _goodsNum:Array = [];
      
      private var _gx:VT;
      
      public function UnionVipData()
      {
         super();
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
      
      public static function createUnionVip(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number, param8:Number, param9:Number, param10:Number, param11:String, param12:String, param13:Number) : UnionVipData
      {
         var _loc14_:UnionVipData = new UnionVipData();
         _loc14_._vipId = VT.createVT(param1);
         _loc14_._needNum = VT.createVT(param2);
         _loc14_._hp = VT.createVT(param3);
         _loc14_._att = VT.createVT(param4);
         _loc14_._fy = VT.createVT(param5);
         _loc14_._bj = VT.createVT(param6);
         _loc14_._fx = VT.createVT(param7);
         _loc14_._exp = VT.createVT(param8);
         _loc14_._cwE = VT.createVT(param9);
         _loc14_._gold = VT.createVT(param10);
         _loc14_._goodsId = strToArr(param11);
         _loc14_._goodsNum = strToArr(param12);
         _loc14_._gx = VT.createVT(param13);
         return _loc14_;
      }
      
      public function getVipId() : Number
      {
         return this._vipId.getValue();
      }
      
      public function getNeedNum() : Number
      {
         return this._needNum.getValue();
      }
      
      public function getHp() : Number
      {
         return this._hp.getValue() / GS.a10000;
      }
      
      public function getAtt() : Number
      {
         return this._att.getValue() / GS.a10000;
      }
      
      public function getFy() : Number
      {
         return this._fy.getValue() / GS.a10000;
      }
      
      public function getBj() : Number
      {
         return this._bj.getValue() / GS.a10000;
      }
      
      public function getFx() : Number
      {
         return this._fx.getValue() / GS.a10000;
      }
      
      public function getExp() : Number
      {
         return this._exp.getValue() / GS.a10000;
      }
      
      public function getCwExp() : Number
      {
         return this._cwE.getValue() / GS.a10000;
      }
      
      public function getGold() : Number
      {
         return this._gold.getValue() / GS.a10000;
      }
      
      public function getGoodsId() : Array
      {
         var _loc1_:Array = [];
         var _loc2_:uint = 0;
         while(_loc2_ < this._goodsId.length)
         {
            _loc1_[_loc2_] = this._goodsId[_loc2_].getValue();
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
            _loc1_[_loc2_] = this._goodsNum[_loc2_].getValue();
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function getGx() : Number
      {
         return this._gx.getValue();
      }
   }
}

