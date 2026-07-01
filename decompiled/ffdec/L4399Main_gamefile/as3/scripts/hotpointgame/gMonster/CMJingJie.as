package hotpointgame.gMonster
{
   public class CMJingJie
   {
      
      private var _lx:Number = 0;
      
      private var _rx:Number = 0;
      
      private var _ly:Number = -1000;
      
      private var _ry:Number = 1000;
      
      public function CMJingJie(param1:Number, param2:Number, param3:Number, param4:Number)
      {
         super();
         this._lx = param1;
         this._ly = param3;
         this._rx = param2;
         this._ry = param4;
      }
      
      public function get lx() : Number
      {
         return this._lx;
      }
      
      public function set lx(param1:Number) : void
      {
         this._lx = param1;
      }
      
      public function get rx() : Number
      {
         return this._rx;
      }
      
      public function set rx(param1:Number) : void
      {
         this._rx = param1;
      }
      
      public function get ly() : Number
      {
         return this._ly;
      }
      
      public function set ly(param1:Number) : void
      {
         this._ly = param1;
      }
      
      public function get ry() : Number
      {
         return this._ry;
      }
      
      public function set ry(param1:Number) : void
      {
         this._ry = param1;
      }
      
      public function isfind(param1:Number, param2:Number) : Boolean
      {
         if(param1 > this.lx && param1 < this.rx && param2 > this.ly && param2 < this.ry)
         {
            return true;
         }
         return false;
      }
   }
}

