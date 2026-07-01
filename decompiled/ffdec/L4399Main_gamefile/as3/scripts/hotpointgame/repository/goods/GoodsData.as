package hotpointgame.repository.goods
{
   import flash.text.*;
   import hotpointgame.common.*;
   import hotpointgame.models.goods.*;
   import hotpointgame.utils.*;
   
   public class GoodsData
   {
      
      private var _id:VT = VT.createVT(-1);
      
      private var _frame:VT = VT.createVT(-1);
      
      private var _name:String = null;
      
      private var _color:VT = VT.createVT(-1);
      
      private var _fixAtSx:Array = [];
      
      private var _quality:VT = VT.createVT(-1);
      
      private var _useLevel:VT = VT.createVT(-1);
      
      private var _createLevel:VT = VT.createVT(-1);
      
      private var _type:VT = VT.createVT(-1);
      
      private var _smallType:VT = VT.createVT(-1);
      
      private var _wmd:VT = VT.createVT(GS.a0);
      
      private var _isWmd:VT = VT.createVT(GS.a0);
      
      private var _wmdId:VT = VT.createVT(GS.a0);
      
      private var _wmJb:VT = VT.createVT(GS.a0);
      
      private var _wmSl:VT = VT.createVT(GS.a0);
      
      private var _wmMax:VT = VT.createVT(GS.a0);
      
      private var _directions:String = null;
      
      private var _price:VT = VT.createVT(-1);
      
      private var _overlapping:VT = VT.createVT(-1);
      
      private var _overTime:VT = VT.createVT(-1);
      
      private var _bagNum:VT = VT.createVT(-1);
      
      private var _isSell:Boolean = false;
      
      private var _isUse:Boolean = false;
      
      private var _gdBo:Array = [];
      
      private var _jd:VT = VT.createVT(-1);
      
      private var _hcGold:VT = VT.createVT(-1);
      
      private var _hcQj:Array = [];
      
      private var _shopG:VT = VT.createVT(-1);
      
      private var _isStreng:VT = VT.createVT(-1);
      
      private var _job:VT = VT.createVT(-1);
      
      private var _fiveSx:Array = [];
      
      private var _skill:Array = [];
      
      private var _gemSolt:VT = VT.createVT(-1);
      
      private var _suiteId:VT = VT.createVT(-1);
      
      private var _attAlter:VT = VT.createVT(-1);
      
      private var _defense:VT = VT.createVT(-1);
      
      private var _cannon:VT = VT.createVT(-1);
      
      private var _equipType:VT = VT.createVT(-1);
      
      private var _shootSpeed:VT = VT.createVT(-1);
      
      private var _bombNum:VT = VT.createVT(-1);
      
      private var _bombMaxNum:VT = VT.createVT(-1);
      
      private var _mcName:String = null;
      
      private var _cj1:String = null;
      
      private var _cj2:String = null;
      
      private var _wxBo:Boolean;
      
      private var _otherValue:VT = VT.createVT(-1);
      
      private var _isbfb:Boolean = false;
      
      private var _lwId:Array = [];
      
      private var _lwNum:Array = [];
      
      private var _needId:Array = [];
      
      private var _needNum:Array = [];
      
      private var _rewGl:Array = [];
      
      public function GoodsData()
      {
         super();
      }
      
      private static function strToArr(param1:String) : Array
      {
         var _loc2_:Array = param1.split("*");
         var _loc3_:Array = [];
         var _loc4_:uint = 0;
         while(_loc4_ < _loc2_.length)
         {
            if(Boolean(Number(_loc2_[_loc4_])) || _loc2_[_loc4_] == 0)
            {
               _loc3_.push(VT.createVT(Number(_loc2_[_loc4_])));
            }
            else
            {
               _loc3_.push(String(_loc2_[_loc4_]));
            }
            _loc4_++;
         }
         return _loc3_;
      }
      
      public function createSameData(param1:Number, param2:Number, param3:String, param4:Number, param5:Array, param6:Number, param7:Number, param8:Number, param9:Number, param10:Number, param11:String, param12:Number, param13:Number, param14:Number, param15:Number, param16:Boolean, param17:Boolean, param18:String, param19:Number, param20:Number, param21:String, param22:Number, param23:Number, param24:Number, param25:Number, param26:Number, param27:Number) : void
      {
         this._id = VT.createVT(param1);
         this._frame = VT.createVT(param2);
         this._name = param3;
         this._color = VT.createVT(param4);
         this._fixAtSx = param5;
         this._quality = VT.createVT(param6);
         this._useLevel = VT.createVT(param7);
         this._createLevel = VT.createVT(param8);
         this._type = VT.createVT(param9);
         this._smallType = VT.createVT(param10);
         this._directions = param11;
         this._price = VT.createVT(param12);
         this._overlapping = VT.createVT(param13);
         this._overTime = VT.createVT(param14);
         this._bagNum = VT.createVT(param15);
         this._isSell = param16;
         this._isUse = param17;
         this._gdBo = strToArr(param18);
         this._jd = VT.createVT(param19);
         this._hcGold = VT.createVT(param20);
         this._hcQj = strToArr(param21);
         this._shopG = VT.createVT(param22);
         this._wmd = VT.createVT(GS.a0);
         this._isWmd = VT.createVT(param23);
         this._wmdId = VT.createVT(param24);
         this._wmJb = VT.createVT(param25);
         this._wmSl = VT.createVT(param26);
         this._wmMax = VT.createVT(param27);
      }
      
      public function creatEquipData(param1:Number, param2:Number, param3:Array, param4:Array, param5:Number, param6:Number, param7:Number, param8:Number, param9:Number, param10:Number, param11:Number, param12:Number, param13:Number, param14:String, param15:String, param16:String, param17:Boolean) : void
      {
         this._isStreng = VT.createVT(param1);
         this._job = VT.createVT(param2);
         this._fiveSx = param3;
         this._skill = param4;
         this._gemSolt = VT.createVT(param5);
         this._suiteId = VT.createVT(param6);
         this._attAlter = VT.createVT(param7);
         this._defense = VT.createVT(param8);
         this._cannon = VT.createVT(param9);
         this._equipType = VT.createVT(param10);
         this._shootSpeed = VT.createVT(param11);
         this._bombNum = VT.createVT(param12);
         this._bombMaxNum = VT.createVT(param13);
         this._mcName = param14;
         this._cj1 = param15;
         this._cj2 = param16;
         this._wxBo = param17;
      }
      
      public function creatOtherData(param1:Number, param2:Boolean, param3:String, param4:String, param5:String, param6:String, param7:String) : void
      {
         this._otherValue = VT.createVT(param1);
         this._isbfb = param2;
         this._lwId = strToArr(param3);
         this._lwNum = strToArr(param4);
         this._needId = strToArr(param5);
         this._needNum = strToArr(param6);
         this._rewGl = strToArr(param7);
      }
      
      public function getWmMax() : Number
      {
         return this._wmMax.getValue();
      }
      
      public function getWmd() : Number
      {
         return this._wmd.getValue();
      }
      
      public function getIsWm() : Number
      {
         return this._isWmd.getValue();
      }
      
      public function getWmId() : Number
      {
         return this._wmdId.getValue();
      }
      
      public function getWmSl() : Number
      {
         return this._wmSl.getValue();
      }
      
      public function getWmJb() : Number
      {
         return this._wmJb.getValue();
      }
      
      public function getGdBo() : Array
      {
         var _loc1_:Array = [];
         var _loc2_:uint = 0;
         while(_loc2_ < this._gdBo.length)
         {
            _loc1_.push(this._gdBo[_loc2_].getValue());
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function getWxBo() : Boolean
      {
         return this._wxBo;
      }
      
      public function getId() : Number
      {
         return this._id.getValue();
      }
      
      public function getFrame() : Number
      {
         return this._frame.getValue();
      }
      
      public function getName() : String
      {
         return this._name;
      }
      
      public function getColor() : Number
      {
         return this._color.getValue();
      }
      
      public function getFixSx() : Array
      {
         return DeepCopyUtil.clone(this._fixAtSx);
      }
      
      public function getQuality() : Number
      {
         return this._quality.getValue();
      }
      
      public function getUseLevel() : Number
      {
         return this._useLevel.getValue();
      }
      
      public function getCreateLevel() : Number
      {
         return this._createLevel.getValue();
      }
      
      public function getType() : Number
      {
         return this._type.getValue();
      }
      
      public function getSmallType() : Number
      {
         return this._smallType.getValue();
      }
      
      public function getDirections() : String
      {
         return this._directions;
      }
      
      public function getPrice() : Number
      {
         return this._price.getValue();
      }
      
      public function getOverlapping() : Number
      {
         return this._overlapping.getValue();
      }
      
      public function getOverTimer() : Number
      {
         return this._overTime.getValue();
      }
      
      public function getbagNum() : Number
      {
         return this._bagNum.getValue();
      }
      
      public function getJd() : Number
      {
         return this._jd.getValue();
      }
      
      public function getHcJg() : Number
      {
         return this._hcGold.getValue();
      }
      
      public function getHcQj() : Array
      {
         var _loc1_:Array = [];
         var _loc2_:uint = 0;
         while(_loc2_ < this._hcQj.length)
         {
            _loc1_.push(this._hcQj[_loc2_].getValue());
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function getShopG() : Number
      {
         return this._shopG.getValue();
      }
      
      public function isStrengBo() : Number
      {
         return this._isStreng.getValue();
      }
      
      public function isAttAlter() : Number
      {
         return this._attAlter.getValue();
      }
      
      public function isDefense() : Number
      {
         return this._defense.getValue();
      }
      
      public function isCannon() : Number
      {
         return this._cannon.getValue();
      }
      
      public function getJob() : Number
      {
         return this._job.getValue();
      }
      
      public function getFiveSxType() : Number
      {
         var _loc1_:int = 0;
         if(this._fiveSx.length != 0)
         {
            _loc1_ = Math.floor(Math.random() * (this._fiveSx.length - 1));
            return (this._fiveSx[_loc1_] as BasicSx).getSxType();
         }
         return -1;
      }
      
      public function getSkill() : Array
      {
         var _loc2_:uint = 0;
         var _loc1_:Array = [];
         if(this._skill.length != 0)
         {
            _loc2_ = 0;
            while(_loc2_ < this._skill.length)
            {
               _loc1_.push(this._skill[_loc2_].getValue());
               _loc2_++;
            }
         }
         return _loc1_;
      }
      
      public function getFiveSx() : Array
      {
         return this._fiveSx;
      }
      
      public function getSuite() : Number
      {
         return this._suiteId.getValue();
      }
      
      public function getEquipType() : Number
      {
         return this._equipType.getValue();
      }
      
      public function getShootSpeed() : Number
      {
         return this._shootSpeed.getValue();
      }
      
      public function getBombNum() : Number
      {
         return this._bombNum.getValue();
      }
      
      public function getBombNumMax() : Number
      {
         return this._bombMaxNum.getValue();
      }
      
      public function getMcName() : String
      {
         return this._mcName;
      }
      
      public function getCj1() : String
      {
         return this._cj1;
      }
      
      public function getCj2() : String
      {
         return this._cj2;
      }
      
      public function isUse() : Boolean
      {
         return this._isUse;
      }
      
      public function isSell() : Boolean
      {
         return this._isSell;
      }
      
      public function getOtherValue() : Number
      {
         return this._otherValue.getValue();
      }
      
      public function isBfb() : Boolean
      {
         return this._isbfb;
      }
      
      public function getLwId() : Array
      {
         var _loc1_:Array = [];
         var _loc2_:uint = 0;
         while(_loc2_ < this._lwId.length)
         {
            _loc1_.push(this._lwId[_loc2_].getValue());
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function getLwNum() : Array
      {
         var _loc1_:Array = [];
         var _loc2_:uint = 0;
         while(_loc2_ < this._lwNum.length)
         {
            _loc1_.push(this._lwNum[_loc2_].getValue());
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function getNeedId() : Array
      {
         var _loc1_:Array = [];
         var _loc2_:uint = 0;
         while(_loc2_ < this._needId.length)
         {
            _loc1_.push(this._needId[_loc2_].getValue());
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function getNeedNum() : Array
      {
         var _loc1_:Array = [];
         var _loc2_:uint = 0;
         while(_loc2_ < this._needNum.length)
         {
            _loc1_.push(this._needNum[_loc2_].getValue());
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function getRewGl() : Array
      {
         var _loc1_:Array = [];
         var _loc2_:uint = 0;
         while(_loc2_ < this._rewGl.length)
         {
            _loc1_.push(this._rewGl[_loc2_].getValue());
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function getColorStr() : TextFormat
      {
         var _loc1_:TextFormat = null;
         if(_loc1_ == null)
         {
            _loc1_ = new TextFormat();
         }
         switch(this.getColor())
         {
            case 0:
               _loc1_.color = "0xffffff";
               break;
            case 1:
               _loc1_.color = "0x0066ff";
               break;
            case 2:
               _loc1_.color = "0xFF33FF";
               break;
            case 3:
               _loc1_.color = "0xffcc00";
               break;
            case 4:
               _loc1_.color = "0xff0000";
         }
         return _loc1_;
      }
      
      public function createGoods() : Goods
      {
         var _loc1_:Object = new Object();
         if(this._type.getValue() == 0)
         {
            if(this._smallType.getValue() == 3 || this._smallType.getValue() == 7)
            {
               _loc1_ = {
                  "gj":VT.createVT(0),
                  "fy":VT.createVT(0),
                  "fp":VT.createVT(0)
               };
            }
            else if(this._smallType.getValue() == 0)
            {
               _loc1_ = {
                  "sx":VT.createVT(this.getFiveSxType()),
                  "qh":VT.createVT(0),
                  "gs":EquipGemSlot.createSlot(this._gemSolt.getValue()),
                  "wq":new Array(),
                  "wm":VT.createVT(GS.a0)
               };
            }
            else
            {
               _loc1_ = {
                  "sx":VT.createVT(this.getFiveSxType()),
                  "qh":VT.createVT(0),
                  "gs":EquipGemSlot.createSlot(this._gemSolt.getValue()),
                  "wm":VT.createVT(GS.a0)
               };
            }
         }
         else
         {
            _loc1_ = {"wm":VT.createVT(GS.a0)};
         }
         return Goods.createGoods(this._id.getValue(),_loc1_);
      }
   }
}

