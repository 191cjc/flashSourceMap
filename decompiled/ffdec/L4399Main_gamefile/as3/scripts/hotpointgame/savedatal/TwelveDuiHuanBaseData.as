package hotpointgame.savedatal
{
   import hotpointgame.common.*;
   
   public class TwelveDuiHuanBaseData
   {
      
      private var _id:VT = VT.createVT(0);
      
      private var _pid:VT = VT.createVT(0);
      
      private var _pgod:VT = VT.createVT(0);
      
      private var _pfnum:VT = VT.createVT(0);
      
      public function TwelveDuiHuanBaseData()
      {
         super();
      }
      
      public function get id() : int
      {
         return this._id.getValue();
      }
      
      public function set id(param1:int) : void
      {
         this._id.setValue(param1);
      }
      
      public function get pid() : int
      {
         return this._pid.getValue();
      }
      
      public function set pid(param1:int) : void
      {
         this._pid.setValue(param1);
      }
      
      public function get pgod() : int
      {
         return this._pgod.getValue();
      }
      
      public function set pgod(param1:int) : void
      {
         this._pgod.setValue(param1);
      }
      
      public function get pfnum() : int
      {
         return this._pfnum.getValue();
      }
      
      public function set pfnum(param1:int) : void
      {
         this._pfnum.setValue(param1);
      }
   }
}

