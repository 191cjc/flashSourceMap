package hotpointgame.glevel
{
   import flash.display.*;
   import flash.events.*;
   import hotpointgame.Control.*;
   import hotpointgame.ginit.*;
   import hotpointgame.gzhujiemian.*;
   import hotpointgame.views.taskPanel.*;
   
   public class CRoomGroup extends CRoom
   {
      
      private var mc:MovieClip;
      
      private var mcMO:Object = new Object();
      
      public function CRoomGroup(param1:Object)
      {
         super(param1);
      }
      
      private function mcInit() : void
      {
         var _loc1_:McBtnLianDong = new McBtnLianDong();
         _loc1_.addBtnLianDong(new McBtn(this.mc["npcyxm"]));
         _loc1_.addBtnLianDong(new McBtn(this.mc["sdyyf"]));
         _loc1_.addBtnLianDong(new McBtn(this.mc["huolei"]));
         this.mcMO["cnpc"] = _loc1_;
         this.mc.addEventListener(MouseEvent.CLICK,this.mcClick);
      }
      
      private function mcClick(param1:MouseEvent) : void
      {
         if(param1.target.name != null && Boolean((this.mcMO["cnpc"] as McBtnLianDong).isFlase(param1.target.name)))
         {
            switch(param1.target.name)
            {
               case "npcyxm":
                  NpcTaskPanel.open(9);
                  break;
               case "sdyyf":
                  NpcTaskPanel.open(10);
                  break;
               case "huolei":
                  NpcTaskPanel.open(11);
            }
         }
      }
      
      override public function gmUpdate(param1:CLevel) : void
      {
         (this.mc["npcyxmb"] as MovieClip).gotoAndStop(FlowInterface.npcGoto(9));
         super.gmUpdate(param1);
      }
      
      override public function enterRoom(param1:CLevel) : void
      {
         Czhujiemian.self.showBtnByLevelByAll();
         this.mc = param1.getvs().getGroupNpcMc();
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

