package hotpointgame.savedatal
{
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   import hotpointgame.models.bag.*;
   
   public class ShengxiaoDouHun
   {
      
      private var _id:VT = VT.createVT(0);
      
      private var _curColor:VT = VT.createVT(0);
      
      private var _curlevel:VT = VT.createVT(0);
      
      private var _curExp:VT = VT.createVT(0);
      
      private var _uplvLimit:VT = VT.createVT(0);
      
      public function ShengxiaoDouHun()
      {
         super();
      }
      
      public static function readData(param1:Object) : ShengxiaoDouHun
      {
         var _loc2_:ShengxiaoDouHun = new ShengxiaoDouHun();
         _loc2_.id = param1.id;
         _loc2_.curColor = param1.colv;
         _loc2_.curlevel = param1.clv;
         _loc2_.curExp = param1.cex;
         _loc2_.uplvLimit = param1.upl;
         return _loc2_;
      }
      
      public function save() : Object
      {
         var _loc1_:Object = new Object();
         _loc1_.id = this.id;
         _loc1_.colv = this.curColor;
         _loc1_.clv = this.curlevel;
         _loc1_.cex = this.curExp;
         _loc1_.upl = this.uplvLimit;
         return _loc1_;
      }
      
      public function addExp() : void
      {
         if(this.getLevelUp() <= this.curlevel)
         {
            return;
         }
         this.curExp += GS.a50;
         var _loc1_:int = this.getNextExp();
         if(_loc1_ <= this.curExp)
         {
            this.curExp -= _loc1_;
            this.curlevel += GS.a1;
            if(this.getLevelUp() <= this.curlevel)
            {
               this.curExp = 0;
            }
         }
      }
      
      public function getUpLimitXuPId() : int
      {
         if(!this.isKeYiUpLimit())
         {
            GM.findCheatMax(GS.a58);
            return 999999;
         }
         return GS.a650 + GS.a24 + this.uplvLimit;
      }
      
      public function getUpLimitXuMoney() : int
      {
         var _loc1_:int = 0;
         if(!this.isKeYiUpLimit())
         {
            GM.findCheatMax(GS.a58);
            return 999999;
         }
         _loc1_ = GS.a1000 * this.uplvLimit;
         if(_loc1_ == 0)
         {
            _loc1_ = int(GS.a500);
         }
         return _loc1_;
      }
      
      public function addUplimitOk() : void
      {
         if(!this.isKeYiUpLimit())
         {
            GM.findCheatMax(GS.a58);
         }
         this.uplvLimit += GS.a1;
      }
      
      public function addColor() : void
      {
         if(this.isKeYiChColor())
         {
            this.curColor += GS.a1;
         }
      }
      
      public function getChColorXuPid() : int
      {
         return GS.a331088 + GS.a1 * this.curColor;
      }
      
      public function isKeYiChColor() : Boolean
      {
         return this.curColor < GS.a3;
      }
      
      public function getLevelUp() : int
      {
         return GS.a70 + this.uplvLimit * GS.a10;
      }
      
      public function isDaoLeLevelUP() : Boolean
      {
         return this.getLevelUp() <= this.curlevel;
      }
      
      public function getAddatt() : Number
      {
         var _loc1_:TwelveDouHunBaseData = TwelveShengXiaoMangager.getDouHunDataById(this.id);
         return this.curlevel * (this.curColor * GS.a03 + GS.a1) * _loc1_.getAddAtt();
      }
      
      public function getNextAddatt() : Number
      {
         var _loc1_:TwelveDouHunBaseData = TwelveShengXiaoMangager.getDouHunDataById(this.id);
         return (this.curlevel + GS.a1) * (this.curColor * GS.a03 + GS.a1) * _loc1_.getAddAtt();
      }
      
      public function getNextExp() : int
      {
         return GS.a100 + Math.pow(GS.a1 + this.curlevel,GS.a1 + GS.a05);
      }
      
      public function getName() : String
      {
         var _loc1_:TwelveDouHunBaseData = TwelveShengXiaoMangager.getDouHunDataById(this.id);
         return _loc1_.name;
      }
      
      public function getAttBName() : String
      {
         var _loc1_:TwelveDouHunBaseData = TwelveShengXiaoMangager.getDouHunDataById(this.id);
         return _loc1_.attname;
      }
      
      public function getUpGod() : int
      {
         var _loc1_:TwelveDouHunBaseData = TwelveShengXiaoMangager.getDouHunDataById(this.id);
         return _loc1_.pgod;
      }
      
      public function getUpPid() : int
      {
         var _loc1_:TwelveDouHunBaseData = TwelveShengXiaoMangager.getDouHunDataById(this.id);
         return _loc1_.pId;
      }
      
      public function isKeYiAddExp() : Boolean
      {
         var _loc1_:TwelveDouHunBaseData = TwelveShengXiaoMangager.getDouHunDataById(this.id);
         if(_loc1_.pgod > GM.cp.getGodByRole() || BagFactory.getNumById(_loc1_.pId) < GS.a1 || this.isDaoLeLevelUP())
         {
            return false;
         }
         return true;
      }
      
      public function isKeYiUpLimit() : Boolean
      {
         return this.uplvLimit < GS.a3;
      }
      
      public function get id() : int
      {
         return this._id.getValue();
      }
      
      public function set id(param1:int) : void
      {
         this._id.setValue(param1);
      }
      
      public function get curlevel() : int
      {
         return this._curlevel.getValue();
      }
      
      public function set curlevel(param1:int) : void
      {
         this._curlevel.setValue(param1);
      }
      
      public function get curExp() : int
      {
         return this._curExp.getValue();
      }
      
      public function set curExp(param1:int) : void
      {
         this._curExp.setValue(param1);
      }
      
      public function get curColor() : int
      {
         return this._curColor.getValue();
      }
      
      public function set curColor(param1:int) : void
      {
         this._curColor.setValue(param1);
      }
      
      public function get uplvLimit() : int
      {
         return this._uplvLimit.getValue();
      }
      
      public function set uplvLimit(param1:int) : void
      {
         this._uplvLimit.setValue(param1);
      }
   }
}

