package hotpointgame.repository.shop
{
   import hotpointgame.common.*;
   import hotpointgame.models.shop.*;
   
   public class ShopBasicData
   {
      
      private var _id:VT;
      
      private var _jd:VT;
      
      private var _name:String;
      
      private var _gold:VT;
      
      private var _color:VT;
      
      private var _shopNum:String;
      
      private var _frame:VT;
      
      private var _level:String;
      
      private var _cxGl:VT;
      
      private var _idArr:Array = [];
      
      private var _numArr:Array = [];
      
      private var _glArr:Array = [];
      
      private var _isId:Boolean;
      
      private var _dj:Boolean;
      
      private var _sm:String;
      
      private var _shopId:VT;
      
      public function ShopBasicData()
      {
         super();
      }
      
      public static function createShopBasicData(param1:Number, param2:Number, param3:String, param4:Number, param5:Number, param6:String, param7:Number, param8:String, param9:Number, param10:String, param11:String, param12:String, param13:Boolean, param14:Boolean, param15:String, param16:Number) : ShopBasicData
      {
         var _loc17_:ShopBasicData = new ShopBasicData();
         _loc17_._id = VT.createVT(param1);
         _loc17_._jd = VT.createVT(param2);
         _loc17_._name = param3;
         _loc17_._color = VT.createVT(param4);
         _loc17_._gold = VT.createVT(param5);
         _loc17_._shopNum = param6;
         _loc17_._frame = VT.createVT(param7);
         _loc17_._level = param8;
         _loc17_._cxGl = VT.createVT(param9);
         _loc17_._idArr = strToArr(param10);
         _loc17_._numArr = strToArr(param11);
         _loc17_._glArr = strToArr(param12);
         _loc17_._dj = param14;
         _loc17_._isId = param13;
         _loc17_._sm = param15;
         _loc17_._shopId = VT.createVT(param16);
         return _loc17_;
      }
      
      private static function strToArr(param1:String) : Array
      {
         var _loc2_:Array = param1.split("*");
         var _loc3_:Array = [];
         var _loc4_:uint = 0;
         while(_loc4_ < _loc2_.length)
         {
            if(Number(_loc2_[_loc4_]) is Number)
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
      
      public function getjd() : Number
      {
         return this._jd.getValue();
      }
      
      public function getName() : String
      {
         return this._name;
      }
      
      public function getColor() : Number
      {
         return this._color.getValue();
      }
      
      public function getGold() : Number
      {
         return this._gold.getValue();
      }
      
      public function getShopNum() : String
      {
         return this._shopNum;
      }
      
      public function getFrame() : Number
      {
         return this._frame.getValue();
      }
      
      public function getLevel() : String
      {
         return this._level;
      }
      
      public function cxGl() : Number
      {
         return this._cxGl.getValue();
      }
      
      public function getIdArr() : Array
      {
         var _loc1_:Array = [];
         var _loc2_:uint = 0;
         while(_loc2_ < this._idArr.length)
         {
            _loc1_.push(this._idArr[_loc2_].getValue());
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function getNumArr() : Array
      {
         var _loc1_:Array = [];
         var _loc2_:uint = 0;
         while(_loc2_ < this._numArr.length)
         {
            _loc1_.push(this._numArr[_loc2_].getValue());
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function getGlArr() : Array
      {
         var _loc1_:Array = [];
         var _loc2_:uint = 0;
         while(_loc2_ < this._glArr.length)
         {
            _loc1_.push(this._glArr[_loc2_].getValue());
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function isId() : Boolean
      {
         return this._isId;
      }
      
      public function isDj() : Boolean
      {
         return this._dj;
      }
      
      public function getSm() : String
      {
         return this._sm;
      }
      
      public function getShopId() : Number
      {
         return this._shopId.getValue();
      }
      
      public function createShop() : Shop
      {
         return Shop.createShop(this._id.getValue());
      }
   }
}

