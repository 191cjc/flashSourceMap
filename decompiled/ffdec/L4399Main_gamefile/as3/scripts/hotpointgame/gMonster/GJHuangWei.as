package hotpointgame.gMonster
{
   public class GJHuangWei
   {
      
      private var _llx:Number = 0;
      
      private var _lrx:Number = 0;
      
      private var _rlx:Number = 0;
      
      private var _rrx:Number = 0;
      
      private var _ty:Number = 0;
      
      private var _by:Number = 0;
      
      public function GJHuangWei(param1:Number = 0, param2:Number = 0, param3:Number = 0, param4:Number = 0)
      {
         super();
         this._llx = -param2;
         this._lrx = -param1;
         this._rlx = param1;
         this._rrx = param2;
         this._ty = param3;
         this._by = param4;
      }
      
      public function isHuangWei(param1:Number, param2:Number) : Boolean
      {
         if(param1 >= this._llx && param1 <= this._lrx || param1 >= this._rlx && param1 <= this._rrx)
         {
            if(param2 >= this._ty && param2 <= this._by)
            {
               return true;
            }
         }
         return false;
      }
   }
}

