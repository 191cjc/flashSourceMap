package hotpointgame.pet
{
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   
   public class EggR
   {
      
      private var _pid:VT = VT.createVT(0);
      
      private var _usedate:VT = VT.createVT(0);
      
      private var _datelimit:VT = VT.createVT(0);
      
      private var _pcolor:VT = VT.createVT(0);
      
      public function EggR()
      {
         super();
      }
      
      public static function readData(param1:Object = null) : EggR
      {
         var _loc2_:EggR = new EggR();
         if(param1 != null)
         {
            _loc2_.pid = param1.id;
            _loc2_.datelimit = param1.dl;
            _loc2_.pcolor = param1.pc;
         }
         return _loc2_;
      }
      
      public function save() : Object
      {
         var _loc1_:Object = new Object();
         _loc1_.id = this.pid;
         _loc1_.dl = this.datelimit;
         _loc1_.pc = this.pcolor;
         return _loc1_;
      }
      
      public function countTime() : Number
      {
         return this.usedate - FlowInterface.getCurrTimer();
      }
      
      public function get pid() : Number
      {
         return this._pid.getValue();
      }
      
      public function set pid(param1:Number) : void
      {
         this._pid.setValue(param1);
      }
      
      public function get usedate() : Number
      {
         return this._usedate.getValue();
      }
      
      public function set usedate(param1:Number) : void
      {
         this._usedate.setValue(param1);
      }
      
      public function get pcolor() : int
      {
         return this._pcolor.getValue();
      }
      
      public function set pcolor(param1:int) : void
      {
         this._pcolor.setValue(param1);
      }
      
      public function get datelimit() : Number
      {
         return this._datelimit.getValue();
      }
      
      public function set datelimit(param1:Number) : void
      {
         this._datelimit.setValue(param1);
         this.usedate = FlowInterface.getCurrTimer() + param1;
      }
   }
}

