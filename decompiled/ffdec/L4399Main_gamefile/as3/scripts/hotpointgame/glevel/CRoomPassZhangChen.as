package hotpointgame.glevel
{
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   import hotpointgame.views.shipPanel.*;
   
   public class CRoomPassZhangChen extends CRoomPass
   {
      
      private var isflase:Boolean = true;
      
      public function CRoomPassZhangChen(param1:Object)
      {
         super(param1);
      }
      
      override public function gmUpdate(param1:CLevel) : void
      {
         if(Boolean(this.isflase) && killBossNum > 0)
         {
            this.isflase = false;
            if(GM.levelm.curLevel.id > GS.a2000 && GM.levelm.curLevel.id <= GS.a2000 + GS.a100)
            {
               ShipData.deleteTl(GS.a2);
               GM.aSaveData.nlevel.addmaxl(GM.levelm.curLevel.id - GS.a2000);
               GM.testapi.saveDataBefore();
            }
         }
         super.gmUpdate(param1);
      }
      
      override public function enterRoom(param1:CLevel) : void
      {
         this.isflase = true;
         super.enterRoom(param1);
      }
   }
}

