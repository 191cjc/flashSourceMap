package hotpointgame.views.unionPanel
{
   import hotpointgame.common.*;
   
   public class MyUnion
   {
      
      private var unionId:VT = VT.createVT(-1);
      
      private var gameId:VT = VT.createVT(-1);
      
      private var bzId:VT = VT.createVT(-1);
      
      private var bzUsername:String;
      
      private var unionName:String;
      
      private var level:VT = VT.createVT(-1);
      
      private var experience:VT = VT.createVT(-1);
      
      private var contribution:VT = VT.createVT(-1);
      
      private var bzExtra:String;
      
      private var dissolveDate:String;
      
      private var pm:String = "无";
      
      private var rs:VT = VT.createVT(0);
      
      private var jsBo:VT;
      
      private var myUid:VT = VT.createVT(-1);
      
      private var myUserName:String;
      
      private var myIndex:VT = VT.createVT(-1);
      
      private var myNickName:String;
      
      private var myContribution:VT = VT.createVT(-1);
      
      private var myTime:String;
      
      public function MyUnion()
      {
         super();
      }
      
      public static function createUnionEx(param1:Object = null) : MyUnion
      {
         var _loc2_:MyUnion = null;
         if(param1.unionInfo != null)
         {
            _loc2_ = new MyUnion();
            _loc2_.unionId = VT.createVT(Number(param1.unionInfo.id));
            _loc2_.gameId = VT.createVT(Number(param1.unionInfo.gameId));
            _loc2_.bzId = VT.createVT(Number(param1.unionInfo.uId));
            _loc2_.bzUsername = String(param1.unionInfo.userName);
            _loc2_.unionName = String(param1.unionInfo.title);
            _loc2_.level = VT.createVT(Number(param1.unionInfo.level));
            _loc2_.experience = VT.createVT(Number(param1.unionInfo.experience));
            _loc2_.contribution = VT.createVT(Number(param1.unionInfo.contribution));
            _loc2_.bzExtra = String(param1.unionInfo.extra);
            _loc2_.dissolveDate = String(param1.unionInfo.dissolveDate);
            _loc2_.pm = "无";
            _loc2_.rs = VT.createVT(0);
            _loc2_.jsBo = VT.createVT(0);
            _loc2_.myUid = VT.createVT(Number(param1.member.uId));
            _loc2_.myUserName = String(param1.member.userName);
            _loc2_.myIndex = VT.createVT(Number(param1.member.index));
            _loc2_.myNickName = String(param1.member.nickName);
            _loc2_.myContribution = VT.createVT(Number(param1.member.contribution));
            _loc2_.myTime = String(param1.member.active_time);
         }
         return _loc2_;
      }
      
      public function getUnionId() : Number
      {
         return this.unionId.getValue();
      }
      
      public function getGameId() : Number
      {
         return this.gameId.getValue();
      }
      
      public function getBzId() : Number
      {
         return this.bzId.getValue();
      }
      
      public function getBzName() : String
      {
         return this.bzUsername;
      }
      
      public function getUnionName() : String
      {
         return this.unionName;
      }
      
      public function getUnionLevel() : Number
      {
         return this.level.getValue();
      }
      
      public function getExperience() : Number
      {
         return this.experience.getValue();
      }
      
      public function getContribution() : Number
      {
         return this.contribution.getValue();
      }
      
      public function getExtra() : String
      {
         var _loc1_:Array = this.bzExtra.split("*");
         return String(_loc1_[0]);
      }
      
      public function getXfZJ() : Number
      {
         var _loc1_:Array = this.bzExtra.split("*");
         if(_loc1_[1] == null)
         {
            return 0;
         }
         return Number(_loc1_[1]);
      }
      
      public function getDissolveDate() : String
      {
         return this.dissolveDate;
      }
      
      public function getMyUid() : Number
      {
         return this.myUid.getValue();
      }
      
      public function getMyUserName() : String
      {
         return this.myUserName;
      }
      
      public function getMyIndex() : Number
      {
         return this.myIndex.getValue();
      }
      
      public function getMyNickName() : String
      {
         return this.myNickName;
      }
      
      public function getMyContribution() : Number
      {
         return this.myContribution.getValue();
      }
      
      public function getMyTime() : String
      {
         return this.myTime;
      }
      
      public function isHz() : Boolean
      {
         if(this.getBzId() == this.getMyUid())
         {
            return true;
         }
         return false;
      }
      
      public function getPm() : String
      {
         return this.pm;
      }
      
      public function setPm(param1:String) : void
      {
         this.pm = param1;
      }
      
      public function getRs() : Number
      {
         return this.rs.getValue();
      }
      
      public function setRs(param1:Number) : void
      {
         this.rs.setValue(param1);
      }
      
      public function getJsBo() : Number
      {
         return this.jsBo.getValue();
      }
      
      public function setJsBo(param1:Number) : void
      {
         this.jsBo.setValue(param1);
      }
   }
}

