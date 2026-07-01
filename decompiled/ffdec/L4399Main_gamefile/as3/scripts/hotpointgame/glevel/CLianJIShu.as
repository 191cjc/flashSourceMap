package hotpointgame.glevel
{
   import hotpointgame.Control.*;
   import hotpointgame.gzhujiemian.*;
   
   public class CLianJIShu
   {
      
      private var maxnum:int = 0;
      
      private var curnum:int = 0;
      
      private var hi:int = 60;
      
      private var jishi:int = 0;
      
      public function CLianJIShu()
      {
         super();
      }
      
      public function addLianJi() : void
      {
         ++this.curnum;
         this.jishi = GM.frameTime;
         if(this.curnum > this.maxnum)
         {
            this.maxnum = this.curnum;
         }
      }
      
      public function gmUpdate() : void
      {
         if(GM.frameTime - this.jishi > this.hi)
         {
            this.curnum = 0;
         }
         Czhujiemian.self.upLianJINum(this.curnum);
      }
   }
}

