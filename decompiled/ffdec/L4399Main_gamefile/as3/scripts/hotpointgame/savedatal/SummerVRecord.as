package hotpointgame.savedatal
{
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   
   public class SummerVRecord
   {
      
      private var datal:Array = new Array();
      
      private var _datalb:VT = VT.createVT(0);
      
      public function SummerVRecord()
      {
         super();
      }
      
      public static function readData(param1:Object = null) : SummerVRecord
      {
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc2_:SummerVRecord = new SummerVRecord();
         if(param1 != null)
         {
            _loc3_ = param1.da;
            _loc4_ = 0;
            while(_loc4_ < _loc3_.length)
            {
               _loc2_.datal[_loc4_] = VT.createVT(_loc3_[_loc4_]);
               _loc4_++;
            }
            _loc2_.datalb = param1.db;
         }
         else
         {
            _loc5_ = 0;
            while(_loc5_ < GS.a8)
            {
               _loc2_.datal.push(VT.createVT(0));
               _loc5_++;
            }
         }
         return _loc2_;
      }
      
      public function save() : Object
      {
         var _loc1_:Object = new Object();
         var _loc2_:Array = new Array();
         var _loc3_:int = 0;
         while(_loc3_ < this.datal.length)
         {
            _loc2_[_loc3_] = (this.datal[_loc3_] as VT).getValue();
            _loc3_++;
         }
         _loc1_.da = _loc2_;
         _loc1_.db = this.datalb;
         return _loc1_;
      }
      
      public function isKYDataa(param1:int) : Boolean
      {
         if((this.datal[param1 - GS.a1] as VT).getValue() != 0)
         {
            return false;
         }
         return true;
      }
      
      public function dataaSave(param1:int) : void
      {
         if((this.datal[param1 - GS.a1] as VT).getValue() == 0)
         {
            (this.datal[param1 - GS.a1] as VT).setValue(GS.a1);
            return;
         }
         GM.findCheatMax(GS.a77);
      }
      
      public function isKYDatab() : Boolean
      {
         if(this.datalb != 0)
         {
            return false;
         }
         return true;
      }
      
      public function databSave() : void
      {
         if(this.datalb == 0)
         {
            this.datalb = GS.a1;
            return;
         }
         GM.findCheatMax(GS.a77);
      }
      
      public function get datalb() : int
      {
         return this._datalb.getValue();
      }
      
      public function set datalb(param1:int) : void
      {
         this._datalb.setValue(param1);
      }
   }
}

