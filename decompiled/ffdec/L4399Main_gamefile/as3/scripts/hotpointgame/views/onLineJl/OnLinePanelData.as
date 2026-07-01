package hotpointgame.views.onLineJl
{
   import flash.utils.*;
   import hotpointgame.common.*;
   import hotpointgame.repository.timeJl.*;
   
   public class OnLinePanelData
   {
      
      public var mbTime:Array = [];
      
      public var gdTime:Array = [];
      
      public var overArr:Array = [];
      
      public var lqArr:Array = [];
      
      public var xsArr:Array = [];
      
      public var fwqTime:VT;
      
      public var currType:VT;
      
      public function OnLinePanelData()
      {
         super();
      }
      
      public static function read(param1:Object = null) : OnLinePanelData
      {
         var _loc3_:Array = null;
         var _loc4_:Array = null;
         var _loc5_:uint = 0;
         var _loc2_:OnLinePanelData = new OnLinePanelData();
         if(param1 != null)
         {
            _loc3_ = param1["ov"];
            _loc4_ = param1["lq"];
            _loc5_ = 1;
            while(_loc5_ < 5)
            {
               _loc2_.overArr[_loc5_] = VT.createVT(_loc3_[_loc5_]);
               _loc2_.lqArr[_loc5_] = VT.createVT(_loc4_[_loc5_]);
               _loc5_++;
            }
         }
         else
         {
            _loc2_.initOver();
         }
         _loc2_.mbTime.length = GS.a0;
         _loc2_.gdTime.length = GS.a0;
         _loc2_.xsArr.length = GS.a0;
         _loc2_.fwqTime = VT.createVT(GS.a0);
         _loc2_.currType = VT.createVT(-GS.a1);
         return _loc2_;
      }
      
      public function save() : Object
      {
         var _loc1_:Object = new Object();
         var _loc2_:Array = [-1];
         var _loc3_:Array = [-1];
         var _loc4_:uint = 1;
         while(_loc4_ < 5)
         {
            _loc2_[_loc4_] = this.overArr[_loc4_].getValue();
            _loc3_[_loc4_] = this.lqArr[_loc4_].getValue();
            _loc4_++;
         }
         _loc1_["ov"] = _loc2_;
         _loc1_["lq"] = _loc3_;
         return _loc1_;
      }
      
      public function getCurrType() : Number
      {
         return this.currType.getValue();
      }
      
      public function setCurrType(param1:Number) : void
      {
         this.currType.setValue(param1);
      }
      
      public function setMbTime() : void
      {
         var _loc1_:uint = 1;
         while(_loc1_ < 5)
         {
            this.gdTime[_loc1_] = VT.createVT(TimeJlFactory.getDataByType(_loc1_).getTime() * GS.a60);
            this.mbTime[_loc1_] = VT.createVT(getTimer() / GS.a1000 + this.gdTime[_loc1_].getValue());
            _loc1_++;
         }
      }
      
      public function getMbTime(param1:Number) : Number
      {
         return this.mbTime[param1].getValue();
      }
      
      public function getGdTime(param1:Number) : Number
      {
         return this.gdTime[param1].getValue();
      }
      
      public function initOver() : void
      {
         var _loc1_:uint = 1;
         while(_loc1_ < 5)
         {
            this.overArr[_loc1_] = VT.createVT(GS.a0);
            this.lqArr[_loc1_] = VT.createVT(GS.a0);
            _loc1_++;
         }
      }
      
      public function getLq(param1:Number) : Number
      {
         return this.lqArr[param1].getValue();
      }
      
      public function setLq(param1:Number, param2:Number) : void
      {
         this.lqArr[param1].setValue(param2);
      }
      
      public function getOver(param1:Number) : Number
      {
         return this.overArr[param1].getValue();
      }
      
      public function setOver(param1:Number, param2:Number) : void
      {
         this.overArr[param1].setValue(param2);
      }
      
      public function getDjs(param1:Number) : Number
      {
         return this.xsArr[param1];
      }
      
      public function setDjs(param1:Number, param2:Number) : void
      {
         this.xsArr[param1] = param2;
      }
      
      public function setFwq(param1:Number) : void
      {
         this.fwqTime.setValue(param1);
      }
      
      public function getFwqTime() : Number
      {
         return this.fwqTime.getValue() / GS.a1000;
      }
   }
}

