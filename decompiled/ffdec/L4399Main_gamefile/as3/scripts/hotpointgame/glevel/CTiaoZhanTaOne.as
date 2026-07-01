package hotpointgame.glevel
{
   import flash.display.SimpleButton;
   import flash.events.*;
   import hotpointgame.Control.*;
   import hotpointgame.gview.*;
   
   public class CTiaoZhanTaOne extends CRoomTZBase
   {
      
      private var npcB:SimpleButton;
      
      public function CTiaoZhanTaOne(param1:Object)
      {
         super(param1);
      }
      
      override public function enterRoom(param1:CLevel) : void
      {
         this.npcB = param1.getvs().getTiaoZhangNpc();
         this.mcInit();
         super.enterRoom(param1);
      }
      
      override public function exitRoom() : void
      {
         GTiaoZhangSend.close();
         this.remove();
         super.exitRoom();
      }
      
      override public function exitLevelClear() : void
      {
         GTiaoZhangSend.close();
         this.remove();
         super.exitLevelClear();
      }
      
      private function mcInit() : void
      {
         this.npcB.addEventListener(MouseEvent.CLICK,this.mcClick);
      }
      
      private function mcClick(param1:MouseEvent) : void
      {
         if(GM.cp.cHp != 0)
         {
            GTiaoZhangSend.open();
         }
      }
      
      private function remove() : void
      {
         if(this.npcB != null)
         {
            this.npcB.removeEventListener(MouseEvent.CLICK,this.mcClick);
            this.npcB = null;
         }
      }
   }
}

