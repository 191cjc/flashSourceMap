package hotpointgame.gview.GvUdata
{
   import hotpointgame.common.*;
   
   public class SVcongData
   {
      
      private var _sid:VT = VT.createVT(0);
      
      private var _congvalue:VT = VT.createVT(0);
      
      public var awardList:Array = new Array();
      
      public function SVcongData()
      {
         super();
      }
      
      public function addAward(param1:Number, param2:Number) : void
      {
         this.awardList.push([VT.createVT(param1),VT.createVT(param2)]);
      }
      
      public function get sid() : Number
      {
         return this._sid.getValue();
      }
      
      public function set sid(param1:Number) : void
      {
         this._sid.setValue(param1);
      }
      
      public function get congvalue() : Number
      {
         return this._congvalue.getValue();
      }
      
      public function set congvalue(param1:Number) : void
      {
         this._congvalue.setValue(param1);
      }
   }
}

