package hotpointgame.views.everyDayPanel
{
   import hotpointgame.common.*;
   import hotpointgame.models.everyDay.*;
   import hotpointgame.repository.everyDay.*;
   
   public class EveryDayData
   {
      
      public var dataArr:Array = [];
      
      public var allFs:VT = VT.createVT(GS.a0);
      
      public var currList:Array = [];
      
      public var lqList:Array = [];
      
      public var lqBsList:Array = [];
      
      public function EveryDayData()
      {
         super();
      }
      
      public static function read(param1:Object = null) : EveryDayData
      {
         var _loc3_:Array = null;
         var _loc4_:uint = 0;
         var _loc5_:Array = null;
         var _loc2_:EveryDayData = new EveryDayData();
         _loc2_.lqBsList = [VT.createVT(GS.a10),VT.createVT(GS.a30),VT.createVT(GS.a50),VT.createVT(GS.a80),VT.createVT(GS.a105)];
         _loc2_.allFs = VT.createVT(GS.a0);
         _loc2_.currList.length = 0;
         if(param1 == null)
         {
            _loc2_.dataArr = EveryDayFactory.everyData;
            _loc2_.initLq();
         }
         else
         {
            _loc3_ = param1["ev"];
            _loc4_ = 0;
            while(_loc4_ < _loc3_.length)
            {
               _loc2_.dataArr[_loc4_] = EveryDay.read(_loc3_[_loc4_]);
               _loc4_++;
            }
            _loc5_ = param1["lq"];
            _loc4_ = 0;
            while(_loc4_ < _loc5_.length)
            {
               _loc2_.lqList[_loc4_] = VT.createVT(_loc5_[_loc4_]);
               _loc4_++;
            }
         }
         return _loc2_;
      }
      
      public function save() : Object
      {
         var _loc5_:EveryDay = null;
         var _loc1_:Object = new Object();
         var _loc2_:Array = [];
         var _loc3_:uint = 0;
         while(_loc3_ < this.dataArr.length)
         {
            _loc5_ = this.dataArr[_loc3_] as EveryDay;
            _loc2_.push(_loc5_.save());
            _loc3_++;
         }
         var _loc4_:Array = [];
         _loc3_ = 0;
         while(_loc3_ < this.lqList.length)
         {
            _loc4_[_loc3_] = this.lqList[_loc3_].getValue();
            _loc3_++;
         }
         _loc1_["ev"] = _loc2_;
         _loc1_["lq"] = _loc4_;
         return _loc1_;
      }
      
      public function initLq() : void
      {
         var _loc1_:uint = 0;
         while(_loc1_ < this.lqBsList.length)
         {
            this.lqList[_loc1_] = VT.createVT(GS.a0);
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < this.dataArr.length)
         {
            (this.dataArr[_loc1_] as EveryDay).createJd();
            _loc1_++;
         }
      }
      
      public function getBtnFs(param1:Number) : Number
      {
         return this.lqBsList[param1].getValue();
      }
      
      public function getLq(param1:Number) : Number
      {
         return this.lqList[param1].getValue();
      }
      
      public function setLq(param1:Number) : void
      {
         this.lqList[param1] = VT.createVT(GS.a1);
      }
      
      public function getCurrEvList(param1:Number, param2:Number = 8) : Array
      {
         this.currList.length = GS.a0;
         var _loc3_:uint = 0;
         while(_loc3_ < param2)
         {
            this.currList.push(this.dataArr[(param1 - 1) * param2 + _loc3_]);
            _loc3_++;
         }
         return this.currList;
      }
      
      public function getAllYe() : Number
      {
         var _loc1_:Number = this.dataArr.length;
         var _loc2_:Number = int(_loc1_ / 8);
         if(_loc1_ % 8 > 0)
         {
            _loc2_ += 1;
         }
         return _loc2_;
      }
      
      public function getDataByKey(param1:Number) : EveryDay
      {
         return this.currList[param1];
      }
      
      public function getCurrList() : Array
      {
         return this.currList;
      }
      
      public function setJd(param1:Number) : void
      {
         var _loc3_:EveryDay = null;
         var _loc2_:uint = 0;
         while(_loc2_ < this.dataArr.length)
         {
            _loc3_ = this.dataArr[_loc2_] as EveryDay;
            if(_loc3_.getType() == param1)
            {
               _loc3_.setJd(param1,GS.a1);
            }
            _loc2_++;
         }
         this.getAllFs();
      }
      
      public function getAllFs() : void
      {
         var _loc2_:EveryDay = null;
         this.allFs.setValue(GS.a0);
         var _loc1_:uint = 0;
         while(_loc1_ < this.dataArr.length)
         {
            _loc2_ = this.dataArr[_loc1_] as EveryDay;
            if(_loc2_.isOk())
            {
               this.allFs.setValue(this.allFs.getValue() + _loc2_.getCurrFs());
            }
            _loc1_++;
         }
      }
      
      public function getFs() : Number
      {
         return this.allFs.getValue();
      }
   }
}

