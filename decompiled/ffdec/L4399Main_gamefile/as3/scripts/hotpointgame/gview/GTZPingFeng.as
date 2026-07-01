package hotpointgame.gview
{
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   import hotpointgame.utils.gameloader.*;
   
   public class GTZPingFeng
   {
      
      public static var self:GTZPingFeng = new GTZPingFeng();
      
      private static var curs:int = 0;
      
      private var mc:MovieClip;
      
      private var _jishi:VT = VT.createVT(0);
      
      private var goodArr:Array;
      
      private var bArr:Array;
      
      public function GTZPingFeng()
      {
         super();
      }
      
      public static function open() : void
      {
         GTiaoZhangSend.close();
         if(curs == 0)
         {
            if(GM.levelm.curLevel.id != GS.a9997)
            {
               GM.findCheatMax(GS.a67);
            }
            self.reset();
         }
      }
      
      public static function close() : void
      {
         self.leave();
      }
      
      public function setData(param1:Array, param2:Array) : void
      {
         this.goodArr = param1;
         this.bArr = param2;
      }
      
      public function reset() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Class = null;
         var _loc3_:Array = null;
         var _loc4_:Class = null;
         var _loc5_:MovieClip = null;
         var _loc6_:Array = null;
         if(this.mc == null)
         {
            if(!LoaderManager.isLoadedBySwfname("map_0_5"))
            {
               if(GM.loaderM.keYiUse())
               {
                  _loc3_ = new Array();
                  _loc3_.push("map_0_5");
                  _loc3_.push("t_box");
                  GM.loaderM.setLoadData(_loc3_);
                  GM.loaderM.completeF = open;
                  GM.loaderM.startLoadDataJieM();
                  return;
               }
               return;
            }
            _loc2_ = LoaderManager.getSwfClass("lfkjjs") as Class;
            this.mc = new _loc2_() as MovieClip;
            this.mc.stop();
            this.mc.x = 19563;
            this.mc.y = 29563;
         }
         this.jishi = 0;
         curs = 1;
         this.mc.x = 0;
         this.mc.y = 0;
         (this.mc["dyj"] as MovieClip).visible = false;
         this.mc.gotoAndPlay(1);
         (this.mc["dyj"]["jb00"] as TextField).text = "" + this.bArr[0];
         (this.mc["dyj"]["txt1"] as TextField).text = "" + this.bArr[1];
         (this.mc["dyj"]["txt2"] as TextField).text = "" + this.bArr[2];
         _loc1_ = 1;
         while(_loc1_ <= 10)
         {
            _loc4_ = LoaderManager.getSwfClass("T_Box") as Class;
            _loc5_ = new _loc4_() as MovieClip;
            _loc5_.mouseEnabled = false;
            _loc5_.mouseChildren = false;
            (_loc5_["mask_mc"] as MovieClip).visible = false;
            (_loc5_["d_mc"] as MovieClip).visible = false;
            (_loc5_["gx_mc"] as MovieClip).visible = false;
            _loc5_.name = "kaipaitubiao";
            (this.mc["dyj"]["k" + _loc1_] as MovieClip).addChild(_loc5_);
            _loc6_ = this.goodArr[_loc1_];
            if(_loc6_.length > 0)
            {
               (this.mc["dyj"]["t" + _loc1_] as MovieClip).visible = false;
               ((this.mc["dyj"]["k" + _loc1_] as MovieClip).getChildByName("kaipaitubiao") as MovieClip).gotoAndStop(_loc6_[2]);
               (this.mc["dyj"]["jb" + _loc1_] as TextField).text = "" + _loc6_[0] + " * " + _loc6_[1];
            }
            else
            {
               ((this.mc["dyj"]["k" + _loc1_] as MovieClip).getChildByName("kaipaitubiao") as MovieClip).gotoAndStop(1935);
               (this.mc["dyj"]["jb" + _loc1_] as TextField).text = "";
            }
            _loc1_++;
         }
         this.mc.addEventListener(Event.ENTER_FRAME,this.enterH);
         GM.cbGview.addChild(this.mc);
      }
      
      public function leave() : void
      {
         if(curs == 1)
         {
            curs = 0;
            this.mc.x = 19563;
            this.mc.y = 29563;
            this.goodArr = null;
            this.bArr = null;
            this.mc.removeEventListener(Event.ENTER_FRAME,this.enterH);
            GM.cbGview.removeChild(this.mc);
            this.mc = null;
         }
      }
      
      private function enterH(param1:Event) : void
      {
         this.jishi += GS.a1;
         if(this.jishi == 51)
         {
            (this.mc["dyj"] as MovieClip).visible = true;
         }
         if(this.jishi == GS.a300)
         {
            GamePassC.open();
            close();
         }
      }
      
      public function get jishi() : int
      {
         return this._jishi.getValue();
      }
      
      public function set jishi(param1:int) : void
      {
         this._jishi.setValue(param1);
      }
   }
}

