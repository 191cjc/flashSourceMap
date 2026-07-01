package hotpointgame.gameobj
{
   import com.adobeadobe.serialization.json.JSON;
   import flash.events.DataEvent;
   import flash.events.Event;
   import flash.utils.*;
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   import hotpointgame.common.event.*;
   import hotpointgame.datapk.*;
   import hotpointgame.glevel.leveldata.*;
   import hotpointgame.grole.*;
   import hotpointgame.gskilllevel.*;
   import hotpointgame.gview.*;
   import hotpointgame.savedatal.*;
   import hotpointgame.utils.*;
   import hotpointgame.views.vipPanel.*;
   import unit4399.events.*;
   
   public class ApiInterface
   {
      
      protected var _userId:VT = VT.createVT(0);
      
      public var userName:String = "";
      
      public var idName:String = "";
      
      public var dataList:Array;
      
      protected var _dataIndex:VT = VT.createVT(0);
      
      protected var idarr:Array = new Array(46970618,559538673,647245645,290029157,450152135,52545208,1035807559,925277563,843980789,980735052,984424036);
      
      public var smp:MPlayer;
      
      protected var leafTimer:VT = VT.createVT(GS.a0);
      
      public var isShowSaveS:Boolean = false;
      
      protected var timerList:Vector.<Function> = new Vector.<Function>();
      
      protected var saveokList:Vector.<Function> = new Vector.<Function>();
      
      protected var getstateList:Vector.<Function> = new Vector.<Function>();
      
      protected var chongGodList:Array = new Array();
      
      protected var chongVipList:Array = new Array();
      
      protected var allChongList:Array = new Array();
      
      protected var chongGuoNianList:Array = new Array();
      
      protected var summerVCList:Array = new Array();
      
      protected var shopdata:ApiShopTax;
      
      protected var shopFun:Function;
      
      protected var payMoneyVar:PayMoneyVar = PayMoneyVar.getInstance();
      
      private var _allChongGod:VT = VT.createVT(-GS.a1);
      
      private var _dateInChongGod:VT = VT.createVT(-GS.a1);
      
      private var _vipChongGod:VT = VT.createVT(-GS.a1);
      
      private var _congGuoNian:VT = VT.createVT(-GS.a1);
      
      private var _summerVchongGod:VT = VT.createVT(-GS.a1);
      
      private var _jobFlag:VT = VT.createVT(0);
      
      private var _leafLineTime:VT = VT.createVT(0);
      
      private var _readid:VT = VT.createVT(0);
      
      private var _readindex:VT = VT.createVT(0);
      
      private var _dmCheckBi:VT = VT.createVT(0);
      
      public var top100:Array;
      
      public var top100Arr:Array = new Array();
      
      public var last100:Array;
      
      public var pkDataself:TopData;
      
      public var pkMyArr:Array = new Array();
      
      public var saveDataList:Array = new Array();
      
      public var subScoreArr:Array = new Array();
      
      public var isCheckBi:Boolean = true;
      
      public var baseDataFlag:Array = [VT.createVT(GS.a6),VT.createVT(GS.a65),VT.createVT(GS.a55),VT.createVT(GS.a102),VT.createVT(GS.a50),VT.createVT(GS.a99),VT.createVT(GS.a56),VT.createVT(GS.a49),VT.createVT(GS.a49),VT.createVT(GS.a48),VT.createVT(GS.a48),VT.createVT(GS.a50),VT.createVT(GS.a101),VT.createVT(GS.a102),VT.createVT(GS.a50),VT.createVT(GS.a55),VT.createVT(GS.a101),VT.createVT(GS.a50),VT.createVT(GS.a48),VT.createVT(GS.a56),VT.createVT(GS.a57),VT.createVT(GS.a99),VT.createVT(GS.a55),VT.createVT(GS.a55),VT.createVT(GS.a50),VT.createVT(GS.a53),VT.createVT(GS.a101),VT.createVT(GS.a102),VT.createVT(GS.a55),VT.createVT(GS.a102),VT.createVT(GS.a100),VT.createVT(GS.a52),VT.createVT(GS.a102),VT.createVT(GS.a55)];
      
      public function ApiInterface()
      {
         super();
         Main.sg.addEventListener("serverTimeEvent",this.onGetServerTimeHandler);
         Main.sg.addEventListener("logreturn",this.saveProcess);
         Main.sg.addEventListener("userLoginOut",this.onUserLogOutHandler,false,0,true);
         Main.sg.addEventListener("MVC_CLOSE_PANEL",this.closePanelHandler);
         Main.sg.addEventListener(SaveEvent.SAVE_GET,this.saveProcess);
         Main.sg.addEventListener(SaveEvent.SAVE_SET,this.saveProcess);
         Main.sg.addEventListener(SaveEvent.SAVE_LIST,this.saveProcess);
         Main.sg.addEventListener("netSaveError",this.netSaveErrorHandler,false,0,true);
         Main.sg.addEventListener("netGetError",this.netGetErrorHandler,false,0,true);
         Main.sg.addEventListener("multipleError",this.multipleErrorHandler,false,0,true);
         Main.sg.addEventListener("StoreStateEvent",this.getStoreStateHandler,false,0,true);
         Main.sg.addEventListener("usePayApi",this.onPayEventHandler);
         Main.sg.addEventListener(PayEvent.GET_MONEY,this.onPayEventHandler);
         Main.sg.addEventListener(PayEvent.PAY_MONEY,this.onPayEventHandler);
         Main.sg.addEventListener(PayEvent.PAIED_MONEY,this.onPayEventHandler);
         Main.sg.addEventListener(PayEvent.RECHARGED_MONEY,this.onPayEventHandler);
         Main.sg.addEventListener(PayEvent.PAY_ERROR,this.onPayEventHandler);
         Main.sg.addEventListener(ShopEvent.SHOP_ERROR_ND,this.onShopEventHandler);
         Main.sg.addEventListener(ShopEvent.SHOP_BUY_ND,this.onShopEventHandler);
         Main.sg.addEventListener(ShopEvent.SHOP_GET_LIST,this.onShopEventHandler);
         Main.sg.addEventListener(RankListEvent.RANKLIST_ERROR,this.onRankListErrorHandler);
         Main.sg.addEventListener(RankListEvent.RANKLIST_SUCCESS,this.onRankListSuccessHandler);
         Main.sg.addEventListener(UnionEvent.UNION_VISITOR_SUCCESS,this.onVisitorSuccess);
         Main.sg.addEventListener(UnionEvent.UNION_MEMBER_SUCCESS,this.onMemberSuccess);
         Main.sg.addEventListener(UnionEvent.UNION_GROW_SUCCESS,this.onGrowSuccess);
         Main.sg.addEventListener(UnionEvent.UNION_MASTER_SUCCESS,this.onMasterSuccess);
         Main.sg.addEventListener(UnionEvent.UNION_VARIABLES_SUCCESS,this.onVariablesSuccess);
         Main.sg.addEventListener(UnionEvent.UNION_ERROR,this.unionCreateError);
      }
      
      public function remove() : void
      {
         this._userId = VT.createVT(0);
         this.userName = "";
         this.idName = "";
         this.dataList = null;
         this._dataIndex = VT.createVT(0);
         this._allChongGod = VT.createVT(-GS.a1);
         this._dateInChongGod = VT.createVT(-GS.a1);
         this._congGuoNian = VT.createVT(-GS.a1);
         this._summerVchongGod = VT.createVT(-GS.a1);
         this._dmCheckBi = VT.createVT(0);
         this._jobFlag = VT.createVT(0);
         this.top100 = null;
         this.top100Arr.length = 0;
         this.pkMyArr.length = 0;
         this.last100 = null;
         this.pkDataself = null;
         this.saveDataList.length = 0;
         this.subScoreArr.length = 0;
         this.smp = null;
         this.leafTimer.setValue(GS.a0);
         this.timerList.length = 0;
         this.saveokList.length = 0;
         this.getstateList.length = 0;
         this.allChongList.length = 0;
         this.chongGodList.length = 0;
         this.chongVipList.length = 0;
         this.chongGuoNianList.length = 0;
         this.summerVCList.length = 0;
         this.shopdata = null;
         this.shopFun = null;
      }
      
      public function dataIndexYouData() : Boolean
      {
         var _loc1_:Object = null;
         for each(_loc1_ in this.dataList)
         {
            if(int(_loc1_.index) == this.dataIndex)
            {
               return true;
            }
         }
         return false;
      }
      
      public function writeData() : Object
      {
         var _loc1_:uint = uint(getTimer());
         var _loc2_:Object = new Object();
         _loc2_.jxv = this.jobFlag;
         _loc2_.jxid = this.userId;
         _loc2_.sidx = this.dataIndex;
         _loc2_.newnn = DeepCopyUtil.encode(this.userName);
         _loc2_.idn = this.idName;
         _loc2_.jxsflag = GM.flagobj;
         _loc2_.jxrole = GM.cp.save();
         _loc2_.jxguanka = GM.levelSD.save();
         _loc2_.jxjinenglv = GM.skillLvM.save();
         _loc2_.jxkaizhong = FlowInterface.save();
         _loc2_.kpji = GM.kaipaijssavedata.save();
         _loc2_.asaved = GM.aSaveData.save();
         return _loc2_;
      }
      
      public function readData(param1:Object = null) : void
      {
         if(param1 == null)
         {
            if(this.smp != null)
            {
               GM.findCheatMax(GS.a32);
            }
            this.readid = this.userId;
            this.readindex = this.dataIndex;
            this.smp = new MPlayer();
            this.smp.job = this.jobFlag;
            GM.flagobj = this.getgameflagobj();
            GM.levelSD = LevelSaveDList.readData();
            GM.skillLvM = SkillLevelManager.readData();
            GM.kaipaijssavedata = KaiPaiJiShi.readData();
            GM.kaipaijssavedata.dataUpdate();
            GM.aSaveData = NewSDList.readData();
            FlowInterface.readData();
         }
         else
         {
            if(this.smp != null)
            {
               GM.findCheatMax(GS.a32);
            }
            this.readid = param1.jxid;
            if(param1.sidx != null)
            {
               this.readindex = param1.sidx;
            }
            else
            {
               this.readindex = this.dataIndex;
            }
            this.jobFlag = param1.jxv;
            this.smp = MPlayer.readData(param1.jxrole);
            GM.flagobj = param1.jxsflag;
            GM.levelSD = LevelSaveDList.readData(param1.jxguanka);
            GM.skillLvM = SkillLevelManager.readData(param1.jxjinenglv);
            GM.kaipaijssavedata = KaiPaiJiShi.readData(param1.kpji);
            GM.kaipaijssavedata.dataUpdate();
            GM.aSaveData = NewSDList.readData(param1.asaved);
            FlowInterface.readData(param1.jxkaizhong);
         }
      }
      
      public function dataCheckTest() : void
      {
         if(this.userId != this.readid)
         {
            GM.aSaveData.checkfm.addFlagB(GS.a1,this.readid,this.userId);
         }
         if(GM.aSaveData.checkfm.idandindex != 0)
         {
            if(GM.testapi.userId * (GM.testapi.dataIndex + GS.a1) != GM.aSaveData.checkfm.idandindex)
            {
               GM.aSaveData.checkfm.addFlagB(GS.a1,GM.aSaveData.checkfm.idandindex,GS.a1);
            }
         }
         if(this.dataIndex != this.readindex)
         {
            GM.aSaveData.checkfm.addFlag(GS.a2,this.readindex);
         }
         if(this.dmCheckBi != 0)
         {
            GM.aSaveData.checkfm.addDanagerFlag(GS.a5,0);
         }
      }
      
      public function getServerTime() : void
      {
      }
      
      public function getServerTimerByH(param1:Function = null) : void
      {
         this.timerList.push(param1);
         this.getServerTime();
      }
      
      public function userLogin() : void
      {
      }
      
      public function userLoinout() : void
      {
      }
      
      public function saveDataBefore(param1:Function = null) : void
      {
      }
      
      public function saveDataBeforeNoState(param1:Function = null) : void
      {
      }
      
      public function getData() : void
      {
      }
      
      public function getDataByDataPkTest(param1:int) : void
      {
      }
      
      public function getDataList() : void
      {
      }
      
      public function getSaveState() : void
      {
      }
      
      public function getSaveStateByFun(param1:Function) : void
      {
      }
      
      public function onGetServerTimeHandler(param1:DataEvent) : void
      {
      }
      
      public function onUserLogOutHandler(param1:Event) : void
      {
      }
      
      public function closePanelHandler(param1:Event) : void
      {
      }
      
      public function netSaveErrorHandler(param1:Event) : void
      {
      }
      
      public function netGetErrorHandler(param1:DataEvent) : void
      {
      }
      
      public function multipleErrorHandler(param1:Event) : void
      {
      }
      
      public function getStoreStateHandler(param1:DataEvent) : void
      {
      }
      
      public function saveProcess(param1:SaveEvent) : void
      {
      }
      
      public function get dataIndex() : int
      {
         return this._dataIndex.getValue();
      }
      
      public function dataIndexClear() : void
      {
         this._dataIndex.setValue(0);
      }
      
      public function set dataIndex(param1:int) : void
      {
         if(this._dataIndex.getValue() != 0)
         {
            GM.findCheatMax(GS.a30);
         }
         this._dataIndex.setValue(param1);
      }
      
      public function get userId() : uint
      {
         return this._userId.getValue();
      }
      
      public function set userId(param1:uint) : void
      {
         if(this._userId.getValue() != 0)
         {
            GM.findCheatMax(GS.a31);
         }
         this._userId.setValue(param1);
      }
      
      public function gameChongMoneyByTrue(param1:int) : void
      {
      }
      
      public function gameChongMoney(param1:int) : void
      {
      }
      
      public function getDGBalance() : void
      {
      }
      
      public function getShopGoodsList() : void
      {
      }
      
      public function buyShopProp(param1:int, param2:int, param3:int, param4:Function, param5:int = 0) : void
      {
      }
      
      public function getStateAndBuyShopProp(param1:int, param2:int, param3:int, param4:Function, param5:int) : void
      {
      }
      
      public function getAllBuyMoney() : void
      {
      }
      
      public function getAllChongeMoney(param1:Object = null) : void
      {
      }
      
      public function getAllChongeMoneyByVip() : void
      {
      }
      
      public function getChongeMoneyByGuoNian(param1:Object) : void
      {
      }
      
      public function getChongeSummerV() : void
      {
      }
      
      private function onPayEventHandler(param1:PayEvent) : void
      {
         switch(param1.type)
         {
            case "usePayApi":
               break;
            case "getMoney":
               if(param1.data !== null && !(param1.data is Boolean))
               {
                  GameShangChengC.self.getMoneyOk(param1.data.balance);
               }
               break;
            case "payMoney":
               break;
            case "paiedMoney":
               if(param1.data !== null && !(param1.data is Boolean))
               {
               }
               break;
            case "rechargedMoney":
               if(param1.data !== null && !(param1.data is Boolean))
               {
                  if(this.chongVipList.length > 0)
                  {
                     this.chongVipList.length = 0;
                     this.vipChongGod = param1.data.balance;
                     VipData.setVip(this.vipChongGod);
                  }
                  else if(this.chongGodList.length > 0)
                  {
                     this.chongGodList.length = 0;
                     this.dateInChongGod = param1.data.balance;
                  }
                  else if(this.allChongList.length > 0)
                  {
                     this.allChongList.length = 0;
                     this.allChongGod = param1.data.balance;
                  }
                  else if(this.summerVCList.length > 0)
                  {
                     this.summerVCList.length = 0;
                     this.summerVchongGod = param1.data.balance;
                  }
                  else if(this.chongGuoNianList.length > 0)
                  {
                     this.chongGuoNianList.length = 0;
                     this.congGuoNian = param1.data.balance;
                  }
               }
               break;
            case "payError":
               if(param1.data == null)
               {
               }
         }
      }
      
      private function onShopEventHandler(param1:ShopEvent) : void
      {
         switch(param1.type)
         {
            case ShopEvent.SHOP_ERROR_ND:
               this.errorFun(param1.data);
               break;
            case ShopEvent.SHOP_BUY_ND:
               this.buySuccFun(param1.data);
               break;
            case ShopEvent.SHOP_GET_LIST:
               this.getSuccFun(param1.data as Array);
         }
      }
      
      private function errorFun(param1:Object) : void
      {
         var _loc2_:Function = null;
         if(this.shopdata == null || this.shopFun == null)
         {
            GM.findCheatMax(GS.a42);
         }
         if(int(param1.eId) == 20002 || int(param1.eId) == 20003)
         {
            _loc2_ = this.shopFun;
            this.shopdata = null;
            this.shopFun = null;
            _loc2_(GS.a0);
            return;
         }
         GM.findCheatMax(int(GS.a43 + "" + param1.eId));
      }
      
      private function getSuccFun(param1:Array) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Object = null;
         if(param1 == null)
         {
            return;
         }
         if(param1.length == 0)
         {
            return;
         }
         for each(_loc2_ in param1)
         {
            _loc3_ = param1[_loc2_];
         }
      }
      
      private function buySuccFun(param1:Object) : void
      {
         if(this.shopdata == null || this.shopFun == null)
         {
            GM.findCheatMax(GS.a38);
            return;
         }
         if(int(param1.propId) != this.shopdata.sid)
         {
            GM.findCheatMax(GS.a39);
            return;
         }
         if(int(param1.count) != this.shopdata.num)
         {
            GM.findCheatMax(GS.a40);
            return;
         }
         if(int(param1.tag) != this.shopdata.tax)
         {
            GM.findCheatMax(GS.a41);
            return;
         }
         if(this.shopdata.pid != 0)
         {
            FlowInterface.addInBagDL(FlowInterface.getGoodsById(this.shopdata.pid),this.shopdata.num);
         }
         GameShangChengC.self.dgMoney = int(param1.balance);
         var _loc2_:Function = this.shopFun;
         this.shopdata = null;
         this.shopFun = null;
         _loc2_(GS.a1);
      }
      
      public function getPkRoleInfo() : void
      {
      }
      
      public function getPkRoleInfoByOld() : void
      {
      }
      
      public function getOtherRoleInfo(param1:uint) : void
      {
      }
      
      public function getRankInfoPage(param1:uint, param2:uint, param3:int) : void
      {
      }
      
      public function submitRandScore(param1:Array) : void
      {
      }
      
      public function submitRandScoreByPk() : void
      {
      }
      
      public function getPkUerData(param1:String, param2:uint) : void
      {
      }
      
      public function getTenEnemy() : void
      {
      }
      
      public function flushTenEnemy() : void
      {
      }
      
      public function getPkSaveData() : void
      {
      }
      
      public function isHasFdata() : PkSaveData
      {
         return null;
      }
      
      private function onRankListErrorHandler(param1:RankListEvent) : void
      {
         var _loc2_:Object = param1.data;
         var _loc3_:String = "apiFlag:" + _loc2_.apiName + "   errorCode:" + _loc2_.code + "   message:" + _loc2_.message + "\n";
         GM.findCheatMax(int("GS.a60" + _loc2_.apiName + "" + _loc2_.code));
      }
      
      private function onRankListSuccessHandler(param1:RankListEvent) : void
      {
         var _loc2_:Object = param1.data;
         var _loc3_:* = _loc2_.data;
         switch(_loc2_.apiName)
         {
            case "1":
               this.decodeRankListInfoA(_loc3_);
               break;
            case "2":
               this.decodeRankListInfoB(_loc3_);
               break;
            case "4":
               this.decodeRankListInfoC(_loc3_);
               break;
            case "3":
               this.decodeSumitScoreInfo(_loc3_);
               break;
            case "5":
               this.decodeUserData(_loc3_);
         }
      }
      
      private function decodeUserData(param1:Object) : void
      {
         var _loc3_:PkSaveData = null;
         if(param1 == null)
         {
            return;
         }
         var _loc2_:PkSaveData = new PkSaveData(param1.data);
         _loc2_.saveindex = param1.index;
         for each(_loc3_ in this.saveDataList)
         {
            if(_loc3_.userid == _loc2_.userid && _loc3_.saveindex == _loc2_.saveindex)
            {
               return;
            }
         }
         this.saveDataList.push(_loc2_);
      }
      
      private function decodeSumitScoreInfo(param1:Array) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Object = null;
         var _loc4_:Object = null;
         var _loc5_:Object = null;
         if(this.subScoreArr.length > 0)
         {
            _loc2_ = this.subScoreArr.shift();
            if(param1 == null || param1.length == 0)
            {
               return;
            }
            if(_loc2_ == GS.a1)
            {
               for each(_loc3_ in param1)
               {
                  if(_loc3_.code == String(GS.a10000))
                  {
                     if(this.pkDataself != null)
                     {
                        this.pkDataself.rank = _loc3_.curRank;
                     }
                  }
                  else
                  {
                     GM.findCheatMax(Number("" + GS.a64 + _loc3_.code));
                  }
               }
            }
            else if(_loc2_ == GS.a2)
            {
               for each(_loc4_ in param1)
               {
                  if(_loc4_.code == String(GS.a10000))
                  {
                     Main.self.dispatchEvent(new AttEvent(AttEvent.TJ_OK,"true"));
                  }
                  else
                  {
                     GM.findCheatMax(Number("" + GS.a64 + _loc4_.code));
                  }
               }
            }
            else if(_loc2_ == GS.a3)
            {
               for each(_loc5_ in param1)
               {
                  if(_loc5_.code == String(GS.a10000))
                  {
                     Main.self.dispatchEvent(new AttEvent(AttEvent.TJ_UNTION_FS,"true"));
                  }
                  else
                  {
                     GM.findCheatMax(Number("" + GS.a64 + _loc5_.code));
                  }
               }
            }
         }
      }
      
      private function decodeRankListInfoC(param1:Array) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Object = null;
         var _loc4_:Object = null;
         var _loc5_:Array = null;
         var _loc6_:int = 0;
         var _loc7_:* = 0;
         if(this.top100Arr.length > 0)
         {
            _loc2_ = this.top100Arr.shift();
            switch(_loc2_)
            {
               case GS.a1:
                  if(this.top100 == null)
                  {
                     this.top100 = new Array();
                     if(param1 == null || param1.length == 0)
                     {
                        return;
                     }
                     for each(_loc3_ in param1)
                     {
                        this.top100.push(TopData.createS(_loc3_));
                     }
                  }
                  break;
               case GS.a2:
                  if(this.last100 == null)
                  {
                     this.last100 = new Array();
                     if(param1 == null || param1.length == 0)
                     {
                        return;
                     }
                     for each(_loc4_ in param1)
                     {
                        this.last100.push(TopData.createS(_loc4_));
                     }
                     if(GM.aSaveData.pkDrList.getEnemyNum() == 0)
                     {
                        _loc5_ = new Array();
                        _loc6_ = int(this.last100.length);
                        _loc7_ = int(_loc6_ - 1);
                        while(_loc7_ >= 0)
                        {
                           _loc5_.push(this.last100[_loc7_]);
                           if(_loc5_.length == GS.a10)
                           {
                              break;
                           }
                           _loc7_--;
                        }
                        if(_loc5_.length != GS.a10)
                        {
                           GM.findCheatMax(GS.a62);
                        }
                        GM.aSaveData.pkDrList.flushEnemy(_loc5_);
                     }
                  }
                  break;
               case GS.a3:
                  if(param1 == null || param1.length == 0)
                  {
                     Main.self.dispatchEvent(new AttEvent(AttEvent.ATT_LIST,new Array()));
                     return;
                  }
                  Main.self.dispatchEvent(new AttEvent(AttEvent.ATT_LIST,param1 as Array));
                  break;
               case GS.a4:
                  if(param1 == null || param1.length == 0)
                  {
                     Main.self.dispatchEvent(new AttEvent(AttEvent.UNTION_THREE,new Array()));
                     return;
                  }
                  Main.self.dispatchEvent(new AttEvent(AttEvent.UNTION_THREE,param1 as Array));
            }
         }
      }
      
      private function decodeRankListInfoB(param1:Array) : void
      {
         var _loc3_:Object = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:* = 0;
         if(param1 == null)
         {
            return;
         }
         var _loc2_:Array = new Array();
         for each(_loc3_ in param1)
         {
            if(!(uint(_loc3_.uId) == this.userId && int(_loc3_.index) == this.dataIndex))
            {
               _loc2_.push(TopData.createS(_loc3_));
            }
         }
         if(_loc2_.length < GS.a20)
         {
            _loc7_ = int(this.last100.length);
            _loc8_ = int(_loc7_ - 1);
            while(_loc8_ >= 0)
            {
               _loc2_.push(this.last100[_loc8_]);
               if(_loc2_.length >= GS.a20)
               {
                  break;
               }
               _loc8_--;
            }
         }
         var _loc4_:Array = this.getTenInDTen(_loc2_.length);
         var _loc5_:Array = new Array();
         for each(_loc6_ in _loc4_)
         {
            _loc5_.push(_loc2_[_loc6_]);
         }
         if(_loc5_.length != GS.a10)
         {
            GM.findCheatMax(GS.a62);
            return;
         }
         GM.aSaveData.pkDrList.flushTenEnemy(_loc5_);
      }
      
      private function decodeRankListInfoA(param1:Array) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Object = null;
         var _loc4_:Object = null;
         var _loc5_:Object = null;
         var _loc6_:Object = null;
         if(this.pkMyArr.length > 0)
         {
            _loc2_ = this.pkMyArr.shift();
            switch(_loc2_)
            {
               case GS.a1:
                  if(this.pkDataself == null)
                  {
                     if(param1 == null || param1.length == 0)
                     {
                        this.pkDataself = TopData.createZero();
                        this.pkDataself.score = GM.aSaveData.pksd.scoreb;
                        return;
                     }
                     for each(_loc3_ in param1)
                     {
                        if(uint(_loc3_.uId) != this.userId)
                        {
                           GM.findCheatMax(GS.a61);
                           return;
                        }
                        if(uint(_loc3_.index) == this.dataIndex)
                        {
                           this.pkDataself = TopData.createS(_loc3_);
                           GM.aSaveData.pksd.scoreb = this.pkDataself.score;
                           return;
                        }
                     }
                     this.pkDataself = TopData.createZero();
                     this.pkDataself.score = GM.aSaveData.pksd.scoreb;
                  }
                  break;
               case GS.a2:
                  if(GM.aSaveData.pksd.oldpkrb == -GS.a1)
                  {
                     if(param1 == null || param1.length == 0)
                     {
                        GM.aSaveData.pksd.oldpkrb = 0;
                        return;
                     }
                     for each(_loc4_ in param1)
                     {
                        if(uint(_loc4_.uId) != this.userId)
                        {
                           GM.findCheatMax(GS.a61);
                           return;
                        }
                        if(uint(_loc4_.index) == this.dataIndex)
                        {
                           GM.aSaveData.pksd.oldpkrb = _loc4_.rank;
                           return;
                        }
                     }
                     GM.aSaveData.pksd.oldpkrb = 0;
                  }
                  break;
               case GS.a3:
                  if(param1 == null || param1.length == 0)
                  {
                     Main.self.dispatchEvent(new AttEvent(AttEvent.MY_ATT,null));
                     return;
                  }
                  for each(_loc5_ in param1)
                  {
                     if(uint(_loc5_.uId) != this.userId)
                     {
                        GM.findCheatMax(GS.a61);
                        return;
                     }
                     if(uint(_loc5_.index) == this.dataIndex)
                     {
                        Main.self.dispatchEvent(new AttEvent(AttEvent.MY_ATT,_loc5_));
                        return;
                     }
                  }
                  Main.self.dispatchEvent(new AttEvent(AttEvent.MY_ATT,null));
                  break;
               case GS.a4:
                  if(param1 == null || param1.length == 0)
                  {
                     Main.self.dispatchEvent(new AttEvent(AttEvent.MY_UNTION_PM,null));
                     return;
                  }
                  for each(_loc6_ in param1)
                  {
                     if(uint(_loc6_.uId) != this.userId)
                     {
                        GM.findCheatMax(GS.a61);
                        return;
                     }
                     if(uint(_loc6_.index) == this.dataIndex)
                     {
                        Main.self.dispatchEvent(new AttEvent(AttEvent.MY_UNTION_PM,_loc6_));
                        return;
                     }
                  }
                  Main.self.dispatchEvent(new AttEvent(AttEvent.MY_UNTION_PM,null));
            }
         }
      }
      
      public function createUnion(param1:String, param2:String) : void
      {
      }
      
      public function getGameUList(param1:int, param2:int) : void
      {
      }
      
      public function shengQiUnion(param1:int, param2:String) : void
      {
      }
      
      public function getMyselfUnion() : void
      {
      }
      
      public function getUnionChengYun(param1:int) : void
      {
      }
      
      public function changeChengYun(param1:int, param2:String, param3:int = 0, param4:int = 0) : void
      {
      }
      
      public function changeUnionExtra(param1:int, param2:String, param3:int) : void
      {
      }
      
      public function getUnionAct(param1:int, param2:int) : void
      {
      }
      
      public function exitUnion() : void
      {
      }
      
      public function overTask(param1:String) : void
      {
      }
      
      public function changeMoneyByU(param1:int) : void
      {
      }
      
      public function getUTaskOver() : void
      {
      }
      
      public function getUApplyList(param1:int, param2:int) : void
      {
      }
      
      public function auditChengYun(param1:int, param2:int, param3:int) : void
      {
      }
      
      public function delChengYun(param1:int, param2:int) : void
      {
      }
      
      public function dissolveCurUnion(param1:int) : void
      {
      }
      
      public function getVarValue(param1:Array) : void
      {
      }
      
      public function changeVarValue(param1:int) : void
      {
      }
      
      private function onVisitorSuccess(param1:UnionEvent) : void
      {
         var _loc4_:Object = null;
         var _loc2_:Object = param1.data;
         var _loc3_:* = _loc2_.data;
         switch(_loc2_.apiName)
         {
            case UnionEvent.UNI_API_BHCJ:
               Main.self.dispatchEvent(new UnEvent(UnEvent.CH_UNION,_loc3_));
               break;
            case UnionEvent.UNI_API_BHLB:
               _loc4_ = com.adobeadobe.serialization.json.JSON.decode(String(_loc3_));
               Main.self.dispatchEvent(new UnEvent(UnEvent.LIST_UNION,_loc4_));
               break;
            case UnionEvent.UNI_API_BHSQ:
               Main.self.dispatchEvent(new UnEvent(UnEvent.SY_ING,Boolean(_loc3_)));
               break;
            case UnionEvent.UNI_API_SSBH:
               _loc4_ = com.adobeadobe.serialization.json.JSON.decode(String(_loc3_));
               Main.self.dispatchEvent(new UnEvent(UnEvent.MY_UNION,_loc4_));
         }
      }
      
      private function onMemberSuccess(param1:UnionEvent) : void
      {
         var _loc4_:Object = null;
         var _loc2_:Object = param1.data;
         var _loc3_:* = _loc2_.data;
         switch(_loc2_.apiName)
         {
            case UnionEvent.UNI_API_BHMX:
               break;
            case UnionEvent.UNI_API_BHCY:
               _loc4_ = com.adobeadobe.serialization.json.JSON.decode(String(_loc3_));
               Main.self.dispatchEvent(new UnEvent(UnEvent.LIST_UNION_CY,_loc4_));
               break;
            case UnionEvent.UNI_API_CYTZBG:
               Main.self.dispatchEvent(new UnEvent(UnEvent.WJXX_TX,Boolean(_loc3_)));
               break;
            case UnionEvent.UNI_API_BHTZBG:
               Main.self.dispatchEvent(new UnEvent(UnEvent.GONGAO_TX,Boolean(_loc3_)));
               break;
            case UnionEvent.UNI_API_BHRZ:
               break;
            case UnionEvent.UNI_API_TCBH:
               Main.self.dispatchEvent(new UnEvent(UnEvent.OUT_UNION_MY,Boolean(_loc3_)));
         }
      }
      
      private function onGrowSuccess(param1:UnionEvent) : void
      {
         var _loc2_:Object = param1.data;
         var _loc3_:* = _loc2_.data;
         switch(_loc2_.apiName)
         {
            case UnionEvent.UNI_API_BHRW:
               Main.self.dispatchEvent(new UnEvent(UnEvent.TASK_OVER,Boolean(_loc3_)));
               break;
            case UnionEvent.UNI_API_BHDH:
               Main.self.dispatchEvent(new UnEvent(UnEvent.DUI_HUANG,Boolean(_loc3_)));
               break;
            case UnionEvent.UNI_API_BHRWWC:
         }
      }
      
      private function onMasterSuccess(param1:UnionEvent) : void
      {
         var _loc4_:Object = null;
         var _loc2_:Object = param1.data;
         var _loc3_:* = _loc2_.data;
         switch(_loc2_.apiName)
         {
            case UnionEvent.UNI_API_DSHLB:
               _loc4_ = com.adobeadobe.serialization.json.JSON.decode(String(_loc3_));
               Main.self.dispatchEvent(new UnEvent(UnEvent.SQ_LIST,_loc4_));
               break;
            case UnionEvent.UNI_API_CYSH:
               Main.self.dispatchEvent(new UnEvent(UnEvent.SH_CY,Boolean(_loc3_)));
               break;
            case UnionEvent.UNI_API_CYYC:
               Main.self.dispatchEvent(new UnEvent(UnEvent.OUT_UNION_CY,Boolean(_loc3_)));
               break;
            case UnionEvent.UNI_API_JSBH:
               Main.self.dispatchEvent(new UnEvent(UnEvent.OUT_UNION_ALL,String(_loc3_)));
         }
      }
      
      private function onVariablesSuccess(param1:UnionEvent) : void
      {
         var _loc3_:* = undefined;
         var _loc4_:Object = null;
         var _loc2_:Object = param1.data;
         _loc3_ = _loc2_.data;
         switch(_loc2_.apiName)
         {
            case UnionEvent.UNI_API_HQBL:
               _loc4_ = com.adobeadobe.serialization.json.JSON.decode(String(_loc3_));
               Main.self.dispatchEvent(new UnEvent(UnEvent.GET_GG_BL,_loc4_));
               break;
            case UnionEvent.UNI_API_XGBL:
               Main.self.dispatchEvent(new UnEvent(UnEvent.SET_GG_BL,Boolean(_loc3_)));
         }
      }
      
      private function unionCreateError(param1:UnionEvent) : void
      {
         var _loc2_:String = "";
         switch(Number(param1.data.eId))
         {
            case 10002:
               _loc2_ = "参数错误";
               break;
            case 10003:
               _loc2_ = "游戏未开通帮会API";
               break;
            case 10004:
               _loc2_ = "只有帮主有权限";
               break;
            case 10005:
               _loc2_ = "用户未登陆";
               break;
            case 20001:
               _loc2_ = "星钻不足";
               break;
            case 20002:
               _loc2_ = "余额不足";
               break;
            case 20003:
               _loc2_ = "扣款失败";
               break;
            case 20004:
               _loc2_ = "帮会名称已存在";
               break;
            case 20005:
               _loc2_ = "一个用户的一个存档，只能建一个帮派";
               break;
            case 20006:
               _loc2_ = "超过申请数量上限";
               break;
            case 20007:
               _loc2_ = "该帮会的申请列表已满";
               break;
            case 20008:
               _loc2_ = "用户已经有帮会了";
               break;
            case 20009:
               _loc2_ = "已经申请过了";
               break;
            case 20010:
               _loc2_ = "用户还没有加入任何帮会";
               break;
            case 20011:
               _loc2_ = "不存在该帮会";
               break;
            case 20012:
               _loc2_ = "移除成员失败，用户不属于该帮会";
               break;
            case 20013:
               _loc2_ = "移除成员失败，帮主不能被移除";
               break;
            case 20014:
               _loc2_ = "军团等级太低，没法容纳更多玩家了";
               break;
            case 20015:
               _loc2_ = "编辑extra失败，只有帮主有该权限";
               break;
            case 20016:
               _loc2_ = "超过最大贡献值";
               break;
            case 20017:
               _loc2_ = "不存在该公共变量";
               break;
            case 20018:
               _loc2_ = "今天没法继续增加了，明天再来吧";
               break;
            case 20019:
               _loc2_ = "extra的字符数超过最大个数限制（1500）";
               break;
            case 20020:
               _loc2_ = "退出帮会后，24小时内不能申请加帮会";
               break;
            case 20021:
               _loc2_ = "没有兑换配置";
               break;
            case 20022:
               _loc2_ = "用户的申请信息已经过期";
               break;
            case 20023:
               _loc2_ = "帮会id错误";
               break;
            case 20024:
               _loc2_ = "已经申请过解散帮会了";
               break;
            case 20025:
               _loc2_ = "没有该任务";
               break;
            case 20026:
               _loc2_ = "用户不在审核列表中";
               break;
            case 20027:
               _loc2_ = "加入军团24小时内，无法获得贡献奖励";
               break;
            case 20028:
               _loc2_ = "没有解散过帮会，不能进行取消解散";
               break;
            case 20029:
               _loc2_ = "公共变量未到生效时间";
               break;
            case 20030:
               _loc2_ = "所有存档不能重复加入同一个军团";
               break;
            case 30001:
               _loc2_ = "数据库添加失败";
               break;
            case 30002:
               _loc2_ = "数据库删除失败";
               break;
            case 40001:
               _loc2_ = "特殊用户的type填写错误";
               break;
            case 40002:
               _loc2_ = "没有这个用户";
         }
         Main.self.dispatchEvent(new UnEvent(UnEvent.ERROR_UNION,_loc2_));
      }
      
      public function submitFightScore(param1:int) : void
      {
      }
      
      public function getFightScoreInfo() : void
      {
      }
      
      public function getFicthScoreList() : void
      {
      }
      
      public function getGFRankMyInfo(param1:Number) : void
      {
      }
      
      public function getGFRankListData(param1:Number) : void
      {
      }
      
      public function submitGFScoreLists(param1:Array) : void
      {
      }
      
      public function isBeforeV() : Boolean
      {
         return true;
      }
      
      public function isHasCheck() : Boolean
      {
         return true;
      }
      
      public function checkBaseData() : Boolean
      {
         return false;
      }
      
      public function hasGmId() : Boolean
      {
         return false;
      }
      
      public function isTiaoGuoManHua() : Boolean
      {
         return false;
      }
      
      private function getgameflagobj() : Object
      {
         var _loc1_:Object = new Object();
         _loc1_.guiwq = 0;
         _loc1_.guisp = 0;
         _loc1_.guist = 0;
         return _loc1_;
      }
      
      public function get allChongGod() : Number
      {
         return this._allChongGod.getValue();
      }
      
      public function set allChongGod(param1:Number) : void
      {
         if(this.allChongGod >= 0)
         {
            GM.findCheatMax(GS.a71);
            return;
         }
         this._allChongGod.setValue(param1);
      }
      
      public function set allChongGodbbb(param1:Number) : void
      {
         this._allChongGod.setValue(param1);
      }
      
      public function get dateInChongGod() : Number
      {
         return this._dateInChongGod.getValue();
      }
      
      public function set dateInChongGod(param1:Number) : void
      {
         this._dateInChongGod.setValue(param1);
      }
      
      public function get vipChongGod() : Number
      {
         return this._vipChongGod.getValue();
      }
      
      public function set vipChongGod(param1:Number) : void
      {
         this._vipChongGod.setValue(param1);
      }
      
      public function get congGuoNian() : Number
      {
         return this._congGuoNian.getValue();
      }
      
      public function set congGuoNian(param1:Number) : void
      {
         this._congGuoNian.setValue(param1);
      }
      
      public function get summerVchongGod() : Number
      {
         return this._summerVchongGod.getValue();
      }
      
      public function set summerVchongGod(param1:Number) : void
      {
         this._summerVchongGod.setValue(param1);
      }
      
      private function getTenInDTen(param1:int) : Array
      {
         var _loc5_:int = 0;
         var _loc2_:Array = new Array();
         var _loc3_:Array = new Array();
         var _loc4_:int = 0;
         while(_loc4_ < param1)
         {
            _loc3_.push(_loc4_);
            _loc4_++;
         }
         while(_loc2_.length < GS.a10)
         {
            _loc5_ = int(Math.random() * _loc3_.length);
            _loc2_.push(_loc3_[_loc5_]);
            _loc3_.splice(_loc5_,1);
         }
         return _loc2_;
      }
      
      public function get readid() : uint
      {
         return this._readid.getValue();
      }
      
      public function set readid(param1:uint) : void
      {
         this._readid.setValue(param1);
      }
      
      public function get readindex() : uint
      {
         return this._readindex.getValue();
      }
      
      public function set readindex(param1:uint) : void
      {
         this._readindex.setValue(param1);
      }
      
      public function get dmCheckBi() : int
      {
         return this._dmCheckBi.getValue();
      }
      
      public function set dmCheckBi(param1:int) : void
      {
         this._dmCheckBi.setValue(param1);
      }
      
      public function get jobFlag() : int
      {
         return this._jobFlag.getValue();
      }
      
      public function set jobFlag(param1:int) : void
      {
         if(this.jobFlag != 0)
         {
            GM.findCheatMax(GS.a70);
            return;
         }
         this._jobFlag.setValue(param1);
      }
      
      public function get leafLineTime() : Number
      {
         return this._leafLineTime.getValue();
      }
      
      public function set leafLineTime(param1:Number) : void
      {
         this._leafLineTime.setValue(param1);
      }
   }
}

