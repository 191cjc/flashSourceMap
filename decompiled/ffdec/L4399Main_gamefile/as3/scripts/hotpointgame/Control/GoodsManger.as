package hotpointgame.Control
{
   import com.adobeadobe.crypto.*;
   import com.adobeadobe.serialization.json.JSON;
   import flash.display.*;
   import flash.events.*;
   import flash.net.*;
   import flash.text.*;
   import flash.utils.*;
   import hotpointgame.common.*;
   import hotpointgame.common.event.*;
   import hotpointgame.datapk.*;
   import hotpointgame.gameobj.*;
   import hotpointgame.gview.*;
   import hotpointgame.gxiaodongxi.*;
   import hotpointgame.models.bag.*;
   import hotpointgame.models.goods.Goods;
   import hotpointgame.models.task.Task;
   import hotpointgame.pet.PetR;
   import hotpointgame.repository.analysis.*;
   import hotpointgame.repository.chHao.*;
   import hotpointgame.repository.chHd.*;
   import hotpointgame.repository.dljl.*;
   import hotpointgame.repository.everyDay.*;
   import hotpointgame.repository.fb.*;
   import hotpointgame.repository.geneChange.*;
   import hotpointgame.repository.gift.*;
   import hotpointgame.repository.goods.*;
   import hotpointgame.repository.goodsSkill.*;
   import hotpointgame.repository.gxShop.*;
   import hotpointgame.repository.jjia.*;
   import hotpointgame.repository.openBox.*;
   import hotpointgame.repository.petGj.*;
   import hotpointgame.repository.ship.*;
   import hotpointgame.repository.shop.*;
   import hotpointgame.repository.strengthen.*;
   import hotpointgame.repository.task.*;
   import hotpointgame.repository.three.*;
   import hotpointgame.repository.timeJl.*;
   import hotpointgame.repository.unionVip.*;
   import hotpointgame.repository.vip.*;
   import hotpointgame.repository.zhanpan.*;
   import hotpointgame.utils.*;
   import hotpointgame.utils.gameloader.*;
   import hotpointgame.utils.gsound.*;
   import hotpointgame.views.attPanel.*;
   import hotpointgame.views.chongwu.*;
   import hotpointgame.views.comPanel.*;
   import hotpointgame.views.dljlPanel.*;
   import hotpointgame.views.everyDayPanel.*;
   import hotpointgame.views.fbPanel.*;
   import hotpointgame.views.geneChangePanel.*;
   import hotpointgame.views.giftPanel.*;
   import hotpointgame.views.guoqin.*;
   import hotpointgame.views.gxShop.*;
   import hotpointgame.views.insertPanel.*;
   import hotpointgame.views.onLineJl.*;
   import hotpointgame.views.petGj.*;
   import hotpointgame.views.playerPanel.*;
   import hotpointgame.views.shipPanel.*;
   import hotpointgame.views.shopPanel.*;
   import hotpointgame.views.signPanel.*;
   import hotpointgame.views.strengPanel.*;
   import hotpointgame.views.taskPanel.*;
   import hotpointgame.views.unionPanel.*;
   import hotpointgame.views.unionVip.*;
   import hotpointgame.views.vipPanel.*;
   import hotpointgame.views.wareroomPanel.*;
   import hotpointgame.views.wmdPanel.*;
   import hotpointgame.views.zenfuPanel.*;
   import hotpointgame.views.zppanel.*;
   import hotpointgame.views.zqhd.*;
   import mx.core.*;
   
   public class GoodsManger
   {
      
      public static var goodsCurrTime:VT;
      
      private static var timexx:VT;
      
      public static var dataList:DataList;
      
      private static var timer:Timer = new Timer(GS.a1000,GS.a0);
      
      private static var oTimer:VT = VT.createVT(-1);
      
      private static var lxurlLoader:URLLoader = new URLLoader();
      
      private static var xlDlPhpUrl:URLRequest = new URLRequest("http://my.4399.com/events/2014/fiveyear/login-counter");
      
      private static var boNum:Number = 0;
      
      public function GoodsManger()
      {
         super();
      }
      
      public static function lxDlUrl() : void
      {
         xlDlPhpUrl.method = URLRequestMethod.POST;
         var _loc1_:URLVariables = new URLVariables();
         _loc1_.app_id = GS.a38;
         _loc1_.game_id = GS.a9;
         _loc1_.time = int(FlowInterface.getCurrTimer() / GS.a1000);
         _loc1_.uid = GM.testapi.userId;
         _loc1_.uri = "/events/2014/fiveyear/login-counter";
         var _loc2_:String = _loc1_.app_id + "||" + _loc1_.game_id + "||" + _loc1_.time + "||" + _loc1_.uid + "||" + _loc1_.uri + "||" + "919e2199989011d08e1c37f03017a27b";
         _loc1_.token = MD5.hash(_loc2_);
         xlDlPhpUrl.data = _loc1_;
         lxurlLoader.load(xlDlPhpUrl);
         lxurlLoader.addEventListener(Event.COMPLETE,completeHandler_All);
      }
      
      private static function completeHandler_All(param1:Event) : void
      {
         var _loc2_:String = (param1.currentTarget as URLLoader).data;
         var _loc3_:Object = com.adobeadobe.serialization.json.JSON.decode(_loc2_,true);
         var _loc4_:Number = Number(_loc3_.code);
         var _loc5_:Number = Number(_loc3_.result);
      }
      
      public static function initXml() : void
      {
         var _loc1_:MovieClip = LoaderManager.getDataDocumentClass("dataxmlva");
         Xmldatacheck.goodsxml = ByteArrayAsset(new (_loc1_.GoodsXml as Class)());
         GoodsFactory.creatGoodsFactory(XMLAsset.createXML(_loc1_.GoodsXml));
         GoodsFactory.creatGsnFactory(XMLAsset.createXML(_loc1_.GsMaxXml));
         SuitEquipFactory.creatSuitFactory(XMLAsset.createXML(_loc1_.SuitXml));
         StrengthenFactory.creatStrFactory(XMLAsset.createXML(_loc1_.StrXml));
         TaskFactory.creatTaskFactory(XMLAsset.createXML(_loc1_.TaskXml));
         TaskFactory.creatSayFactory(XMLAsset.createXML(_loc1_.TaskSayXml));
         ShopGoodsFactory.creatShopFactory(XMLAsset.createXML(_loc1_.ShopXml));
         AnalysisFactory.creatGoodsFactory(XMLAsset.createXML(_loc1_.AnalysisXml));
         GoodsSkillFactory.creteGoodsSkillFactory(XMLAsset.createXML(_loc1_.GoodsSkillXml));
         GeneChangeFactory.createGeneFactory(XMLAsset.createXML(_loc1_.GeneChangeXml));
         GiftFactory.createGiftFactory(XMLAsset.createXML(_loc1_.GiftXml));
         Xmldatacheck.vipXml = ByteArrayAsset(new (_loc1_.VipXml as Class)());
         VipFactory.createVipFactory(XMLAsset.createXML(_loc1_.VipXml));
         EveryDayFactory.creteEveryDayFactory(XMLAsset.createXML(_loc1_.EdXml));
         Xmldatacheck.edJlXml = ByteArrayAsset(new (_loc1_.EdJlXml as Class)());
         EveryDayFactory.creteEveryJlFactory(XMLAsset.createXML(_loc1_.EdJlXml));
         FbFactory.createFbXml(XMLAsset.createXML(_loc1_.FbXml));
         ChHaoFactory.createChHaoXml(XMLAsset.createXML(_loc1_.ChXml));
         GxShopFactory.createGxShop(XMLAsset.createXML(_loc1_.GxSpXml));
         ZpFactory.createZpFactory(XMLAsset.createXML(_loc1_.ZpXml));
         ShipFactory.createLvFactory(XMLAsset.createXML(_loc1_.SpLv));
         ShipFactory.createXlFactory(XMLAsset.createXML(_loc1_.SpXl));
         ShipFactory.createGkFactory(XMLAsset.createXML(_loc1_.SpGk));
         PetGjFactory.createExpLvFactory(XMLAsset.createXML(_loc1_.ExpLv));
         PetGjFactory.createHosLvFactory(XMLAsset.createXML(_loc1_.HosLv));
         PetGjFactory.createQdFactory(XMLAsset.createXML(_loc1_.QdXml));
         UnionVipFactory.createUnVipFactory(XMLAsset.createXML(_loc1_.UnVipXml));
         UnionVipFactory.createUnShopFactory(XMLAsset.createXML(_loc1_.UnShopXml));
         UnionVipFactory.createUnJsFactory(XMLAsset.createXML(_loc1_.UnStSjXml));
         UnionVipFactory.createUnJtzFactory(XMLAsset.createXML(_loc1_.jtzjlXml));
         ChHdFactory.createChHdFactory(XMLAsset.createXML(_loc1_.ChHdXml));
         Xmldatacheck.onlinexml = ByteArrayAsset(new (_loc1_.onLineXml as Class)());
         TimeJlFactory.createTimeJl(XMLAsset.createXML(_loc1_.onLineXml));
         ThreeFactory.createThreeFactory(XMLAsset.createXML(_loc1_.treeXml));
         JjiaFactory.creatJiJiaLv(XMLAsset.createXML(_loc1_.JjSxXml));
         JjiaFactory.creatJiJiaQh(XMLAsset.createXML(_loc1_.JjQHSxXml));
         JjiaFactory.creatJiJiaJh(XMLAsset.createXML(_loc1_.JjJhXml));
         OpenBoxFactory.creatOpenBoxFactory(XMLAsset.createXML(_loc1_.kxzXml));
         DlJlFactory.ctreateDlJlFactory(XMLAsset.createXML(_loc1_.ljdlXml));
      }
      
      public static function initDataAgain() : void
      {
         VipData.setVip(GM.testapi.vipChongGod);
         if(dataList.unionData.getMyUnion() != null)
         {
            dataList.uVipData.setVip(UnionVipFactory.getDataByCz(GoodsManger.dataList.unionData.getGgBl(GS.a6)));
         }
         else
         {
            GoodsManger.dataList.unionData.clearData();
         }
         TaskData.initTaskData();
         Main.self.addEventListener(GoodsEvent.DO_BACK,goodsHandle);
         dataList.onLData.setMbTime();
         shopTimer();
         BagFactory.backGoodsSI();
         ComData.initJpData();
         GiftData.initData();
         dataList.cwZfBag.jsSx();
         dataList.pzfBag.jsSx();
         BagFactory.equipSlot.jsSx(VipData.vip.getValue(),GoodsManger.dataList.uVipData.getVip());
         FbData.initData();
         GxShopData.initData();
      }
      
      private static function addXX() : void
      {
         Main.self.addEventListener(UnEvent.MY_UNION,myUnHandlexx);
         Main.self.addEventListener(UnEvent.LIST_UNION,unionHandlexx);
         Main.self.addEventListener(UnEvent.SQ_LIST,sqHandlexx);
         Main.self.addEventListener(UnEvent.ERROR_UNION,errorXX);
         Main.self.addEventListener(UnEvent.GET_GG_BL,getGGbLxx);
         Main.self.addEventListener(AttEvent.TJ_UNTION_FS,okHandlexx);
      }
      
      private static function removeXX() : void
      {
         Main.self.removeEventListener(UnEvent.MY_UNION,myUnHandlexx);
         Main.self.removeEventListener(UnEvent.LIST_UNION,unionHandlexx);
         Main.self.removeEventListener(UnEvent.SQ_LIST,sqHandlexx);
         Main.self.removeEventListener(UnEvent.ERROR_UNION,errorXX);
         Main.self.removeEventListener(UnEvent.GET_GG_BL,getGGbLxx);
         Main.self.removeEventListener(AttEvent.TJ_UNTION_FS,okHandlexx);
      }
      
      private static function errorXX(param1:UnEvent) : void
      {
         DataIngPanelXX.close();
         GM.loadSwf();
         removeXX();
      }
      
      public static function getApiData() : void
      {
         addXX();
         DataIngPanelXX.open();
         GM.testapi.getGameUList(1,1);
      }
      
      private static function unionHandlexx(param1:UnEvent) : void
      {
         dataList.unionData.setAllUntionNum(Number(param1.obj.rowCount));
         GM.testapi.getMyselfUnion();
      }
      
      private static function myUnHandlexx(param1:UnEvent) : void
      {
         var _loc2_:Array = null;
         dataList.unionData.setMyUnion(param1.obj);
         if(dataList.unionData.getMyUnion() != null)
         {
            _loc2_ = dataList.unionData.getGbId();
            GM.testapi.getVarValue(_loc2_);
         }
         else
         {
            DataIngPanelXX.close();
            GM.loadSwf();
            removeXX();
         }
      }
      
      private static function getGGbLxx(param1:UnEvent) : void
      {
         GoodsManger.dataList.unionData.setGgBl(param1.obj as Array);
         GM.testapi.getUApplyList(1,1);
      }
      
      private static function sqHandlexx(param1:UnEvent) : void
      {
         dataList.unionData.setAllSq(Number(param1.obj.rowCount));
         boNum = 0;
         dataList.unionData.tjPhb(0,3);
      }
      
      private static function okHandlexx(param1:AttEvent) : void
      {
         if(boNum == 0)
         {
            boNum = 1;
            dataList.unionData.tjPhb(4,6);
         }
         else if(boNum == 1)
         {
            DataIngPanelXX.close();
            GM.loadSwf();
            removeXX();
         }
      }
      
      public static function close() : void
      {
         allPanelClose();
         BagFactory.initBag();
         TaskData.closeData();
         ShopData.closeData();
         ComData.closeDate();
         GeneData.closeData();
         GiftData.closeData();
         ChongWuPanel.closeData();
         FbData.closeData();
         ZpData.clearTimes();
         ShipData.initData();
         PetGjData.initData();
         timer.stop();
         timer.removeEventListener(TimerEvent.TIMER,timerHandler);
         Main.self.removeEventListener(GoodsEvent.DO_BACK,goodsHandle);
         removeXX();
         PlayerBagPanel._instance = null;
         AttZdlPanel._instance = null;
      }
      
      private static function shopTimer() : void
      {
         timer.addEventListener(TimerEvent.TIMER,timerHandler);
         timer.start();
      }
      
      private static function timerHandler(param1:TimerEvent) : void
      {
         shopFun();
         GeneChangeFun();
         jdTaskFun();
         petFun();
         onLineJlFun();
      }
      
      private static function petFun() : void
      {
         if(PetGjData.getIsBo() == GS.a1)
         {
            if(PetGjData.getGjTime() > GS.a0)
            {
               PetGjData.setGjTime(PetGjData.getGjTime() - GS.a1);
               if(PetGjData.getGjTimeZ() != PetGjData.getGjTime())
               {
                  if((PetGjData.getGjTimeZ() - int(PetGjData.getGjTime())) / (PetGjData.gdTime.getValue() * GS.a60) is int)
                  {
                     PetGjData.addZxTime();
                     ShipData.deleteNj(GS.a1);
                     FlowInterface.saveDataByKai();
                  }
               }
            }
            else if(!PetGjData.eatBo)
            {
               PetGjData.eatBo = true;
               PetGjData.addExp();
               PetGjData.deleteGs();
            }
         }
      }
      
      private static function jdTaskFun() : void
      {
         var _loc1_:Task = null;
         if(TaskData.getJdTaskXX() != null)
         {
            _loc1_ = TaskData.getJdTaskXX();
            if(_loc1_ != null && _loc1_.getState() == GS.a2)
            {
               if(TaskData.getjsTime() > GS.a0)
               {
                  TaskData.setJsTime(int(TaskData.getMbTime() - getTimer() / GS.a1000));
               }
               else
               {
                  _loc1_.setState(GS.a3);
                  TaskData.setJsTime(GS.a0);
                  GoodsManger.taskTs(_loc1_,1);
               }
            }
         }
      }
      
      private static function GeneChangeFun() : void
      {
         var _loc1_:uint = 0;
         while(_loc1_ < GS.a7)
         {
            if(GeneData.getLoadState(_loc1_) == GS.a1 && GeneData.getMbTime(_loc1_) != -1 && GeneData.getBeForeTime(_loc1_) != -1 && GeneData.getTimeBo(_loc1_) == -1)
            {
               if(GeneData.getXsTime(_loc1_) > GS.a0)
               {
                  GeneData.setXsTime(_loc1_,Math.floor(GeneData.getMbTime(_loc1_) - getTimer() / GS.a1000));
               }
               else if(GeneData.getTimeBo(_loc1_) == -1)
               {
                  GeneData.setTimeBo(_loc1_,GS.a0);
                  GM.testapi.getServerTimerByH(geneUpdate);
               }
            }
            _loc1_++;
         }
      }
      
      private static function geneUpdate(param1:Number) : void
      {
         var _loc2_:uint = 0;
         while(_loc2_ < GS.a7)
         {
            if(GeneData.getTimeBo(_loc2_) == GS.a0)
            {
               if(int((param1 - GeneData.getBeForeTime(_loc2_)) / GS.a1000) + GS.a180 > int(GeneData.getMbtimeXX(_loc2_)))
               {
                  GeneData.setLoadState(_loc2_,GS.a2);
                  GeneData.tsBo = true;
               }
               else
               {
                  FlowInterface.findCheat(GS.a110);
               }
            }
            _loc2_++;
         }
      }
      
      private static function onLineJlFun() : void
      {
         var _loc1_:uint = 0;
         if(dataList.onLData.getFwqTime() != GS.a0)
         {
            _loc1_ = 1;
            while(_loc1_ < 5)
            {
               if(dataList.onLData.getOver(_loc1_) == GS.a0)
               {
                  if(dataList.onLData.getMbTime(_loc1_) <= getTimer() / GS.a1000)
                  {
                     timer.stop();
                     dataList.onLData.setCurrType(_loc1_);
                     GM.testapi.getServerTimerByH(onLineUptate);
                     break;
                  }
                  dataList.onLData.setDjs(_loc1_,Math.floor(dataList.onLData.getMbTime(_loc1_) - getTimer() / GS.a1000));
               }
               _loc1_++;
            }
         }
      }
      
      private static function onLineUptate(param1:Number) : void
      {
         var _loc2_:VT = VT.createVT(param1 / GS.a1000);
         if(_loc2_.getValue() - dataList.onLData.getFwqTime() + GS.a20 >= dataList.onLData.getGdTime(dataList.onLData.getCurrType()))
         {
            dataList.onLData.setOver(dataList.onLData.getCurrType(),GS.a1);
            FlowInterface.saveDataByKai(saveOk);
         }
         else
         {
            FlowInterface.findCheat(GS.a110);
         }
      }
      
      private static function saveOk() : void
      {
         timer.start();
      }
      
      private static function shopFun() : void
      {
         if(ShopData.shopDate.getValue() == -1)
         {
            timer.stop();
            oTimer.setValue(getTimer() + ShopData.saveTimer.getValue());
            GM.testapi.getServerTimerByH(shopUptate);
         }
         else if(ShopData.timerNum.getValue() <= GS.a0)
         {
            if(ShopData.currentDate.getValue() == -1)
            {
               timer.stop();
               GM.testapi.getServerTimerByH(shopUptate);
            }
         }
         else
         {
            ShopData.timerNum.setValue(Math.floor((oTimer.getValue() - getTimer()) / GS.a1000));
         }
      }
      
      public static function shopUptate(param1:Number) : void
      {
         if(ShopData.shopDate.getValue() != -1)
         {
            ShopData.currentDate.setValue(param1);
            if(Math.abs(ShopData.currentDate.getValue() - ShopData.shopDate.getValue() + GS.a180000) > ShopData.saveTimer.getValue())
            {
               ShopData.initData();
               ComPanel.close();
               FlowInterface.saveDataByKai();
               Main.self.dispatchEvent(new UpdateBagEvent(UpdateBagEvent.D0_UPDATE_SHOP));
               ShopData.shopDate.setValue(ShopData.currentDate.getValue());
               ShopData.currentDate.setValue(-1);
               ShopData.timerNum.setValue(GS.a1800);
               oTimer.setValue(getTimer() + ShopData.saveTimer.getValue());
               timer.start();
            }
            else
            {
               FlowInterface.findCheat(GS.a104);
            }
         }
         else
         {
            ShopData.initShopTime(param1);
            dataList.onLData.setFwq(param1);
            timer.start();
         }
      }
      
      public static function initTestGoods() : void
      {
         BagFactory.addInBagById(131180,2,0);
         BagFactory.addInBagById(131181,2,0);
         BagFactory.addInBagById(131182,2,0);
         BagFactory.addInBagById(131186,2,0);
         BagFactory.addInBagById(131187,2,0);
         BagFactory.addInBagById(131197,2,0);
         BagFactory.addInBagById(121012,2,0);
         BagFactory.addInBagById(121016,2,0);
         BagFactory.addInBagById(121020,1,0);
         BagFactory.addInBagById(131000,1,0);
         BagFactory.addInBagById(131004,1,0);
         BagFactory.addInBagById(411069,3,0);
         BagFactory.addInBagById(141080,1,0);
         BagFactory.addInBagById(141088,1,0);
      }
      
      private static function goodsHandle(param1:GoodsEvent) : void
      {
         var _loc2_:Goods = param1.goods;
         var _loc3_:Number = param1.id;
         var _loc4_:Number = param1.goodsNum;
         var _loc5_:Boolean = param1.bo;
         if(_loc3_ != -1)
         {
            BagFactory.addToBag(_loc2_,_loc4_,_loc3_,_loc5_);
         }
         else
         {
            BagFactory.addInBagByGoods(_loc2_,_loc4_,_loc5_);
         }
      }
      
      public static function allPanelClose() : void
      {
         PlayerBagPanel.close();
         InsertPanel.close();
         StrengthenPanel.close();
         NpcTaskPanel.close();
         PlayerTaskPanel.close();
         ShopPanel.close();
         SkillGoUpC.close();
         GameShangChengC.close();
         ActLevelC.close();
         GqixihuodongC.close();
         Gshiershengxiao.close();
         GdataPK.close();
         ComPanel.close();
         WareroomPanel.close();
         GeneChangePanel.close();
         SignPanel.close();
         GiftPanel.close();
         ChongWuPanel.close();
         Zqhd.close();
         VipPanel.close();
         GuoQin.close();
         EveryDayPanel.close();
         FbPanel.close();
         GxShopPanel.close();
         Zppanel.close();
         ShipSdPanel.close();
         ShipPanel.close();
         ShipWxPanel.close();
         PetGjPanel.close();
         PetGlLvPanel.close();
         PetOpenPanel.close();
         UnionPanel.close();
         UnionSqPanel.close();
         UnionVip.close();
         UnionShopPanel.close();
         AddUnJsPanel.close();
         AddUnZJPanel.close();
         UnJsPanel.close();
         WmdPanel.close();
         OnLinePanel.close();
         AttZdlPanel.close();
         DljlPanel.close();
         UnionZpanel.close();
      }
      
      public static function saveMoviclip(param1:Function, param2:String) : void
      {
         var _loc3_:Object = LoaderManager.getSwfClass(param2);
         var _loc4_:MovieClip = new _loc3_() as MovieClip;
         _loc4_.x = 0;
         _loc4_.y = 0;
         XiaoXiaoManager.addCGX(new CGXTime(_loc4_,GM.tsUp,60,param1));
      }
      
      public static function movicpStr(param1:Number = 0, param2:Number = 0, param3:Function = null, param4:String = "Ts_44") : void
      {
         var _loc5_:Object = LoaderManager.getSwfClass(param4);
         var _loc6_:MovieClip = new _loc5_() as MovieClip;
         _loc6_.x = param1;
         _loc6_.y = param2;
         XiaoXiaoManager.addCGX(new CGXEvent(_loc6_,GM.tsUp,param3));
      }
      
      public static function openBoxMovicpStr(param1:Number = 0, param2:Number = 0, param3:Function = null, param4:String = "Ts_44") : void
      {
         var _loc5_:Object = LoaderManager.getSwfClass(param4);
         var _loc6_:MovieClip = new _loc5_() as MovieClip;
         _loc6_.x = param1;
         _loc6_.y = param2;
         var _loc7_:Object = LoaderManager.getSwfClass("Ts_200");
         var _loc8_:MovieClip = new _loc7_() as MovieClip;
         _loc8_.x = -2480;
         _loc8_.y = 114;
         XiaoXiaoManager.addCGX(new CGXFrame(_loc8_,GM.levelm.curLevel.getvs().getNpcMc()));
         XiaoXiaoManager.addCGX(new CGXEvent(_loc6_,GM.tsUp,param3));
      }
      
      public static function tsFunction(param1:String, param2:Number = 0, param3:Number = 230) : void
      {
         var _loc4_:Object = LoaderManager.getSwfClass(param1);
         var _loc5_:MovieClip = new _loc4_() as MovieClip;
         if(param2 == 0)
         {
            _loc5_.x = 480 - _loc5_.width / 2;
         }
         else
         {
            _loc5_.x = param2;
         }
         _loc5_.y = param3;
         (_loc5_ as MovieClip).mouseChildren = false;
         (_loc5_ as MovieClip).mouseEnabled = false;
         XiaoXiaoManager.addCGX(new CGXFrame(_loc5_,GM.tsUp));
      }
      
      public static function overTs(param1:String, param2:String, param3:Number, param4:Number) : void
      {
         var _loc5_:Object = LoaderManager.getSwfClass(param1);
         var _loc6_:MovieClip = new _loc5_() as MovieClip;
         _loc6_.x = param3;
         _loc6_.y = param4;
         (_loc6_ as MovieClip).mouseChildren = false;
         (_loc6_ as MovieClip).mouseEnabled = false;
         (_loc6_.jn_3 as TextField).text = param2;
         XiaoXiaoManager.addCGX(new CGXSpeed(_loc6_,GM.tsUp,0,0,100));
      }
      
      public static function tsManger(param1:String, param2:Array, param3:Array, param4:Number = 427, param5:Number = 50) : void
      {
         var _loc6_:Object = LoaderManager.getSwfClass(param1);
         var _loc7_:MovieClip = new _loc6_() as MovieClip;
         _loc7_.x = _loc7_.x = 480 - _loc7_.width / 2;
         _loc7_.y = param5;
         (_loc7_ as MovieClip).mouseChildren = false;
         (_loc7_ as MovieClip).mouseEnabled = false;
         var _loc8_:Array = [];
         var _loc9_:Array = [];
         var _loc10_:Array = [];
         var _loc11_:String = "获得:";
         var _loc12_:uint = 0;
         while(_loc12_ < param2.length)
         {
            _loc8_.push(GoodsFactory.getGoodsById(param2[_loc12_]).getName() + "*" + param3[_loc12_] + ".");
            _loc9_.push(GoodsFactory.getGoodsById(param2[_loc12_]).getColor());
            _loc12_++;
         }
         _loc12_ = 0;
         while(_loc12_ < _loc9_.length)
         {
            if(_loc9_[_loc12_] == 0)
            {
               param1 = "<font color=\"#" + "ffffff" + "\">" + _loc8_[_loc12_] + "</font>";
            }
            else if(_loc9_[_loc12_] == 1)
            {
               param1 = "<font color=\"#" + "0066ff" + "\">" + _loc8_[_loc12_] + "</font>";
            }
            else if(_loc9_[_loc12_] == 2)
            {
               param1 = "<font color=\"#" + "FF33FF" + "\">" + _loc8_[_loc12_] + "</font>";
            }
            else if(_loc9_[_loc12_] == 3)
            {
               param1 = "<font color=\"#" + "ffcc00" + "\">" + _loc8_[_loc12_] + "</font>";
            }
            else if(_loc9_[_loc12_] == 4)
            {
               param1 = "<font color=\"#" + "ff0000" + "\">" + _loc8_[_loc12_] + "</font>";
            }
            _loc11_ += param1;
            _loc12_++;
         }
         (_loc7_.tx as TextField).selectable = false;
         (_loc7_.tx as TextField).embedFonts = true;
         (_loc7_.tx as TextField).htmlText = _loc11_;
         (_loc7_.tx as TextField).setTextFormat(new TextFormat(GM.fzfont.fontName,13));
         XiaoXiaoManager.addCGX(new CGXSpeed(_loc7_,GM.tsUp,0,0,100));
      }
      
      public static function taskTs(param1:Task, param2:Number = 0) : void
      {
         var _loc7_:String = null;
         var _loc8_:Array = null;
         var _loc9_:uint = 0;
         var _loc3_:Object = LoaderManager.getSwfClass("Ts_43");
         var _loc4_:MovieClip = new _loc3_() as MovieClip;
         _loc4_.x = 480 - _loc4_.width / 2;
         (_loc4_ as MovieClip).mouseChildren = false;
         (_loc4_ as MovieClip).mouseEnabled = false;
         (_loc4_.tx as TextField).selectable = false;
         var _loc5_:TextFormat = new TextFormat();
         var _loc6_:String = "";
         if(param2 == 0)
         {
            _loc6_ = "获得任务:" + param1.getName();
            _loc7_ = "0x00FF00";
            _loc4_.y = 81;
            SoundManager.playOnlySound("mp_jierenwu");
         }
         else if(param2 == 1)
         {
            _loc6_ = param1.getName() + "(完成)";
            _loc7_ = "0xFFFF00";
            _loc4_.y = 143;
            SoundManager.playOnlySound("mp3_wanchengrenwu");
         }
         else if(param2 == 2)
         {
            _loc6_ = param1.getName();
            _loc8_ = param1.getTaskMbStr();
            _loc9_ = 0;
            while(_loc9_ < _loc8_.length)
            {
               _loc6_ += String(_loc8_[_loc9_]) + ".";
               _loc9_++;
            }
            _loc7_ = "0xFF00FF";
            _loc4_.y = 112;
         }
         (_loc4_.tx as TextField).embedFonts = true;
         (_loc4_.tx as TextField).text = _loc6_;
         (_loc4_.tx as TextField).setTextFormat(new TextFormat(GM.fzfont.fontName,13,_loc7_));
         XiaoXiaoManager.addCGX(new CGXSpeed(_loc4_,GM.tsUp,0,0,100));
      }
      
      public static function cwTs(param1:String) : void
      {
         var _loc2_:Object = LoaderManager.getSwfClass("Ts_123");
         var _loc3_:MovieClip = new _loc2_() as MovieClip;
         _loc3_.x = 480 - _loc3_.width / 2;
         _loc3_.y = 250;
         (_loc3_ as MovieClip).mouseChildren = false;
         (_loc3_ as MovieClip).mouseEnabled = false;
         (_loc3_.tx as TextField).selectable = false;
         (_loc3_.tx as TextField).embedFonts = true;
         (_loc3_.tx as TextField).text = param1;
         (_loc3_.tx as TextField).setTextFormat(new TextFormat(GM.fzfont.fontName,20));
         XiaoXiaoManager.addCGX(new CGXSpeedAlp(_loc3_,GM.tsUp,0,-1,80));
      }
      
      public static function save() : Object
      {
         var _loc1_:Object = new Object();
         _loc1_.addEq = EquipSlot.save();
         _loc1_.jxbag = BagFactory.save();
         _loc1_.jxtask = TaskData.save();
         _loc1_.jxshop = ShopData.save();
         _loc1_.jxfengj = BagDisplay.save();
         _loc1_.jxware = WareroomPanel.save();
         _loc1_.gene = GeneData.save();
         _loc1_.gift = GiftData.save();
         _loc1_.vp = VipData.save();
         _loc1_.fb = FbData.save();
         _loc1_.fmv = FbPanel.save();
         _loc1_.zp = ZpData.save();
         _loc1_.tim = timexx.getValue();
         _loc1_.ship = ShipData.save();
         _loc1_.pgj = PetGjData.save();
         _loc1_.dl = dataList.save();
         return _loc1_;
      }
      
      public static function read(param1:Object) : void
      {
         var _loc2_:Object = null;
         var _loc3_:Object = null;
         var _loc4_:Object = null;
         var _loc5_:Object = null;
         var _loc6_:Object = null;
         var _loc7_:Array = null;
         var _loc8_:uint = 0;
         initDataXX();
         if(param1 != null)
         {
            dataList = DataList.read(param1.dl);
            if(param1.addEq != null)
            {
               EquipSlot.read(param1.addEq);
            }
            if(param1.gene != null)
            {
               GeneData.read(param1.gene);
            }
            BagFactory.read(param1.jxbag);
            TaskData.read(param1.jxtask);
            ShopData.read(param1.jxshop);
            BagDisplay.read(param1.jxfengj);
            if(param1.jxware != null)
            {
               WareroomPanel.read(param1.jxware);
            }
            if(param1.gift != null)
            {
               GiftData.read(param1.gift);
            }
            if(param1.vp != null)
            {
               VipData.read(param1.vp);
            }
            if(param1.fb != null)
            {
               FbData.read(param1.fb);
            }
            if(param1.fmv != null)
            {
               FbPanel.read(param1.fmv);
            }
            if(param1.zp != null)
            {
               ZpData.read(param1.zp);
            }
            if(param1.ship != null)
            {
               ShipData.read(param1.ship);
            }
            if(param1.pgj != null)
            {
               PetGjData.read(param1.pgj);
            }
            if(param1.tim != null)
            {
               timexx.setValue(param1.tim);
            }
            isNewDxx();
         }
         else
         {
            dataList = DataList.read();
            _loc2_ = new Object();
            _loc2_["id"] = GS.a511060;
            _loc2_["ct"] = GM.getCurrentTime();
            _loc2_["ob"] = new Object();
            _loc3_ = new Object();
            _loc3_["gs"] = _loc2_;
            _loc3_["gn"] = GS.a1;
            _loc4_ = new Object();
            _loc4_["id"] = GS.a511032;
            _loc4_["ct"] = GM.getCurrentTime();
            _loc4_["ob"] = new Object();
            _loc5_ = new Object();
            _loc5_["gs"] = _loc4_;
            _loc5_["gn"] = GS.a5;
            _loc6_ = new Object();
            _loc7_ = [];
            _loc8_ = 0;
            while(_loc8_ < 20)
            {
               if(_loc8_ == GS.a0)
               {
                  _loc7_.push(_loc3_);
               }
               else if(_loc8_ == GS.a1)
               {
                  _loc7_.push(_loc5_);
               }
               else
               {
                  _loc7_.push("null");
               }
               _loc8_++;
            }
            _loc6_["bg"] = _loc7_;
            BagFactory.otherBag.readData(_loc6_);
            BagFactory.otherBag.initKey();
         }
      }
      
      public static function initDataXX() : void
      {
         EquipSlot.addEqSlotBo = false;
         BagFactory.initBag();
         GeneData.initData();
         VipData.initData();
         ZpData.clearTimes();
         ShipData.initData();
         PetGjData.initData();
         timexx = VT.createVT(FlowInterface.getCurrTimer() + GS.a8 * GS.a60 * GS.a60 * GS.a1000);
      }
      
      public static function isNewDxx() : void
      {
         var _loc1_:Date = new Date(timexx.getValue());
         var _loc2_:Number = _loc1_.fullYearUTC;
         var _loc3_:Number = _loc1_.monthUTC;
         var _loc4_:Number = _loc1_.dateUTC;
         var _loc5_:Date = new Date(FlowInterface.getCurrTimer() + GS.a8 * GS.a60 * GS.a60 * GS.a1000);
         var _loc6_:Number = _loc5_.fullYearUTC;
         var _loc7_:Number = _loc5_.monthUTC;
         var _loc8_:Number = _loc5_.dateUTC;
         if(_loc6_ > _loc2_ || _loc7_ > _loc3_ || _loc8_ > _loc4_)
         {
            if(_loc6_ > _loc2_ || _loc7_ > _loc3_)
            {
               dataList.sgnData.initData();
               dataList.unionData.initCs();
            }
            if(isOverZ(_loc6_,_loc7_,_loc8_,_loc2_,_loc3_,_loc4_))
            {
               dataList.unionData.initCs();
               dataList.unionData.initLqJt();
            }
            timexx = VT.createVT(_loc5_.getTime());
            ZpData.clearTimes();
            ShipData.tl.setValue(GS.a100);
            VipData.isSx();
            GeneData.clearTime();
            FbData.clearEd();
            ShopData.evClear();
            TaskData.setTimes(GS.a0);
            TaskData.setJtTimes(GS.a0);
            TaskData.clearSaveDate();
            dataList.uVipData.setEvLq(GS.a0);
            dataList.unShop.clearEv();
            dataList.unionData.evClear();
            dataList.onLData.initOver();
            dataList.evData.initLq();
         }
      }
      
      private static function isOverZ(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number) : Boolean
      {
         if(param1 > param4)
         {
            return true;
         }
         if(param2 > param5)
         {
            return true;
         }
         if(getDayNum(param1,param2,param3) > getDayNum(param4,param5,param6))
         {
            return true;
         }
         return false;
      }
      
      private static function getDayNum(param1:Number, param2:Number, param3:Number) : Number
      {
         var _loc8_:Date = null;
         var _loc4_:Array = [31,28,31,30,31,30,31,31,30,31,30,31];
         if(Number(param1.toString().substr(2,3)) % 4 == 0)
         {
            if(param2 == 1)
            {
               _loc4_[1] = 29;
            }
         }
         var _loc5_:Array = [];
         var _loc6_:Number = Number(_loc4_[param2]);
         var _loc7_:uint = 1;
         while(_loc7_ < _loc6_)
         {
            _loc8_ = new Date(param1,param2,_loc7_);
            if(_loc8_.getDay() == 0)
            {
               _loc5_.push(_loc7_);
            }
            _loc7_++;
         }
         if(param3 >= _loc5_[0] && param3 < _loc5_[1])
         {
            return 1;
         }
         if(param3 >= _loc5_[1] && param3 < _loc5_[2])
         {
            return 2;
         }
         if(param3 >= _loc5_[2] && param3 < _loc5_[3])
         {
            return 3;
         }
         if(param3 >= _loc5_[3])
         {
            return 4;
         }
         return 0;
      }
      
      public static function getPkData(param1:Object) : PkKaiZong
      {
         var _loc2_:PkKaiZong = new PkKaiZong();
         var _loc3_:EquipSlot = EquipSlot.pkRead(param1.jxbag.b5);
         _loc2_.zbArr = _loc3_.getYjNameArr();
         if(param1.vp != null && param1.vp.vip != null)
         {
            if(param1.dl != null && param1.dl.uvp != null && param1.dl.uvp.vp != null)
            {
               if(param1.dl.pb != null)
               {
                  _loc3_.jsSx(param1.vp.vip,param1.dl.uvp.vp,PlayerZfBag.read(param1.dl.pb),GS.a0);
               }
               else
               {
                  _loc3_.jsSx(param1.vp.vip,param1.dl.uvp.vp,null,GS.a0);
               }
            }
            else
            {
               _loc3_.jsSx(param1.vp.vip,GS.a0,null,GS.a0);
            }
         }
         else
         {
            _loc3_.jsSx(GS.a0,GS.a0,null,GS.a0);
         }
         _loc2_.gsdArr = _loc3_.getSkillList();
         _loc2_.roleAtt.hp = _loc3_.getHp(GS.a0);
         _loc2_.roleAtt.nl = _loc3_.getNl(GS.a0);
         _loc2_.roleAtt.gj = _loc3_.getAtt(GS.a0);
         _loc2_.roleAtt.fy = _loc3_.getFy(GS.a0);
         _loc2_.roleAtt.sd = _loc3_.getSp();
         _loc2_.roleAtt.hpPrce = _loc3_.getHp(GS.a1);
         _loc2_.roleAtt.nlPrce = _loc3_.getNl(GS.a1);
         _loc2_.roleAtt.gjPrce = _loc3_.getAtt(GS.a1);
         _loc2_.roleAtt.fyPrce = _loc3_.getFy(GS.a1);
         _loc2_.roleAtt.bj = _loc3_.getBj();
         _loc2_.roleAtt.jin = _loc3_.getJin();
         _loc2_.roleAtt.mu = _loc3_.getMu();
         _loc2_.roleAtt.shui = _loc3_.getShui();
         _loc2_.roleAtt.huo = _loc3_.getHuo();
         _loc2_.roleAtt.tu = _loc3_.getTu();
         _loc2_.roleAtt.hd = _loc3_.getHd();
         _loc2_.roleAtt.jinPrce = _loc3_.getJin(GS.a1);
         _loc2_.roleAtt.muPrce = _loc3_.getMu(GS.a1);
         _loc2_.roleAtt.shuiPrce = _loc3_.getShui(GS.a1);
         _loc2_.roleAtt.huoPrce = _loc3_.getHuo(GS.a1);
         _loc2_.roleAtt.tuPrce = _loc3_.getTu(GS.a1);
         _loc2_.roleAtt.hdPrce = _loc3_.getHd(GS.a1);
         if(param1.vp != null && param1.vp.vip != null)
         {
            if(param1.dl != null && param1.dl.uvp != null && param1.dl.uvp.vp != null)
            {
               if(param1.dl.pb != null)
               {
                  _loc3_.jsSx(param1.vp.vip,param1.dl.uvp.vp,PlayerZfBag.read(param1.dl.pb),GS.a1);
               }
               else
               {
                  _loc3_.jsSx(param1.vp.vip,param1.dl.uvp.vp,null,GS.a1);
               }
            }
            else
            {
               _loc3_.jsSx(param1.vp.vip,GS.a0,null,GS.a1);
            }
         }
         else
         {
            _loc3_.jsSx(GS.a0,GS.a0,null,GS.a1);
         }
         _loc2_.roleAttAndJiJia.hp = _loc3_.getHp(GS.a0);
         _loc2_.roleAttAndJiJia.nl = _loc3_.getNl(GS.a0);
         _loc2_.roleAttAndJiJia.gj = _loc3_.getAtt(GS.a0);
         _loc2_.roleAttAndJiJia.fy = _loc3_.getFy(GS.a0);
         _loc2_.roleAttAndJiJia.sd = _loc3_.getSp();
         _loc2_.roleAttAndJiJia.hpPrce = _loc3_.getHp(GS.a1);
         _loc2_.roleAttAndJiJia.nlPrce = _loc3_.getNl(GS.a1);
         _loc2_.roleAttAndJiJia.gjPrce = _loc3_.getAtt(GS.a1);
         _loc2_.roleAttAndJiJia.fyPrce = _loc3_.getFy(GS.a1);
         _loc2_.roleAttAndJiJia.bj = _loc3_.getBj();
         _loc2_.roleAttAndJiJia.jin = _loc3_.getJin();
         _loc2_.roleAttAndJiJia.mu = _loc3_.getMu();
         _loc2_.roleAttAndJiJia.shui = _loc3_.getShui();
         _loc2_.roleAttAndJiJia.huo = _loc3_.getHuo();
         _loc2_.roleAttAndJiJia.tu = _loc3_.getTu();
         _loc2_.roleAttAndJiJia.hd = _loc3_.getHd();
         _loc2_.roleAttAndJiJia.jinPrce = _loc3_.getJin(GS.a1);
         _loc2_.roleAttAndJiJia.muPrce = _loc3_.getMu(GS.a1);
         _loc2_.roleAttAndJiJia.shuiPrce = _loc3_.getShui(GS.a1);
         _loc2_.roleAttAndJiJia.huoPrce = _loc3_.getHuo(GS.a1);
         _loc2_.roleAttAndJiJia.tuPrce = _loc3_.getTu(GS.a1);
         _loc2_.roleAttAndJiJia.hdPrce = _loc3_.getHd(GS.a1);
         return _loc2_;
      }
      
      public static function pkDisplaySave() : Object
      {
         var _loc9_:Gird = null;
         var _loc10_:Goods = null;
         var _loc1_:Object = new Object();
         _loc1_["newne"] = DeepCopyUtil.encode(GM.testapi.userName);
         _loc1_["lv"] = FlowInterface.getLevelByRole();
         _loc1_["jo"] = FlowInterface.getJobByRole();
         var _loc2_:Array = [];
         var _loc3_:EquipSlot = BagFactory.equipSlot;
         var _loc4_:uint = 0;
         while(_loc4_ < _loc3_.getBagArr().length)
         {
            _loc9_ = _loc3_.getGird(_loc4_);
            if(_loc9_.getGoods() != null)
            {
               _loc10_ = _loc9_.getGoods();
               _loc2_[_loc4_] = _loc10_.getFrame();
            }
            else
            {
               _loc2_[_loc4_] = -1;
            }
            _loc4_++;
         }
         _loc1_["fe"] = _loc2_;
         var _loc5_:Array = [];
         var _loc6_:Array = [];
         _loc5_[0] = String(Math.floor(_loc3_.getHp(0) + FlowInterface.getHpByRole() + (_loc3_.getHp(0) + FlowInterface.getHpByRole()) * _loc3_.getHp(1)));
         _loc5_[1] = String(Math.floor(_loc3_.getNl(0) + FlowInterface.getNlByRole() + (_loc3_.getNl(0) + FlowInterface.getNlByRole()) * _loc3_.getNl(1)));
         _loc5_[2] = String(Math.floor(_loc3_.getAtt(0) + FlowInterface.getAttByRole() + (_loc3_.getAtt(0) + FlowInterface.getAttByRole()) * _loc3_.getAtt(1)));
         _loc5_[3] = String(Math.floor(_loc3_.getFy(0) + FlowInterface.getFyByRole() + (_loc3_.getFy(0) + FlowInterface.getFyByRole()) * _loc3_.getFy(1)));
         _loc5_[4] = String(Math.floor(_loc3_.getSp() + FlowInterface.getSpByRole()));
         _loc5_[5] = String(((_loc3_.getBj() + FlowInterface.getBjByRole()) * 100).toFixed(1) + "%");
         _loc6_[0] = String(Math.floor(_loc3_.getJin()));
         _loc6_[1] = String(Math.floor(_loc3_.getMu()));
         _loc6_[2] = String(Math.floor(_loc3_.getShui()));
         _loc6_[3] = String(Math.floor(_loc3_.getHuo()));
         _loc6_[4] = String(Math.floor(_loc3_.getTu()));
         _loc6_[5] = String(Math.floor(_loc3_.getHd()));
         var _loc7_:* = [_loc5_,_loc6_];
         _loc1_["tx"] = _loc7_;
         var _loc8_:PetR = GM.aSaveData.petm.getFightingPet();
         if(_loc8_ == null)
         {
            _loc1_["ca"] = -1;
            _loc1_["cb"] = -1;
         }
         else
         {
            _loc1_["ca"] = _loc8_.getPetFrame();
            _loc1_["cb"] = _loc8_.curPot + GS.a1;
         }
         return _loc1_;
      }
   }
}

