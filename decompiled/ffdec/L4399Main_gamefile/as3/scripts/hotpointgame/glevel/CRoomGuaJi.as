package hotpointgame.glevel
{
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   import hotpointgame.ginit.*;
   import hotpointgame.gzhujiemian.*;
   import hotpointgame.views.petGj.*;
   import hotpointgame.views.shipPanel.*;
   
   public class CRoomGuaJi extends CRoom
   {
      
      private var mc:MovieClip;
      
      private var mcMO:Object = new Object();
      
      public function CRoomGuaJi(param1:Object)
      {
         super(param1);
      }
      
      private function mcInit() : void
      {
         var _loc1_:McBtnLianDong = new McBtnLianDong();
         _loc1_.addBtnLianDong(new McBtn(this.mc["npcalgj"]));
         _loc1_.addBtnLianDong(new McBtn(this.mc["npcczt"]));
         _loc1_.addBtnLianDong(new McBtn(this.mc["npcalcwgj"]));
         this.mcMO["cnpc"] = _loc1_;
         this.mc.addEventListener(MouseEvent.CLICK,this.mcClick);
      }
      
      private function mcClick(param1:MouseEvent) : void
      {
         if(param1.target.name != null && Boolean((this.mcMO["cnpc"] as McBtnLianDong).isFlase(param1.target.name)))
         {
            switch(param1.target.name)
            {
               case "npcalgj":
                  ShipWxPanel.open();
                  break;
               case "npcalcwgj":
                  if(PetGjData.opBo)
                  {
                     if(ShipData.level.getValue() >= GS.a14)
                     {
                        PetGjPanel.open();
                     }
                     else
                     {
                        GoodsManger.cwTs("战舰等级必需达到30!");
                     }
                  }
                  else
                  {
                     PetOpenPanel.open();
                  }
                  break;
               case "npcczt":
                  if(!ShipData.opBo)
                  {
                     ShipSdPanel.open();
                  }
                  else if(ShipData.nj.getValue() > GS.a60)
                  {
                     ShipPanel.open();
                  }
                  else
                  {
                     GoodsManger.cwTs("耐久度必须大于60!");
                  }
            }
         }
      }
      
      override public function gmUpdate(param1:CLevel) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:int = 0;
         if(PetGjData.isBo.getValue() == GS.a1)
         {
            (this.mc["npcalcwgjb"] as MovieClip).visible = true;
            _loc2_ = int(PetGjData.gjTime.getValue());
            _loc3_ = 1;
            if(_loc2_ <= 0)
            {
               _loc3_ = 2;
            }
            (this.mc["npcalcwgjb"]["wxgold_tx"] as MovieClip).gotoAndStop(_loc3_);
            if(_loc2_ < 0)
            {
               _loc2_ = 0;
            }
            _loc4_ = "";
            _loc5_ = _loc2_ / 3600;
            _loc4_ += "" + _loc5_ + ":";
            _loc2_ -= 3600 * _loc5_;
            _loc5_ = _loc2_ / 60;
            _loc4_ += "" + _loc5_ + ":";
            _loc2_ -= 60 * _loc5_;
            _loc4_ += "" + _loc2_;
            (this.mc["npcalcwgjb"]["wxgold_tx1"] as TextField).text = "" + _loc4_;
            (this.mc["npcalcwgjb"]["wxgold_tx2"] as TextField).text = "" + PetGjData.getZxExp();
            (this.mc["npcalcwgjb"]["wxgold_tx3"] as TextField).text = "" + PetGjData.getLxExp();
         }
         else
         {
            (this.mc["npcalcwgjb"] as MovieClip).visible = false;
         }
         super.gmUpdate(param1);
      }
      
      override public function enterRoom(param1:CLevel) : void
      {
         Czhujiemian.self.showBtnByLevelByAll();
         this.mc = param1.getvs().getGuaJiNpcMc();
         this.mcInit();
         super.enterRoom(param1);
      }
      
      override public function exitRoom() : void
      {
         Czhujiemian.self.hideBtnByLevelByAll();
         this.remove();
         super.exitRoom();
      }
      
      override public function exitLevelClear() : void
      {
         Czhujiemian.self.hideBtnByLevelByAll();
         this.remove();
         super.exitLevelClear();
      }
      
      private function remove() : void
      {
         (this.mcMO["cnpc"] as McBtnLianDong).remove();
         this.mcMO = new Object();
         this.mc.removeEventListener(MouseEvent.CLICK,this.mcClick);
         this.mc = null;
      }
   }
}

