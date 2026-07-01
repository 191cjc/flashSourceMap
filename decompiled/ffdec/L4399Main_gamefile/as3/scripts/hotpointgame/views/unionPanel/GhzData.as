package hotpointgame.views.unionPanel
{
   import hotpointgame.common.*;
   
   public class GhzData
   {
      
      private var _uId:VT;
      
      private var _userName:String;
      
      private var _score:VT;
      
      private var _rank:VT;
      
      private var _extra:Object;
      
      public function GhzData()
      {
         super();
      }
      
      public static function crateAttCyData(param1:Object) : GhzData
      {
         var _loc2_:GhzData = new GhzData();
         _loc2_._score = VT.createVT(param1.score);
         _loc2_._rank = VT.createVT(param1.rank);
         _loc2_._extra = Object(param1.extra);
         return _loc2_;
      }
      
      public function getScore() : Number
      {
         return this._score.getValue();
      }
      
      public function getRank() : Number
      {
         return this._rank.getValue();
      }
      
      public function getUnId() : Number
      {
         return Number(this._extra.uid);
      }
      
      public function getUnName() : String
      {
         return this._extra.na;
      }
      
      public function getVipRy() : Number
      {
         return Number(this._extra.vip);
      }
   }
}

