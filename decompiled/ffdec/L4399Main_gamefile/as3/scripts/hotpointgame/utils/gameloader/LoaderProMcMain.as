package hotpointgame.utils.gameloader
{
   import flash.display.*;
   import flash.events.*;
   import flash.net.*;
   import flash.text.*;
   import hotpointgame.Control.*;
   import hotpointgame.ginit.*;
   import hotpointgame.utils.*;
   
   public class LoaderProMcMain extends LoaderProMc
   {
      
      private var lmc:MovieClip;
      
      private var preloadmc:MovieClip;
      
      private var pretext:TextField;
      
      private var haibaojinum:int = 0;
      
      private var haibaoMc:MovieClip;
      
      private var btnT:int = 3;
      
      private var btnc:int = 1;
      
      private var mcM:McBtnLianDong;
      
      private var tishijinum:int = 0;
      
      private var tishiarr:Array = ["随着等级的提升将会出现更多功能","银河商店每次刷新时都要记得去看看，好东西大都出现在那里","难度越高的关卡获得的金币、成就点数与经验都会越多","副本关卡里获得的奖励将会是普通关卡的好几倍","幸运彩罐能够开出许多你意想不到的东西","游戏中有许多隐藏元素，如果你认真探索的话都会有惊喜发现","前期要多买一些太阳碎片，这样等到强化系统开放时会对你很有帮助","在关卡内发现的隐藏元素越多，通关时获得的经验、金币与成就点数奖励就越多","通关时的战斗成绩越好，获得的经验、金币与成就点数奖励就越多","游戏后期利用五行相克的原理能够更加容易的打倒怪物"];
      
      public function LoaderProMcMain(param1:MovieClip)
      {
         super();
         this.lmc = param1;
         this.preloadmc = this.lmc["preloader"] as MovieClip;
         this.pretext = this.lmc["pretext"] as TextField;
         this.preloadmc.gotoAndStop(1);
         this.haibaoMc = this.lmc["jiazaihaibao"];
         this.haibaoMc.gotoAndStop(this.btnc);
         this.mcM = new McBtnLianDong();
         var _loc2_:int = 1;
         while(_loc2_ <= this.btnT)
         {
            this.mcM.addBtnLianDong(new McBtn(this.lmc["jiazaihaibaoanniu" + _loc2_]));
            _loc2_++;
         }
         this.mcM.btnByClick("jiazaihaibaoanniu1");
         this.mcM.addBtnNoLian(new McBtn(this.lmc["jiazaifanzhi"]));
         this.mcM.addBtnNoLian(new McBtn(this.lmc["jiazaijinrulunt"]));
         this.mcM.addBtnNoLian(new McBtn(this.lmc["jiazaigxnr"]));
         this.mcM.addBtnNoLian(new McBtn(this.lmc["jiazaihaibaochup"]));
         this.lmc.addEventListener(MouseEvent.CLICK,this.lmcclickH);
         GM.einit.addChild(this.lmc);
      }
      
      override public function gmUpdate(param1:String, param2:int) : void
      {
         ++this.haibaojinum;
         if(param2 <= 0)
         {
            param2 = 1;
         }
         if(param2 > 100)
         {
            param2 = 100;
         }
         this.pretext.text = param1;
         this.preloadmc.gotoAndStop(param2);
         ++this.tishijinum;
         if(this.tishijinum % 1000 == 0)
         {
            (this.lmc["xiaotishi"] as TextField).text = "" + this.tishiarr[int(Math.random() * this.tishiarr.length)];
         }
         if(this.haibaojinum > 500)
         {
            this.haibaojinum = 0;
            if(this.btnc == this.btnT)
            {
               this.btnc = 1;
            }
            else
            {
               ++this.btnc;
            }
            this.haibaoMc.gotoAndStop(this.btnc);
            this.mcM.btnByClick("jiazaihaibaoanniu" + this.btnc);
         }
      }
      
      private function lmcclickH(param1:MouseEvent) : void
      {
         var _loc2_:URLRequest = null;
         var _loc3_:URLRequest = null;
         var _loc4_:URLRequest = null;
         var _loc5_:String = null;
         var _loc6_:URLRequest = null;
         if(param1.target.name != null)
         {
            switch(param1.target.name)
            {
               case "jiazaifanzhi":
                  _loc2_ = new URLRequest("http://my.4399.com/forums-thread-tagid-81881-id-34766953.html");
                  navigateToURL(_loc2_,"_blank");
                  break;
               case "jiazaijinrulunt":
                  _loc3_ = new URLRequest("http://my.4399.com/forums-mtag-tagid-81881.html");
                  navigateToURL(_loc3_,"_blank");
                  break;
               case "jiazaigxnr":
                  _loc4_ = new URLRequest(UTools.updateUrl);
                  navigateToURL(_loc4_,"_blank");
                  break;
               case "jiazaihaibaochup":
                  switch(this.btnc)
                  {
                     case 1:
                        _loc5_ = UTools.updateUrl1;
                        break;
                     case 2:
                        _loc5_ = UTools.updateUrl2;
                        break;
                     case 3:
                        _loc5_ = UTools.updateUrl3;
                        break;
                     case 4:
                        _loc5_ = "http://my.4399.com/forums-thread-tagid-81881-id-39250516.html";
                  }
                  _loc6_ = new URLRequest(_loc5_);
                  navigateToURL(_loc6_,"_blank");
                  break;
               case "jiazaihaibaoanniu1":
                  this.btnc = 1;
                  this.haibaoMc.gotoAndStop(this.btnc);
                  this.mcM.btnByClick("jiazaihaibaoanniu" + this.btnc);
                  this.haibaojinum = 0;
                  break;
               case "jiazaihaibaoanniu2":
                  this.btnc = 2;
                  this.haibaoMc.gotoAndStop(this.btnc);
                  this.mcM.btnByClick("jiazaihaibaoanniu" + this.btnc);
                  this.haibaojinum = 0;
                  break;
               case "jiazaihaibaoanniu3":
                  this.btnc = 3;
                  this.haibaoMc.gotoAndStop(this.btnc);
                  this.mcM.btnByClick("jiazaihaibaoanniu" + this.btnc);
                  this.haibaojinum = 0;
                  break;
               case "jiazaihaibaoanniu4":
                  this.btnc = 4;
                  this.haibaoMc.gotoAndStop(this.btnc);
                  this.mcM.btnByClick("jiazaihaibaoanniu" + this.btnc);
                  this.haibaojinum = 0;
            }
         }
      }
      
      override public function remove() : void
      {
         this.preloadmc = null;
         this.pretext = null;
         this.haibaoMc = null;
         this.mcM.remove();
         this.mcM = null;
         this.lmc.removeEventListener(MouseEvent.CLICK,this.lmcclickH);
         GM.einit.removeChild(this.lmc);
         this.lmc = null;
      }
   }
}

