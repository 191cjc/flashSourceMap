package hotpointgame.views.unionPanel
{
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   import hotpointgame.repository.unionVip.*;
   
   public class UnionPanelData
   {
      
      private var myUnion:MyUnion;
      
      private var unionList:Array = [];
      
      private var currUnionList:Array = [];
      
      private var currUnionCyList:Array = [];
      
      private var unionCyList:Array = [];
      
      private var skList:Array = [];
      
      private var currSkList:Array = [];
      
      private var unionAllNum:VT = VT.createVT(GS.a0);
      
      private var sqAllNum:VT = VT.createVT(GS.a0);
      
      private var gxValue:VT = VT.createVT(GS.a0);
      
      private var ggBlArr:Array = [];
      
      private var xfVt:VT = VT.createVT(GS.a0);
      
      private var isJs:VT = VT.createVT(GS.a0);
      
      private var ggBlIdArr:Array = [];
      
      private var mcMax:VT = VT.createVT(GS.a10);
      
      private var currMc:VT = VT.createVT(GS.a0);
      
      private var zjMax:VT = VT.createVT(GS.a100);
      
      private var xhZJ:VT = VT.createVT(GS.a0);
      
      private var evGxZj:VT = VT.createVT(GS.a0);
      
      private var evJsZj:VT = VT.createVT(GS.a0);
      
      private var jtzopenIdArr:Array = [79,81,80,78,77,75,76];
      
      private var jtzIdArr:Array = [[61,60,59],[67,66,65],[64,63,62],[58,57,56],[55,54,53],[49,48,47],[52,51,50]];
      
      private var jtzCsIdArr:Array = [72,74,73,71,70,68,69];
      
      private var jtzPhId:Array = [1103,1105,1104,1102,1101,1099,1100];
      
      private var myjtzData:Array = [];
      
      private var jtzDataArr:Array = [];
      
      private var jtzLqArr:Array = [VT.createVT(GS.a0),VT.createVT(GS.a0),VT.createVT(GS.a0),VT.createVT(GS.a0),VT.createVT(GS.a0),VT.createVT(GS.a0),VT.createVT(GS.a0)];
      
      private var overCs:VT = VT.createVT(GS.a0);
      
      public function UnionPanelData()
      {
         super();
      }
      
      public static function read(param1:Object = null) : UnionPanelData
      {
         var _loc3_:Array = null;
         var _loc4_:uint = 0;
         var _loc2_:UnionPanelData = new UnionPanelData();
         if(param1 != null)
         {
            _loc2_.gxValue = VT.createVT(param1["gx"]);
            _loc2_.isJs = VT.createVT(param1["js"]);
            if(param1["xf"] != null)
            {
               _loc2_.xfVt.setValue(param1["xf"]);
            }
            else
            {
               _loc2_.xfVt.setValue(GS.a0);
            }
            if(param1["xj"] != null)
            {
               _loc2_.xhZJ.setValue(param1["xj"]);
            }
            else
            {
               _loc2_.xhZJ.setValue(GS.a0);
            }
            if(param1["egj"] != null)
            {
               _loc2_.evGxZj.setValue(param1["egj"]);
            }
            else
            {
               _loc2_.evGxZj.setValue(GS.a0);
            }
            if(param1["ejj"] != null)
            {
               _loc2_.evJsZj.setValue(param1["ejj"]);
            }
            else
            {
               _loc2_.evJsZj.setValue(GS.a0);
            }
            if(param1["cum"] != null)
            {
               _loc2_.currMc.setValue(param1["cum"]);
            }
            else
            {
               _loc2_.currMc.setValue(GS.a0);
            }
            if(param1["jlq"] != null)
            {
               _loc3_ = param1["jlq"];
               _loc4_ = 0;
               while(_loc4_ < _loc3_.length)
               {
                  _loc2_.jtzLqArr[_loc4_] = VT.createVT(_loc3_[_loc4_]);
                  _loc4_++;
               }
            }
            else
            {
               _loc2_.jtzLqArr = [VT.createVT(GS.a0),VT.createVT(GS.a0),VT.createVT(GS.a0),VT.createVT(GS.a0),VT.createVT(GS.a0),VT.createVT(GS.a0),VT.createVT(GS.a0)];
            }
            if(param1["ov"] != null)
            {
               _loc2_.overCs = VT.createVT(param1["ov"]);
            }
            else
            {
               _loc2_.overCs = VT.createVT(GS.a0);
            }
         }
         else
         {
            _loc2_.isJs = VT.createVT(GS.a0);
            _loc2_.gxValue = VT.createVT(GS.a0);
            _loc2_.xfVt.setValue(GS.a0);
            _loc2_.xhZJ.setValue(GS.a0);
            _loc2_.evGxZj.setValue(GS.a0);
            _loc2_.evJsZj.setValue(GS.a0);
            _loc2_.currMc.setValue(GS.a0);
            _loc2_.jtzLqArr = [VT.createVT(GS.a0),VT.createVT(GS.a0),VT.createVT(GS.a0),VT.createVT(GS.a0),VT.createVT(GS.a0),VT.createVT(GS.a0),VT.createVT(GS.a0)];
         }
         _loc2_.unionList.length = 0;
         _loc2_.currUnionList.length = 0;
         _loc2_.unionCyList.length = 0;
         _loc2_.currUnionCyList.length = 0;
         _loc2_.unionAllNum = VT.createVT(GS.a0);
         _loc2_.sqAllNum = VT.createVT(GS.a0);
         _loc2_.skList.length = 0;
         _loc2_.currSkList.length = 0;
         _loc2_.ggBlArr.length = 0;
         _loc2_.ggBlIdArr = [6,7,8,9,10,11,12,13,61,62,63,64,65,66,67,68,69,70,71,72,76,77,78,79,80,81,82,83,84,85,86,87,88,99,90,91,92,93,94,95,96,97,98];
         _loc2_.mcMax = VT.createVT(GS.a10);
         _loc2_.zjMax = VT.createVT(GS.a100);
         _loc2_.jtzIdArr = [[61,62,63],[64,65,66],[67,68,69],[70,71,72],[76,77,78],[79,80,81],[82,83,84]];
         _loc2_.jtzCsIdArr = [85,86,87,88,99,90,91];
         _loc2_.jtzopenIdArr = [92,93,94,95,96,97,98];
         _loc2_.myjtzData = [];
         _loc2_.jtzDataArr = [];
         _loc2_.jtzPhId = [1103,1105,1104,1102,1101,1099,1100];
         return _loc2_;
      }
      
      public function getZjMax() : Number
      {
         return this.zjMax.getValue();
      }
      
      public function getMcMax() : Number
      {
         return this.mcMax.getValue();
      }
      
      public function save() : Object
      {
         var _loc1_:Object = new Object();
         _loc1_["gx"] = this.gxValue.getValue();
         _loc1_["js"] = this.isJs.getValue();
         _loc1_["xf"] = this.xfVt.getValue();
         _loc1_["xj"] = this.xhZJ.getValue();
         _loc1_["egj"] = this.evGxZj.getValue();
         _loc1_["ejj"] = this.evJsZj.getValue();
         _loc1_["cum"] = this.currMc.getValue();
         var _loc2_:Array = [];
         var _loc3_:uint = 0;
         while(_loc3_ < this.jtzLqArr.length)
         {
            _loc2_[_loc3_] = this.jtzLqArr[_loc3_].getValue();
            _loc3_++;
         }
         _loc1_["jlq"] = _loc2_;
         _loc1_["ov"] = this.overCs.getValue();
         return _loc1_;
      }
      
      public function getOVERcs() : Number
      {
         return this.overCs.getValue();
      }
      
      public function addOverCs() : void
      {
         if(this.overCs.getValue() < 2)
         {
            this.overCs.setValue(this.overCs.getValue() + GS.a1);
         }
      }
      
      public function getCurrMc() : Number
      {
         return this.currMc.getValue();
      }
      
      public function addCurrMc(param1:Number) : void
      {
         this.currMc.setValue(param1);
      }
      
      public function getZjGx() : Number
      {
         return this.evGxZj.getValue();
      }
      
      public function setZJgX(param1:Number) : void
      {
         this.evGxZj.setValue(param1);
      }
      
      public function getJSGx() : Number
      {
         return this.evJsZj.getValue();
      }
      
      public function setJSGx(param1:Number) : void
      {
         return this.evJsZj.setValue(param1);
      }
      
      public function evClear() : void
      {
         this.setZJgX(GS.a0);
         this.setJSGx(GS.a0);
         this.addCurrMc(GS.a0);
      }
      
      public function clearData() : void
      {
         this.isJs = VT.createVT(GS.a0);
         this.gxValue = VT.createVT(GS.a0);
         this.xfVt.setValue(GS.a0);
         this.xhZJ.setValue(GS.a0);
         this.addCurrMc(GS.a0);
         GoodsManger.dataList.uVipData.setVip(GS.a0);
         GoodsManger.dataList.uVipData.setEvLq(GS.a0);
         GoodsManger.dataList.unShop.initData();
      }
      
      public function getMyUnion() : MyUnion
      {
         return this.myUnion;
      }
      
      public function setMyUnion(param1:Object) : void
      {
         this.myUnion = MyUnion.createUnionEx(param1);
      }
      
      public function getCurrUnionList(param1:Number, param2:Number = 10) : Array
      {
         this.currUnionList.length = GS.a0;
         var _loc3_:uint = 0;
         while(_loc3_ < param2)
         {
            this.currUnionList.push(this.unionList[(param1 - 1) * param2 + _loc3_]);
            _loc3_++;
         }
         return this.currUnionList;
      }
      
      public function setUnionList(param1:Object) : void
      {
         var _loc2_:uint = 0;
         this.unionList.length = GS.a0;
         if(param1 != null)
         {
            this.setAllUntionNum(Number(param1.rowCount));
            if(param1.unionList.length != GS.a0)
            {
               _loc2_ = 0;
               while(_loc2_ < param1.unionList.length)
               {
                  this.unionList[_loc2_] = UnionData.createUnionData(param1.unionList[_loc2_]);
                  _loc2_++;
               }
               this.pmFun();
            }
         }
      }
      
      public function getUnionList() : Array
      {
         return this.unionList;
      }
      
      private function pmFun() : void
      {
         var _loc1_:UnionData = null;
         var _loc6_:Object = null;
         var _loc2_:Array = [];
         var _loc3_:Array = ["等级"];
         var _loc4_:Array = [Array.DESCENDING | Array.NUMERIC];
         var _loc5_:uint = 0;
         while(_loc5_ < this.unionList.length)
         {
            _loc1_ = this.unionList[_loc5_] as UnionData;
            _loc6_ = {
               "uObj":_loc1_,
               "等级":_loc1_.getLevel()
            };
            _loc2_[_loc5_] = _loc6_;
            _loc5_++;
         }
         _loc2_.sortOn(_loc3_,_loc4_);
         _loc5_ = 0;
         while(_loc5_ < _loc2_.length)
         {
            this.unionList[_loc5_] = _loc2_[_loc5_].uObj;
            (this.unionList[_loc5_] as UnionData).setPm(String(_loc5_ + 1));
            if(this.myUnion != null)
            {
               if(this.myUnion.getUnionId() == (this.unionList[_loc5_] as UnionData).getId())
               {
                  this.myUnion.setPm((this.unionList[_loc5_] as UnionData).getPm());
                  this.myUnion.setRs((this.unionList[_loc5_] as UnionData).getCount());
               }
            }
            _loc5_++;
         }
      }
      
      public function getAllYeUn() : Number
      {
         var _loc1_:Number = this.getUnionAllNum();
         var _loc2_:Number = int(_loc1_ / 10);
         if(_loc1_ % 10 > 0)
         {
            _loc2_ += 1;
         }
         return _loc2_;
      }
      
      public function setAllUntionNum(param1:Number) : void
      {
         this.unionAllNum.setValue(param1);
      }
      
      public function getUnionAllNum() : Number
      {
         return this.unionAllNum.getValue();
      }
      
      public function getUnionByKey(param1:Number) : UnionData
      {
         return this.currUnionList[param1];
      }
      
      public function getCurrUnionCyList() : Array
      {
         return this.currUnionCyList;
      }
      
      public function setUnionCyList(param1:Array) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:Array = null;
         var _loc4_:Array = null;
         var _loc5_:Array = null;
         var _loc6_:UnioinCy = null;
         var _loc7_:Object = null;
         if(param1.length != 0)
         {
            this.unionCyList.length = GS.a0;
            _loc2_ = 0;
            while(_loc2_ < param1.length)
            {
               this.unionCyList[_loc2_] = UnioinCy.createUnionCy(param1[_loc2_]);
               if((this.unionCyList[_loc2_] as UnioinCy).getId() == this.myUnion.getBzId())
               {
                  (this.unionCyList[_loc2_] as UnioinCy).setZw("团长");
                  (this.unionCyList[_loc2_] as UnioinCy).setZwBs(1);
               }
               else
               {
                  (this.unionCyList[_loc2_] as UnioinCy).setZw("成员");
                  (this.unionCyList[_loc2_] as UnioinCy).setZwBs(0);
               }
               _loc2_++;
            }
            _loc3_ = [];
            _loc4_ = ["职位","贡献"];
            _loc5_ = [Array.DESCENDING | Array.NUMERIC,Array.DESCENDING | Array.NUMERIC];
            _loc2_ = 0;
            while(_loc2_ < this.unionCyList.length)
            {
               _loc6_ = this.unionCyList[_loc2_] as UnioinCy;
               _loc7_ = {
                  "uObj":_loc6_,
                  "职位":_loc6_.getZwBs(),
                  "贡献":_loc6_.getContribution()
               };
               _loc3_[_loc2_] = _loc7_;
               _loc2_++;
            }
            _loc3_.sortOn(_loc4_,_loc5_);
            _loc2_ = 0;
            while(_loc2_ < _loc3_.length)
            {
               this.unionCyList[_loc2_] = _loc3_[_loc2_].uObj;
               _loc2_++;
            }
         }
      }
      
      public function getUnionCyList() : Array
      {
         return this.unionCyList;
      }
      
      public function getCurrCyList(param1:Number, param2:Number = 11) : Array
      {
         this.currUnionCyList.length = GS.a0;
         var _loc3_:uint = 0;
         while(_loc3_ < param2)
         {
            if(this.unionCyList[(param1 - 1) * param2 + _loc3_] != null)
            {
               this.currUnionCyList.push(this.unionCyList[(param1 - 1) * param2 + _loc3_]);
            }
            _loc3_++;
         }
         return this.currUnionCyList;
      }
      
      public function getAllYeCy() : Number
      {
         var _loc1_:Number = this.getUnionCyList().length;
         var _loc2_:Number = int(_loc1_ / 11);
         if(_loc1_ % 11 > 0)
         {
            _loc2_ += 1;
         }
         return _loc2_;
      }
      
      public function getCurrCy(param1:Number) : UnioinCy
      {
         return this.currUnionCyList[param1];
      }
      
      public function getGxValue() : Number
      {
         return this.gxValue.getValue();
      }
      
      public function addGxValue(param1:Number) : void
      {
         this.gxValue.setValue(this.gxValue.getValue() + param1);
      }
      
      public function deleteValue(param1:Number) : void
      {
         this.gxValue.setValue(this.gxValue.getValue() - param1);
      }
      
      public function setShList(param1:Object) : void
      {
         var _loc2_:uint = 0;
         if(param1 != null)
         {
            this.skList.length = GS.a0;
            this.sqAllNum.setValue(Number(param1.rowCount));
            if(param1.applyList.length != GS.a0)
            {
               _loc2_ = 0;
               while(_loc2_ < param1.applyList.length)
               {
                  this.skList[_loc2_] = UnionSq.createSq(param1.applyList[_loc2_]);
                  _loc2_++;
               }
            }
         }
      }
      
      public function setAllSq(param1:Number) : void
      {
         this.sqAllNum.setValue(param1);
      }
      
      public function getAllSq() : Number
      {
         return this.sqAllNum.getValue();
      }
      
      public function getCurrSqList(param1:Number, param2:Number = 6) : Array
      {
         this.currSkList.length = 0;
         var _loc3_:uint = 0;
         while(_loc3_ < param2)
         {
            if(this.skList[(param1 - 1) * param2 + _loc3_] != null)
            {
               this.currSkList.push(this.skList[(param1 - 1) * param2 + _loc3_]);
            }
            _loc3_++;
         }
         return this.currSkList;
      }
      
      public function getAllYeSq() : Number
      {
         var _loc1_:Number = Number(this.skList.length);
         var _loc2_:Number = int(_loc1_ / 6);
         if(_loc1_ % 6 > 0)
         {
            _loc2_ += 1;
         }
         return _loc2_;
      }
      
      public function getSqList() : Array
      {
         return this.skList;
      }
      
      public function getSqCyByKey(param1:Number) : UnionSq
      {
         return this.currSkList[param1];
      }
      
      public function getIsJs() : Number
      {
         return this.isJs.getValue();
      }
      
      public function setJs(param1:Number) : void
      {
         this.isJs.setValue(param1);
      }
      
      public function getLevel() : Number
      {
         if(this.myUnion == null)
         {
            return 0;
         }
         return this.myUnion.getUnionLevel();
      }
      
      public function getUname() : String
      {
         if(this.myUnion == null)
         {
            return "";
         }
         return this.myUnion.getUnionName();
      }
      
      public function setGgBl(param1:Array) : void
      {
         var _loc2_:uint = 0;
         this.ggBlArr.length = GS.a0;
         if(param1.length != GS.a0)
         {
            _loc2_ = 0;
            while(_loc2_ < param1.length)
            {
               this.ggBlArr[_loc2_] = UnionGgObj.createGgObj(param1[_loc2_]);
               _loc2_++;
            }
         }
      }
      
      public function getGgBl(param1:Number) : Number
      {
         var _loc3_:UnionGgObj = null;
         var _loc2_:VT = VT.createVT(GS.a0);
         if(this.ggBlArr.length != GS.a0)
         {
            for each(_loc3_ in this.ggBlArr)
            {
               if(_loc3_.getId() == param1)
               {
                  _loc2_.setValue(_loc3_.getValue());
                  break;
               }
            }
         }
         return _loc2_.getValue();
      }
      
      public function initLqJt() : void
      {
         this.jtzLqArr = [VT.createVT(GS.a0),VT.createVT(GS.a0),VT.createVT(GS.a0),VT.createVT(GS.a0),VT.createVT(GS.a0),VT.createVT(GS.a0),VT.createVT(GS.a0)];
      }
      
      public function initCs() : void
      {
         this.overCs.setValue(GS.a0);
      }
      
      public function tjPhb(param1:Number, param2:Number) : void
      {
         var _loc5_:Object = null;
         var _loc6_:Object = null;
         var _loc3_:Array = [];
         var _loc4_:uint = param1;
         while(_loc4_ <= param2)
         {
            _loc5_ = new Object();
            _loc5_.rId = this.getPhbId(_loc4_);
            _loc5_.score = this.getJdBlByKey(_loc4_);
            _loc6_ = new Object();
            _loc6_.uid = this.getMyUnion().getUnionId();
            _loc6_.na = this.getMyUnion().getUnionName();
            _loc6_.vip = this.getGgBl(GS.a6);
            _loc5_.extra = _loc6_;
            _loc3_.push(_loc5_);
            _loc4_++;
         }
         GM.testapi.submitGFScoreLists(_loc3_);
      }
      
      public function tjFsTest(param1:Number) : void
      {
         var _loc2_:Array = [];
         var _loc3_:Object = new Object();
         _loc3_.rId = this.getPhbId(0);
         _loc3_.score = param1;
         var _loc4_:Object = new Object();
         _loc4_.uid = this.getMyUnion().getUnionId();
         _loc4_.na = this.getMyUnion().getUnionName();
         _loc4_.vip = this.getGgBl(GS.a6);
         _loc3_.extra = _loc4_;
         _loc2_.push(_loc3_);
         GM.testapi.submitGFScoreLists(_loc2_);
      }
      
      public function getJtLq(param1:Number) : Number
      {
         return this.jtzLqArr[param1].getValue();
      }
      
      public function setJtLq(param1:Number, param2:Number) : void
      {
         this.jtzLqArr[param1] = VT.createVT(param2);
      }
      
      public function getPhbId(param1:Number) : Number
      {
         return this.jtzPhId[param1];
      }
      
      public function getJdBlByKey(param1:Number) : Number
      {
         var _loc2_:Array = this.jtzIdArr[param1];
         var _loc3_:VT = VT.createVT(GS.a0);
         var _loc4_:uint = 0;
         while(_loc4_ < _loc2_.length)
         {
            _loc3_.setValue(_loc3_.getValue() + this.getGgBl(_loc2_[_loc4_]) * (GS.a3 + _loc4_));
            _loc4_++;
         }
         if(_loc3_.getValue() == 0)
         {
            return 1;
         }
         return _loc3_.getValue();
      }
      
      public function getJdCs(param1:Number) : Number
      {
         if(this.getGgBl(this.jtzCsIdArr[param1]) < 0)
         {
            return 0;
         }
         return this.getGgBl(this.jtzCsIdArr[param1]);
      }
      
      public function getOverCsId(param1:Number) : Number
      {
         return this.jtzCsIdArr[param1];
      }
      
      public function getJdOpen(param1:Number) : Number
      {
         return this.getGgBl(this.jtzopenIdArr[param1]);
      }
      
      public function getkqiD(param1:Number) : Number
      {
         return this.jtzopenIdArr[param1];
      }
      
      public function getMyJtzPh(param1:Number) : GhzData
      {
         return this.myjtzData[param1];
      }
      
      public function setMyjtz(param1:Object, param2:Number) : void
      {
         if(param1 != null)
         {
            this.myjtzData[param2] = GhzData.crateAttCyData(param1);
         }
      }
      
      public function getjtzArr(param1:Number) : Array
      {
         return this.jtzDataArr[param1];
      }
      
      public function getMyPmData(param1:Number) : GhzData
      {
         var _loc3_:GhzData = null;
         var _loc2_:Array = this.getjtzArr(param1);
         for each(_loc3_ in _loc2_)
         {
            if(_loc3_.getUnId() == this.myUnion.getUnionId())
            {
               return _loc3_;
            }
         }
         return null;
      }
      
      public function getNbOne(param1:Number) : Boolean
      {
         var _loc3_:Array = null;
         var _loc4_:Array = null;
         var _loc5_:Array = null;
         var _loc6_:Array = null;
         var _loc7_:uint = 0;
         var _loc8_:GhzData = null;
         var _loc9_:GhzData = null;
         var _loc10_:Object = null;
         var _loc2_:Array = this.getjtzArr(param1);
         if(_loc2_.length == 0)
         {
            return false;
         }
         if(this.getMyPmData(param1).getRank() == GS.a1)
         {
            _loc3_ = [];
            _loc4_ = ["排名","荣耀"];
            _loc5_ = [Array.NUMERIC,Array.DESCENDING | Array.NUMERIC];
            _loc6_ = [];
            _loc7_ = 0;
            while(_loc7_ < _loc2_.length)
            {
               _loc9_ = _loc2_[_loc7_] as GhzData;
               _loc10_ = {
                  "obj":_loc9_,
                  "排名":_loc9_.getRank(),
                  "荣耀":_loc9_.getVipRy()
               };
               _loc3_.push(_loc10_);
               _loc7_++;
            }
            _loc3_.sortOn(_loc4_,_loc5_);
            _loc7_ = 0;
            while(_loc7_ < _loc3_.length)
            {
               _loc6_.push(_loc3_[_loc7_].obj);
               _loc7_++;
            }
            _loc8_ = _loc6_[0];
            if(this.myUnion.getUnionId() == _loc8_.getUnId())
            {
               return true;
            }
         }
         return false;
      }
      
      public function setJtzList(param1:Array, param2:Number) : void
      {
         var _loc3_:Array = null;
         var _loc4_:uint = 0;
         if(param1.length != 0)
         {
            _loc3_ = [];
            _loc4_ = 0;
            while(_loc4_ < param1.length)
            {
               _loc3_[_loc4_] = GhzData.crateAttCyData(param1[_loc4_]);
               _loc4_++;
            }
            this.jtzDataArr[param2] = _loc3_;
         }
      }
      
      public function getJtzJgTime() : Boolean
      {
         var _loc1_:Date = new Date(FlowInterface.getCurrTimer() + GS.a8 * GS.a60 * GS.a60 * GS.a1000);
         if(_loc1_.dayUTC == GS.a0)
         {
            return false;
         }
         return true;
      }
      
      public function addUnJf(param1:Number, param2:Number) : void
      {
         var _loc3_:Array = [4007,4006,4001,4004,4005,4002,4003];
         var _loc4_:uint = 0;
         while(_loc4_ < _loc3_.length)
         {
            if(param1 == _loc3_[_loc4_])
            {
               GM.testapi.changeVarValue(this.jtzIdArr[_loc4_][param2]);
               return;
            }
            _loc4_++;
         }
      }
      
      public function gotoGk(param1:Number) : Number
      {
         var _loc2_:Array = [4007,4006,4001,4004,4005,4002,4003];
         return _loc2_[param1];
      }
      
      public function getXf() : Number
      {
         return this.xfVt.getValue();
      }
      
      public function setXf(param1:Number) : void
      {
         this.xfVt.setValue(param1);
      }
      
      public function getGbId() : Array
      {
         return this.ggBlIdArr;
      }
      
      public function getZj() : Number
      {
         return this.xhZJ.getValue();
      }
      
      public function addXhZJ(param1:Number) : void
      {
         this.xhZJ.setValue(this.xhZJ.getValue() + param1);
      }
      
      public function getXhZj() : Number
      {
         return this.getMyUnion().getXfZJ();
      }
      
      public function getNowZj() : Number
      {
         if(this.getGgBl(GS.a13) * GS.a10000 - this.getXhZj() <= GS.a0)
         {
            this.xhZJ.setValue(this.getGgBl(GS.a13) * GS.a10000);
         }
         return this.getGgBl(GS.a13) * GS.a10000 - this.getXhZj();
      }
      
      public function getAlLJs() : Number
      {
         return this.getGgBl(GS.a8);
      }
      
      public function getShopJs() : Number
      {
         return UnionVipFactory.getDataZy(GS.a0,GS.a0,GoodsManger.dataList.unShop.getLevel());
      }
      
      public function getJsOver() : Number
      {
         return this.getShopJs();
      }
      
      public function getSyJs() : Number
      {
         return this.getAlLJs() - this.getJsOver();
      }
   }
}

