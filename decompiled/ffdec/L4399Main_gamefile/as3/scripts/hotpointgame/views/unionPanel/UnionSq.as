package hotpointgame.views.unionPanel
{
   import hotpointgame.common.*;
   
   public class UnionSq
   {
      
      private var unionId:VT;
      
      private var uId:VT;
      
      private var userName:String;
      
      private var index:VT;
      
      private var nickName:String;
      
      private var extra:String;
      
      public function UnionSq()
      {
         super();
      }
      
      public static function createSq(param1:Object) : UnionSq
      {
         var _loc2_:UnionSq = new UnionSq();
         _loc2_.unionId = VT.createVT(param1.unionId);
         _loc2_.uId = VT.createVT(param1.uId);
         _loc2_.userName = String(param1.userName);
         _loc2_.index = VT.createVT(param1.index);
         _loc2_.nickName = String(param1.nickName);
         _loc2_.extra = String(param1.extra);
         return _loc2_;
      }
      
      public function getUnionId() : Number
      {
         return this.unionId.getValue();
      }
      
      public function getUid() : Number
      {
         return this.uId.getValue();
      }
      
      public function getUserName() : String
      {
         return this.userName;
      }
      
      public function getIndex() : Number
      {
         return this.index.getValue();
      }
      
      public function getNickName() : String
      {
         if(this.nickName == "0")
         {
            return this.getUserName();
         }
         return this.nickName;
      }
      
      public function getExtra() : String
      {
         return this.extra;
      }
      
      public function getLv() : Number
      {
         var _loc1_:Array = this.getExtra().split("*");
         return Number(_loc1_[0]);
      }
      
      public function getJjFs() : Number
      {
         var _loc1_:Array = this.getExtra().split("*");
         return Number(_loc1_[1]);
      }
      
      public function getJob() : String
      {
         var _loc1_:Array = this.getExtra().split("*");
         return String(_loc1_[2]);
      }
   }
}

