package hotpointgame.Control
{
   import flash.utils.*;
   import hotpointgame.common.*;
   
   public class ServerDateC
   {
      
      private var _sYear:VT = VT.createVT(0);
      
      private var _sMonth:VT = VT.createVT(0);
      
      private var _sDate:VT = VT.createVT(0);
      
      private var _sHours:VT = VT.createVT(0);
      
      private var _serverDateU:VT = VT.createVT(0);
      
      private var _avmDate:VT = VT.createVT(0);
      
      private var serverDate:Date;
      
      public function ServerDateC()
      {
         super();
      }
      
      public static function createServerDateA(param1:String) : ServerDateC
      {
         var _loc2_:ServerDateC = new ServerDateC();
         var _loc3_:Array = param1.split(" ");
         var _loc4_:Array = (_loc3_[0] as String).split("-");
         var _loc5_:Array = (_loc3_[1] as String).split(":");
         var _loc6_:String = "" + _loc4_[1] + "/" + _loc4_[2] + "/" + _loc4_[0] + " " + _loc3_[1];
         _loc2_.sYear = _loc4_[0];
         _loc2_.sMonth = _loc4_[1] - GS.a1;
         _loc2_.sDate = _loc4_[2];
         _loc2_.sHours = _loc5_[0];
         _loc2_.serverDate = new Date(_loc6_);
         _loc2_.serverDateU = _loc2_.serverDate.time;
         _loc2_.avmDate = getTimer();
         return _loc2_;
      }
      
      public static function createServerDateB() : ServerDateC
      {
         var _loc1_:ServerDateC = new ServerDateC();
         _loc1_.serverDate = new Date();
         _loc1_.serverDateU = _loc1_.serverDate.time;
         _loc1_.avmDate = getTimer();
         _loc1_.sYear = _loc1_.serverDate.fullYear;
         _loc1_.sMonth = _loc1_.serverDate.month;
         _loc1_.sDate = _loc1_.serverDate.date;
         _loc1_.sHours = _loc1_.serverDate.hours;
         return _loc1_;
      }
      
      public function timeIsCorr() : Boolean
      {
         if(this.serverDateU == this.serverDate.time)
         {
            return true;
         }
         return false;
      }
      
      public function getCurrentGameTime() : Number
      {
         return this.serverDateU + getTimer() - this.avmDate;
      }
      
      public function get sYear() : Number
      {
         return this._sYear.getValue();
      }
      
      public function set sYear(param1:Number) : void
      {
         this._sYear.setValue(param1);
      }
      
      public function get sMonth() : Number
      {
         return this._sMonth.getValue();
      }
      
      public function set sMonth(param1:Number) : void
      {
         this._sMonth.setValue(param1);
      }
      
      public function get sDate() : Number
      {
         return this._sDate.getValue();
      }
      
      public function set sDate(param1:Number) : void
      {
         this._sDate.setValue(param1);
      }
      
      public function get sHours() : Number
      {
         return this._sHours.getValue();
      }
      
      public function set sHours(param1:Number) : void
      {
         this._sHours.setValue(param1);
      }
      
      public function get serverDateU() : Number
      {
         return this._serverDateU.getValue();
      }
      
      public function set serverDateU(param1:Number) : void
      {
         this._serverDateU.setValue(param1);
      }
      
      public function get avmDate() : Number
      {
         return this._avmDate.getValue();
      }
      
      public function set avmDate(param1:Number) : void
      {
         this._avmDate.setValue(param1);
      }
   }
}

