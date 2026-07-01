package hotpointgame.views.unionPanel
{
   import hotpointgame.common.*;
   
   public class UnioinCy
   {
      
      private var id:VT;
      
      private var userName:String;
      
      private var nickName:String;
      
      private var contribution:VT;
      
      private var extra:String;
      
      private var active_time:String;
      
      private var cd:VT;
      
      private var zw:String = "团长";
      
      private var zwNum:VT;
      
      private var xf:VT;
      
      public function UnioinCy()
      {
         super();
      }
      
      public static function createUnionCy(param1:Object) : UnioinCy
      {
         var _loc2_:UnioinCy = new UnioinCy();
         _loc2_.id = VT.createVT(Number(param1.uId));
         _loc2_.userName = String(param1.userName);
         _loc2_.nickName = String(param1.nickName);
         _loc2_.contribution = VT.createVT(Number(param1.contribution));
         _loc2_.extra = String(param1.extra);
         _loc2_.active_time = String(param1.active_time);
         _loc2_.cd = VT.createVT(Number(param1.index));
         _loc2_.zw = "团长";
         _loc2_.zwNum = VT.createVT(0);
         _loc2_.xf = VT.createVT(0);
         return _loc2_;
      }
      
      public function getId() : Number
      {
         return this.id.getValue();
      }
      
      public function getUserName() : String
      {
         return this.userName;
      }
      
      public function getNickName() : String
      {
         if(this.nickName == "0")
         {
            return this.getUserName();
         }
         return this.nickName;
      }
      
      public function getContribution() : Number
      {
         return this.contribution.getValue();
      }
      
      public function getExtra() : String
      {
         return this.extra;
      }
      
      public function getActiveTime() : String
      {
         var _loc1_:Number = Number(this.active_time);
         var _loc2_:Date = new Date(_loc1_);
         var _loc3_:Number = _loc2_.fullYear;
         var _loc4_:Number = _loc2_.month;
         var _loc5_:Number = _loc2_.date;
         return _loc3_ + "/" + _loc4_ + "/" + _loc5_;
      }
      
      public function setZw(param1:String) : void
      {
         this.zw = param1;
      }
      
      public function getZw() : String
      {
         return this.zw;
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
      
      public function getCd() : Number
      {
         return this.cd.getValue();
      }
      
      public function getJob() : String
      {
         var _loc1_:Array = this.getExtra().split("*");
         return String(_loc1_[2]);
      }
      
      public function getXf() : String
      {
         var _loc1_:Array = this.getExtra().split("*");
         if(_loc1_[3] == null)
         {
            return "0";
         }
         return String(_loc1_[3]);
      }
      
      public function getZwBs() : Number
      {
         return this.zwNum.getValue();
      }
      
      public function setZwBs(param1:*) : void
      {
         this.zwNum.setValue(param1);
      }
   }
}

