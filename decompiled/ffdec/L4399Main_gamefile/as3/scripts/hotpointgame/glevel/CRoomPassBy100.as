package hotpointgame.glevel
{
   import hotpointgame.gzhujiemian.*;
   
   public class CRoomPassBy100 extends CRoomPass
   {
      
      public function CRoomPassBy100(param1:Object)
      {
         super(param1);
      }
      
      override public function enterRoom(param1:CLevel) : void
      {
         Czhujiemian.self.hideBtnByLevel();
         super.enterRoom(param1);
      }
      
      override public function exitRoom() : void
      {
         Czhujiemian.self.showBtnByLevel();
         super.exitRoom();
      }
      
      override public function exitLevelClear() : void
      {
         Czhujiemian.self.showBtnByLevel();
         super.exitLevelClear();
      }
   }
}

