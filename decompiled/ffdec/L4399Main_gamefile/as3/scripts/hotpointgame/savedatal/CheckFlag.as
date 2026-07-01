package hotpointgame.savedatal
{
   import hotpointgame.common.*;
   
   public class CheckFlag
   {
      
      private var _cflag:VT = VT.createVT(0);
      
      private var _cvalue:VT = VT.createVT(0);
      
      private var _cnum:VT = VT.createVT(0);
      
      private var _cDate:VT = VT.createVT(0);
      
      public function CheckFlag()
      {
         super();
      }
      
      public static function readData(param1:Object = null) : CheckFlag
      {
         var _loc2_:CheckFlag = new CheckFlag();
         if(param1 != null)
         {
            _loc2_.cflag = param1.cf;
            _loc2_.cvalue = param1.cv;
            _loc2_.cnum = param1.cm;
            if(param1.cd != null)
            {
               _loc2_.cDate = param1.cd;
            }
         }
         return _loc2_;
      }
      
      public function save() : Object
      {
         var _loc1_:Object = new Object();
         _loc1_.cf = this.cflag;
         _loc1_.cv = this.cvalue;
         _loc1_.cm = this.cnum;
         _loc1_.cd = this.cDate;
         return _loc1_;
      }
      
      public function get cflag() : Number
      {
         return this._cflag.getValue();
      }
      
      public function set cflag(param1:Number) : void
      {
         this._cflag.setValue(param1);
      }
      
      public function get cvalue() : Number
      {
         return this._cvalue.getValue();
      }
      
      public function set cvalue(param1:Number) : void
      {
         this._cvalue.setValue(param1);
      }
      
      public function get cnum() : Number
      {
         return this._cnum.getValue();
      }
      
      public function set cnum(param1:Number) : void
      {
         this._cnum.setValue(param1);
      }
      
      public function get cDate() : Number
      {
         return this._cDate.getValue();
      }
      
      public function set cDate(param1:Number) : void
      {
         this._cDate.setValue(param1);
      }
   }
}

