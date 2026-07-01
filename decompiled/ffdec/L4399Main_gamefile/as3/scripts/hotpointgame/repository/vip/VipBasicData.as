package hotpointgame.repository.vip
{
   import hotpointgame.common.*;
   
   public class VipBasicData
   {
      
      private var _id:VT;
      
      private var needXz:VT;
      
      private var jlIdArr:Array = [];
      
      private var jlNumArr:Array = [];
      
      private var _hp:VT;
      
      private var _nl:VT;
      
      private var _att:VT;
      
      private var _fy:VT;
      
      private var _bj:VT;
      
      private var _jin:VT;
      
      private var _mu:VT;
      
      private var _shui:VT;
      
      private var _huo:VT;
      
      private var _tu:VT;
      
      private var _hd:VT;
      
      public function VipBasicData()
      {
         super();
      }
      
      public static function createVipData(param1:Number, param2:Number, param3:String, param4:String, param5:Number, param6:Number, param7:Number, param8:Number, param9:Number, param10:Number, param11:Number, param12:Number, param13:Number, param14:Number, param15:Number) : VipBasicData
      {
         var _loc16_:VipBasicData = new VipBasicData();
         _loc16_._id = VT.createVT(param1);
         _loc16_.needXz = VT.createVT(param2);
         _loc16_.jlIdArr = strToArr(param3);
         _loc16_.jlNumArr = strToArr(param4);
         _loc16_._hp = VT.createVT(param5);
         _loc16_._nl = VT.createVT(param6);
         _loc16_._att = VT.createVT(param7);
         _loc16_._fy = VT.createVT(param8);
         _loc16_._bj = VT.createVT(param9);
         _loc16_._jin = VT.createVT(param10);
         _loc16_._mu = VT.createVT(param11);
         _loc16_._shui = VT.createVT(param12);
         _loc16_._huo = VT.createVT(param13);
         _loc16_._tu = VT.createVT(param14);
         _loc16_._hd = VT.createVT(param15);
         return _loc16_;
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
      
      public function getNeedXz() : Number
      {
         return this.needXz.getValue();
      }
      
      public function getjlId() : Array
      {
         var _loc1_:Array = [];
         var _loc2_:uint = 0;
         while(_loc2_ < this.jlIdArr.length)
         {
            _loc1_[_loc2_] = this.jlIdArr[_loc2_].getValue();
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function getjlNum() : Array
      {
         var _loc1_:Array = [];
         var _loc2_:uint = 0;
         while(_loc2_ < this.jlIdArr.length)
         {
            _loc1_[_loc2_] = this.jlNumArr[_loc2_].getValue();
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function getHp() : Number
      {
         return this._hp.getValue() / GS.a10000;
      }
      
      public function getAtt() : Number
      {
         return this._att.getValue() / GS.a10000;
      }
      
      public function getNl() : Number
      {
         return this._nl.getValue();
      }
      
      public function getFy() : Number
      {
         return this._fy.getValue() / GS.a10000;
      }
      
      public function getBj() : Number
      {
         return this._bj.getValue() / GS.a10000;
      }
      
      public function getJin() : Number
      {
         return this._jin.getValue() / GS.a10000;
      }
      
      public function getMu() : Number
      {
         return this._mu.getValue() / GS.a10000;
      }
      
      public function getShui() : Number
      {
         return this._shui.getValue() / GS.a10000;
      }
      
      public function getHuo() : Number
      {
         return this._huo.getValue() / GS.a10000;
      }
      
      public function getTu() : Number
      {
         return this._tu.getValue() / GS.a10000;
      }
      
      public function getHd() : Number
      {
         return this._hd.getValue() / GS.a10000;
      }
   }
}

