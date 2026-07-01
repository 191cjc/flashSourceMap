package hotpointgame.repository.unionVip
{
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   import hotpointgame.models.unionShop.*;
   
   public class UnionShopData
   {
      
      private var _id:VT;
      
      private var _lv:VT;
      
      private var _name:String;
      
      private var _needGold:VT;
      
      private var _needGx:VT;
      
      private var _gsId:Array;
      
      private var _gsNum:VT;
      
      private var _gsSl:VT;
      
      private var _px:VT;
      
      private var _sm:String;
      
      public function UnionShopData()
      {
         super();
      }
      
      public static function createUnShopData(param1:Number, param2:Number, param3:String, param4:Number, param5:Number, param6:String, param7:Number, param8:Number, param9:Number, param10:String) : UnionShopData
      {
         var _loc11_:UnionShopData = new UnionShopData();
         _loc11_._id = VT.createVT(param1);
         _loc11_._lv = VT.createVT(param2);
         _loc11_._name = String(param3);
         _loc11_._needGold = VT.createVT(param4);
         _loc11_._needGx = VT.createVT(param5);
         _loc11_._gsId = strToArr(param6);
         _loc11_._gsNum = VT.createVT(param7);
         _loc11_._gsSl = VT.createVT(param8);
         _loc11_._px = VT.createVT(param9);
         _loc11_._sm = String(param10);
         return _loc11_;
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
      
      public function getLv() : Number
      {
         return this._lv.getValue();
      }
      
      public function getName() : String
      {
         return this._name;
      }
      
      public function getNeedGold() : Number
      {
         return this._needGold.getValue();
      }
      
      public function getNeedGx() : Number
      {
         return this._needGx.getValue();
      }
      
      public function getGsId() : Number
      {
         return this._gsId[FlowInterface.getJobByRole() - 1].getValue();
      }
      
      public function getGsNum() : Number
      {
         return this._gsNum.getValue();
      }
      
      public function getGsSl() : Number
      {
         return this._gsSl.getValue();
      }
      
      public function getPx() : Number
      {
         return this._px.getValue();
      }
      
      public function getSm() : String
      {
         return this._sm;
      }
      
      public function createUnShop() : UnionShop
      {
         return UnionShop.createUnShop(this._id.getValue());
      }
   }
}

