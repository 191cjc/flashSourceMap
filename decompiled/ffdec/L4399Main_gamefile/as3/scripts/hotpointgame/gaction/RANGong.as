package hotpointgame.gaction
{
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   import hotpointgame.gBullet.*;
   import hotpointgame.gameobj.*;
   import hotpointgame.utils.*;
   
   public class RANGong extends CAction
   {
      
      public static var name:String = "攻击";
      
      protected var nameA:String = "攻击1";
      
      protected var nameB:String = "攻击2";
      
      protected var nameC:String = "攻击3";
      
      protected var nameD:String = "攻击4";
      
      private var _fanbivalue:VT = VT.createVT(0);
      
      protected var pauseKey:Object = {
         "攻击1":9,
         "攻击2":6,
         "攻击3":17,
         "攻击4":14
      };
      
      private var bulletObj:Object;
      
      private var effectFrame:int = 1;
      
      private var lastName:String = this.nameA;
      
      private var lastFrameTime:int = 0;
      
      public function RANGong(param1:String)
      {
         super(param1);
      }
      
      override public function setData(param1:Object) : void
      {
         this.bulletObj = param1.bo;
         super.setData(param1);
      }
      
      override public function enter(param1:ZtC) : void
      {
         if(GM.frameTime - this.lastFrameTime != 0)
         {
            currentFrameNum = 0;
            this.lastName = this.nameA;
            this.fanbivalue = GS.a20;
         }
         else if(this.lastName == this.nameA)
         {
            currentFrameNum = 0;
            this.lastName = this.nameB;
            this.fanbivalue = GS.a18;
         }
         else if(this.lastName == this.nameB)
         {
            currentFrameNum = 0;
            this.lastName = this.nameC;
            this.fanbivalue = GS.a27;
         }
         else if(this.lastName == this.nameC)
         {
            currentFrameNum = 0;
            this.lastName = this.nameD;
            this.fanbivalue = GS.a32;
         }
         else
         {
            this.lastName = this.nameA;
            currentFrameNum = 0;
            this.fanbivalue = GS.a20;
         }
         param1.gotoAndPlayFrame(this.lastName);
      }
      
      override protected function beforeByBullet(param1:ZtC) : void
      {
         var _loc2_:Object = null;
         var _loc3_:Class = null;
         var _loc4_:ZtB = null;
         if(this.bulletObj[this.lastName][currentFrameNum])
         {
            _loc2_ = ZtBFactory.getBulletData(this.bulletObj[this.lastName][currentFrameNum]);
            _loc3_ = ClassGet.getClassByNameAndAlias(_loc2_.classname) as Class;
            _loc4_ = new _loc3_(param1.getBullet(_loc2_.flaname),param1,_loc2_) as ZtB;
            GM.levelm.addBullet(_loc4_);
         }
      }
      
      override protected function actionStateUpdate(param1:ZtC) : Boolean
      {
         if(currentFrameNum < this.fanbivalue)
         {
            return false;
         }
         return true;
      }
      
      override public function useKeyDaDuan() : int
      {
         if(currentFrameNum > this.pauseKey[this.lastName])
         {
            return ActionConstant.KeyDaDuanYB;
         }
         return ActionConstant.KeyDaDuanYA;
      }
      
      override public function exit() : void
      {
         this.lastFrameTime = GM.frameTime;
         super.exit();
      }
      
      public function get fanbivalue() : int
      {
         return this._fanbivalue.getValue();
      }
      
      public function set fanbivalue(param1:int) : void
      {
         this._fanbivalue.setValue(param1);
      }
   }
}

