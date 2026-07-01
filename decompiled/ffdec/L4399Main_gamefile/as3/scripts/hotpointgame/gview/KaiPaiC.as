package hotpointgame.gview
{
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   import hotpointgame.ginit.*;
   import hotpointgame.glevel.*;
   import hotpointgame.models.goods.*;
   import hotpointgame.utils.gameloader.*;
   
   public class KaiPaiC
   {
      
      private static var self:KaiPaiC = new KaiPaiC();
      
      private static var curs:int = 0;
      
      private var mc:MovieClip;
      
      private var wanjiazawuqwczMc:MovieClip;
      
      private var kaipailiangpaiMc:MovieClip;
      
      private var jishiq:String = "起";
      
      private var jb:int = 0;
      
      private var mcMO:Object = new Object();
      
      private var kanpaiId:int = 0;
      
      private var chooseId:int = 0;
      
      private var flagId:int = 0;
      
      private var kpgoodArr:Array;
      
      public function KaiPaiC()
      {
         super();
      }
      
      public static function open() : void
      {
         if(curs == 0)
         {
            self.reset();
            curs = 1;
         }
      }
      
      public static function close() : void
      {
         self.leave();
      }
      
      public function reset() : void
      {
         var _loc3_:Class = null;
         var _loc4_:int = 0;
         var _loc5_:Class = null;
         var _loc6_:MovieClip = null;
         this.kpgoodArr = new Array();
         if(this.mc == null)
         {
            _loc3_ = LoaderManager.getSwfClass("kaipai") as Class;
            this.mc = new _loc3_() as MovieClip;
            this.mc.stop();
            this.mc.x = 19563;
            this.mc.y = 29563;
            _loc4_ = 1;
            while(_loc4_ <= 5)
            {
               _loc5_ = LoaderManager.getSwfClass("T_Box") as Class;
               _loc6_ = new _loc5_() as MovieClip;
               _loc6_.mouseEnabled = false;
               _loc6_.mouseChildren = false;
               (_loc6_["mask_mc"] as MovieClip).visible = false;
               (_loc6_["d_mc"] as MovieClip).visible = false;
               (_loc6_["gx_mc"] as MovieClip).visible = false;
               _loc6_.name = "kaipaitubiao";
               this.mc["kaipa" + _loc4_]["moveMc"].addChild(_loc6_);
               _loc5_ = LoaderManager.getSwfClass("T_Box") as Class;
               _loc6_ = new _loc5_() as MovieClip;
               _loc6_.mouseEnabled = false;
               _loc6_.mouseChildren = false;
               (_loc6_["mask_mc"] as MovieClip).visible = false;
               (_loc6_["d_mc"] as MovieClip).visible = false;
               (_loc6_["gx_mc"] as MovieClip).visible = false;
               _loc6_.name = "kaipaitubiao";
               this.mc["kaipailiangpai"]["kaipae" + _loc4_]["moveMc"].addChild(_loc6_);
               this.kpgoodArr[_loc4_] = null;
               _loc4_++;
            }
         }
         this.jishiq = "起";
         this.kanpaiId = 0;
         this.chooseId = 0;
         this.flagId = 0;
         this.jb = 0;
         this.mc.x = 0;
         this.mc.y = 0;
         this.wanjiazawuqwczMc = this.mc["wanjiazawuqwcz"];
         this.wanjiazawuqwczMc.visible = false;
         var _loc1_:McBtnLianDong = new McBtnLianDong();
         _loc1_.addBtnLianDong(new McBtn(this.wanjiazawuqwczMc["scqwczan"]));
         _loc1_.addBtnLianDong(new McBtn(this.wanjiazawuqwczMc["sctok"]));
         this.mcMO["wanjiazawuqwcz"] = _loc1_;
         this.kaipailiangpaiMc = this.mc["kaipailiangpai"];
         this.kaipailiangpaiMc.visible = false;
         this.kaipailiangpaiMc.mouseEnabled = false;
         this.kanpaiPriceUp();
         var _loc2_:int = 1;
         while(_loc2_ <= 5)
         {
            (this.mc["kaipailiangpai"]["kaipae" + _loc2_] as MovieClip).visible = false;
            (this.mc["kaipailiangpai"]["kaipae" + _loc2_] as MovieClip).mouseEnabled = false;
            (this.mc["kaipailiangpai"]["kaipae" + _loc2_] as MovieClip).mouseChildren = false;
            _loc2_++;
         }
         _loc1_ = new McBtnLianDong();
         _loc1_.addBtnLianDong(new McBtn(this.kaipailiangpaiMc["kaipa1c"]));
         _loc1_.addBtnLianDong(new McBtn(this.kaipailiangpaiMc["kaipa2c"]));
         _loc1_.addBtnLianDong(new McBtn(this.kaipailiangpaiMc["kaipa3c"]));
         _loc1_.addBtnLianDong(new McBtn(this.kaipailiangpaiMc["kaipa4c"]));
         _loc1_.addBtnLianDong(new McBtn(this.kaipailiangpaiMc["kaipa5c"]));
         this.mcMO["kaipailiangpai"] = _loc1_;
         (this.mc["wanjiaxzkcz"] as MovieClip).visible = false;
         (this.mc["kaipa0"] as MovieClip).gotoAndPlay(1);
         (this.mc["kaipa0"] as MovieClip).visible = true;
         _loc1_ = new McBtnLianDong();
         _loc1_.addBtnLianDong(new McBtn(this.mc["kaipa1b"]));
         _loc1_.addBtnLianDong(new McBtn(this.mc["kaipa2b"]));
         _loc1_.addBtnLianDong(new McBtn(this.mc["kaipa3b"]));
         _loc1_.addBtnLianDong(new McBtn(this.mc["kaipa4b"]));
         _loc1_.addBtnLianDong(new McBtn(this.mc["kaipa5b"]));
         this.mcMO["kaipai"] = _loc1_;
         (this.mc["kaipa1b"] as MovieClip).visible = false;
         (this.mc["kaipa2b"] as MovieClip).visible = false;
         (this.mc["kaipa3b"] as MovieClip).visible = false;
         (this.mc["kaipa4b"] as MovieClip).visible = false;
         (this.mc["kaipa5b"] as MovieClip).visible = false;
         (this.mc["kaipa1"] as MovieClip).visible = false;
         (this.mc["kaipa2"] as MovieClip).visible = false;
         (this.mc["kaipa3"] as MovieClip).visible = false;
         (this.mc["kaipa4"] as MovieClip).visible = false;
         (this.mc["kaipa5"] as MovieClip).visible = false;
         (this.mc["kaipa1"] as MovieClip).gotoAndStop(1);
         (this.mc["kaipa1"]["kaipaishanguang"] as MovieClip).gotoAndStop(1);
         (this.mc["kaipa2"] as MovieClip).gotoAndStop(1);
         (this.mc["kaipa2"]["kaipaishanguang"] as MovieClip).gotoAndStop(1);
         (this.mc["kaipa3"] as MovieClip).gotoAndStop(1);
         (this.mc["kaipa3"]["kaipaishanguang"] as MovieClip).gotoAndStop(1);
         (this.mc["kaipa4"] as MovieClip).gotoAndStop(1);
         (this.mc["kaipa4"]["kaipaishanguang"] as MovieClip).gotoAndStop(1);
         (this.mc["kaipa5"] as MovieClip).gotoAndStop(1);
         (this.mc["kaipa5"]["kaipaishanguang"] as MovieClip).gotoAndStop(1);
         GM.cbGview.addChild(this.mc);
         this.kaipailiangpaiMc.addEventListener(MouseEvent.CLICK,this.kaipailiangpaiClick);
         this.wanjiazawuqwczMc.addEventListener(MouseEvent.CLICK,this.wanjiazawuqwczClick);
         this.mc.addEventListener(Event.ENTER_FRAME,this.frameH);
         this.mc.addEventListener(MouseEvent.CLICK,this.mcClick);
      }
      
      public function leave() : void
      {
         if(curs == 1)
         {
            curs = 0;
            this.mc.x = 19563;
            this.mc.y = 29563;
            this.kpgoodArr = null;
            (this.mcMO["kaipai"] as McBtnLianDong).remove();
            (this.mcMO["kaipailiangpai"] as McBtnLianDong).remove();
            (this.mcMO["wanjiazawuqwcz"] as McBtnLianDong).remove();
            this.mcMO = new Object();
            this.mc.removeEventListener(Event.ENTER_FRAME,this.frameH);
            this.mc.removeEventListener(MouseEvent.CLICK,this.mcClick);
            this.kaipailiangpaiMc.removeEventListener(MouseEvent.CLICK,this.kaipailiangpaiClick);
            this.wanjiazawuqwczMc.removeEventListener(MouseEvent.CLICK,this.wanjiazawuqwczClick);
            GM.cbGview.removeChild(this.mc);
            this.wanjiazawuqwczMc = null;
            this.kaipailiangpaiMc = null;
            this.mc = null;
         }
      }
      
      public function frameH(param1:Event) : void
      {
         var _loc2_:Array = null;
         var _loc3_:int = 0;
         var _loc4_:Array = null;
         var _loc5_:Goods = null;
         var _loc6_:int = 0;
         if(this.jishiq == "起" && (this.mc["kaipa0"] as MovieClip).currentFrame == (this.mc["kaipa0"] as MovieClip).totalFrames)
         {
            (this.mc["kaipa0"] as MovieClip).stop();
            (this.mc["kaipa0"] as MovieClip).visible = false;
            (this.mc["kaipa1b"] as MovieClip).visible = true;
            (this.mc["kaipa2b"] as MovieClip).visible = true;
            (this.mc["kaipa3b"] as MovieClip).visible = true;
            (this.mc["kaipa4b"] as MovieClip).visible = true;
            (this.mc["kaipa5b"] as MovieClip).visible = true;
            this.jishiq = "等等点击";
            this.kaipailiangpaiMc.visible = true;
         }
         if(this.jishiq == "发奖")
         {
            if((this.mc["kaipa" + this.chooseId] as MovieClip).currentFrame == (this.mc["kaipa" + this.chooseId] as MovieClip).totalFrames)
            {
               if(this.kpgoodArr[this.chooseId] != null)
               {
                  _loc2_ = this.kpgoodArr[this.chooseId];
                  if(_loc2_.length > 1)
                  {
                     if((_loc2_[0] as Goods).getType() == GS.a2 && (_loc2_[0] as Goods).getSmallType() == GS.a4)
                     {
                        GM.cp.addGodByRole((_loc2_[0] as Goods).getOtherValue());
                     }
                     else
                     {
                        FlowInterface.addInBagDL(_loc2_[0] as Goods,(_loc2_[1] as VT).getValue());
                     }
                  }
                  this.kpgoodArr[this.chooseId] = null;
               }
               else
               {
                  GM.findCheatMax(GS.a56);
               }
               this.jishiq = "看其它牌";
               (this.mc["kaipa" + this.chooseId] as MovieClip).stop();
            }
         }
         if(this.jishiq == "看其它牌")
         {
            ++this.jb;
            if(this.jb == 90)
            {
               _loc3_ = 1;
               while(_loc3_ < 6)
               {
                  if((this.mc["kaipa" + _loc3_] as MovieClip).currentFrame == 1)
                  {
                     if(this.kpgoodArr[_loc3_] != null)
                     {
                        _loc4_ = this.kpgoodArr[_loc3_];
                     }
                     else
                     {
                        _loc4_ = GM.levelm.curLevel.getKaiPaiAward();
                     }
                     if(_loc4_.length > 1)
                     {
                        _loc5_ = _loc4_[0] as Goods;
                        ((this.mc["kaipa" + _loc3_]["moveMc"] as MovieClip).getChildByName("kaipaitubiao") as MovieClip).gotoAndStop(_loc5_.getFrame());
                        (this.mc["kaipa" + _loc3_]["kaipaishanguang"] as MovieClip).gotoAndPlay(1);
                        (this.mc["kaipa" + _loc3_]["kaipamingcheng"]["txt_name"] as TextField).text = _loc5_.getName() + " * " + (_loc4_[1] as VT).getValue();
                        (this.mc["kaipa" + _loc3_]["kaipamingcheng"]["txt_name"] as TextField).setTextFormat(new TextFormat(null,null,DiaoLouGoods.cArr[_loc5_.getColor()]));
                     }
                     else if(_loc4_.length > 0)
                     {
                        ((this.mc["kaipa" + _loc3_]["moveMc"] as MovieClip).getChildByName("kaipaitubiao") as MovieClip).gotoAndStop(1735);
                        (this.mc["kaipa" + _loc3_]["kaipaishanguang"] as MovieClip).gotoAndPlay(1);
                        (this.mc["kaipa" + _loc3_]["kaipamingcheng"]["txt_name"] as TextField).text = "";
                     }
                     else
                     {
                        ((this.mc["kaipa" + _loc3_]["moveMc"] as MovieClip).getChildByName("kaipaitubiao") as MovieClip).gotoAndStop(1935);
                        (this.mc["kaipa" + _loc3_]["kaipaishanguang"] as MovieClip).gotoAndPlay(1);
                        (this.mc["kaipa" + _loc3_]["kaipamingcheng"]["txt_name"] as TextField).text = "";
                     }
                     this.flagId = _loc3_;
                     (this.mc["kaipa" + _loc3_] as MovieClip).gotoAndPlay(1);
                  }
                  _loc3_++;
               }
               this.jishiq = "看完";
               this.jb = 0;
            }
         }
         if(this.jishiq == "看完")
         {
            ++this.jb;
            if((this.mc["kaipa" + this.flagId] as MovieClip).currentFrame == (this.mc["kaipa" + this.flagId] as MovieClip).totalFrames)
            {
               _loc6_ = 1;
               while(_loc6_ < 6)
               {
                  (this.mc["kaipa" + _loc6_] as MovieClip).stop();
                  _loc6_++;
               }
               this.jishiq = "等结束";
               this.jb = 0;
            }
         }
         if(this.jishiq == "等结束")
         {
            ++this.jb;
            if(this.jb == 90)
            {
               this.leave();
               GamePassC.open();
               GM.testapi.isShowSaveS = true;
               GM.testapi.saveDataBefore();
            }
         }
      }
      
      private function mcClick(param1:MouseEvent) : void
      {
         var _loc2_:String = null;
         var _loc3_:Array = null;
         var _loc4_:Goods = null;
         if(param1.target.name != null && Boolean((this.mcMO["kaipai"] as McBtnLianDong).isFlase(param1.target.name)))
         {
            _loc2_ = param1.target.name;
            this.chooseId = int(_loc2_.substr(5,1));
            (this.mc["kaipa1b"] as MovieClip).visible = false;
            (this.mc["kaipa2b"] as MovieClip).visible = false;
            (this.mc["kaipa3b"] as MovieClip).visible = false;
            (this.mc["kaipa4b"] as MovieClip).visible = false;
            (this.mc["kaipa5b"] as MovieClip).visible = false;
            (this.mc["kaipa1"] as MovieClip).visible = true;
            (this.mc["kaipa2"] as MovieClip).visible = true;
            (this.mc["kaipa3"] as MovieClip).visible = true;
            (this.mc["kaipa4"] as MovieClip).visible = true;
            (this.mc["kaipa5"] as MovieClip).visible = true;
            if(this.kpgoodArr[this.chooseId] == null)
            {
               this.kpgoodArr[this.chooseId] = GM.levelm.curLevel.getKaiPaiAward();
            }
            _loc3_ = this.kpgoodArr[this.chooseId];
            (this.mc["kaipa" + this.chooseId] as MovieClip).gotoAndPlay(1);
            if(_loc3_.length > 1)
            {
               _loc4_ = _loc3_[0] as Goods;
               ((this.mc["kaipa" + this.chooseId]["moveMc"] as MovieClip).getChildByName("kaipaitubiao") as MovieClip).gotoAndStop(_loc4_.getFrame());
               (this.mc["kaipa" + this.chooseId]["kaipaishanguang"] as MovieClip).gotoAndPlay(1);
               (this.mc["kaipa" + this.chooseId]["kaipamingcheng"]["txt_name"] as TextField).text = _loc4_.getName() + " * " + (_loc3_[1] as VT).getValue();
               (this.mc["kaipa" + this.chooseId]["kaipamingcheng"]["txt_name"] as TextField).setTextFormat(new TextFormat(null,null,DiaoLouGoods.cArr[_loc4_.getColor()]));
            }
            else if(_loc3_.length > 0)
            {
               ((this.mc["kaipa" + this.chooseId]["moveMc"] as MovieClip).getChildByName("kaipaitubiao") as MovieClip).gotoAndStop(1735);
               (this.mc["kaipa" + this.chooseId]["kaipaishanguang"] as MovieClip).gotoAndPlay(1);
               (this.mc["kaipa" + this.chooseId]["kaipamingcheng"]["txt_name"] as TextField).text = "";
            }
            else
            {
               ((this.mc["kaipa" + this.chooseId]["moveMc"] as MovieClip).getChildByName("kaipaitubiao") as MovieClip).gotoAndStop(1935);
               (this.mc["kaipa" + this.chooseId]["kaipaishanguang"] as MovieClip).gotoAndPlay(1);
               (this.mc["kaipa" + this.chooseId]["kaipamingcheng"]["txt_name"] as TextField).text = "";
            }
            this.kaipailiangpaiMc.visible = false;
            this.jishiq = "发奖";
         }
      }
      
      private function kaipailiangpaiClick(param1:MouseEvent) : void
      {
         var _loc2_:String = null;
         var _loc3_:Array = null;
         if(param1.target.name != null && Boolean((this.mcMO["kaipailiangpai"] as McBtnLianDong).isFlase(param1.target.name)))
         {
            _loc2_ = param1.target.name;
            this.kanpaiId = int(_loc2_.substr(5,1));
            _loc3_ = GM.kaipaijssavedata.getCurPrice();
            if(_loc3_[1] > GameShangChengC.self.dgMoney)
            {
               this.wanjiazawuqwczMc.visible = true;
               return;
            }
            if((this.mc["wanjiaxzkcz"] as MovieClip).visible)
            {
               GM.findCheatMax(GS.a55);
               return;
            }
            (this.mc["wanjiaxzkcz"] as MovieClip).visible = true;
            GM.testapi.getStateAndBuyShopProp(_loc3_[0],GS.a1,_loc3_[1],this.kaipaibuyover,GS.a0);
         }
      }
      
      private function kaipaibuyover(param1:int) : void
      {
         var _loc2_:Array = null;
         var _loc3_:Goods = null;
         if(curs == 1)
         {
            if(!(this.mc["wanjiaxzkcz"] as MovieClip).visible)
            {
               GM.findCheatMax(GS.a54);
               return;
            }
            if(param1 == 0)
            {
               (this.mc["wanjiaxzkcz"] as MovieClip).visible = false;
            }
            else
            {
               ++GM.kaipaijssavedata.kpnum;
               this.kanpaiPriceUp();
               (this.mc["wanjiaxzkcz"] as MovieClip).visible = false;
               (this.kaipailiangpaiMc["kaipae" + this.kanpaiId] as MovieClip).visible = true;
               this.kpgoodArr[this.kanpaiId] = GM.levelm.curLevel.getKaiPaiAward();
               _loc2_ = this.kpgoodArr[this.kanpaiId];
               if(_loc2_.length > 1)
               {
                  _loc3_ = _loc2_[0] as Goods;
                  ((this.kaipailiangpaiMc["kaipae" + this.kanpaiId]["moveMc"] as MovieClip).getChildByName("kaipaitubiao") as MovieClip).gotoAndStop(_loc3_.getFrame());
                  (this.kaipailiangpaiMc["kaipae" + this.kanpaiId]["kaipamingcheng"]["txt_name"] as TextField).text = _loc3_.getName() + " * " + (_loc2_[1] as VT).getValue();
                  (this.kaipailiangpaiMc["kaipae" + this.kanpaiId]["kaipamingcheng"]["txt_name"] as TextField).setTextFormat(new TextFormat(null,null,DiaoLouGoods.cArr[_loc3_.getColor()]));
               }
               else if(_loc2_.length > 0)
               {
                  ((this.kaipailiangpaiMc["kaipae" + this.kanpaiId]["moveMc"] as MovieClip).getChildByName("kaipaitubiao") as MovieClip).gotoAndStop(1735);
                  (this.kaipailiangpaiMc["kaipae" + this.kanpaiId]["kaipamingcheng"]["txt_name"] as TextField).text = "";
               }
               else
               {
                  ((this.kaipailiangpaiMc["kaipae" + this.kanpaiId]["moveMc"] as MovieClip).getChildByName("kaipaitubiao") as MovieClip).gotoAndStop(1935);
                  (this.kaipailiangpaiMc["kaipae" + this.kanpaiId]["kaipamingcheng"]["txt_name"] as TextField).text = "";
               }
               (this.kaipailiangpaiMc["kaipa" + this.kanpaiId + "c"] as MovieClip).visible = false;
               (this.kaipailiangpaiMc["kaipa" + this.kanpaiId + "d"] as MovieClip).visible = false;
            }
         }
      }
      
      private function kanpaiPriceUp() : void
      {
         var _loc1_:int = 1;
         while(_loc1_ <= 5)
         {
            (this.kaipailiangpaiMc["kaipa" + _loc1_ + "d"]["goldshu"] as TextField).text = "" + GM.kaipaijssavedata.getCurPrice()[1];
            _loc1_++;
         }
      }
      
      private function wanjiazawuqwczClick(param1:MouseEvent) : void
      {
         if(param1.target.name != null && Boolean((this.mcMO["wanjiazawuqwcz"] as McBtnLianDong).isFlase(param1.target.name)))
         {
            switch(param1.target.name)
            {
               case "scqwczan":
                  GM.testapi.gameChongMoney(100);
                  this.wanjiazawuqwczMc.visible = false;
                  break;
               case "sctok":
                  this.wanjiazawuqwczMc.visible = false;
            }
         }
      }
   }
}

