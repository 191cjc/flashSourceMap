package hotpointgame.models.unionShop
{
   import hotpointgame.common.*;
   import hotpointgame.repository.unionVip.*;
   
   public class UnionShop
   {
      
      private var _id:VT;
      
      private var _time:VT;
      
      public function UnionShop()
      {
         super();
      }
      
      public static function createUnShop(param1:Number) : UnionShop
      {
         var _loc2_:UnionShop = new UnionShop();
         _loc2_._id = VT.createVT(param1);
         _loc2_._time = VT.createVT(GS.a0);
         return _loc2_;
      }
      
      public static function read(param1:Object) : UnionShop
      {
         var _loc2_:UnionShop = new UnionShop();
         _loc2_._id = VT.createVT(param1["id"]);
         _loc2_._time = VT.createVT(param1["te"]);
         return _loc2_;
      }
      
      public function save() : Object
      {
         var _loc1_:Object = new Object();
         _loc1_["id"] = this._id.getValue();
         _loc1_["te"] = this._time.getValue();
         return _loc1_;
      }
      
      public function getDataById() : UnionShopData
      {
         return UnionVipFactory.getShopDataById(this._id.getValue());
      }
      
      public function getId() : Number
      {
         return this._id.getValue();
      }
      
      public function getLv() : Number
      {
         return this.getDataById().getLv();
      }
      
      public function getName() : String
      {
         return this.getDataById().getName();
      }
      
      public function getNeedGold() : Number
      {
         return this.getDataById().getNeedGold();
      }
      
      public function getNeedGx() : Number
      {
         return this.getDataById().getNeedGx();
      }
      
      public function getGsId() : Number
      {
         return this.getDataById().getGsId();
      }
      
      public function getGsNum() : Number
      {
         return this.getDataById().getGsNum();
      }
      
      public function getGsSl() : Number
      {
         return this.getDataById().getGsSl();
      }
      
      public function getPx() : Number
      {
         return this.getDataById().getPx();
      }
      
      public function getTimes() : Number
      {
         return this._time.getValue();
      }
      
      public function setTimes(param1:Number) : void
      {
         this._time.setValue(param1);
      }
      
      public function getSm() : String
      {
         return this.getDataById().getSm();
      }
   }
}

