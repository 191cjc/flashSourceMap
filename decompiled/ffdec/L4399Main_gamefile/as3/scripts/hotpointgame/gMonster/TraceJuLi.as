package hotpointgame.gMonster
{
   public class TraceJuLi
   {
      
      private var _llx:Number = 0;
      
      private var _lrx:Number = 0;
      
      private var _rlx:Number = 0;
      
      private var _rrx:Number = 0;
      
      private var _ty:Number = 0;
      
      private var _by:Number = 0;
      
      public function TraceJuLi(param1:Number = 0, param2:Number = 0, param3:Number = 0, param4:Number = 0)
      {
         super();
         this._rlx = param1;
         this._rrx = param2;
         this._llx = -this._rrx;
         this._lrx = -this._rlx;
         this._ty = param3;
         this._by = param4;
      }
      
      public function includeJuLi(param1:int, param2:Number = 0, param3:Number = 0) : Boolean
      {
         if(param1 == 1)
         {
            if(param2 >= 0 && param2 < this._rrx && param2 > this._rlx)
            {
               if(param3 >= this._ty && param3 <= this._by)
               {
                  return true;
               }
            }
            if(param2 < 0 && param2 < this._lrx && param2 > this._llx)
            {
               if(param3 >= this._ty && param3 <= this._by)
               {
                  return true;
               }
            }
         }
         return false;
      }
      
      public function getMoveForth(param1:int, param2:Number, param3:Number, param4:Number) : int
      {
         var _loc5_:int = 1;
         if(param1 == 0)
         {
            if(param2 >= 0)
            {
               if(param3 < this._ty || param3 > this._by)
               {
                  _loc5_ = 1;
               }
               else
               {
                  if(param2 <= this.rlx)
                  {
                     _loc5_ = 1;
                  }
                  if(param2 >= this.rrx)
                  {
                     _loc5_ = -1;
                  }
               }
            }
            if(param2 <= 0)
            {
               if(param3 < this._ty || param3 > this._by)
               {
                  _loc5_ = -1;
               }
               else
               {
                  if(param2 <= this.llx)
                  {
                     _loc5_ = 1;
                  }
                  if(param2 >= this.lrx)
                  {
                     _loc5_ = -1;
                  }
               }
            }
         }
         if(param1 == -1)
         {
            if(param3 < this._ty || param3 > this._by)
            {
               _loc5_ = 1;
            }
            else if(param2 >= 0)
            {
               if(param2 <= this.rlx)
               {
                  if(param2 >= param4 || param4 > this.rrx)
                  {
                     _loc5_ = 1;
                  }
                  else
                  {
                     _loc5_ = -1;
                  }
               }
               if(param2 >= this.rrx)
               {
                  if(param2 < param4 || param4 < this.rlx)
                  {
                     _loc5_ = -1;
                  }
                  else
                  {
                     _loc5_ = 1;
                  }
               }
            }
            else
            {
               if(param2 <= this.llx)
               {
                  if(param2 >= param4 || param4 > this.lrx)
                  {
                     _loc5_ = 1;
                  }
                  else
                  {
                     _loc5_ = -1;
                  }
               }
               if(param2 >= this.lrx)
               {
                  if(param2 < param4 || param4 < this.llx)
                  {
                     _loc5_ = -1;
                  }
                  else
                  {
                     _loc5_ = 1;
                  }
               }
            }
         }
         if(param1 == 1)
         {
            if(param3 < this._ty || param3 > this._by)
            {
               _loc5_ = -1;
            }
            else if(param2 >= 0)
            {
               if(param2 <= this.rlx)
               {
                  if(param2 > param4 || param4 > this.rrx)
                  {
                     _loc5_ = 1;
                  }
                  else
                  {
                     _loc5_ = -1;
                  }
               }
               if(param2 >= this.rrx)
               {
                  if(param2 <= param4 || param4 < this.rlx)
                  {
                     _loc5_ = -1;
                  }
                  else
                  {
                     _loc5_ = 1;
                  }
               }
            }
            else
            {
               if(param2 <= this.llx)
               {
                  if(param2 > param4 || param4 > this.lrx)
                  {
                     _loc5_ = 1;
                  }
                  else
                  {
                     _loc5_ = -1;
                  }
               }
               if(param2 >= this.lrx)
               {
                  if(param2 <= param4 || param4 < this.llx)
                  {
                     _loc5_ = -1;
                  }
                  else
                  {
                     _loc5_ = 1;
                  }
               }
            }
         }
         return _loc5_;
      }
      
      public function get llx() : Number
      {
         return this._llx;
      }
      
      public function set llx(param1:Number) : void
      {
         this._llx = param1;
      }
      
      public function get lrx() : Number
      {
         return this._lrx;
      }
      
      public function set lrx(param1:Number) : void
      {
         this._lrx = param1;
      }
      
      public function get rlx() : Number
      {
         return this._rlx;
      }
      
      public function set rlx(param1:Number) : void
      {
         this._rlx = param1;
      }
      
      public function get rrx() : Number
      {
         return this._rrx;
      }
      
      public function set rrx(param1:Number) : void
      {
         this._rrx = param1;
      }
      
      public function get ty() : Number
      {
         return this._ty;
      }
      
      public function set ty(param1:Number) : void
      {
         this._ty = param1;
      }
      
      public function get by() : Number
      {
         return this._by;
      }
      
      public function set by(param1:Number) : void
      {
         this._by = param1;
      }
   }
}

