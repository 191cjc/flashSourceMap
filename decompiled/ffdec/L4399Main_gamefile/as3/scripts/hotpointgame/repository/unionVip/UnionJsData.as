package hotpointgame.repository.unionVip
{
   import hotpointgame.common.*;
   
   public class UnionJsData
   {
      
      private var _id:VT;
      
      private var _name:String;
      
      private var _frame:VT;
      
      private var _npc:VT;
      
      private var _xt:VT;
      
      private var _lv:VT;
      
      private var _nZj:VT;
      
      private var _njs:VT;
      
      private var _nlv:VT;
      
      private var _sm:String;
      
      public function UnionJsData()
      {
         super();
      }
      
      public static function createUjData(param1:Number, param2:String, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number, param8:Number, param9:Number, param10:String) : UnionJsData
      {
         var _loc11_:UnionJsData = new UnionJsData();
         _loc11_._id = VT.createVT(param1);
         _loc11_._name = String(param2);
         _loc11_._frame = VT.createVT(param3);
         _loc11_._npc = VT.createVT(param4);
         _loc11_._xt = VT.createVT(param5);
         _loc11_._lv = VT.createVT(param6);
         _loc11_._nZj = VT.createVT(param7);
         _loc11_._njs = VT.createVT(param8);
         _loc11_._nlv = VT.createVT(param9);
         _loc11_._sm = String(param10);
         return _loc11_;
      }
      
      public function getId() : Number
      {
         return this._id.getValue();
      }
      
      public function getName() : String
      {
         return this._name;
      }
      
      public function getFrame() : Number
      {
         return this._frame.getValue();
      }
      
      public function getNpc() : Number
      {
         return this._npc.getValue();
      }
      
      public function getXt() : Number
      {
         return this._xt.getValue();
      }
      
      public function getLv() : Number
      {
         return this._lv.getValue();
      }
      
      public function getNzj() : Number
      {
         return this._nZj.getValue();
      }
      
      public function getNjs() : Number
      {
         return this._njs.getValue();
      }
      
      public function getNlv() : Number
      {
         return this._nlv.getValue();
      }
      
      public function getSm() : String
      {
         return this._sm;
      }
   }
}

