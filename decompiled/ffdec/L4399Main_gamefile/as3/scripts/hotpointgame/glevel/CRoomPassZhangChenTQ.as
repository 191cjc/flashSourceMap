package hotpointgame.glevel
{
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   import hotpointgame.gzhujiemian.*;
   
   public class CRoomPassZhangChenTQ extends CRoomPassZhangChen
   {
      
      private var jishi:int = 0;
      
      private var _curtq:VT = VT.createVT(0);
      
      public function CRoomPassZhangChenTQ(param1:Object)
      {
         super(param1);
      }
      
      override public function gmUpdate(param1:CLevel) : void
      {
         if(GM.frameTime - enterT > 60)
         {
            ++this.jishi;
            if((GM.frameTime - enterT) % GS.a900 == 0)
            {
               if(Math.random() * GS.a10 < GS.a5)
               {
                  this.curtq = Math.random() * GS.a5 + GS.a1;
                  Czhujiemian.self.showTQ(this.curtq);
                  GM.cp.addBuffByTq(this.curtq);
                  GM.cp.zCd.setTqatt(this.curtq);
                  this.jishi = 0;
               }
            }
            if(this.curtq > 0 && this.jishi > GS.a300)
            {
               this.curtq = 0;
               Czhujiemian.self.hideTQ();
            }
         }
         super.gmUpdate(param1);
      }
      
      public function get curtq() : int
      {
         return this._curtq.getValue();
      }
      
      public function set curtq(param1:int) : void
      {
         this._curtq.setValue(param1);
      }
   }
}

