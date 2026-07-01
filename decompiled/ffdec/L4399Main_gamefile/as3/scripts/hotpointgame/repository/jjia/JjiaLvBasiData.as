package hotpointgame.repository.jjia
{
   import hotpointgame.common.*;
   
   public class JjiaLvBasiData
   {
      
      private var _id:VT;
      
      private var _goodsId:VT;
      
      private var _lv:VT;
      
      private var _sxa:Array = [];
      
      private var _needExp:VT;
      
      private var _skFrame:Array = [];
      
      public function JjiaLvBasiData()
      {
         super();
      }
      
      public static function createJjiaLvBasiData(param1:Number, param2:Number, param3:Number, param4:String, param5:Number, param6:String) : JjiaLvBasiData
      {
         var _loc7_:JjiaLvBasiData = new JjiaLvBasiData();
         _loc7_._id = VT.createVT(param1);
         _loc7_._goodsId = VT.createVT(param2);
         _loc7_._lv = VT.createVT(param3);
         _loc7_._sxa = strToArr(param4);
         _loc7_._needExp = VT.createVT(param5);
         _loc7_._skFrame = strToArr(param6);
         return _loc7_;
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
      
      public function getGoodsId() : Number
      {
         return this._goodsId.getValue();
      }
      
      public function getLv() : Number
      {
         return this._lv.getValue();
      }
      
      public function getSx() : Array
      {
         var _loc1_:Array = [];
         var _loc2_:uint = 0;
         while(_loc2_ < this._sxa.length)
         {
            _loc1_[_loc2_] = this._sxa[_loc2_].getValue();
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function getHp() : Number
      {
         return this._sxa[0].getValue();
      }
      
      public function getAtt() : Number
      {
         return this._sxa[2].getValue();
      }
      
      public function getHd() : Number
      {
         return this._sxa[1].getValue();
      }
      
      public function getFy() : Number
      {
         return this._sxa[3].getValue();
      }
      
      public function getBj() : Number
      {
         return this._sxa[4].getValue();
      }
      
      public function getNeedExp() : Number
      {
         return this._needExp.getValue();
      }
      
      public function getSkFrame() : Array
      {
         var _loc1_:Array = [];
         var _loc2_:uint = 0;
         while(_loc2_ < this._skFrame.length)
         {
            _loc1_[_loc2_] = this._skFrame[_loc2_].getValue();
            _loc2_++;
         }
         return _loc1_;
      }
   }
}

