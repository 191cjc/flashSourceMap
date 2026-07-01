package hotpointgame.views.attPanel
{
   import hotpointgame.common.*;
   
   public class AttCyData
   {
      
      private var _uId:VT;
      
      private var _userName:String;
      
      private var _score:VT;
      
      private var _rank:VT;
      
      private var _area:VT;
      
      private var _extra:Object;
      
      public function AttCyData()
      {
         super();
      }
      
      public static function crateAttCyData(param1:Object) : AttCyData
      {
         var _loc2_:AttCyData = new AttCyData();
         _loc2_._uId = VT.createVT(param1.uId);
         _loc2_._userName = String(param1.userName);
         _loc2_._score = VT.createVT(param1.score);
         _loc2_._rank = VT.createVT(param1.rank);
         _loc2_._extra = Object(param1.extra);
         return _loc2_;
      }
      
      public function getUid() : Number
      {
         return this._uId.getValue();
      }
      
      public function getUseName() : String
      {
         return this._userName;
      }
      
      public function getScore() : Number
      {
         return this._score.getValue();
      }
      
      public function getRank() : Number
      {
         return this._rank.getValue();
      }
      
      public function getJob() : String
      {
         if(this._extra != null && this._extra.jl != null)
         {
            if(this._extra.jl == 1)
            {
               return "绝影枪手";
            }
            if(this._extra.jl == 2)
            {
               return "炎蓝炮手";
            }
         }
         return "";
      }
      
      public function getLevel() : String
      {
         if(this._extra != null && this._extra.lv != null)
         {
            return String(this._extra.lv);
         }
         return "";
      }
   }
}

