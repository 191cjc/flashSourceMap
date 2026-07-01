package hotpointgame.views.unionPanel
{
   import hotpointgame.common.*;
   
   public class UnionData
   {
      
      private var id:VT = VT.createVT(-1);
      
      private var username:String;
      
      private var unionName:String;
      
      private var level:VT = VT.createVT(-1);
      
      private var extra:String;
      
      private var count:VT = VT.createVT(-1);
      
      private var pm:String = "无";
      
      public function UnionData()
      {
         super();
      }
      
      public static function createUnionData(param1:Object) : UnionData
      {
         var _loc2_:UnionData = new UnionData();
         _loc2_.id = VT.createVT(Number(param1.unionId));
         _loc2_.username = String(param1.username);
         _loc2_.unionName = String(param1.title);
         _loc2_.level = VT.createVT(Number(param1.level));
         _loc2_.extra = String(param1.extra);
         _loc2_.count = VT.createVT(Number(param1.count));
         _loc2_.pm = "无";
         return _loc2_;
      }
      
      public function getId() : Number
      {
         return this.id.getValue();
      }
      
      public function getUseName() : String
      {
         return this.username;
      }
      
      public function getUnionName() : String
      {
         return this.unionName;
      }
      
      public function getLevel() : Number
      {
         return this.level.getValue();
      }
      
      public function getExtra() : String
      {
         return this.extra;
      }
      
      public function getCount() : Number
      {
         return this.count.getValue();
      }
      
      public function getPm() : String
      {
         return this.pm;
      }
      
      public function setPm(param1:String) : void
      {
         this.pm = param1;
      }
   }
}

