package hotpointgame.views.fbPanel
{
   import hotpointgame.common.*;
   import hotpointgame.models.fb.*;
   import hotpointgame.repository.chHao.*;
   import hotpointgame.repository.fb.*;
   import hotpointgame.utils.*;
   
   public class FbData
   {
      
      private static var fbList:Array = [];
      
      public static var chLevel:VT = VT.createVT(GS.a1);
      
      public static var saveArr:Array = [];
      
      public static var lqArrSave:Array = [];
      
      public static var lqSave:Array = [];
      
      public function FbData()
      {
         super();
      }
      
      public static function initData() : void
      {
         fbList = DeepCopyUtil.clone(FbFactory.fbList);
         initLq();
         readFun();
      }
      
      public static function initLq() : void
      {
         var _loc1_:uint = 0;
         while(_loc1_ < ChHaoFactory.chHaoList.length)
         {
            lqArrSave[_loc1_] = VT.createVT(GS.a0);
            _loc1_++;
         }
      }
      
      public static function closeData() : void
      {
         saveArr.length = GS.a0;
         chLevel.setValue(GS.a1);
      }
      
      public static function readFun() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         if(saveArr.length != GS.a0)
         {
            _loc1_ = 0;
            while(_loc1_ < fbList.length)
            {
               _loc2_ = 0;
               while(_loc2_ < saveArr.length)
               {
                  if((fbList[_loc1_] as Fb).getId() == (saveArr[_loc2_] as Fb).getId())
                  {
                     fbList[_loc1_] = saveArr[_loc2_];
                  }
                  _loc2_++;
               }
               _loc1_++;
            }
            saveArr.length = GS.a0;
         }
         if(lqSave.length != GS.a0)
         {
            _loc1_ = 0;
            while(_loc1_ < lqArrSave.length)
            {
               _loc2_ = 0;
               while(_loc2_ < lqSave.length)
               {
                  lqArrSave[_loc1_] = lqSave[_loc2_];
                  _loc2_++;
               }
               _loc1_++;
            }
            lqSave.length = GS.a0;
         }
      }
      
      public static function addChLevel() : void
      {
         if(chLevel.getValue() < ChHaoFactory.chHaoList.length)
         {
            chLevel.setValue(chLevel.getValue() + GS.a1);
         }
      }
      
      public static function getLq(param1:Number) : Number
      {
         return lqArrSave[param1].getValue();
      }
      
      public static function setLq(param1:Number) : void
      {
         lqArrSave[param1] = VT.createVT(GS.a1);
      }
      
      public static function save() : Object
      {
         var _loc3_:Fb = null;
         var _loc4_:Array = null;
         var _loc5_:uint = 0;
         var _loc1_:Object = new Object();
         _loc1_["ch"] = chLevel.getValue();
         var _loc2_:Array = [];
         for each(_loc3_ in fbList)
         {
            if(_loc3_.getState() != GS.a0 || _loc3_.getFinishNum() > GS.a0)
            {
               _loc2_.push(_loc3_.save());
            }
         }
         _loc1_["fb"] = _loc2_;
         _loc4_ = [];
         _loc5_ = 0;
         while(_loc5_ < lqArrSave.length)
         {
            _loc4_[_loc5_] = lqArrSave[_loc5_].getValue();
            _loc5_++;
         }
         _loc1_["lq"] = _loc4_;
         return _loc1_;
      }
      
      public static function read(param1:Object) : void
      {
         saveArr.length = GS.a0;
         lqSave.length = GS.a0;
         chLevel.setValue(param1["ch"]);
         var _loc2_:Array = param1["lq"];
         var _loc3_:uint = 0;
         while(_loc3_ < _loc2_.length)
         {
            lqSave[_loc3_] = VT.createVT(_loc2_[_loc3_]);
            _loc3_++;
         }
         var _loc4_:Array = param1["fb"];
         _loc3_ = 0;
         while(_loc3_ < _loc4_.length)
         {
            saveArr.push(Fb.read(_loc4_[_loc3_]));
            _loc3_++;
         }
      }
      
      public static function clearEd() : void
      {
         var _loc2_:Fb = null;
         var _loc1_:uint = 0;
         while(_loc1_ < saveArr.length)
         {
            _loc2_ = saveArr[_loc1_] as Fb;
            if(_loc2_.getState() == GS.a1)
            {
               _loc2_.setState(GS.a0);
            }
            _loc1_++;
         }
      }
      
      public static function addFbTimes(param1:Number) : void
      {
         var _loc2_:Fb = null;
         for each(_loc2_ in fbList)
         {
            if(param1 == _loc2_.getFbId())
            {
               _loc2_.addFinishNum();
               _loc2_.setState(GS.a1);
               return;
            }
         }
      }
      
      public static function isAgin(param1:Number) : Boolean
      {
         var _loc2_:Fb = null;
         for each(_loc2_ in fbList)
         {
            if(_loc2_.getFbId() == param1)
            {
               if(_loc2_.getState() == GS.a0)
               {
                  return true;
               }
            }
         }
         return false;
      }
      
      public static function getFbById(param1:Number) : Array
      {
         var _loc3_:Fb = null;
         var _loc2_:Array = [];
         for each(_loc3_ in fbList)
         {
            if(_loc3_.getType() == param1)
            {
               _loc2_.push(_loc3_);
            }
         }
         return _loc2_;
      }
      
      public static function isKey(param1:Number) : Boolean
      {
         var _loc2_:Fb = null;
         for each(_loc2_ in fbList)
         {
            if(_loc2_.getId() == param1)
            {
               if(_loc2_.getFinishNum() > GS.a0)
               {
                  return true;
               }
            }
         }
         return false;
      }
      
      public static function getFinishTimeById(param1:Number) : Number
      {
         var _loc2_:Fb = null;
         for each(_loc2_ in fbList)
         {
            if(_loc2_.getId() == param1)
            {
               return _loc2_.getFinishNum();
            }
         }
         return GS.a0;
      }
   }
}

