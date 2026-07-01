package hotpointgame.gview
{
   import flash.display.*;
   import flash.events.*;
   import flash.net.*;
   import flash.text.*;
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   import hotpointgame.ginit.*;
   import hotpointgame.utils.*;
   
   public class GameInitC
   {
      
      public static var self:GameInitC = new GameInitC();
      
      private static var curs:int = 0;
      
      private var mc:MovieClip;
      
      private var shifofukaiMc:MovieClip;
      
      private var xuanrenjiemianMc:MovieClip;
      
      private var anniujmMc:MovieClip;
      
      private var duqubMc:MovieClip;
      
      private var xinjianbMc:MovieClip;
      
      private var gengxinbMc:MovieClip;
      
      private var caozuobMc:MovieClip;
      
      private var readDataing:MovieClip;
      
      private var mcMO:Object = null;
      
      private var curMc:String = "";
      
      private var tempF:String = "";
      
      private var _chooseJob:VT = VT.createVT(GS.a1);
      
      public function GameInitC()
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
         var _loc1_:Class = ClassGet.getClassByName("fengmian");
         this.mc = new _loc1_() as MovieClip;
         this.readDataing = this.mc["fmsjjzz"];
         this.readDataing.visible = false;
         this.mcMO = new Object();
         this.anniujmMc = this.mc["anniujm"];
         var _loc2_:McBtnLianDong = new McBtnLianDong();
         _loc2_.addBtnLianDong(new McBtn(this.anniujmMc["xinjian"]));
         _loc2_.addBtnLianDong(new McBtn(this.anniujmMc["duqu"]));
         _loc2_.addBtnLianDong(new McBtn(this.anniujmMc["gengxin"]));
         _loc2_.addBtnLianDong(new McBtn(this.anniujmMc["caozuo"]));
         _loc2_.addBtnLianDong(new McBtn(this.anniujmMc["luntan"]));
         _loc2_.btnByClick("gengxin");
         this.mcMO["anniujm"] = _loc2_;
         this.shifofukaiMc = this.mc["shifofukai"];
         this.shifofukaiMc.visible = false;
         _loc2_ = new McBtnLianDong();
         _loc2_.addBtnNoLian(new McBtn(this.shifofukaiMc["queding"]));
         _loc2_.addBtnNoLian(new McBtn(this.shifofukaiMc["quxiao"]));
         this.mcMO["shifofukai"] = _loc2_;
         this.xuanrenjiemianMc = this.mc["xuanrenjiemian"];
         this.xuanrenjiemianMc.visible = false;
         _loc2_ = new McBtnLianDong();
         _loc2_.addBtnNoLian(new McBtn(this.xuanrenjiemianMc["zhucaidan"]));
         _loc2_.addBtnNoLian(new McBtn(this.xuanrenjiemianMc["kaishiyouxi"]));
         _loc2_.addBtnNoLian(new McBtn(this.xuanrenjiemianMc["jsxzan1"]));
         _loc2_.addBtnNoLian(new McBtn(this.xuanrenjiemianMc["jsxzan2"]));
         (this.xuanrenjiemianMc["jsxzk1"] as MovieClip).gotoAndStop(2);
         (this.xuanrenjiemianMc["jsxzk2"] as MovieClip).gotoAndStop(1);
         (this.xuanrenjiemianMc["jsxz"] as MovieClip).gotoAndStop(2);
         this.chooseJob = 1;
         this.mcMO["xuanrenjiemian"] = _loc2_;
         this.duqubMc = this.mc["duqub"];
         this.duqubMc.visible = false;
         _loc2_ = new McBtnLianDong();
         _loc2_.addBtnLianDong(new McBtn(this.duqubMc["cundang1"]));
         _loc2_.addBtnLianDong(new McBtn(this.duqubMc["cundang2"]));
         _loc2_.addBtnLianDong(new McBtn(this.duqubMc["cundang3"]));
         _loc2_.addBtnLianDong(new McBtn(this.duqubMc["cundang4"]));
         _loc2_.addBtnLianDong(new McBtn(this.duqubMc["cundang5"]));
         _loc2_.addBtnLianDong(new McBtn(this.duqubMc["cundang6"]));
         _loc2_.addBtnNoLian(new McBtn(this.duqubMc["xxx"]));
         this.mcMO["duqub"] = _loc2_;
         this.xinjianbMc = this.mc["xinjianb"];
         this.xinjianbMc.visible = false;
         _loc2_ = new McBtnLianDong();
         _loc2_.addBtnLianDong(new McBtn(this.xinjianbMc["cundang1"]));
         _loc2_.addBtnLianDong(new McBtn(this.xinjianbMc["cundang2"]));
         _loc2_.addBtnLianDong(new McBtn(this.xinjianbMc["cundang3"]));
         _loc2_.addBtnLianDong(new McBtn(this.xinjianbMc["cundang4"]));
         _loc2_.addBtnLianDong(new McBtn(this.xinjianbMc["cundang5"]));
         _loc2_.addBtnLianDong(new McBtn(this.xinjianbMc["cundang6"]));
         _loc2_.addBtnNoLian(new McBtn(this.xinjianbMc["xxx"]));
         this.mcMO["xinjianb"] = _loc2_;
         this.gengxinbMc = this.mc["gengxinb"];
         _loc2_ = new McBtnLianDong();
         _loc2_.addBtnNoLian(new McBtn(this.gengxinbMc["xxx"]));
         this.mcMO["gengxinb"] = _loc2_;
         this.caozuobMc = this.mc["caozuob"];
         this.caozuobMc.visible = false;
         _loc2_ = new McBtnLianDong();
         _loc2_.addBtnNoLian(new McBtn(this.caozuobMc["xxx"]));
         this.mcMO["caozuob"] = _loc2_;
         this.curMc = "gengxin";
         this.anniujmMc.addEventListener(MouseEvent.CLICK,this.anniujmMcCH);
         this.gengxinbMc.addEventListener(MouseEvent.CLICK,this.gengxinbMcCH);
         this.caozuobMc.addEventListener(MouseEvent.CLICK,this.caozuobMcCH);
         this.duqubMc.addEventListener(MouseEvent.CLICK,this.duqubMcCH);
         this.xinjianbMc.addEventListener(MouseEvent.CLICK,this.xinjianbMcCH);
         this.shifofukaiMc.addEventListener(MouseEvent.CLICK,this.shifofukaiMcCH);
         this.xuanrenjiemianMc.addEventListener(MouseEvent.CLICK,this.xuanrenjiemianMcCH);
         this.mc.x = 0;
         this.mc.y = 0;
         GM.fone.addChild(this.mc);
      }
      
      public function leave() : void
      {
         if(curs == 1)
         {
            this.anniujmMc.removeEventListener(MouseEvent.CLICK,this.anniujmMcCH);
            this.gengxinbMc.removeEventListener(MouseEvent.CLICK,this.gengxinbMcCH);
            this.caozuobMc.removeEventListener(MouseEvent.CLICK,this.caozuobMcCH);
            this.duqubMc.removeEventListener(MouseEvent.CLICK,this.duqubMcCH);
            this.xinjianbMc.removeEventListener(MouseEvent.CLICK,this.xinjianbMcCH);
            this.shifofukaiMc.removeEventListener(MouseEvent.CLICK,this.shifofukaiMcCH);
            this.xuanrenjiemianMc.removeEventListener(MouseEvent.CLICK,this.xuanrenjiemianMcCH);
            (this.mcMO["anniujm"] as McBtnLianDong).remove();
            (this.mcMO["shifofukai"] as McBtnLianDong).remove();
            (this.mcMO["xuanrenjiemian"] as McBtnLianDong).remove();
            (this.mcMO["duqub"] as McBtnLianDong).remove();
            (this.mcMO["xinjianb"] as McBtnLianDong).remove();
            (this.mcMO["gengxinb"] as McBtnLianDong).remove();
            (this.mcMO["caozuob"] as McBtnLianDong).remove();
            this.mcMO = null;
            this.shifofukaiMc = null;
            this.xuanrenjiemianMc = null;
            this.anniujmMc = null;
            this.duqubMc = null;
            this.xinjianbMc = null;
            this.gengxinbMc = null;
            this.caozuobMc = null;
            this.readDataing = null;
            GM.fone.removeChild(this.mc);
            this.mc.x = 19563;
            this.mc.y = 29563;
            this.mc = null;
            curs = 0;
         }
      }
      
      public function readdataMcOpen() : void
      {
         if(curs == 1)
         {
            this.readDataing.visible = true;
         }
      }
      
      public function changeDataList(param1:Array) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Boolean = false;
         var _loc4_:Object = null;
         var _loc5_:Array = null;
         if(curs == 1)
         {
            if(this.readDataing.visible)
            {
               this.readDataing.visible = false;
            }
            else
            {
               GM.findCheatMax(GS.a33);
            }
            _loc2_ = 1;
            while(_loc2_ < 7)
            {
               _loc3_ = true;
               for each(_loc4_ in param1)
               {
                  if(_loc2_ == int(_loc4_.index))
                  {
                     _loc3_ = false;
                     _loc5_ = (_loc4_.title as String).split("Lv");
                     (this.xinjianbMc["cundang" + _loc2_]["datatext"]["zhiye"] as TextField).text = _loc5_[0];
                     (this.xinjianbMc["cundang" + _loc2_]["datatext"]["dengji"] as TextField).text = "Lv." + _loc5_[1];
                     (this.xinjianbMc["cundang" + _loc2_]["datatext"]["shijian"] as TextField).text = _loc4_.datetime;
                     (this.duqubMc["cundang" + _loc2_]["datatext"]["zhiye"] as TextField).text = _loc5_[0];
                     (this.duqubMc["cundang" + _loc2_]["datatext"]["dengji"] as TextField).text = "Lv." + _loc5_[1];
                     (this.duqubMc["cundang" + _loc2_]["datatext"]["shijian"] as TextField).text = _loc4_.datetime;
                     (this.xinjianbMc["kongdang" + _loc2_] as MovieClip).visible = false;
                     (this.duqubMc["kongdang" + _loc2_] as MovieClip).visible = false;
                     break;
                  }
               }
               if(_loc3_)
               {
                  (this.xinjianbMc["kongdang" + _loc2_] as MovieClip).visible = true;
                  (this.duqubMc["kongdang" + _loc2_] as MovieClip).visible = true;
                  (this.xinjianbMc["kongdang" + _loc2_] as MovieClip).mouseEnabled = false;
                  (this.duqubMc["kongdang" + _loc2_] as MovieClip).mouseEnabled = false;
                  (this.duqubMc["cundang" + _loc2_] as MovieClip).visible = false;
                  (this.xinjianbMc["cundang" + _loc2_]["datatext"] as MovieClip).visible = false;
               }
               _loc2_++;
            }
            this.SaveListOkCH();
         }
      }
      
      private function SaveListOkCH() : void
      {
         if(curs == 1)
         {
            if(this.curMc != "luntan")
            {
               (this.mc[this.curMc + "b"] as MovieClip).visible = false;
            }
            if(this.tempF == "xinjian")
            {
               (this.mc["xinjianb"] as MovieClip).visible = true;
               this.curMc = "xinjian";
            }
            if(this.tempF == "duqu")
            {
               (this.mc["duqub"] as MovieClip).visible = true;
               this.curMc = "duqu";
            }
         }
      }
      
      private function anniujmMcCH(param1:MouseEvent) : void
      {
         var _loc2_:URLRequest = null;
         if(param1.target.name != null && Boolean((this.mcMO["anniujm"] as McBtnLianDong).isFlase(param1.target.name)))
         {
            (this.mcMO["anniujm"] as McBtnLianDong).btnByClick(param1.target.name);
            if(param1.target.name != "luntan")
            {
               if(param1.target.name == "xinjian" || param1.target.name == "duqu")
               {
                  this.tempF = param1.target.name;
                  if(this.curMc != "luntan")
                  {
                     (this.mc[this.curMc + "b"] as MovieClip).visible = false;
                  }
                  if(GM.testapi.dataList != null)
                  {
                     this.SaveListOkCH();
                  }
                  else
                  {
                     GM.testapi.userLogin();
                  }
               }
               else
               {
                  if(this.curMc != "luntan")
                  {
                     (this.mc[this.curMc + "b"] as MovieClip).visible = false;
                  }
                  (this.mc[param1.target.name + "b"] as MovieClip).visible = true;
               }
            }
            else
            {
               if(this.curMc != "luntan")
               {
                  (this.mc[this.curMc + "b"] as MovieClip).visible = false;
               }
               _loc2_ = new URLRequest("http://my.4399.com/forums-mtag-tagid-81881.html");
               navigateToURL(_loc2_,"_blank");
            }
            this.curMc = param1.target.name;
         }
      }
      
      private function gengxinbMcCH(param1:MouseEvent) : void
      {
         if(param1.target.name != null && Boolean((this.mcMO["gengxinb"] as McBtnLianDong).isFlase(param1.target.name)))
         {
            this.gengxinbMc.visible = false;
         }
      }
      
      private function caozuobMcCH(param1:MouseEvent) : void
      {
         if(param1.target.name != null && Boolean((this.mcMO["caozuob"] as McBtnLianDong).isFlase(param1.target.name)))
         {
            this.caozuobMc.visible = false;
         }
      }
      
      private function duqubMcCH(param1:MouseEvent) : void
      {
         if(param1.target.name != null && Boolean((this.mcMO["duqub"] as McBtnLianDong).isFlase(param1.target.name)))
         {
            if(param1.target.name == "xxx")
            {
               this.duqubMc.visible = false;
            }
            else
            {
               GM.testapi.dataIndex = int((param1.target.name as String).substr(7,1));
               if(GM.testapi.dataIndexYouData())
               {
                  this.readDataing.x = 0;
                  this.readDataing.y = 0;
                  this.readDataing.visible = true;
                  this.duqubMc.visible = false;
                  GM.testapi.getData();
               }
               else
               {
                  GM.findCheatMax(GS.a8);
               }
            }
         }
      }
      
      private function xinjianbMcCH(param1:MouseEvent) : void
      {
         if(param1.target.name != null && Boolean((this.mcMO["xinjianb"] as McBtnLianDong).isFlase(param1.target.name)))
         {
            if(param1.target.name == "xxx")
            {
               this.xinjianbMc.visible = false;
            }
            else
            {
               GM.testapi.dataIndex = int((param1.target.name as String).substr(7,1));
               if(GM.testapi.dataIndexYouData())
               {
                  this.shifofukaiMc.visible = true;
               }
               else
               {
                  this.showXuanrenjiemianMc();
               }
            }
         }
      }
      
      private function shifofukaiMcCH(param1:MouseEvent) : void
      {
         if(param1.target.name != null && Boolean((this.mcMO["shifofukai"] as McBtnLianDong).isFlase(param1.target.name)))
         {
            if(param1.target.name == "queding")
            {
               this.shifofukaiMc.visible = false;
               this.showXuanrenjiemianMc();
            }
            if(param1.target.name == "quxiao")
            {
               GM.testapi.dataIndexClear();
               this.shifofukaiMc.visible = false;
            }
         }
      }
      
      private function showXuanrenjiemianMc() : void
      {
         switch(this.chooseJob)
         {
            case 1:
               this.xuanrenjiemianMc.visible = true;
               (this.xuanrenjiemianMc["jsxzk1"] as MovieClip).gotoAndStop(1);
               (this.xuanrenjiemianMc["jsxzk2"] as MovieClip).gotoAndStop(2);
               (this.xuanrenjiemianMc["jsxz"] as MovieClip).gotoAndStop(1);
               break;
            case 2:
               this.xuanrenjiemianMc.visible = true;
               (this.xuanrenjiemianMc["jsxzk1"] as MovieClip).gotoAndStop(2);
               (this.xuanrenjiemianMc["jsxzk2"] as MovieClip).gotoAndStop(1);
               (this.xuanrenjiemianMc["jsxz"] as MovieClip).gotoAndStop(2);
         }
      }
      
      private function xuanrenjiemianMcCH(param1:MouseEvent) : void
      {
         if(param1.target.name != null && Boolean((this.mcMO["xuanrenjiemian"] as McBtnLianDong).isFlase(param1.target.name)))
         {
            switch(param1.target.name)
            {
               case "zhucaidan":
                  this.xuanrenjiemianMc.visible = false;
                  GM.testapi.dataIndexClear();
                  break;
               case "kaishiyouxi":
                  this.xuanrenjiemianMc.visible = false;
                  GM.testapi.jobFlag = this.chooseJob;
                  GM.testapi.leafLineTime = 0;
                  GM.testapi.readData();
                  ManHuaKaiC.open();
                  return;
               case "jsxzan1":
                  (this.xuanrenjiemianMc["jsxzk1"] as MovieClip).gotoAndStop(1);
                  (this.xuanrenjiemianMc["jsxzk2"] as MovieClip).gotoAndStop(2);
                  (this.xuanrenjiemianMc["jsxz"] as MovieClip).gotoAndStop(1);
                  this.chooseJob = 1;
                  break;
               case "jsxzan2":
                  (this.xuanrenjiemianMc["jsxzk1"] as MovieClip).gotoAndStop(2);
                  (this.xuanrenjiemianMc["jsxzk2"] as MovieClip).gotoAndStop(1);
                  (this.xuanrenjiemianMc["jsxz"] as MovieClip).gotoAndStop(2);
                  this.chooseJob = 2;
            }
         }
      }
      
      public function get chooseJob() : int
      {
         return this._chooseJob.getValue();
      }
      
      public function set chooseJob(param1:int) : void
      {
         this._chooseJob.setValue(param1);
      }
   }
}

