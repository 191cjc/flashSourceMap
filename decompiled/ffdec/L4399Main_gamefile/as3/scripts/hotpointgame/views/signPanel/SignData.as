package hotpointgame.views.signPanel
{
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   import hotpointgame.common.basicBtn.*;
   import hotpointgame.common.event.*;
   import hotpointgame.common.newBasicBtn.*;
   import hotpointgame.repository.petGj.*;
   
   public class SignData
   {
      
      private var dateArr:Array = [];
      
      private var stateArr:Array = [];
      
      private var reawdStateArr:Array = [];
      
      public var qdGoodsId:VT;
      
      private var currentDayId:VT = VT.createVT(GS.a0);
      
      private var xxobj:VT = VT.createVT(GS.a0);
      
      public function SignData()
      {
         super();
      }
      
      public static function read(param1:Object = null) : SignData
      {
         var _loc3_:Array = null;
         var _loc4_:uint = 0;
         var _loc5_:Array = null;
         var _loc2_:SignData = new SignData();
         _loc2_.qdGoodsId = VT.createVT(GS.a331358 + GS.a8);
         if(param1 != null)
         {
            _loc3_ = param1["st"];
            _loc4_ = 0;
            while(_loc4_ < _loc3_.length)
            {
               _loc2_.stateArr[_loc4_] = VT.createVT(_loc3_[_loc4_]);
               _loc4_++;
            }
            _loc5_ = param1["rs"];
            _loc4_ = 0;
            while(_loc4_ < 3)
            {
               _loc2_.reawdStateArr[_loc4_] = VT.createVT(_loc5_[_loc4_]);
               _loc4_++;
            }
            _loc2_.xxobj = VT.createVT(param1["cz"]);
         }
         else
         {
            _loc2_.initData();
         }
         return _loc2_;
      }
      
      public function save() : Object
      {
         var _loc1_:Object = new Object();
         var _loc2_:Array = [];
         var _loc3_:uint = 0;
         while(_loc3_ < this.stateArr.length)
         {
            _loc2_.push(this.stateArr[_loc3_].getValue());
            _loc3_++;
         }
         _loc1_["st"] = _loc2_;
         var _loc4_:Array = [];
         _loc3_ = 0;
         while(_loc3_ < this.reawdStateArr.length)
         {
            _loc4_.push(this.reawdStateArr[_loc3_].getValue());
            _loc3_++;
         }
         _loc1_["rs"] = _loc4_;
         _loc1_["cz"] = this.xxobj.getValue();
         return _loc1_;
      }
      
      public function initDisplay() : void
      {
         var _loc1_:VT = VT.createVT(GM.serverDateC.sYear);
         var _loc2_:VT = VT.createVT(GM.serverDateC.sMonth);
         var _loc3_:Array = [31,28,31,30,31,30,31,31,30,31,30,31];
         var _loc4_:VT = VT.createVT(_loc3_[_loc2_.getValue()]);
         if(Number(_loc1_.getValue().toString().substr(2,3)) % 4 == 0)
         {
            if(_loc2_.getValue() == GS.a1)
            {
               _loc4_.setValue(GS.a29);
            }
         }
         var _loc5_:Date = new Date(_loc1_.getValue(),_loc2_.getValue(),GS.a1);
         var _loc6_:VT = VT.createVT(_loc5_.day);
         var _loc7_:VT = VT.createVT(_loc4_.getValue() + _loc6_.getValue());
         var _loc8_:VT = VT.createVT(GM.serverDateC.sDate);
         var _loc9_:VT = VT.createVT(GS.a0);
         var _loc10_:uint = 0;
         while(_loc10_ < GS.a42)
         {
            if(_loc10_ >= _loc6_.getValue() && _loc10_ < _loc7_.getValue())
            {
               _loc9_.setValue(_loc9_.getValue() + GS.a1);
               this.dateArr[_loc10_] = VT.createVT(_loc9_.getValue() + GS.a1);
               if(_loc9_.getValue() == _loc8_.getValue())
               {
                  this.currentDayId.setValue(_loc10_);
               }
            }
            else
            {
               this.dateArr[_loc10_] = VT.createVT(-1);
            }
            _loc10_++;
         }
      }
      
      public function initData() : void
      {
         var _loc1_:uint = 0;
         while(_loc1_ < GS.a42)
         {
            this.stateArr[_loc1_] = VT.createVT(GS.a0);
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < GS.a3)
         {
            this.reawdStateArr[_loc1_] = VT.createVT(-1);
            _loc1_++;
         }
      }
      
      public function getrewdState() : Array
      {
         return this.reawdStateArr;
      }
      
      public function getReadGoods(param1:Number) : Number
      {
         return PetGjFactory.getJlByMonth(GM.serverDateC.sMonth + GS.a1,param1);
      }
      
      public function setRewdState(param1:Number) : void
      {
         this.reawdStateArr[param1] = VT.createVT(GS.a0);
      }
      
      public function getDateArr() : Array
      {
         return this.dateArr;
      }
      
      public function getStateArr() : Array
      {
         return this.stateArr;
      }
      
      public function getDateById(param1:Number) : Number
      {
         return this.dateArr[param1];
      }
      
      public function getbqNum() : Number
      {
         var _loc1_:VT = VT.createVT(0);
         var _loc2_:uint = 0;
         while(_loc2_ < this.stateArr.length)
         {
            if(_loc2_ < this.getQdId())
            {
               if(this.stateArr[_loc2_].getValue() == GS.a0 && this.dateArr[_loc2_].getValue() != -1)
               {
                  _loc1_.setValue(_loc1_.getValue() + GS.a1);
               }
            }
            _loc2_++;
         }
         return _loc1_.getValue();
      }
      
      public function getQdId() : Number
      {
         return this.currentDayId.getValue();
      }
      
      public function qdFun(param1:Number) : void
      {
         this.stateArr[param1] = VT.createVT(GS.a1);
      }
      
      public function bqFun(param1:Number) : void
      {
         var _loc2_:uint = 0;
         while(_loc2_ < this.stateArr.length)
         {
            if(param1 > 0)
            {
               if(_loc2_ < this.getQdId())
               {
                  if(this.stateArr[_loc2_].getValue() == GS.a0 && this.dateArr[_loc2_].getValue() != -1)
                  {
                     this.stateArr[_loc2_].setValue(GS.a1);
                     param1--;
                  }
               }
            }
            _loc2_++;
         }
      }
      
      public function getQdNum() : Number
      {
         var _loc1_:VT = VT.createVT(GS.a0);
         var _loc2_:uint = 0;
         while(_loc2_ < GS.a42)
         {
            if(this.stateArr[_loc2_].getValue() == GS.a1)
            {
               _loc1_.setValue(_loc1_.getValue() + GS.a1);
            }
            _loc2_++;
         }
         return _loc1_.getValue();
      }
   }
}

