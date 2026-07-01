package hotpointgame.gzhujiemian
{
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   import hotpointgame.gaction.CAction;
   import hotpointgame.grole.CPlayer;
   import hotpointgame.models.goods.Goods;
   
   public class GunSlotM
   {
      
      private var _gunSlotNum:VT = VT.createVT(0);
      
      private var guns:Vector.<GunSlot> = new Vector.<GunSlot>();
      
      private var _currentG:VT = VT.createVT(GS.a1);
      
      public function GunSlotM(param1:int = 0)
      {
         super();
         this.gunSlotNum = param1;
         var _loc2_:int = 0;
         while(_loc2_ <= GS.a4)
         {
            this.guns[_loc2_] = new GunSlot();
            _loc2_++;
         }
         Czhujiemian.self.gunSlotBtnShow(this.gunSlotNum);
         Czhujiemian.self.gunSlotChangeGun(GS.a1,FlowInterface.getEquipTuBiaoFrame(0));
      }
      
      public function remove() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ <= 4)
         {
            (this.guns[_loc1_] as GunSlot).remove();
            _loc1_++;
         }
         this._gunSlotNum = null;
         this.guns = null;
      }
      
      public function getAction(param1:String) : CAction
      {
         return this.guns[this.currentG].getAction(param1);
      }
      
      public function getMonsterName() : String
      {
         var _loc1_:Goods = this.guns[this.currentG].mWeapon;
         return "" + _loc1_.getId() + _loc1_.getName();
      }
      
      public function openNewslot() : void
      {
         if(this.gunSlotNum < GS.a2 && this.gunSlotNum >= 0)
         {
            this.gunSlotNum += GS.a1;
            Czhujiemian.self.gunSlotBtnShow(this.gunSlotNum);
         }
         else
         {
            GM.findCheatMax(GS.a49);
         }
      }
      
      public function startGJ(param1:String) : Boolean
      {
         if(this.guns[this.currentG].startGJ(param1))
         {
            Czhujiemian.self.showBulletNum(this.currentG,"" + this.guns[this.currentG].bcur + "/" + this.guns[this.currentG].blimit);
            return true;
         }
         Czhujiemian.self.gunSlotCurrentState(1);
         this.currentG = GS.a1;
         return false;
      }
      
      public function isKeyenterGJ() : Boolean
      {
         if(this.currentG != GS.a1)
         {
            if(this.guns[this.currentG].iskeyGJ())
            {
               Czhujiemian.self.showBulletNum(this.currentG,"" + this.guns[this.currentG].bcur + "/" + this.guns[this.currentG].blimit);
               return true;
            }
         }
         return false;
      }
      
      public function changeLevelClearMapGun(param1:CPlayer) : void
      {
         var _loc2_:int = int(GS.a2);
         while(_loc2_ <= GS.a2 + this.gunSlotNum)
         {
            Czhujiemian.self.showBulletNum(_loc2_,"0");
            Czhujiemian.self.gunSlotChangeGun(_loc2_,0);
            this.guns[_loc2_].changeLevelClearGun();
            _loc2_++;
         }
         if(this.currentG != GS.a1)
         {
            this.currentG = GS.a1;
            param1.lostMapWeapon();
            Czhujiemian.self.gunSlotCurrentState(1);
         }
      }
      
      public function changeGunChaoByJiJia() : void
      {
         Czhujiemian.self.gunSlotCurrentState(1);
         this.currentG = GS.a1;
      }
      
      public function getCurrentG() : int
      {
         return this.currentG;
      }
      
      public function pickGun(param1:Goods) : Boolean
      {
         var _loc2_:int = int(GS.a2);
         while(_loc2_ <= GS.a2 + this.gunSlotNum)
         {
            if(this.guns[_loc2_].pickGun(param1))
            {
               Czhujiemian.self.gunSlotChangeGun(_loc2_,param1.getFrame());
               Czhujiemian.self.showBulletNum(_loc2_,"" + this.guns[_loc2_].bcur + "/" + this.guns[_loc2_].blimit);
               return true;
            }
            _loc2_++;
         }
         GoodsManger.cwTs("场景枪槽已满Ts!");
         return false;
      }
      
      public function pickClip(param1:int) : Boolean
      {
         var _loc2_:int = 0;
         if(this.currentG == GS.a1)
         {
            _loc2_ = int(GS.a2);
            while(_loc2_ <= GS.a2 + this.gunSlotNum)
            {
               if(this.guns[_loc2_].pickClipByfor(param1))
               {
                  Czhujiemian.self.showBulletNum(_loc2_,"" + this.guns[_loc2_].bcur + "/" + this.guns[_loc2_].blimit);
                  return true;
               }
               _loc2_++;
            }
            return false;
         }
         if(this.guns[this.currentG].pickClip(param1))
         {
            Czhujiemian.self.showBulletNum(this.currentG,"" + this.guns[this.currentG].bcur + "/" + this.guns[this.currentG].blimit);
            return true;
         }
         GM.findCheatMax(GS.a27);
         return true;
      }
      
      public function gmUpdate(param1:CPlayer) : Boolean
      {
         switch(this.currentG)
         {
            case GS.a1:
               if(this.guns[2].isHaveGun())
               {
                  if(GM.ckey.isKey("2"))
                  {
                     Czhujiemian.self.gunSlotCurrentState(2);
                     this.currentG = GS.a2;
                     param1.baseToMap(this.guns[2].mWeapon.getMcName());
                     return true;
                  }
               }
               if(this.guns[3].isHaveGun())
               {
                  if(GM.ckey.isKey("3"))
                  {
                     Czhujiemian.self.gunSlotCurrentState(3);
                     this.currentG = GS.a3;
                     param1.baseToMap(this.guns[3].mWeapon.getMcName());
                     return true;
                  }
               }
               if(this.guns[4].isHaveGun())
               {
                  if(GM.ckey.isKey("4"))
                  {
                     Czhujiemian.self.gunSlotCurrentState(4);
                     this.currentG = GS.a4;
                     param1.baseToMap(this.guns[4].mWeapon.getMcName());
                     return true;
                  }
               }
               break;
            case GS.a2:
               if(GM.ckey.isKey("1"))
               {
                  Czhujiemian.self.gunSlotCurrentState(1);
                  this.currentG = GS.a1;
                  param1.mapToBase();
                  return true;
               }
               if(this.guns[3].isHaveGun())
               {
                  if(GM.ckey.isKey("3"))
                  {
                     Czhujiemian.self.gunSlotCurrentState(3);
                     this.currentG = GS.a3;
                     param1.mapToMap(this.guns[3].mWeapon.getMcName());
                     return true;
                  }
               }
               if(this.guns[4].isHaveGun())
               {
                  if(GM.ckey.isKey("4"))
                  {
                     Czhujiemian.self.gunSlotCurrentState(4);
                     this.currentG = GS.a4;
                     param1.mapToMap(this.guns[4].mWeapon.getMcName());
                     return true;
                  }
               }
               break;
            case GS.a3:
               if(GM.ckey.isKey("1"))
               {
                  Czhujiemian.self.gunSlotCurrentState(1);
                  this.currentG = GS.a1;
                  param1.mapToBase();
                  return true;
               }
               if(this.guns[2].isHaveGun())
               {
                  if(GM.ckey.isKey("2"))
                  {
                     Czhujiemian.self.gunSlotCurrentState(2);
                     this.currentG = GS.a2;
                     param1.mapToMap(this.guns[2].mWeapon.getMcName());
                     return true;
                  }
               }
               if(this.guns[4].isHaveGun())
               {
                  if(GM.ckey.isKey("4"))
                  {
                     Czhujiemian.self.gunSlotCurrentState(4);
                     this.currentG = GS.a4;
                     param1.mapToMap(this.guns[4].mWeapon.getMcName());
                     return true;
                  }
               }
               break;
            case GS.a4:
               if(GM.ckey.isKey("1"))
               {
                  Czhujiemian.self.gunSlotCurrentState(1);
                  this.currentG = GS.a1;
                  param1.mapToBase();
                  return true;
               }
               if(this.guns[2].isHaveGun())
               {
                  if(GM.ckey.isKey("2"))
                  {
                     Czhujiemian.self.gunSlotCurrentState(2);
                     this.currentG = GS.a2;
                     param1.mapToMap(this.guns[2].mWeapon.getMcName());
                     return true;
                  }
               }
               if(this.guns[3].isHaveGun())
               {
                  if(GM.ckey.isKey("3"))
                  {
                     Czhujiemian.self.gunSlotCurrentState(3);
                     this.currentG = GS.a3;
                     param1.mapToMap(this.guns[3].mWeapon.getMcName());
                     return true;
                  }
               }
         }
         if(this.currentG > GS.a1)
         {
            if(GM.ckey.isKey("G"))
            {
               this.guns[this.currentG].lostGun();
               Czhujiemian.self.gunSlotCurrentState(1);
               Czhujiemian.self.showBulletNum(this.currentG,"0");
               Czhujiemian.self.gunSlotChangeGun(this.currentG,0);
               this.currentG = GS.a1;
               param1.lostMapWeapon();
            }
         }
         return false;
      }
      
      public function get gunSlotNum() : int
      {
         return this._gunSlotNum.getValue();
      }
      
      public function set gunSlotNum(param1:int) : void
      {
         this._gunSlotNum.setValue(param1);
      }
      
      public function get currentG() : int
      {
         return this._currentG.getValue();
      }
      
      public function set currentG(param1:int) : void
      {
         this._currentG.setValue(param1);
      }
   }
}

