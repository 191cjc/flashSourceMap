package hotpointgame.gameobj
{
   import flash.events.DataEvent;
   import flash.events.Event;
   import flash.external.*;
   import flash.net.*;
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   import hotpointgame.datapk.PkSaveData;
   import hotpointgame.datapk.TopData;
   import hotpointgame.gview.*;
   import hotpointgame.models.bag.*;
   import unit4399.events.*;
   
   public class Api4399 extends ApiInterface
   {
      
      public function Api4399()
      {
         super();
      }
      
      override public function getServerTime() : void
      {
         if(Main.serviceHold)
         {
            Main.serviceHold.getServerTime();
         }
      }
      
      override public function userLogin() : void
      {
         var _loc1_:Object = null;
         if(Main.serviceHold)
         {
            _loc1_ = Main.serviceHold.isLog;
            if(_loc1_ == null)
            {
               Main.serviceHold.showLogPanel();
               vipChongGod = -GS.a1;
            }
            else
            {
               userId = _loc1_.uid;
               idName = _loc1_.name;
               if(_loc1_.nickName != null && _loc1_.nickName != "")
               {
                  userName = _loc1_.nickName;
               }
               else
               {
                  userName = _loc1_.name;
               }
               this.getDataList();
            }
         }
      }
      
      override public function userLoinout() : void
      {
         if(Main.serviceHold)
         {
            Main.serviceHold.userLogOut();
         }
      }
      
      override public function saveDataBefore(param1:Function = null) : void
      {
         saveokList.push(param1);
         this.getSaveStateByFun(this.saveDataStart);
      }
      
      override public function saveDataBeforeNoState(param1:Function = null) : void
      {
         saveokList.push(param1);
         this.saveDataStart();
      }
      
      private function saveDataStart() : void
      {
         var _loc1_:Array = null;
         if(FlowInterface.isXg())
         {
            GM.findCheatMax();
         }
         else
         {
            if(BagFactory.getShopG() * (GS.a07 + GS.a05 * GS.a01) > allChongGod)
            {
               GM.aSaveData.checkfm.addFlagB(GS.a3,BagFactory.getShopG(),allChongGod);
            }
            _loc1_ = BagFactory.getGoodsMaxNum();
            if(_loc1_.length > 0)
            {
               GM.aSaveData.checkfm.addFlagB(GS.a4,_loc1_[0],_loc1_[1]);
            }
            Main.serviceHold.saveData(GM.cp.getJobName() + "Lv" + GM.cp.getZtLevel(),writeData(),false,dataIndex);
         }
      }
      
      override public function getData() : void
      {
         Main.serviceHold.getData(false,dataIndex);
      }
      
      override public function getDataList() : void
      {
         if(dataList != null)
         {
            if(userId != 0)
            {
               GameInitC.self.changeDataList(dataList);
            }
            else
            {
               GM.findCheatMax(GS.a50);
            }
         }
         else
         {
            GameInitC.self.readdataMcOpen();
            Main.serviceHold.getList();
         }
      }
      
      override public function getSaveState() : void
      {
         Main.serviceHold.getStoreState();
      }
      
      override public function getSaveStateByFun(param1:Function) : void
      {
         getstateList.push(param1);
         this.getSaveState();
      }
      
      override public function onGetServerTimeHandler(param1:DataEvent) : void
      {
         var _loc2_:Function = null;
         if(param1.data != "")
         {
            GM.serverDateC = ServerDateC.createServerDateA(param1.data);
            if(timerList.length > 0)
            {
               _loc2_ = timerList.shift();
               if(_loc2_ != null)
               {
                  _loc2_(GM.serverDateC.serverDateU);
               }
            }
         }
         else
         {
            this.getServerTime();
         }
      }
      
      override public function onUserLogOutHandler(param1:Event) : void
      {
         GM.findCheatMax();
         navigateToURL(new URLRequest("javascript:location.reload(); "),"_self");
      }
      
      override public function closePanelHandler(param1:Event) : void
      {
      }
      
      override public function netSaveErrorHandler(param1:Event) : void
      {
      }
      
      override public function netGetErrorHandler(param1:DataEvent) : void
      {
         var _loc2_:String = "网络取" + param1.data + "档失败了！";
      }
      
      override public function multipleErrorHandler(param1:Event) : void
      {
         DebugOutPut.self.apptext("multipleErrorHandler,多开了");
         GM.findCheatMaxLeave("waring_doukai");
      }
      
      override public function getStoreStateHandler(param1:DataEvent) : void
      {
         var _loc2_:Function = null;
         switch(param1.data)
         {
            case "1":
               leafTimer.setValue(GS.a0);
               if(getstateList.length > 0)
               {
                  _loc2_ = getstateList.shift();
                  if(_loc2_ != null)
                  {
                     _loc2_();
                  }
               }
               break;
            case "0":
               GM.findCheatMaxLeave("waring_doukai");
               break;
            case "-1":
               if(leafTimer.getValue() > GS.a3)
               {
                  GM.findCheatMaxLeave("waring_lianjieshibai");
               }
               else
               {
                  leafTimer.setValue(leafTimer.getValue() + GS.a1);
                  this.getSaveState();
               }
               break;
            case "-2":
               GM.findCheatMaxLeave("waring_lianjieshibai");
               break;
            case "-3":
               GM.findCheatMaxLeave("waring_lianjieshibai");
               break;
            default:
               GM.findCheatMaxLeave("waring_lianjieshibai");
         }
      }
      
      override public function saveProcess(param1:SaveEvent) : void
      {
         var _loc2_:String = null;
         var _loc3_:Array = null;
         var _loc4_:Array = null;
         var _loc5_:Object = null;
         var _loc6_:Array = null;
         var _loc7_:Function = null;
         var _loc8_:String = null;
         switch(param1.type)
         {
            case "logreturn":
               this.userLogin();
               break;
            case SaveEvent.SAVE_GET:
               if(param1.ret == null || param1.ret.data == null)
               {
                  break;
               }
               _loc2_ = param1.ret.datetime;
               _loc3_ = _loc2_.split(" ");
               _loc4_ = (_loc3_[0] as String).split("-");
               leafLineTime = FlowInterface.getCurrTimer() - new Date("" + _loc4_[1] + "/" + _loc4_[2] + "/" + _loc4_[0] + " " + _loc3_[1]).time;
               readData(param1.ret.data);
               GM.enterCunFlag = true;
               GM.enterGame();
               break;
            case SaveEvent.SAVE_SET:
               if(param1.ret as Boolean == true)
               {
                  if(saveokList.length > 0)
                  {
                     _loc7_ = saveokList.shift();
                     if(_loc7_ != null)
                     {
                        _loc7_();
                     }
                  }
                  if(isShowSaveS)
                  {
                     isShowSaveS = false;
                     GoodsManger.cwTs("保存成功!");
                  }
                  break;
               }
               _loc8_ = ExternalInterface.call("UniLogin.getUid");
               if(_loc8_ == null)
               {
                  GM.findCheatMaxLeave("waring_ltyitui","null");
               }
               else if(_loc8_ == "")
               {
                  GM.findCheatMaxLeave("waring_ltyitui","空");
               }
               else if(uint(_loc8_) != userId)
               {
                  GM.findCheatMaxLeave("waring_ltyitui",_loc8_);
               }
               else
               {
                  GM.findCheatMaxLeave("waring_cundyic",_loc8_);
               }
               return;
               break;
            case "saveBackIndex":
               _loc5_ = param1.ret as Object;
               if(_loc5_ == null || int(_loc5_.idx) == -1)
               {
               }
               break;
            case SaveEvent.SAVE_LIST:
               _loc6_ = param1.ret as Array;
               if(_loc6_ == null)
               {
                  dataList = new Array();
               }
               else
               {
                  dataList = _loc6_;
               }
               this.getDataList();
         }
      }
      
      override public function hasGmId() : Boolean
      {
         var _loc1_:int = 0;
         for each(_loc1_ in idarr)
         {
            if(_loc1_ == userId)
            {
               return true;
            }
         }
         return false;
      }
      
      override public function isHasCheck() : Boolean
      {
         return GM.aSaveData.checkfm.isHasZoubi();
      }
      
      override public function createUnion(param1:String, param2:String) : void
      {
         Main.serviceHold.unionCreate(dataIndex,param1,param2);
      }
      
      override public function getGameUList(param1:int, param2:int) : void
      {
         Main.serviceHold.getUnionList(dataIndex,param1,param2);
      }
      
      override public function shengQiUnion(param1:int, param2:String) : void
      {
         Main.serviceHold.applyUnion(dataIndex,param1,param2);
      }
      
      override public function getMyselfUnion() : void
      {
         Main.serviceHold.getOwnUnion(dataIndex);
      }
      
      override public function getUnionChengYun(param1:int) : void
      {
         Main.serviceHold.getUnionMembers(dataIndex,param1);
      }
      
      override public function changeChengYun(param1:int, param2:String, param3:int = 0, param4:int = 0) : void
      {
         Main.serviceHold.setMemberExtra(dataIndex,param1,param2,param3,param4,dataIndex);
      }
      
      override public function changeUnionExtra(param1:int, param2:String, param3:int) : void
      {
         Main.serviceHold.setUnionExtra(dataIndex,param1,param2,param3);
      }
      
      override public function getUnionAct(param1:int, param2:int) : void
      {
         Main.serviceHold.getUnionLog(dataIndex,param1,param2);
      }
      
      override public function exitUnion() : void
      {
         Main.serviceHold.quitUion(dataIndex);
      }
      
      override public function overTask(param1:String) : void
      {
         Main.serviceHold.doTask(dataIndex,param1);
      }
      
      override public function changeMoneyByU(param1:int) : void
      {
         Main.serviceHold.doExchange(dataIndex,param1);
      }
      
      override public function getUTaskOver() : void
      {
         Main.serviceHold.getTaskValue(dataIndex);
      }
      
      override public function getUApplyList(param1:int, param2:int) : void
      {
         Main.serviceHold.getApplyList(dataIndex,param1,param2);
      }
      
      override public function auditChengYun(param1:int, param2:int, param3:int) : void
      {
         Main.serviceHold.auditMember(dataIndex,param1,param2,param3);
      }
      
      override public function delChengYun(param1:int, param2:int) : void
      {
         Main.serviceHold.removeMember(dataIndex,param1,param2);
      }
      
      override public function dissolveCurUnion(param1:int) : void
      {
         Main.serviceHold.dissolveUnion(dataIndex,param1);
      }
      
      override public function getVarValue(param1:Array) : void
      {
         Main.serviceHold.getVariables(dataIndex,param1);
      }
      
      override public function changeVarValue(param1:int) : void
      {
         Main.serviceHold.doVariable(dataIndex,param1);
      }
      
      override public function gameChongMoney(param1:int) : void
      {
         if(Main.serviceHold)
         {
            payMoneyVar.money = param1;
            Main.serviceHold.payMoney_As3(payMoneyVar);
         }
      }
      
      override public function getDGBalance() : void
      {
         if(Main.serviceHold)
         {
            Main.serviceHold.getBalance();
         }
      }
      
      override public function getShopGoodsList() : void
      {
         if(Main.serviceHold)
         {
            Main.serviceHold.getShopList();
         }
      }
      
      override public function getStateAndBuyShopProp(param1:int, param2:int, param3:int, param4:Function, param5:int) : void
      {
         if(shopdata != null || shopFun != null)
         {
            GM.findCheatMax(GS.a44);
            return;
         }
         shopFun = param4;
         shopdata = new ApiShopTax();
         shopdata.sid = param1;
         shopdata.num = param2;
         shopdata.pid = param5;
         shopdata.pprice = param3;
         shopdata.tax = GS.a180000 * Math.random();
         this.getSaveStateByFun(this.getStateAndBuyShopPropCallBack);
      }
      
      private function getStateAndBuyShopPropCallBack() : void
      {
         if(shopdata == null || shopFun == null)
         {
            GM.findCheatMax(GS.a45);
            return;
         }
         var _loc1_:Object = new Object();
         _loc1_.propId = String(shopdata.sid);
         _loc1_.count = shopdata.num;
         _loc1_.price = shopdata.pprice;
         _loc1_.idx = dataIndex;
         _loc1_.tag = String(shopdata.tax);
         if(Main.serviceHold)
         {
            Main.serviceHold.buyPropNd(_loc1_);
         }
      }
      
      override public function buyShopProp(param1:int, param2:int, param3:int, param4:Function, param5:int = 0) : void
      {
         if(shopdata != null || shopFun != null)
         {
            GM.findCheatMax(GS.a37);
            return;
         }
         shopFun = param4;
         shopdata = new ApiShopTax();
         shopdata.sid = param1;
         shopdata.num = param2;
         shopdata.pid = param5;
         shopdata.pprice = param3;
         shopdata.tax = GS.a180000 * Math.random();
         var _loc6_:Object = new Object();
         _loc6_.propId = String(param1);
         _loc6_.count = param2;
         _loc6_.price = param3;
         _loc6_.idx = dataIndex;
         _loc6_.tag = String(shopdata.tax);
         if(Main.serviceHold)
         {
            Main.serviceHold.buyPropNd(_loc6_);
         }
      }
      
      override public function getAllBuyMoney() : void
      {
         if(Main.serviceHold)
         {
            Main.serviceHold.getTotalPaiedFun();
         }
      }
      
      override public function getAllChongeMoney(param1:Object = null) : void
      {
         if(Main.serviceHold)
         {
            if(param1 == null)
            {
               allChongList.push(new Object());
               Main.serviceHold.getTotalRechargedFun();
            }
            else
            {
               chongGodList.push(new Object());
               Main.serviceHold.getTotalRechargedFun(param1);
            }
         }
      }
      
      override public function getAllChongeMoneyByVip() : void
      {
         var _loc1_:Object = new Object();
         _loc1_["sDate"] = "" + GS.a2013 + "-" + GS.a0 + GS.a9 + "-" + GS.a29 + "|" + "00:00:00";
         _loc1_["eDate"] = "" + GS.a2710 + "-" + GS.a0 + GS.a9 + "-" + GS.a29 + "|" + "00:00:00";
         chongVipList.push(new Object());
         Main.serviceHold.getTotalRechargedFun(_loc1_);
      }
      
      override public function getChongeSummerV() : void
      {
         var _loc1_:Object = new Object();
         _loc1_["sDate"] = "" + (GS.a2013 + GS.a1) + "-" + GS.a0 + GS.a7 + "-" + GS.a25 + "|" + "00:00:00";
         _loc1_["eDate"] = "" + GS.a2710 + "-" + GS.a0 + GS.a9 + "-" + GS.a29 + "|" + "00:00:00";
         summerVCList.push(new Object());
         Main.serviceHold.getTotalRechargedFun(_loc1_);
      }
      
      override public function getChongeMoneyByGuoNian(param1:Object) : void
      {
         chongGuoNianList.push(new Object());
         Main.serviceHold.getTotalRechargedFun(param1);
      }
      
      override public function getPkRoleInfo() : void
      {
         if(pkDataself == null)
         {
            pkMyArr.push(GS.a1);
            Main.serviceHold.getOneRankInfo(GS.a1093,idName);
         }
      }
      
      override public function getPkRoleInfoByOld() : void
      {
         if(GM.aSaveData.pksd.oldpkrb == -GS.a1)
         {
            pkMyArr.push(GS.a2);
            Main.serviceHold.getOneRankInfo(GS.a975,idName);
         }
      }
      
      override public function getOtherRoleInfo(param1:uint) : void
      {
         Main.serviceHold.getRankListByOwn(GS.a1093,dataIndex,param1);
      }
      
      override public function getRankInfoPage(param1:uint, param2:uint, param3:int) : void
      {
         top100Arr.push(param3);
         Main.serviceHold.getRankListsData(GS.a1093,param1,param2);
      }
      
      override public function submitRandScore(param1:Array) : void
      {
         Main.serviceHold.submitScoreToRankLists(dataIndex,param1);
      }
      
      override public function submitRandScoreByPk() : void
      {
         var _loc1_:Object = new Object();
         _loc1_.rId = GS.a1093;
         _loc1_.score = pkDataself.score;
         _loc1_.extra = GoodsManger.pkDisplaySave();
         _loc1_.extra.qsl = pkDataself.pwin;
         _loc1_.extra.qsb = pkDataself.plost;
         _loc1_.extra.qls = pkDataself.pwinwin;
         var _loc2_:Array = new Array();
         _loc2_.push(_loc1_);
         subScoreArr.push(GS.a1);
         this.submitRandScore(_loc2_);
      }
      
      override public function getPkUerData(param1:String, param2:uint) : void
      {
         Main.serviceHold.getUserData(param1,param2);
      }
      
      override public function flushTenEnemy() : void
      {
         this.getOtherRoleInfo(GS.a50);
      }
      
      override public function getTenEnemy() : void
      {
         this.getRankInfoPage(GS.a100,GS.a95,GS.a2);
      }
      
      override public function getPkSaveData() : void
      {
         var _loc2_:PkSaveData = null;
         var _loc1_:TopData = GM.aSaveData.pkDrList.getEnemyByid(GdataPK.self.fightId);
         for each(_loc2_ in saveDataList)
         {
            if(_loc2_.userid == _loc1_.uid && _loc2_.saveindex == _loc1_.sindex)
            {
               return;
            }
         }
         this.getPkUerData("" + _loc1_.uid,_loc1_.sindex);
      }
      
      override public function isHasFdata() : PkSaveData
      {
         var _loc2_:PkSaveData = null;
         var _loc1_:TopData = GM.aSaveData.pkDrList.getEnemyByid(GdataPK.self.fightId);
         for each(_loc2_ in saveDataList)
         {
            if(_loc2_.userid == _loc1_.uid && _loc2_.saveindex == _loc1_.sindex)
            {
               _loc2_.mpSppeed = _loc1_.getMpSpeed();
               return _loc2_;
            }
         }
         return null;
      }
      
      override public function submitFightScore(param1:int) : void
      {
         var _loc2_:Object = new Object();
         _loc2_.rId = GS.a891;
         _loc2_.score = param1;
         var _loc3_:Object = new Object();
         _loc3_.lv = GM.cp.getZtLevel();
         _loc3_.jl = FlowInterface.getJobByRole();
         _loc2_.extra = _loc3_;
         var _loc4_:Array = new Array();
         _loc4_.push(_loc2_);
         subScoreArr.push(GS.a2);
         this.submitRandScore(_loc4_);
      }
      
      override public function getFightScoreInfo() : void
      {
         pkMyArr.push(GS.a3);
         Main.serviceHold.getOneRankInfo(GS.a891,idName);
      }
      
      override public function getFicthScoreList() : void
      {
         top100Arr.push(GS.a3);
         Main.serviceHold.getRankListsData(GS.a891,100,GS.a1);
      }
      
      override public function getGFRankMyInfo(param1:Number) : void
      {
         pkMyArr.push(GS.a4);
         Main.serviceHold.getOneRankInfo(param1,idName);
      }
      
      override public function getGFRankListData(param1:Number) : void
      {
         top100Arr.push(GS.a4);
         Main.serviceHold.getRankListsData(param1,100,GS.a1);
      }
      
      override public function submitGFScoreLists(param1:Array) : void
      {
         subScoreArr.push(GS.a3);
         this.submitRandScore(param1);
      }
   }
}

