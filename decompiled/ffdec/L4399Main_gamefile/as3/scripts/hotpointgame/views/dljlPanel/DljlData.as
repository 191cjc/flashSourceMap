package hotpointgame.views.dljlPanel
{
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   
   public class DljlData
   {
      
      private static var sTime:Array = [VT.createVT(GS.a2013 + GS.a1),VT.createVT(GS.a7),VT.createVT(GS.a26)];
      
      private static var oTime:Array = [VT.createVT(GS.a2013 + GS.a1),VT.createVT(GS.a8),VT.createVT(GS.a9)];
      
      private var cs:VT = VT.createVT(GS.a1);
      
      private var csArr:Array = [];
      
      private var saveArr:Array = [];
      
      private var saveTime:VT = VT.createVT(GS.a0);
      
      public function DljlData()
      {
         super();
      }
      
      public static function read(param1:Object = null) : DljlData
      {
         var _loc4_:Array = null;
         var _loc2_:DljlData = new DljlData();
         _loc2_.csArr = [VT.createVT(GS.a1),VT.createVT(GS.a2),VT.createVT(GS.a3),VT.createVT(GS.a5),VT.createVT(GS.a8),VT.createVT(GS.a11),VT.createVT(GS.a14)];
         _loc2_.cs = VT.createVT(GS.a0);
         var _loc3_:uint = 0;
         while(_loc3_ < 7)
         {
            _loc2_.saveArr[_loc3_] = VT.createVT(GS.a0);
            _loc3_++;
         }
         if(param1 == null)
         {
            if(isOk())
            {
               _loc2_.saveTime = VT.createVT(FlowInterface.getCurrTimer() + GS.a8 * GS.a60 * GS.a60 * GS.a1000);
               _loc2_.cs = VT.createVT(GS.a1);
            }
         }
         else if(isOk())
         {
            _loc2_.cs = VT.createVT(param1["cs"]);
            _loc4_ = param1["sv"];
            _loc3_ = 0;
            while(_loc3_ < 7)
            {
               _loc2_.saveArr[_loc3_] = VT.createVT(_loc4_[_loc3_]);
               _loc3_++;
            }
            _loc2_.saveTime = VT.createVT(param1["st"]);
            if(_loc2_.getCs() == 0)
            {
               _loc2_.cs = VT.createVT(GS.a1);
            }
            else if(_loc2_.isNewDate())
            {
               _loc2_.addCs();
            }
         }
         return _loc2_;
      }
      
      public static function isOk() : Boolean
      {
         var _loc1_:VT = VT.createVT(GM.serverDateC.sYear);
         var _loc2_:VT = VT.createVT(GM.serverDateC.sMonth + GS.a1);
         var _loc3_:VT = VT.createVT(GM.serverDateC.sDate);
         if(stOk(_loc1_.getValue(),_loc2_.getValue(),_loc3_.getValue()) && otOk(_loc1_.getValue(),_loc2_.getValue(),_loc3_.getValue()))
         {
            return true;
         }
         return false;
      }
      
      public static function stOk(param1:Number, param2:Number, param3:Number) : Boolean
      {
         if(param1 > sTime[GS.a0].getValue())
         {
            return true;
         }
         if(param1 == sTime[GS.a0].getValue())
         {
            if(param2 > sTime[GS.a1].getValue())
            {
               return true;
            }
            if(param2 == sTime[GS.a1].getValue())
            {
               if(param3 >= sTime[GS.a2].getValue())
               {
                  return true;
               }
            }
         }
         return false;
      }
      
      public static function otOk(param1:Number, param2:Number, param3:Number) : Boolean
      {
         if(param1 < oTime[GS.a0].getValue())
         {
            return true;
         }
         if(param1 == oTime[GS.a0].getValue())
         {
            if(param2 < oTime[GS.a1].getValue())
            {
               return true;
            }
            if(param2 == oTime[GS.a1].getValue())
            {
               if(param3 <= oTime[GS.a2].getValue())
               {
                  return true;
               }
            }
         }
         return false;
      }
      
      public function save() : Object
      {
         var _loc1_:Object = new Object();
         _loc1_["cs"] = this.cs.getValue();
         var _loc2_:Array = [];
         var _loc3_:uint = 0;
         while(_loc3_ < 7)
         {
            _loc2_[_loc3_] = this.saveArr[_loc3_].getValue();
            _loc3_++;
         }
         _loc1_["sv"] = _loc2_;
         _loc1_["st"] = this.saveTime.getValue();
         return _loc1_;
      }
      
      public function isNewDate() : Boolean
      {
         var _loc1_:Date = new Date(this.saveTime.getValue());
         var _loc2_:Number = _loc1_.fullYearUTC;
         var _loc3_:Number = _loc1_.monthUTC;
         var _loc4_:Number = _loc1_.dateUTC;
         var _loc5_:Date = new Date(FlowInterface.getCurrTimer() + GS.a8 * GS.a60 * GS.a60 * GS.a1000);
         var _loc6_:Number = _loc5_.fullYearUTC;
         var _loc7_:Number = _loc5_.monthUTC;
         var _loc8_:Number = _loc5_.dateUTC;
         if(_loc6_ > _loc2_ || _loc7_ > _loc3_ || _loc8_ > _loc4_)
         {
            this.saveTime.setValue(_loc5_.getTime());
            return true;
         }
         return false;
      }
      
      public function addCs() : void
      {
         if(isOk())
         {
            this.cs.setValue(this.cs.getValue() + GS.a1);
         }
      }
      
      public function getCs() : Number
      {
         return this.cs.getValue();
      }
      
      public function getBtnCs(param1:Number) : Number
      {
         return this.csArr[param1].getValue();
      }
      
      public function isLq(param1:Number) : Boolean
      {
         if(this.saveArr[param1].getValue() == GS.a1)
         {
            return true;
         }
         return false;
      }
      
      public function setLq(param1:Number) : void
      {
         this.saveArr[param1] = VT.createVT(GS.a1);
      }
   }
}

