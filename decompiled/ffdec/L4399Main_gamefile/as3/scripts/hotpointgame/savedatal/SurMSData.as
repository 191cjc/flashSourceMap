package hotpointgame.savedatal
{
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   
   public class SurMSData
   {
      
      private var _smNum:VT = VT.createVT(0);
      
      private var _boMax:VT = VT.createVT(0);
      
      public function SurMSData()
      {
         super();
      }
      
      public static function readData(param1:Object = null) : SurMSData
      {
         var _loc2_:SurMSData = new SurMSData();
         if(param1 != null)
         {
            _loc2_.smNum = param1.smn;
            if(param1.bom != null)
            {
               _loc2_.boMax = param1.bom;
            }
         }
         return _loc2_;
      }
      
      public function save() : Object
      {
         var _loc1_:Object = new Object();
         _loc1_.smn = this.smNum;
         _loc1_.bom = this.boMax;
         return _loc1_;
      }
      
      public function dataUpdate() : void
      {
         this.smNum = 0;
      }
      
      public function addNum() : void
      {
         if(this.smNum <= GS.a5)
         {
            this.smNum += GS.a1;
         }
         else
         {
            GM.findCheatMax(GS.a75);
         }
      }
      
      public function addBomMax(param1:int) : void
      {
         if(this.boMax < param1)
         {
            this.boMax = param1;
         }
      }
      
      public function get smNum() : int
      {
         return this._smNum.getValue();
      }
      
      public function set smNum(param1:int) : void
      {
         this._smNum.setValue(param1);
      }
      
      public function get boMax() : int
      {
         return this._boMax.getValue();
      }
      
      public function set boMax(param1:int) : void
      {
         this._boMax.setValue(param1);
      }
   }
}

