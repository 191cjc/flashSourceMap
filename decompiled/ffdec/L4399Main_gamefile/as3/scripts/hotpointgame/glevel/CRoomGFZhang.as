package hotpointgame.glevel
{
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   import hotpointgame.gview.*;
   
   public class CRoomGFZhang extends CRoom
   {
      
      private var _jishu:VT = VT.createVT(0);
      
      public function CRoomGFZhang(param1:Object)
      {
         super(param1);
      }
      
      override public function gmUpdate(param1:CLevel) : void
      {
         if(this.jishu == 0 && GM.frameTime - enterT > GS.a100)
         {
            if(GM.cp.cHp == 0)
            {
               this.jishu = GS.a1;
               GM.levelm.clearallMAndBNoGa();
               GgfPingFeng.open(3);
               GoodsManger.dataList.unionData.addUnJf(GM.levelm.curLevel.id,GS.a0);
               GM.testapi.saveDataBefore();
               return;
            }
            if(killBossNum > 0)
            {
               this.jishu = GS.a1;
               GM.levelm.clearallMAndBNoGa();
               if(GM.cp.cHp / GM.cp.getHpMax() > GS.a08)
               {
                  GoodsManger.dataList.unionData.addUnJf(GM.levelm.curLevel.id,GS.a2);
                  GgfPingFeng.open(5);
               }
               else if(GM.cp.cHp / GM.cp.getHpMax() > GS.a03)
               {
                  GoodsManger.dataList.unionData.addUnJf(GM.levelm.curLevel.id,GS.a1);
                  GgfPingFeng.open(4);
               }
               else
               {
                  GoodsManger.dataList.unionData.addUnJf(GM.levelm.curLevel.id,GS.a0);
                  GgfPingFeng.open(3);
               }
               GM.testapi.saveDataBefore();
               return;
            }
         }
         super.gmUpdate(param1);
      }
      
      override public function enterRoom(param1:CLevel) : void
      {
         this.jishu = 0;
         super.enterRoom(param1);
      }
      
      public function get jishu() : int
      {
         return this._jishu.getValue();
      }
      
      public function set jishu(param1:int) : void
      {
         this._jishu.setValue(param1);
      }
   }
}

