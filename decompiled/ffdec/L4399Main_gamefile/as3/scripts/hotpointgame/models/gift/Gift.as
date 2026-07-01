package hotpointgame.models.gift
{
   import hotpointgame.common.*;
   import hotpointgame.repository.gift.*;
   
   public class Gift
   {
      
      private var _id:VT;
      
      private var _state:VT;
      
      public function Gift()
      {
         super();
      }
      
      public static function createGift(param1:Number) : Gift
      {
         var _loc2_:Gift = new Gift();
         _loc2_._id = VT.createVT(param1);
         _loc2_._state = VT.createVT(GS.a0);
         return _loc2_;
      }
      
      public static function read(param1:Object) : Gift
      {
         var _loc2_:Gift = new Gift();
         _loc2_._id = VT.createVT(param1["id"]);
         _loc2_._state = VT.createVT(param1["st"]);
         return _loc2_;
      }
      
      public function save() : Object
      {
         var _loc1_:Object = new Object();
         _loc1_["id"] = this._id.getValue();
         _loc1_["st"] = this._state.getValue();
         return _loc1_;
      }
      
      public function getState() : Number
      {
         return this._state.getValue();
      }
      
      public function setState() : void
      {
         this._state.setValue(GS.a1);
      }
      
      public function getId() : Number
      {
         return this.getGiftData().getId();
      }
      
      public function getType() : Number
      {
         return this.getGiftData().getType();
      }
      
      public function getSmType() : Number
      {
         return this.getGiftData().getSmType();
      }
      
      public function getName() : String
      {
         return this.getGiftData().getName();
      }
      
      public function getResultId() : Number
      {
         return this.getGiftData().getResultId();
      }
      
      public function getNeed() : Number
      {
         return this.getGiftData().getNeed();
      }
      
      public function getHttp() : String
      {
         return this.getGiftData().getHttp();
      }
      
      public function getFrame() : Number
      {
         return this.getGiftData().getFrame();
      }
      
      public function getRewardId() : Number
      {
         return this.getGiftData().getRewardId();
      }
      
      public function getSm() : String
      {
         return this.getGiftData().getSm();
      }
      
      public function getSave() : Number
      {
         return this.getGiftData().getSave();
      }
      
      public function getSt() : String
      {
         return this.getGiftData().getSt();
      }
      
      public function getOt() : String
      {
         return this.getGiftData().getOt();
      }
      
      public function getXiaJ() : Number
      {
         return this.getGiftData().getXiaJia();
      }
      
      public function getGiftData() : GiftBasicData
      {
         return GiftFactory.getGiftDataById(this._id.getValue());
      }
      
      public function get id() : VT
      {
         return this._id;
      }
      
      public function set id(param1:VT) : void
      {
         this._id = param1;
      }
      
      public function get state() : VT
      {
         return this._state;
      }
      
      public function set state(param1:VT) : void
      {
         this._state = param1;
      }
   }
}

