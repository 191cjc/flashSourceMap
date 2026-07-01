package hotpointgame.gshangcheng
{
   import hotpointgame.common.*;
   
   public class ShangChengBData
   {
      
      private var _propId:VT = VT.createVT(0);
      
      private var _buyId:VT = VT.createVT(0);
      
      private var _showPrice:VT = VT.createVT(0);
      
      private var _buyPrice:VT = VT.createVT(0);
      
      private var _priceFlag:VT = VT.createVT(0);
      
      private var _hotFlagFrameNum:VT = VT.createVT(0);
      
      private var _isKYShiChuang:VT = VT.createVT(0);
      
      private var _isShowBuyNum:VT = VT.createVT(0);
      
      private var _tjtype:VT = VT.createVT(0);
      
      private var _sztype:VT = VT.createVT(0);
      
      private var _djtype:VT = VT.createVT(0);
      
      private var _pettype:VT = VT.createVT(0);
      
      private var _sorttj:VT = VT.createVT(0);
      
      private var _sortother:VT = VT.createVT(0);
      
      private var _showJob:VT = VT.createVT(0);
      
      public function ShangChengBData()
      {
         super();
      }
      
      public function get propId() : int
      {
         return this._propId.getValue();
      }
      
      public function set propId(param1:int) : void
      {
         this._propId.setValue(param1);
      }
      
      public function get buyId() : int
      {
         return this._buyId.getValue();
      }
      
      public function set buyId(param1:int) : void
      {
         this._buyId.setValue(param1);
      }
      
      public function get showPrice() : int
      {
         return this._showPrice.getValue();
      }
      
      public function set showPrice(param1:int) : void
      {
         this._showPrice.setValue(param1);
      }
      
      public function get buyPrice() : int
      {
         return this._buyPrice.getValue();
      }
      
      public function set buyPrice(param1:int) : void
      {
         this._buyPrice.setValue(param1);
      }
      
      public function get priceFlag() : int
      {
         return this._priceFlag.getValue();
      }
      
      public function set priceFlag(param1:int) : void
      {
         this._priceFlag.setValue(param1);
      }
      
      public function get isKYShiChuang() : int
      {
         return this._isKYShiChuang.getValue();
      }
      
      public function set isKYShiChuang(param1:int) : void
      {
         this._isKYShiChuang.setValue(param1);
      }
      
      public function get isShowBuyNum() : int
      {
         return this._isShowBuyNum.getValue();
      }
      
      public function set isShowBuyNum(param1:int) : void
      {
         this._isShowBuyNum.setValue(param1);
      }
      
      public function get tjtype() : int
      {
         return this._tjtype.getValue();
      }
      
      public function set tjtype(param1:int) : void
      {
         this._tjtype.setValue(param1);
      }
      
      public function get sztype() : int
      {
         return this._sztype.getValue();
      }
      
      public function set sztype(param1:int) : void
      {
         this._sztype.setValue(param1);
      }
      
      public function get djtype() : int
      {
         return this._djtype.getValue();
      }
      
      public function set djtype(param1:int) : void
      {
         this._djtype.setValue(param1);
      }
      
      public function get sorttj() : int
      {
         return this._sorttj.getValue();
      }
      
      public function set sorttj(param1:int) : void
      {
         this._sorttj.setValue(param1);
      }
      
      public function get sortother() : int
      {
         return this._sortother.getValue();
      }
      
      public function set sortother(param1:int) : void
      {
         this._sortother.setValue(param1);
      }
      
      public function get showJob() : int
      {
         return this._showJob.getValue();
      }
      
      public function set showJob(param1:int) : void
      {
         this._showJob.setValue(param1);
      }
      
      public function get hotFlagFrameNum() : int
      {
         return this._hotFlagFrameNum.getValue();
      }
      
      public function set hotFlagFrameNum(param1:int) : void
      {
         this._hotFlagFrameNum.setValue(param1);
      }
      
      public function get pettype() : int
      {
         return this._pettype.getValue();
      }
      
      public function set pettype(param1:int) : void
      {
         this._pettype.setValue(param1);
      }
   }
}

