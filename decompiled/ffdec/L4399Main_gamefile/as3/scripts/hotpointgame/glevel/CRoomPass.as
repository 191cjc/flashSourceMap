package hotpointgame.glevel
{
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   import hotpointgame.gview.*;
   
   public class CRoomPass extends CRoom
   {
      
      private var comjishi:int = 0;
      
      public function CRoomPass(param1:Object)
      {
         super(param1);
      }
      
      override protected function CurstateOne(param1:CLevel) : void
      {
         ++this.comjishi;
         if(this.comjishi == 60)
         {
            PinFengC.open();
         }
      }
      
      override public function enterRoom(param1:CLevel) : void
      {
         if(type != GS.a2)
         {
            GM.findCheatMax(GS.a9);
         }
         this.comjishi = 0;
         super.enterRoom(param1);
      }
      
      override public function exitRoom() : void
      {
         this.comjishi = 0;
         super.exitRoom();
      }
      
      override public function exitLevelClear() : void
      {
         this.comjishi = 0;
         super.exitLevelClear();
      }
      
      override protected function overHandle(param1:CLevel) : void
      {
         if(param1.id >= GS.a1000 && param1.id <= GS.a1000 * GS.a2)
         {
            GoodsManger.dataList.evData.setJd(GS.a5);
         }
         else if(GM.levelm.curLevel.id >= GS.a980 && GM.levelm.curLevel.id <= GS.a998)
         {
            if(GM.levelm.curLevel.id % 2 == 0)
            {
               GoodsManger.dataList.evData.setJd(GS.a7);
            }
            else
            {
               GoodsManger.dataList.evData.setJd(GS.a6);
            }
         }
         else
         {
            GoodsManger.dataList.evData.setJd(GS.a4);
         }
         super.overHandle(param1);
      }
   }
}

