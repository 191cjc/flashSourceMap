package hotpointgame.gview
{
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   import hotpointgame.ginit.*;
   import hotpointgame.gshangcheng.*;
   import hotpointgame.models.goods.Goods;
   import hotpointgame.utils.gameloader.*;
   import hotpointgame.views.sxPanel.*;
   
   public class GameShangChengC
   {
      
      public static var self:GameShangChengC = new GameShangChengC();
      
      private static var curs:int = 0;
      
      private var mc:MovieClip;
      
      private var scdyjanMc:MovieClip;
      
      private var scdyjtjMc:MovieClip;
      
      private var scdyjzbMc:MovieClip;
      
      private var scdyjdjMc:MovieClip;
      
      private var scdyjcwMc:MovieClip;
      
      private var scdyjwplMc:MovieClip;
      
      private var scxzsxzjmMc:MovieClip;
      
      private var scqwczMc:MovieClip;
      
      private var scgoumaijiemianMc:MovieClip;
      
      private var scczsxttsMc:MovieClip;
      
      private var mcMO:Object;
      
      private var memDa:int = 1;
      
      private var memscdyjtj:int = 1;
      
      private var memscdyjtjpage:int = 1;
      
      private var memscdyjzb:int = 1;
      
      private var memscdyjzbpage:int = 1;
      
      private var memscdyjdj:int = 1;
      
      private var memscdyjdjpage:int = 1;
      
      private var memscdyjcw:int = 1;
      
      private var memscdyjcwpage:int = 1;
      
      private var firstgetmoney:int = 0;
      
      private var _dgMoney:VT = VT.createVT(0);
      
      private var ftjishi:int = 0;
      
      private var _buynumCur:VT = VT.createVT(GS.a1);
      
      private var _buynumMax:VT = VT.createVT(GS.a49 + GS.a50);
      
      private var buyshopBD:ShangChengBData;
      
      private var allscs:Vector.<GameShangChengS>;
      
      private var _sxDisplay:SxPanel;
      
      private var typearray:Array = [0,1,2,5,8,10,11,12];
      
      private var typevaluearray:Array = new Array();
      
      public function GameShangChengC()
      {
         super();
         var _loc1_:int = 0;
         while(_loc1_ < 50)
         {
            this.typevaluearray[_loc1_] = 1;
            _loc1_++;
         }
      }
      
      public static function open() : void
      {
         if(curs == 0)
         {
            self.reset();
         }
      }
      
      public static function close() : void
      {
         self.leave();
      }
      
      public static function exitgame() : void
      {
         self.voltabreset();
         self.leave();
      }
      
      private function voltabreset() : void
      {
         this.memDa = 1;
         this.memscdyjtj = 1;
         this.memscdyjtjpage = 1;
         this.memscdyjzb = 1;
         this.memscdyjzbpage = 1;
         this.memscdyjdj = 1;
         this.memscdyjdjpage = 1;
         this.memscdyjcw = 1;
         this.memscdyjcwpage = 1;
         this.firstgetmoney = 0;
         this.dgMoney = 0;
         this.ftjishi = 0;
         this.buynumCur = GS.a1;
      }
      
      public function reset() : void
      {
         var _loc7_:Class = null;
         var _loc8_:Array = null;
         if(this.mc == null)
         {
            if(!LoaderManager.isLoadedBySwfname("j_shangcheng"))
            {
               if(GM.loaderM.keYiUse())
               {
                  _loc8_ = new Array();
                  _loc8_.push("j_shangcheng");
                  _loc8_.push("sxpanel");
                  _loc8_.push("pmodes1");
                  _loc8_.push("pmodes2");
                  _loc8_.push("t_box");
                  GM.loaderM.setLoadData(_loc8_);
                  GM.loaderM.completeF = open;
                  GM.loaderM.startLoadDataJieM();
                  return;
               }
               return;
            }
            _loc7_ = LoaderManager.getSwfClass("j_shangcheng") as Class;
            this.mc = new _loc7_() as MovieClip;
            this.mc.stop();
            this.mc.x = 19563;
            this.mc.y = 29563;
         }
         curs = 1;
         var _loc1_:Class = LoaderManager.getSwfClass("P_" + FlowInterface.getJobByRole()) as Class;
         var _loc2_:MovieClip = new _loc1_() as MovieClip;
         _loc2_.name = "huangtemp";
         (this.mc["pl"] as MovieClip).addChild(_loc2_);
         (this.mc["scbd"] as MovieClip).gotoAndStop(FlowInterface.getJobByRole());
         (this.mc["scwpgmz"] as MovieClip).visible = false;
         (this.mc["scsave"] as TextField).text = String(int(this.ftjishi / 30));
         (this.mc["scname"] as TextField).htmlText = GM.testapi.userName;
         (this.mc["sczhiye"] as TextField).text = GM.cp.getJobName();
         (this.mc["scdengji"] as TextField).text = String(FlowInterface.getLevelByRole());
         this.mcMO = new Object();
         this.allscs = new Vector.<GameShangChengS>();
         this.scdyjanMc = this.mc["scdyjan"];
         var _loc3_:McBtnLianDong = new McBtnLianDong();
         _loc3_.addBtnLianDong(new McBtn(this.scdyjanMc["sctuijian"]));
         _loc3_.addBtnLianDong(new McBtn(this.scdyjanMc["sczhuangban"]));
         _loc3_.addBtnLianDong(new McBtn(this.scdyjanMc["scdaoju"]));
         _loc3_.addBtnLianDong(new McBtn(this.scdyjanMc["scchongwu"]));
         _loc3_.addBtnNoLian(new McBtn(this.scdyjanMc["scclose"]));
         _loc3_.addBtnNoLian(new McBtn(this.scdyjanMc["scchongzhi"]));
         _loc3_.addBtnNoLian(new McBtn(this.scdyjanMc["schuanyuanchushi"]));
         switch(this.memDa)
         {
            case 1:
               _loc3_.btnByClick("sctuijian");
               break;
            case 2:
               _loc3_.btnByClick("sczhuangban");
               break;
            case 3:
               _loc3_.btnByClick("scdaoju");
               break;
            case 4:
               _loc3_.btnByClick("scchongwu");
         }
         this.mcMO["scdyjanmcm"] = _loc3_;
         this.scdyjwplMc = this.mc["scdyjwpl"];
         _loc3_ = new McBtnLianDong();
         _loc3_.addBtnLianDong(new McBtn(this.scdyjwplMc["scfanyeshang"]));
         _loc3_.addBtnLianDong(new McBtn(this.scdyjwplMc["scfanyexia"]));
         this.mcMO["scdyjwplmcm"] = _loc3_;
         this.scdyjtjMc = this.mc["scdyjtj"];
         _loc3_ = new McBtnLianDong();
         _loc3_.addBtnLianDong(new McBtn(this.scdyjtjMc["scquanbu"]));
         _loc3_.addBtnLianDong(new McBtn(this.scdyjtjMc["screxiao"]));
         _loc3_.addBtnLianDong(new McBtn(this.scdyjtjMc["scxinpin"]));
         _loc3_.addBtnLianDong(new McBtn(this.scdyjtjMc["sczhekou"]));
         switch(this.memscdyjtj)
         {
            case 1:
               _loc3_.btnByClick("scquanbu");
               break;
            case 2:
               _loc3_.btnByClick("screxiao");
               break;
            case 3:
               _loc3_.btnByClick("scxinpin");
               break;
            case 4:
               _loc3_.btnByClick("sczhekou");
         }
         this.mcMO["scdyjtjmcm"] = _loc3_;
         this.scdyjzbMc = this.mc["scdyjzb"];
         _loc3_ = new McBtnLianDong();
         _loc3_.addBtnLianDong(new McBtn(this.scdyjzbMc["scquanbu"]));
         _loc3_.addBtnLianDong(new McBtn(this.scdyjzbMc["screnyifu"]));
         _loc3_.addBtnLianDong(new McBtn(this.scdyjzbMc["screnjianbang"]));
         _loc3_.addBtnLianDong(new McBtn(this.scdyjzbMc["scszwq"]));
         _loc3_.addBtnLianDong(new McBtn(this.scdyjzbMc["scxuanguang"]));
         switch(this.memscdyjzb)
         {
            case 1:
               _loc3_.btnByClick("scquanbu");
               break;
            case 2:
               _loc3_.btnByClick("screnyifu");
               break;
            case 3:
               _loc3_.btnByClick("screnjianbang");
               break;
            case 4:
               _loc3_.btnByClick("scszwq");
               break;
            case 5:
               _loc3_.btnByClick("scxuanguang");
         }
         this.mcMO["scdyjzbmcm"] = _loc3_;
         this.scdyjdjMc = this.mc["scdyjdj"];
         _loc3_ = new McBtnLianDong();
         _loc3_.addBtnLianDong(new McBtn(this.scdyjdjMc["scquanbu"]));
         _loc3_.addBtnLianDong(new McBtn(this.scdyjdjMc["scqita"]));
         switch(this.memscdyjdj)
         {
            case 1:
               _loc3_.btnByClick("scquanbu");
               break;
            case 2:
               _loc3_.btnByClick("scqita");
         }
         this.mcMO["scdyjdjmcm"] = _loc3_;
         this.scdyjcwMc = this.mc["scdyjcw"];
         _loc3_ = new McBtnLianDong();
         _loc3_.addBtnLianDong(new McBtn(this.scdyjcwMc["scquanbu"]));
         _loc3_.addBtnLianDong(new McBtn(this.scdyjcwMc["scqita"]));
         switch(this.memscdyjcw)
         {
            case 1:
               _loc3_.btnByClick("scquanbu");
               break;
            case 2:
               _loc3_.btnByClick("scqita");
         }
         this.mcMO["scdyjcwmcm"] = _loc3_;
         switch(this.memDa)
         {
            case 1:
               this.scdyjtjMc.visible = true;
               this.scdyjzbMc.visible = false;
               this.scdyjdjMc.visible = false;
               this.scdyjcwMc.visible = false;
               break;
            case 2:
               this.scdyjtjMc.visible = false;
               this.scdyjzbMc.visible = true;
               this.scdyjdjMc.visible = false;
               this.scdyjcwMc.visible = false;
               break;
            case 3:
               this.scdyjtjMc.visible = false;
               this.scdyjzbMc.visible = false;
               this.scdyjdjMc.visible = true;
               this.scdyjcwMc.visible = false;
               break;
            case 4:
               this.scdyjtjMc.visible = false;
               this.scdyjzbMc.visible = false;
               this.scdyjdjMc.visible = false;
               this.scdyjcwMc.visible = true;
         }
         this.scqwczMc = this.mc["scqwcz"];
         this.scqwczMc.visible = false;
         _loc3_ = new McBtnLianDong();
         _loc3_.addBtnLianDong(new McBtn(this.scqwczMc["scqwczan"]));
         _loc3_.addBtnLianDong(new McBtn(this.scqwczMc["sctok"]));
         this.mcMO["scqwczmcm"] = _loc3_;
         this.scczsxttsMc = this.mc["scczsxtts"];
         this.scczsxttsMc.visible = false;
         _loc3_ = new McBtnLianDong();
         _loc3_.addBtnLianDong(new McBtn(this.scczsxttsMc["scanwzdl"]));
         this.mcMO["scczsxttsmcm"] = _loc3_;
         this.scgoumaijiemianMc = this.mc["scgoumaijiemian"];
         this.scgoumaijiemianMc.visible = false;
         var _loc4_:Class = LoaderManager.getSwfClass("T_Box") as Class;
         var _loc5_:MovieClip = new _loc4_() as MovieClip;
         _loc5_.mouseEnabled = false;
         _loc5_.mouseChildren = false;
         (_loc5_["mask_mc"] as MovieClip).visible = false;
         (_loc5_["d_mc"] as MovieClip).visible = false;
         (_loc5_["gx_mc"] as MovieClip).visible = false;
         _loc5_.x = this.scgoumaijiemianMc["sctubiaozuobiao"].x - 4;
         _loc5_.y = this.scgoumaijiemianMc["sctubiaozuobiao"].y - 4;
         _loc5_.name = "T_Box_one";
         _loc5_.gotoAndStop(2);
         this.scgoumaijiemianMc.addChild(_loc5_);
         _loc3_ = new McBtnLianDong();
         _loc3_.addBtnLianDong(new McBtn(this.scgoumaijiemianMc["sctshang"]));
         _loc3_.addBtnLianDong(new McBtn(this.scgoumaijiemianMc["sctxia"]));
         _loc3_.addBtnLianDong(new McBtn(this.scgoumaijiemianMc["sctok"]));
         _loc3_.addBtnLianDong(new McBtn(this.scgoumaijiemianMc["sctnook"]));
         this.mcMO["scgoumaijiemianmcm"] = _loc3_;
         var _loc6_:TextField = new TextField();
         _loc6_.mouseEnabled = false;
         _loc6_.defaultTextFormat = new TextFormat("宋体",16,16711680);
         _loc6_.text = "适当娱乐，理性消费";
         _loc6_.width = 300;
         _loc6_.selectable = false;
         _loc6_.x = 425;
         _loc6_.y = 325;
         this.scgoumaijiemianMc.addChild(_loc6_);
         this.scxzsxzjmMc = this.mc["scxzsxzjm"];
         (this.mc["scxingzhuan"] as TextField).text = String(this.dgMoney);
         this.scxzsxzjmMc.visible = false;
         this.initscdyjwpl();
         this.initTypevaluearray();
         this.initZhuangBei();
         this.scdyjanMc.addEventListener(MouseEvent.CLICK,this.scdyjanByClick);
         this.scdyjtjMc.addEventListener(MouseEvent.CLICK,this.scdyjtjByClick);
         this.scdyjzbMc.addEventListener(MouseEvent.CLICK,this.scdyjzbByClick);
         this.scdyjdjMc.addEventListener(MouseEvent.CLICK,this.scdyjdjByClick);
         this.scdyjcwMc.addEventListener(MouseEvent.CLICK,this.scdyjcwByClick);
         this.scdyjwplMc.addEventListener(MouseEvent.CLICK,this.scdyjwplByClick);
         this.scqwczMc.addEventListener(MouseEvent.CLICK,this.scqwczByClick);
         this.scgoumaijiemianMc.addEventListener(MouseEvent.CLICK,this.scgoumaijiemianByClick);
         this.scczsxttsMc.addEventListener(MouseEvent.CLICK,this.scczsxttsByClick);
         this.mc.addEventListener(Event.ENTER_FRAME,this.enterfH);
         this._sxDisplay = SxPanel.createSxpanel();
         this.mc.addChild(this._sxDisplay);
         this._sxDisplay.init();
         this.mc.x = 0;
         this.mc.y = 0;
         GM.cbGview.addChild(this.mc);
      }
      
      private function leave() : void
      {
         var _loc1_:GameShangChengS = null;
         if(curs == 1)
         {
            curs = 0;
            this.mc.x = 19563;
            this.mc.y = 29563;
            for each(_loc1_ in this.allscs)
            {
               _loc1_.removeSelf();
            }
            this.allscs.length = 0;
            this.allscs = null;
            this.scdyjanMc.removeEventListener(MouseEvent.CLICK,this.scdyjanByClick);
            this.scdyjtjMc.removeEventListener(MouseEvent.CLICK,this.scdyjtjByClick);
            this.scdyjzbMc.removeEventListener(MouseEvent.CLICK,this.scdyjzbByClick);
            this.scdyjdjMc.removeEventListener(MouseEvent.CLICK,this.scdyjdjByClick);
            this.scdyjcwMc.removeEventListener(MouseEvent.CLICK,this.scdyjcwByClick);
            this.scdyjwplMc.removeEventListener(MouseEvent.CLICK,this.scdyjwplByClick);
            this.scqwczMc.removeEventListener(MouseEvent.CLICK,this.scqwczByClick);
            this.scgoumaijiemianMc.removeEventListener(MouseEvent.CLICK,this.scgoumaijiemianByClick);
            this.scczsxttsMc.removeEventListener(MouseEvent.CLICK,this.scczsxttsByClick);
            this.mc.removeEventListener(Event.ENTER_FRAME,this.enterfH);
            this.scdyjanMc = null;
            this.scdyjtjMc = null;
            this.scdyjzbMc = null;
            this.scdyjdjMc = null;
            this.scdyjcwMc = null;
            this.scdyjwplMc = null;
            this.scxzsxzjmMc = null;
            this.scqwczMc = null;
            this.scgoumaijiemianMc = null;
            this.scczsxttsMc = null;
            (this.mcMO["scdyjanmcm"] as McBtnLianDong).remove();
            (this.mcMO["scdyjwplmcm"] as McBtnLianDong).remove();
            (this.mcMO["scdyjtjmcm"] as McBtnLianDong).remove();
            (this.mcMO["scdyjzbmcm"] as McBtnLianDong).remove();
            (this.mcMO["scdyjdjmcm"] as McBtnLianDong).remove();
            (this.mcMO["scqwczmcm"] as McBtnLianDong).remove();
            (this.mcMO["scczsxttsmcm"] as McBtnLianDong).remove();
            (this.mcMO["scgoumaijiemianmcm"] as McBtnLianDong).remove();
            (this.mcMO["scdyjcwmcm"] as McBtnLianDong).remove();
            this.mcMO = null;
            this.buyshopBD = null;
            if(this._sxDisplay.parent)
            {
               this._sxDisplay.parent.removeChild(this._sxDisplay);
            }
            this._sxDisplay = null;
            GM.cbGview.removeChild(this.mc);
            this.mc = null;
         }
      }
      
      public function getMoneyOk(param1:int) : void
      {
         if(curs == 1)
         {
            this.scxzsxzjmMc.visible = false;
            this.dgMoney = param1;
            (this.mc["scxingzhuan"] as TextField).text = String(this.dgMoney);
         }
         else
         {
            this.dgMoney = param1;
         }
      }
      
      public function buyShopByClick(param1:ShangChengBData) : void
      {
         var _loc2_:Goods = null;
         if(curs == 1)
         {
            this.buyshopBD = param1;
            if(this.buyshopBD.isShowBuyNum == -1)
            {
               if(this.buyshopBD.buyPrice > GameShangChengC.self.dgMoney)
               {
                  this.scqwczMc.visible = true;
                  return;
               }
               if(!FlowInterface.isKeYiFangById(this.buyshopBD.propId,GS.a1))
               {
                  GoodsManger.cwTs("背包已满");
                  return;
               }
               this.buyShopByApiOne();
            }
            else
            {
               this.buynumCur = GS.a1;
               this.scgoumaijiemianMc.visible = true;
               _loc2_ = FlowInterface.getGoodsById(this.buyshopBD.propId);
               (this.scgoumaijiemianMc.getChildByName("T_Box_one") as MovieClip).gotoAndStop(_loc2_.getFrame());
               (this.scgoumaijiemianMc["sctwpm"] as TextField).text = _loc2_.getName();
               (this.scgoumaijiemianMc["sctshuliang"] as TextField).text = "" + this.buynumCur;
               (this.scgoumaijiemianMc["sctzj"] as TextField).text = "" + this.buynumCur * this.buyshopBD.buyPrice;
            }
         }
      }
      
      private function buyShopOver(param1:int) : void
      {
         if(curs == 1)
         {
            if(param1 == 0)
            {
               (this.mc["scwpgmz"] as MovieClip).visible = false;
               this.scqwczMc.visible = true;
            }
            else
            {
               GM.testapi.saveDataBeforeNoState();
               (this.mc["scwpgmz"] as MovieClip).visible = false;
               (this.mc["scxingzhuan"] as TextField).text = String(this.dgMoney);
               GoodsManger.cwTs("购买成功!");
            }
         }
      }
      
      private function buyShopByApi() : void
      {
         (this.mc["scwpgmz"] as MovieClip).visible = true;
         GM.testapi.getStateAndBuyShopProp(this.buyshopBD.buyId,this.buynumCur,this.buyshopBD.buyPrice,this.buyShopOver,this.buyshopBD.propId);
      }
      
      private function buyShopByApiOne() : void
      {
         (this.mc["scwpgmz"] as MovieClip).visible = true;
         GM.testapi.getStateAndBuyShopProp(this.buyshopBD.buyId,GS.a1,this.buyshopBD.buyPrice,this.buyShopOver,this.buyshopBD.propId);
      }
      
      private function showBuyKuanByupdate() : void
      {
         (this.scgoumaijiemianMc["sctshuliang"] as TextField).text = "" + this.buynumCur;
         (this.scgoumaijiemianMc["sctzj"] as TextField).text = "" + this.buynumCur * this.buyshopBD.buyPrice;
      }
      
      public function testChuangZB(param1:int, param2:int) : void
      {
         this.typevaluearray[param1] = param2;
         this.initZhuangBei();
      }
      
      private function initTypevaluearray() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this.typearray.length)
         {
            this.typevaluearray[this.typearray[_loc1_]] = FlowInterface.getEquipTuBiaoFrame(this.typearray[_loc1_]);
            _loc1_++;
         }
      }
      
      private function initZhuangBei() : void
      {
         var _loc1_:MovieClip = (this.mc["pl"] as MovieClip).getChildByName("huangtemp") as MovieClip;
         var _loc2_:int = 0;
         while(_loc2_ < this.typearray.length)
         {
            (_loc1_["bh_" + this.typearray[_loc2_]] as MovieClip).gotoAndStop(this.typevaluearray[this.typearray[_loc2_]]);
            (_loc1_["bh_" + this.typearray[_loc2_]]["playerhuwan"] as MovieClip).gotoAndPlay(1);
            switch(this.typearray[_loc2_])
            {
               case 8:
                  (_loc1_["bh_" + 17] as MovieClip).gotoAndStop(this.typevaluearray[this.typearray[_loc2_]]);
                  (_loc1_["bh_" + 17]["playerhuwan"] as MovieClip).gotoAndPlay(1);
                  if(this.typevaluearray[this.typearray[_loc2_]] != 1)
                  {
                     (_loc1_["bh_" + 8] as MovieClip).visible = true;
                     (_loc1_["bh_" + 17] as MovieClip).visible = true;
                     (_loc1_["bh_" + 1] as MovieClip).visible = false;
                     (_loc1_["bh_" + 2] as MovieClip).visible = false;
                     (_loc1_["bh_" + 5] as MovieClip).visible = false;
                  }
                  else
                  {
                     (_loc1_["bh_" + 8] as MovieClip).visible = false;
                     (_loc1_["bh_" + 17] as MovieClip).visible = false;
                     (_loc1_["bh_" + 1] as MovieClip).visible = true;
                     (_loc1_["bh_" + 2] as MovieClip).visible = true;
                     (_loc1_["bh_" + 5] as MovieClip).visible = true;
                  }
                  break;
               case 10:
                  (_loc1_["bh_" + 18] as MovieClip).gotoAndStop(this.typevaluearray[this.typearray[_loc2_]]);
                  (_loc1_["bh_" + 18]["playerhuwan"] as MovieClip).gotoAndPlay(1);
                  break;
               case 11:
                  if(this.typevaluearray[this.typearray[_loc2_]] != 1)
                  {
                     (_loc1_["bh_" + 0] as MovieClip).visible = false;
                     (_loc1_["bh_" + 11] as MovieClip).visible = true;
                  }
                  else
                  {
                     (_loc1_["bh_" + 0] as MovieClip).visible = true;
                     (_loc1_["bh_" + 11] as MovieClip).visible = false;
                  }
                  break;
               case 12:
                  (_loc1_["bh_" + 19] as MovieClip).gotoAndStop(this.typevaluearray[this.typearray[_loc2_]]);
                  (_loc1_["bh_" + 19]["playerhuwan"] as MovieClip).gotoAndPlay(1);
            }
            _loc2_++;
         }
      }
      
      private function initscdyjwpl() : void
      {
         var _loc1_:GameShangChengS = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc6_:GameShangChengS = null;
         for each(_loc1_ in this.allscs)
         {
            _loc1_.removeSelf();
         }
         this.allscs.length = 0;
         _loc2_ = 0;
         _loc3_ = 0;
         switch(this.memDa)
         {
            case 1:
               _loc2_ = int(this.memscdyjtj);
               _loc3_ = int(this.memscdyjtjpage);
               break;
            case 2:
               _loc2_ = int(this.memscdyjzb);
               _loc3_ = int(this.memscdyjzbpage);
               break;
            case 3:
               _loc2_ = int(this.memscdyjdj);
               _loc3_ = int(this.memscdyjdjpage);
               break;
            case 4:
               _loc2_ = int(this.memscdyjcw);
               _loc3_ = int(this.memscdyjcwpage);
         }
         var _loc4_:Array = ShangChengBDMangaer.getShopList(this.memDa,_loc2_,_loc3_);
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_.length)
         {
            _loc6_ = new GameShangChengS(_loc4_[_loc5_]);
            _loc6_.x = this.scdyjwplMc["scbiaoqian" + (_loc5_ + 1)].x;
            _loc6_.y = this.scdyjwplMc["scbiaoqian" + (_loc5_ + 1)].y;
            this.scdyjwplMc.addChild(_loc6_);
            this.allscs.push(_loc6_);
            _loc5_++;
         }
         (this.scdyjwplMc["scyeshu"] as TextField).text = "" + _loc3_ + "/" + ShangChengBDMangaer.getShopPage(this.memDa,_loc2_);
      }
      
      private function enterfH(param1:Event) : void
      {
         if(this.ftjishi >= 0)
         {
            (this.mc["scsave"] as TextField).text = String(int(this.ftjishi / 30));
            --this.ftjishi;
         }
      }
      
      private function scdyjanByClick(param1:MouseEvent) : void
      {
         if(param1.target.name != null && Boolean((this.mcMO["scdyjanmcm"] as McBtnLianDong).isFlase(param1.target.name)))
         {
            switch(param1.target.name)
            {
               case "sctuijian":
                  if(this.memDa != 1)
                  {
                     (this.mcMO["scdyjanmcm"] as McBtnLianDong).btnByClick(param1.target.name);
                     this.scdyjtjMc.visible = true;
                     this.scdyjzbMc.visible = false;
                     this.scdyjdjMc.visible = false;
                     this.scdyjcwMc.visible = false;
                     this.memDa = 1;
                     this.initscdyjwpl();
                  }
                  break;
               case "sczhuangban":
                  if(this.memDa != 2)
                  {
                     (this.mcMO["scdyjanmcm"] as McBtnLianDong).btnByClick(param1.target.name);
                     this.scdyjtjMc.visible = false;
                     this.scdyjzbMc.visible = true;
                     this.scdyjdjMc.visible = false;
                     this.scdyjcwMc.visible = false;
                     this.memDa = 2;
                     this.initscdyjwpl();
                  }
                  break;
               case "scdaoju":
                  if(this.memDa != 3)
                  {
                     (this.mcMO["scdyjanmcm"] as McBtnLianDong).btnByClick(param1.target.name);
                     this.scdyjtjMc.visible = false;
                     this.scdyjzbMc.visible = false;
                     this.scdyjdjMc.visible = true;
                     this.scdyjcwMc.visible = false;
                     this.memDa = 3;
                     this.initscdyjwpl();
                  }
                  break;
               case "scchongwu":
                  if(this.memDa != 4)
                  {
                     (this.mcMO["scdyjanmcm"] as McBtnLianDong).btnByClick(param1.target.name);
                     this.scdyjtjMc.visible = false;
                     this.scdyjzbMc.visible = false;
                     this.scdyjdjMc.visible = false;
                     this.scdyjcwMc.visible = true;
                     this.memDa = 4;
                     this.initscdyjwpl();
                  }
                  break;
               case "scchongzhi":
                  GM.testapi.gameChongMoney(100);
                  this.scczsxttsMc.visible = true;
                  break;
               case "schuanyuanchushi":
                  this.initTypevaluearray();
                  this.initZhuangBei();
                  break;
               case "scclose":
                  this.leave();
            }
         }
      }
      
      private function scdyjtjByClick(param1:MouseEvent) : void
      {
         if(param1.target.name != null && Boolean((this.mcMO["scdyjtjmcm"] as McBtnLianDong).isFlase(param1.target.name)))
         {
            (this.mcMO["scdyjtjmcm"] as McBtnLianDong).btnByClick(param1.target.name);
            switch(param1.target.name)
            {
               case "scquanbu":
                  if(this.memscdyjtj != 1)
                  {
                     this.memscdyjtj = 1;
                     this.memscdyjtjpage = 1;
                     this.initscdyjwpl();
                  }
                  break;
               case "screxiao":
                  if(this.memscdyjtj != 2)
                  {
                     this.memscdyjtj = 2;
                     this.memscdyjtjpage = 1;
                     this.initscdyjwpl();
                  }
                  break;
               case "scxinpin":
                  if(this.memscdyjtj != 3)
                  {
                     this.memscdyjtj = 3;
                     this.memscdyjtjpage = 1;
                     this.initscdyjwpl();
                  }
                  break;
               case "sczhekou":
                  if(this.memscdyjtj != 4)
                  {
                     this.memscdyjtj = 4;
                     this.memscdyjtjpage = 1;
                     this.initscdyjwpl();
                  }
            }
         }
      }
      
      private function scdyjzbByClick(param1:MouseEvent) : void
      {
         if(param1.target.name != null && Boolean((this.mcMO["scdyjzbmcm"] as McBtnLianDong).isFlase(param1.target.name)))
         {
            (this.mcMO["scdyjzbmcm"] as McBtnLianDong).btnByClick(param1.target.name);
            switch(param1.target.name)
            {
               case "scquanbu":
                  if(this.memscdyjzb != 1)
                  {
                     this.memscdyjzb = 1;
                     this.memscdyjzbpage = 1;
                     this.initscdyjwpl();
                  }
                  break;
               case "screnyifu":
                  if(this.memscdyjzb != 2)
                  {
                     this.memscdyjzb = 2;
                     this.memscdyjzbpage = 1;
                     this.initscdyjwpl();
                  }
                  break;
               case "screnjianbang":
                  if(this.memscdyjzb != 3)
                  {
                     this.memscdyjzb = 3;
                     this.memscdyjzbpage = 1;
                     this.initscdyjwpl();
                  }
                  break;
               case "scszwq":
                  if(this.memscdyjzb != 4)
                  {
                     this.memscdyjzb = 4;
                     this.memscdyjzbpage = 1;
                     this.initscdyjwpl();
                  }
                  break;
               case "scxuanguang":
                  if(this.memscdyjzb != 5)
                  {
                     this.memscdyjzb = 5;
                     this.memscdyjzbpage = 1;
                     this.initscdyjwpl();
                  }
            }
         }
      }
      
      private function scdyjdjByClick(param1:MouseEvent) : void
      {
         if(param1.target.name != null && Boolean((this.mcMO["scdyjdjmcm"] as McBtnLianDong).isFlase(param1.target.name)))
         {
            (this.mcMO["scdyjdjmcm"] as McBtnLianDong).btnByClick(param1.target.name);
            switch(param1.target.name)
            {
               case "scquanbu":
                  if(this.memscdyjdj != 1)
                  {
                     this.memscdyjdj = 1;
                     this.memscdyjdjpage = 1;
                     this.initscdyjwpl();
                  }
                  break;
               case "scqita":
                  if(this.memscdyjdj != 2)
                  {
                     this.memscdyjdj = 2;
                     this.memscdyjdjpage = 1;
                     this.initscdyjwpl();
                  }
            }
         }
      }
      
      private function scdyjcwByClick(param1:MouseEvent) : void
      {
         if(param1.target.name != null && Boolean((this.mcMO["scdyjcwmcm"] as McBtnLianDong).isFlase(param1.target.name)))
         {
            (this.mcMO["scdyjcwmcm"] as McBtnLianDong).btnByClick(param1.target.name);
            switch(param1.target.name)
            {
               case "scquanbu":
                  if(this.memscdyjcw != 1)
                  {
                     this.memscdyjcw = 1;
                     this.memscdyjcwpage = 1;
                     this.initscdyjwpl();
                  }
                  break;
               case "scqita":
                  if(this.memscdyjcw != 2)
                  {
                     this.memscdyjcw = 2;
                     this.memscdyjcwpage = 1;
                     this.initscdyjwpl();
                  }
            }
         }
      }
      
      private function scdyjwplByClick(param1:MouseEvent) : void
      {
         if(param1.target.name != null && Boolean((this.mcMO["scdyjwplmcm"] as McBtnLianDong).isFlase(param1.target.name)))
         {
            switch(param1.target.name)
            {
               case "scfanyeshang":
                  if(this.isYouShange())
                  {
                     switch(this.memDa)
                     {
                        case 1:
                           --this.memscdyjtjpage;
                           this.initscdyjwpl();
                           break;
                        case 2:
                           --this.memscdyjzbpage;
                           this.initscdyjwpl();
                           break;
                        case 3:
                           --this.memscdyjdjpage;
                           this.initscdyjwpl();
                           break;
                        case 4:
                           --this.memscdyjcwpage;
                           this.initscdyjwpl();
                     }
                  }
                  return;
               case "scfanyexia":
                  if(this.isYouXia())
                  {
                     switch(this.memDa)
                     {
                        case 1:
                           ++this.memscdyjtjpage;
                           this.initscdyjwpl();
                           break;
                        case 2:
                           ++this.memscdyjzbpage;
                           this.initscdyjwpl();
                           break;
                        case 3:
                           ++this.memscdyjdjpage;
                           this.initscdyjwpl();
                           break;
                        case 4:
                           ++this.memscdyjcwpage;
                           this.initscdyjwpl();
                     }
                  }
                  return;
            }
         }
      }
      
      private function scqwczByClick(param1:MouseEvent) : void
      {
         if(param1.target.name != null && Boolean((this.mcMO["scqwczmcm"] as McBtnLianDong).isFlase(param1.target.name)))
         {
            switch(param1.target.name)
            {
               case "scqwczan":
                  GM.testapi.gameChongMoney(100);
                  this.scczsxttsMc.visible = true;
                  this.scqwczMc.visible = false;
                  break;
               case "sctok":
                  this.scqwczMc.visible = false;
            }
         }
      }
      
      private function scgoumaijiemianByClick(param1:MouseEvent) : void
      {
         if(param1.target.name != null && Boolean((this.mcMO["scgoumaijiemianmcm"] as McBtnLianDong).isFlase(param1.target.name)))
         {
            switch(param1.target.name)
            {
               case "sctshang":
                  if(this.buynumCur == 1)
                  {
                     this.buynumCur = this.buynumMax;
                  }
                  else
                  {
                     --this.buynumCur;
                  }
                  this.showBuyKuanByupdate();
                  break;
               case "sctxia":
                  if(this.buynumCur == this.buynumMax)
                  {
                     this.buynumCur = GS.a1;
                  }
                  else
                  {
                     ++this.buynumCur;
                  }
                  this.showBuyKuanByupdate();
                  break;
               case "sctok":
                  this.scgoumaijiemianMc.visible = false;
                  if(this.buynumCur < GS.a1)
                  {
                     GM.findCheatMax(GS.a36);
                  }
                  if(this.buyshopBD.buyPrice * this.buynumCur > this.dgMoney)
                  {
                     this.scqwczMc.visible = true;
                     return;
                  }
                  if(!FlowInterface.isKeYiFangById(this.buyshopBD.propId,this.buynumCur))
                  {
                     GoodsManger.cwTs("背包已满");
                     return;
                  }
                  this.buyShopByApi();
                  break;
               case "sctnook":
                  this.scgoumaijiemianMc.visible = false;
            }
         }
      }
      
      private function scczsxttsByClick(param1:MouseEvent) : void
      {
         if(param1.target.name != null && Boolean((this.mcMO["scczsxttsmcm"] as McBtnLianDong).isFlase(param1.target.name)))
         {
            switch(param1.target.name)
            {
               case "scanwzdl":
                  this.scczsxttsMc.visible = false;
            }
         }
      }
      
      private function isYouShange() : Boolean
      {
         var _loc1_:int = 0;
         switch(this.memDa)
         {
            case 1:
               _loc1_ = int(ShangChengBDMangaer.getShopPage(this.memDa,this.memscdyjtj));
               return this.memscdyjtjpage > 1;
            case 2:
               _loc1_ = int(ShangChengBDMangaer.getShopPage(this.memDa,this.memscdyjzb));
               return this.memscdyjzbpage > 1;
            case 3:
               _loc1_ = int(ShangChengBDMangaer.getShopPage(this.memDa,this.memscdyjdj));
               return this.memscdyjdjpage > 1;
            case 4:
               _loc1_ = int(ShangChengBDMangaer.getShopPage(this.memDa,this.memscdyjcw));
               return this.memscdyjcwpage > 1;
            default:
               return false;
         }
      }
      
      private function isYouXia() : Boolean
      {
         var _loc1_:int = 0;
         switch(this.memDa)
         {
            case 1:
               _loc1_ = int(ShangChengBDMangaer.getShopPage(this.memDa,this.memscdyjtj));
               return this.memscdyjtjpage < _loc1_;
            case 2:
               _loc1_ = int(ShangChengBDMangaer.getShopPage(this.memDa,this.memscdyjzb));
               return this.memscdyjzbpage < _loc1_;
            case 3:
               _loc1_ = int(ShangChengBDMangaer.getShopPage(this.memDa,this.memscdyjdj));
               return this.memscdyjdjpage < _loc1_;
            case 4:
               _loc1_ = int(ShangChengBDMangaer.getShopPage(this.memDa,this.memscdyjcw));
               return this.memscdyjcwpage < _loc1_;
            default:
               return false;
         }
      }
      
      public function get dgMoney() : int
      {
         return this._dgMoney.getValue();
      }
      
      public function set dgMoney(param1:int) : void
      {
         this._dgMoney.setValue(param1);
      }
      
      public function get buynumCur() : int
      {
         return this._buynumCur.getValue();
      }
      
      public function set buynumCur(param1:int) : void
      {
         this._buynumCur.setValue(param1);
      }
      
      public function get buynumMax() : int
      {
         return this._buynumMax.getValue();
      }
      
      public function set buynumMax(param1:int) : void
      {
         this._buynumMax.setValue(param1);
      }
   }
}

