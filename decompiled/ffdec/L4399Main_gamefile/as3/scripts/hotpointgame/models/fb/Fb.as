package hotpointgame.models.fb
{
   import hotpointgame.common.*;
   import hotpointgame.repository.fb.*;
   
   public class Fb
   {
      
      private var _id:VT;
      
      private var _state:VT;
      
      private var _finishNum:VT;
      
      public function Fb()
      {
         super();
      }
      
      public static function createFb(param1:Number) : Fb
      {
         var _loc2_:Fb = new Fb();
         _loc2_._id = VT.createVT(param1);
         _loc2_._state = VT.createVT(GS.a0);
         _loc2_._finishNum = VT.createVT(GS.a0);
         return _loc2_;
      }
      
      public static function read(param1:Object) : Fb
      {
         var _loc2_:Fb = new Fb();
         _loc2_._id = VT.createVT(param1["id"]);
         _loc2_._state = VT.createVT(param1["st"]);
         _loc2_._finishNum = VT.createVT(param1["ft"]);
         return _loc2_;
      }
      
      public function save() : Object
      {
         var _loc1_:Object = new Object();
         _loc1_["id"] = this._id.getValue();
         _loc1_["st"] = this._state.getValue();
         _loc1_["ft"] = this._finishNum.getValue();
         return _loc1_;
      }
      
      public function getState() : Number
      {
         return this._state.getValue();
      }
      
      public function setState(param1:Number) : void
      {
         this._state.setValue(param1);
      }
      
      public function getFinishNum() : Number
      {
         return this._finishNum.getValue();
      }
      
      public function addFinishNum() : void
      {
         this._finishNum.setValue(this._finishNum.getValue() + GS.a1);
      }
      
      public function getDataById() : FbBasicData
      {
         return FbFactory.getDataById(this._id.getValue());
      }
      
      public function getId() : Number
      {
         return this.getDataById().getId();
      }
      
      public function getName() : String
      {
         return this.getDataById().getName();
      }
      
      public function getType() : Number
      {
         return this.getDataById().getType();
      }
      
      public function getFbId() : Number
      {
         return this.getDataById().getFbId();
      }
      
      public function getGkId() : Number
      {
         return this.getDataById().getGkId();
      }
      
      public function getNeedId() : Number
      {
         return this.getDataById().getNeedId();
      }
      
      public function getKeyId() : Number
      {
         return this.getDataById().getKeyId();
      }
      
      public function getGoodsId() : Array
      {
         return this.getDataById().getGoodsId();
      }
      
      public function getFrame() : Number
      {
         return this.getDataById().getFrame();
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
      
      public function get finishNum() : VT
      {
         return this._finishNum;
      }
      
      public function set finishNum(param1:VT) : void
      {
         this._finishNum = param1;
      }
   }
}

