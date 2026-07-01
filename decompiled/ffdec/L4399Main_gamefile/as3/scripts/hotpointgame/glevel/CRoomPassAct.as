package hotpointgame.glevel
{
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   import hotpointgame.gzhujiemian.*;
   import hotpointgame.views.fbPanel.*;
   
   public class CRoomPassAct extends CRoomPass
   {
      
      private var isflase:Boolean = true;
      
      public function CRoomPassAct(param1:Object)
      {
         super(param1);
      }
      
      override public function gmUpdate(param1:CLevel) : void
      {
         if(Boolean(this.isflase) && killBossNum > 0)
         {
            this.isflase = false;
            if(GM.levelm.curLevel.id >= GS.a980 && GM.levelm.curLevel.id <= GS.a998)
            {
               GM.aSaveData.jieshas.killOverNum(GM.levelm.curLevel.id - GS.a980);
               GM.testapi.saveDataBefore();
            }
            else if(GM.levelm.curLevel.id >= GS.a1000 && GM.levelm.curLevel.id <= GS.a1000 * GS.a2)
            {
               GM.aSaveData.sxiaodata.addOne();
               GM.testapi.saveDataBefore();
            }
            else if(GM.levelm.curLevel.id >= GS.a3000 && GM.levelm.curLevel.id <= GS.a3000 + GS.a100)
            {
               FbData.addFbTimes(GM.levelm.curLevel.id);
            }
         }
         super.gmUpdate(param1);
      }
      
      override public function enterRoom(param1:CLevel) : void
      {
         this.isflase = true;
         if(!(GM.levelm.curLevel.id >= GS.a3000 && GM.levelm.curLevel.id <= GS.a3000 + GS.a100))
         {
            Czhujiemian.self.hideBtnByLevel();
         }
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

