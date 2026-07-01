package hotpointgame.gview
{
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   import hotpointgame.common.event.*;
   import hotpointgame.ginit.*;
   import hotpointgame.gview.GvUdata.*;
   import hotpointgame.models.bag.*;
   import hotpointgame.repository.goods.*;
   import hotpointgame.utils.gameloader.*;
   import hotpointgame.views.sxPanel.*;
   
   public class GSummerVChong
   {
      
      private static var self:GSummerVChong = new GSummerVChong();
      
      private static var curs:int = 0;
      
      private var mc:MovieClip;
      
      private var mcMO:Object;
      
      private var curchoose:int = 1;
      
      private var _sxDisplay:SxPanel;
      
      private var dddA:Array = ["wpk1","wpk2","wpk3","wpk4"];
      
      public function GSummerVChong()
      {
         super();
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
      
      public function reset() : void
      {
         var _loc3_:Class = null;
         var _loc4_:Array = null;
         var _loc5_:Class = null;
         var _loc6_:MovieClip = null;
         if(this.mc == null)
         {
            if(!LoaderManager.isLoadedBySwfname("j_sjljcz"))
            {
               if(GM.loaderM.keYiUse())
               {
                  _loc4_ = new Array();
                  _loc4_.push("j_sjljcz");
                  _loc4_.push("t_box");
                  _loc4_.push("sxpanel");
                  GM.loaderM.setLoadData(_loc4_);
                  GM.loaderM.completeF = open;
                  GM.loaderM.startLoadDataJieM();
                  return;
               }
               return;
            }
            _loc3_ = LoaderManager.getSwfClass("j_sjljcz") as Class;
            this.mc = new _loc3_() as MovieClip;
            this.mc.stop();
            this.mc.x = 19563;
            this.mc.y = 29563;
         }
         curs = 1;
         this.mc.x = 0;
         this.mc.y = 0;
         (this.mc["pktk5"] as MovieClip).visible = true;
         if(GM.testapi.allChongGod < GS.a0)
         {
            GM.testapi.getAllChongeMoney();
         }
         this.mcMO = new Object();
         var _loc1_:McBtnLianDong = new McBtnLianDong();
         _loc1_.addBtnLianDong(new McBtn(this.mc["d1"]));
         _loc1_.addBtnLianDong(new McBtn(this.mc["d2"]));
         _loc1_.addBtnLianDong(new McBtn(this.mc["d3"]));
         _loc1_.addBtnLianDong(new McBtn(this.mc["d4"]));
         _loc1_.addBtnLianDong(new McBtn(this.mc["d5"]));
         _loc1_.addBtnLianDong(new McBtn(this.mc["d6"]));
         _loc1_.addBtnLianDong(new McBtn(this.mc["d7"]));
         _loc1_.addBtnLianDong(new McBtn(this.mc["d8"]));
         _loc1_.addBtnNoLian(new McBtn(this.mc["sjlq"]));
         _loc1_.addBtnNoLian(new McBtn(this.mc["sjchongzhi"]));
         _loc1_.addBtnNoLian(new McBtn(this.mc["xx"]));
         this.mcMO["onlybtnz"] = _loc1_;
         var _loc2_:int = 1;
         while(_loc2_ <= 4)
         {
            _loc5_ = LoaderManager.getSwfClass("T_Box") as Class;
            _loc6_ = new _loc5_() as MovieClip;
            _loc6_.mouseEnabled = false;
            _loc6_.mouseChildren = false;
            (_loc6_["mask_mc"] as MovieClip).visible = false;
            (_loc6_["d_mc"] as MovieClip).visible = false;
            (_loc6_["gx_mc"] as MovieClip).visible = false;
            _loc6_.name = "kaipaitubiao";
            (this.mc["wpk" + _loc2_] as MovieClip).addChild(_loc6_);
            _loc6_.gotoAndStop(1);
            _loc2_++;
         }
         this._sxDisplay = SxPanel.createSxpanel();
         this.mc.addChild(this._sxDisplay);
         this._sxDisplay.init();
         this.mc.addEventListener(Event.ENTER_FRAME,this.enterHandle);
         this.mc.addEventListener(MouseEvent.CLICK,this.mcclick);
         this.mc.addEventListener(MouseEvent.MOUSE_OVER,this.mcmoveovere);
         this.mc.addEventListener(MouseEvent.MOUSE_OUT,this.mcmoveoute);
         GM.cbGview.addChild(this.mc);
      }
      
      public function leave() : void
      {
         if(curs == 1)
         {
            curs = 0;
            this.curchoose = 1;
            this.mc.x = 19563;
            this.mc.y = 29563;
            (this.mcMO["onlybtnz"] as McBtnLianDong).remove();
            this.mcMO = null;
            if(this._sxDisplay.parent)
            {
               this._sxDisplay.parent.removeChild(this._sxDisplay);
            }
            this._sxDisplay = null;
            this.mc.removeEventListener(Event.ENTER_FRAME,this.enterHandle);
            this.mc.removeEventListener(MouseEvent.CLICK,this.mcclick);
            this.mc.removeEventListener(MouseEvent.MOUSE_OVER,this.mcmoveovere);
            this.mc.removeEventListener(MouseEvent.MOUSE_OUT,this.mcmoveoute);
            GM.cbGview.removeChild(this.mc);
            this.mc = null;
         }
      }
      
      private function showjiemian() : void
      {
         (this.mc["ljcz"] as TextField).text = "" + GM.testapi.allChongGod;
         (this.mcMO["onlybtnz"] as McBtnLianDong).btnByClick("d" + this.curchoose);
         var _loc1_:int = 1;
         while(_loc1_ < 5)
         {
            ((this.mc["wpk" + _loc1_] as MovieClip).getChildByName("kaipaitubiao") as MovieClip).gotoAndStop(1);
            (this.mc["s" + _loc1_] as TextField).text = "";
            _loc1_++;
         }
         var _loc2_:SVcongData = SVcongDataM.getbd(this.curchoose);
         if(Boolean(GM.aSaveData.summervd.isKYDataa(this.curchoose)) && _loc2_.congvalue <= GM.testapi.allChongGod)
         {
            (this.mcMO["onlybtnz"] as McBtnLianDong).getMcBtnByName("sjlq").clickCancel();
         }
         else
         {
            (this.mcMO["onlybtnz"] as McBtnLianDong).getMcBtnByName("sjlq").clickDisable();
         }
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.awardList.length)
         {
            ((this.mc["wpk" + (_loc3_ + 1)] as MovieClip).getChildByName("kaipaitubiao") as MovieClip).gotoAndStop(GoodsFactory.getGoodsById((_loc2_.awardList[_loc3_][0] as VT).getValue()).getFrame());
            (this.mc["s" + (_loc3_ + 1)] as TextField).text = "" + (_loc2_.awardList[_loc3_][1] as VT).getValue();
            _loc3_++;
         }
      }
      
      private function enterHandle(param1:Event) : void
      {
         if(GM.testapi.allChongGod >= GS.a0)
         {
            this.mc.removeEventListener(Event.ENTER_FRAME,this.enterHandle);
            this.showjiemian();
            (this.mc["pktk5"] as MovieClip).visible = false;
         }
      }
      
      private function mcclick(param1:MouseEvent) : void
      {
         var _loc2_:SVcongData = null;
         var _loc3_:Array = null;
         var _loc4_:Array = null;
         var _loc5_:int = 0;
         if(param1.target.name != null && Boolean((this.mcMO["onlybtnz"] as McBtnLianDong).isFlase(param1.target.name)))
         {
            switch(param1.target.name)
            {
               case "d1":
                  this.curchoose = GS.a1;
                  this.showjiemian();
                  break;
               case "d2":
                  this.curchoose = GS.a2;
                  this.showjiemian();
                  break;
               case "d3":
                  this.curchoose = GS.a3;
                  this.showjiemian();
                  break;
               case "d4":
                  this.curchoose = GS.a4;
                  this.showjiemian();
                  break;
               case "d5":
                  this.curchoose = GS.a5;
                  this.showjiemian();
                  this.showjiemian();
                  break;
               case "d6":
                  this.curchoose = GS.a6;
                  this.showjiemian();
                  break;
               case "d7":
                  this.curchoose = GS.a7;
                  this.showjiemian();
                  break;
               case "d8":
                  this.curchoose = GS.a8;
                  this.showjiemian();
                  break;
               case "sjlq":
                  _loc2_ = SVcongDataM.getbd(this.curchoose);
                  if(Boolean(GM.aSaveData.summervd.isKYDataa(this.curchoose)) && _loc2_.congvalue <= GM.testapi.allChongGod)
                  {
                     _loc3_ = new Array();
                     _loc4_ = new Array();
                     _loc5_ = 0;
                     while(_loc5_ < _loc2_.awardList.length)
                     {
                        _loc3_.push((_loc2_.awardList[_loc5_][0] as VT).getValue());
                        _loc4_.push((_loc2_.awardList[_loc5_][1] as VT).getValue());
                        _loc5_++;
                     }
                     if(BagFactory.isFullBag(_loc3_,_loc4_))
                     {
                        BagFactory.addBagArr(_loc3_,_loc4_);
                        GM.aSaveData.summervd.dataaSave(this.curchoose);
                        GM.testapi.saveDataBefore();
                        this.showjiemian();
                        GoodsManger.cwTs("已领取成功!");
                     }
                     else
                     {
                        GoodsManger.cwTs("背包已满");
                     }
                  }
                  break;
               case "xx":
                  close();
                  break;
               case "sjchongzhi":
                  GM.testapi.gameChongMoney(100);
            }
         }
      }
      
      private function mcmoveovere(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:SVcongData = null;
         if(param1.target.name != null && this.dddA.indexOf(param1.target.name) != -1)
         {
            _loc2_ = 0;
            switch(param1.target.name)
            {
               case "wpk1":
                  _loc2_ = 1;
                  break;
               case "wpk2":
                  _loc2_ = 2;
                  break;
               case "wpk3":
                  _loc2_ = 3;
                  break;
               case "wpk4":
                  _loc2_ = 4;
            }
            _loc3_ = SVcongDataM.getbd(this.curchoose);
            if(_loc3_.awardList[_loc2_ - 1] != null)
            {
               Main.self.dispatchEvent(new GoodsEvent(GoodsEvent.DO_DISPLAY,FlowInterface.getGoodsById((_loc3_.awardList[_loc2_ - 1][0] as VT).getValue())));
            }
         }
      }
      
      private function mcmoveoute(param1:MouseEvent) : void
      {
         if(param1.target.name != null && this.dddA.indexOf(param1.target.name) != -1)
         {
            Main.self.dispatchEvent(new BtnEvent(BtnEvent.DO_OUT));
         }
      }
   }
}

