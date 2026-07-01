package hotpointgame.gzhujiemian
{
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   import hotpointgame.gaction.CAction;
   import hotpointgame.grole.*;
   import hotpointgame.models.goods.Goods;
   
   public class GunSlot
   {
      
      private static var clipNum:VT = VT.createVT(GS.a100);
      
      private var _mWeapon:Goods = null;
      
      private var _blimit:VT = VT.createVT(0);
      
      private var _bcur:VT = VT.createVT(0);
      
      private var gjAction:CAction;
      
      private var tjAction:CAction;
      
      public function GunSlot()
      {
         super();
      }
      
      public function getAction(param1:String) : CAction
      {
         if(param1 == "场景枪攻击")
         {
            return this.gjAction;
         }
         return this.tjAction;
      }
      
      public function startGJ(param1:String) : Boolean
      {
         if(this.bcur <= 0)
         {
            return false;
         }
         if(param1 != "场景枪跳击" || this.tjAction.getName() != "抖动")
         {
            this.bcur -= GS.a1;
         }
         return true;
      }
      
      public function iskeyGJ() : Boolean
      {
         if(this.bcur <= 0)
         {
            return false;
         }
         this.bcur -= GS.a1;
         return true;
      }
      
      public function changeLevelClearGun() : void
      {
         this.mWeapon = null;
         if(this.gjAction != null)
         {
            this.gjAction.exit();
            this.gjAction = null;
         }
         if(this.tjAction != null)
         {
            this.tjAction.exit();
            this.tjAction = null;
         }
         this.blimit = 0;
         this.bcur = 0;
      }
      
      public function pickGun(param1:Goods) : Boolean
      {
         if(this.mWeapon != null)
         {
            return false;
         }
         this.mWeapon = param1;
         this.gjAction = RoleActionManger.getMapGunActionByName(param1.getCj1());
         this.tjAction = RoleActionManger.getMapGunActionByName(param1.getCj2());
         if(FlowInterface.getJobByRole() == GS.a1)
         {
            this.blimit = param1.getBombNumMax();
            this.bcur = param1.getBombNum();
         }
         else
         {
            this.blimit = param1.isDefense();
            this.bcur = param1.isAttAlter();
         }
         return true;
      }
      
      public function pickClip(param1:int) : Boolean
      {
         if(FlowInterface.getJobByRole() != GS.a1)
         {
            param1 = int(clipNum.getValue());
         }
         if(this.mWeapon == null)
         {
            return false;
         }
         this.bcur += param1;
         if(this.bcur > this.blimit)
         {
            this.bcur = this.blimit;
         }
         return true;
      }
      
      public function pickClipByfor(param1:int) : Boolean
      {
         if(FlowInterface.getJobByRole() != GS.a1)
         {
            param1 = int(clipNum.getValue());
         }
         if(this.mWeapon == null)
         {
            return false;
         }
         if(this.bcur == this.blimit)
         {
            return false;
         }
         this.bcur += param1;
         if(this.bcur > this.blimit)
         {
            this.bcur = this.blimit;
         }
         return true;
      }
      
      public function remove() : void
      {
         this.mWeapon = null;
         if(this.gjAction != null)
         {
            this.gjAction.exit();
            this.gjAction = null;
         }
         if(this.tjAction != null)
         {
            this.tjAction.exit();
            this.tjAction = null;
         }
      }
      
      public function lostGun() : void
      {
         this.mWeapon = null;
         this.gjAction.exit();
         this.tjAction.exit();
         this.gjAction = null;
         this.tjAction = null;
         this.blimit = 0;
         this.bcur = 0;
      }
      
      public function isHaveGun() : Boolean
      {
         if(this.mWeapon != null)
         {
            return true;
         }
         return false;
      }
      
      public function get blimit() : int
      {
         return this._blimit.getValue();
      }
      
      public function set blimit(param1:int) : void
      {
         this._blimit.setValue(param1);
      }
      
      public function get bcur() : int
      {
         return this._bcur.getValue();
      }
      
      public function set bcur(param1:int) : void
      {
         this._bcur.setValue(param1);
      }
      
      public function get mWeapon() : Goods
      {
         return this._mWeapon;
      }
      
      public function set mWeapon(param1:Goods) : void
      {
         this._mWeapon = param1;
      }
   }
}

