package hotpointgame.gameobj
{
   import hotpointgame.common.*;
   
   public class ApiShopTax
   {
      
      private var _sid:VT = VT.createVT(0);
      
      private var _num:VT = VT.createVT(0);
      
      private var _pid:VT = VT.createVT(0);
      
      private var _tax:VT = VT.createVT(0);
      
      private var _pprice:VT = VT.createVT(0);
      
      public function ApiShopTax()
      {
         super();
      }
      
      public function get sid() : int
      {
         return this._sid.getValue();
      }
      
      public function set sid(param1:int) : void
      {
         this._sid.setValue(param1);
      }
      
      public function get num() : int
      {
         return this._num.getValue();
      }
      
      public function set num(param1:int) : void
      {
         this._num.setValue(param1);
      }
      
      public function get pid() : int
      {
         return this._pid.getValue();
      }
      
      public function set pid(param1:int) : void
      {
         this._pid.setValue(param1);
      }
      
      public function get tax() : int
      {
         return this._tax.getValue();
      }
      
      public function set tax(param1:int) : void
      {
         this._tax.setValue(param1);
      }
      
      public function get pprice() : int
      {
         return this._pprice.getValue();
      }
      
      public function set pprice(param1:int) : void
      {
         this._pprice.setValue(param1);
      }
   }
}

