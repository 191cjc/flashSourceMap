package hotpointgame.models.everyDay
{
   import hotpointgame.common.*;
   import hotpointgame.repository.everyDay.*;
   
   public class EveryDay
   {
      
      private var _id:VT;
      
      private var _jd:VT;
      
      private var _lq:VT;
      
      public function EveryDay()
      {
         super();
      }
      
      public static function read(param1:Object) : EveryDay
      {
         var _loc2_:EveryDay = new EveryDay();
         _loc2_._id = VT.createVT(param1["id"]);
         _loc2_._jd = VT.createVT(param1["jd"]);
         return _loc2_;
      }
      
      public static function createEveryDay(param1:Number) : EveryDay
      {
         var _loc2_:EveryDay = new EveryDay();
         _loc2_._id = VT.createVT(param1);
         _loc2_._jd = VT.createVT(GS.a0);
         return _loc2_;
      }
      
      public function save() : Object
      {
         var _loc1_:Object = new Object();
         _loc1_["id"] = this._id.getValue();
         _loc1_["jd"] = this._jd.getValue();
         return _loc1_;
      }
      
      public function isOk() : Boolean
      {
         if(this._jd.getValue() < this.getAllNum())
         {
            return false;
         }
         return true;
      }
      
      public function getJd() : Number
      {
         return this._jd.getValue();
      }
      
      public function setJd(param1:Number, param2:Number) : void
      {
         if(this.getType() == param1 && this._jd.getValue() < this.getAllNum())
         {
            this._jd.setValue(this._jd.getValue() + param2);
         }
      }
      
      public function createJd() : void
      {
         this._jd.setValue(GS.a0);
      }
      
      public function getCurrFs() : Number
      {
         return this.getFs();
      }
      
      public function getId() : Number
      {
         return this.getData().getId();
      }
      
      public function getName() : String
      {
         return this.getData().getName();
      }
      
      public function getType() : Number
      {
         return this.getData().getType();
      }
      
      public function getAllNum() : Number
      {
         return this.getData().getAllNum();
      }
      
      public function getFs() : Number
      {
         return this.getData().getFs();
      }
      
      private function getData() : EveryDayBasicData
      {
         return EveryDayFactory.getIdByData(this._id.getValue());
      }
      
      public function getlq() : Number
      {
         return this._lq.getValue();
      }
      
      public function setLq() : void
      {
         this._lq.setValue(GS.a1);
      }
      
      public function get id() : VT
      {
         return this._id;
      }
      
      public function set id(param1:VT) : void
      {
         this._id = param1;
      }
      
      public function get jd() : VT
      {
         return this._jd;
      }
      
      public function set jd(param1:VT) : void
      {
         this._jd = param1;
      }
      
      public function get lq() : VT
      {
         return this._lq;
      }
      
      public function set lq(param1:VT) : void
      {
         this._lq = param1;
      }
   }
}

