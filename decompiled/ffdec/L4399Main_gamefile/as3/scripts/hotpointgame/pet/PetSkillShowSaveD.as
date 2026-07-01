package hotpointgame.pet
{
   import hotpointgame.common.*;
   
   public class PetSkillShowSaveD
   {
      
      private static var expArr:Array = initexpAll();
      
      private var _basedataid:VT = VT.createVT(0);
      
      private var _curExp:VT = VT.createVT(0);
      
      private var _curLv:VT = VT.createVT(1);
      
      private var _tempBD:PetSkillShowBD;
      
      public function PetSkillShowSaveD()
      {
         super();
      }
      
      private static function initexpAll() : Array
      {
         var _loc3_:int = 0;
         var _loc1_:Array = new Array();
         var _loc2_:int = 0;
         while(_loc2_ < 4)
         {
            _loc1_[_loc2_] = new Array();
            _loc3_ = int(GS.a1);
            while(_loc3_ <= GS.a100)
            {
               if(_loc3_ == 1)
               {
                  _loc1_[_loc2_][_loc3_] = (Math.pow(GS.a2 + _loc3_,GS.a1 + GS.a04) + GS.a400) * (_loc2_ * GS.a03 + GS.a1);
               }
               else
               {
                  _loc1_[_loc2_][_loc3_] = (Math.pow(GS.a2 + _loc3_,GS.a1 + GS.a04) + GS.a400) * (_loc2_ * GS.a03 + GS.a1) + _loc1_[_loc2_][_loc3_ - 1];
               }
               _loc3_++;
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      public static function readData(param1:Object = null) : PetSkillShowSaveD
      {
         var _loc2_:PetSkillShowSaveD = new PetSkillShowSaveD();
         if(param1 != null)
         {
            _loc2_.basedataid = param1.bid;
            _loc2_.curExp = param1.cexp;
            _loc2_.curLv = param1.clv;
         }
         return _loc2_;
      }
      
      public function save() : Object
      {
         var _loc1_:Object = new Object();
         _loc1_.bid = this.basedataid;
         _loc1_.cexp = this.curExp;
         _loc1_.clv = this.curLv;
         return _loc1_;
      }
      
      public function initBDid(param1:int) : void
      {
         this.basedataid = param1;
         this.tempBD = PetDataManager.getPetSkillShowById(this.basedataid);
         this.addSkillExp(this.tempBD.initexp);
      }
      
      public function getNextLvExp() : int
      {
         return expArr[this.getscolor()][this.curLv];
      }
      
      public function addSkillExp(param1:int) : void
      {
         if(param1 < 0)
         {
            return;
         }
         if(this.curLv == GS.a100)
         {
            return;
         }
         this.curExp += param1;
         if(this.curExp > this.getNextLvExp())
         {
            while(this.curExp > this.getNextLvExp())
            {
               this.curLv += GS.a1;
               if(this.curLv == GS.a100)
               {
                  break;
               }
            }
         }
      }
      
      public function getsname() : String
      {
         return this.tempBD.sname;
      }
      
      public function getFrameNum() : int
      {
         return this.tempBD.frameNum;
      }
      
      public function getsshuomi() : String
      {
         if(this.basedataid >= GS.a10000)
         {
            return "" + this.tempBD.sshuomi[0];
         }
         return "" + this.tempBD.sshuomi[0] + ((this.tempBD.hurtIxishu * this.curLv + this.tempBD.hurtIshu) * GS.a100).toFixed(2) + this.tempBD.sshuomi[1];
      }
      
      public function getHurtBi() : Number
      {
         return this.tempBD.hurtIxishu * this.curLv + this.tempBD.hurtIshu;
      }
      
      public function getscolor() : int
      {
         return this.tempBD.scolor;
      }
      
      public function getsfid() : String
      {
         return this.tempBD.sfid + "1";
      }
      
      public function getFightPotLimit() : int
      {
         return this.tempBD.potlimitv;
      }
      
      public function get basedataid() : int
      {
         return this._basedataid.getValue();
      }
      
      public function set basedataid(param1:int) : void
      {
         this._basedataid.setValue(param1);
      }
      
      public function get curExp() : int
      {
         return this._curExp.getValue();
      }
      
      public function set curExp(param1:int) : void
      {
         this._curExp.setValue(param1);
      }
      
      public function get curLv() : int
      {
         return this._curLv.getValue();
      }
      
      public function set curLv(param1:int) : void
      {
         this._curLv.setValue(param1);
      }
      
      public function get tempBD() : PetSkillShowBD
      {
         if(this._tempBD == null)
         {
            this.tempBD = PetDataManager.getPetSkillShowById(this.basedataid);
         }
         return this._tempBD;
      }
      
      public function set tempBD(param1:PetSkillShowBD) : void
      {
         this._tempBD = param1;
      }
   }
}

