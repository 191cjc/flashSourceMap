package hotpointgame.glevel
{
   public class CNextRoom
   {
      
      private var lx:Number;
      
      private var rx:Number;
      
      private var ly:Number;
      
      private var ry:Number;
      
      private var _f:Number;
      
      private var _nname:String;
      
      public function CNextRoom(param1:Object)
      {
         super();
         this.lx = param1.lx;
         this.rx = param1.rx;
         this.ly = param1.ly;
         this.ry = param1.ry;
         this.f = param1.f;
         this.nname = param1.fjm;
      }
      
      public function ishit(param1:Number, param2:Number) : Boolean
      {
         if(param1 > this.lx && param1 < this.rx && param2 > this.ly && param2 < this.ry)
         {
            return true;
         }
         return false;
      }
      
      public function get nname() : String
      {
         return this._nname;
      }
      
      public function set nname(param1:String) : void
      {
         this._nname = param1;
      }
      
      public function get f() : Number
      {
         return this._f;
      }
      
      public function set f(param1:Number) : void
      {
         this._f = param1;
      }
   }
}

