package hotpointgame.views.giftPanel
{
   import hotpointgame.common.*;
   import hotpointgame.models.gift.*;
   import hotpointgame.repository.gift.*;
   import hotpointgame.utils.*;
   
   public class GiftData
   {
      
      private static var jfArr:Array = [];
      
      public static var jfLength:VT = VT.createVT(GS.a0);
      
      public static var ptArr:Array = [];
      
      public static var ptLength:VT = VT.createVT(GS.a0);
      
      private static var saveArr:Array = [];
      
      public static var CzBo:Boolean = false;
      
      public function GiftData()
      {
         super();
      }
      
      public static function initData() : void
      {
         jfArr = getArr(GiftFactory.getJfArr(GS.a0),GS.a6);
         jfLength = VT.createVT(jfArr.length);
         ptArr = getArr(GiftFactory.getJfArr(GS.a1),GS.a3);
         ptLength = VT.createVT(ptArr.length);
         readFun();
      }
      
      public static function readFun() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         if(saveArr.length != GS.a0)
         {
            _loc1_ = 0;
            while(_loc1_ < jfArr.length)
            {
               _loc2_ = 0;
               while(_loc2_ < jfArr[_loc1_].length)
               {
                  _loc3_ = 0;
                  while(_loc3_ < saveArr.length)
                  {
                     if((jfArr[_loc1_][_loc2_] as Gift).getId() == (saveArr[_loc3_] as Gift).getId())
                     {
                        jfArr[_loc1_][_loc2_] = saveArr[_loc3_];
                     }
                     _loc3_++;
                  }
                  _loc2_++;
               }
               _loc1_++;
            }
            _loc1_ = 0;
            while(_loc1_ < ptArr.length)
            {
               _loc2_ = 0;
               while(_loc2_ < ptArr[_loc1_].length)
               {
                  _loc3_ = 0;
                  while(_loc3_ < saveArr.length)
                  {
                     if((ptArr[_loc1_][_loc2_] as Gift).getId() == (saveArr[_loc3_] as Gift).getId())
                     {
                        ptArr[_loc1_][_loc2_] = saveArr[_loc3_];
                     }
                     _loc3_++;
                  }
                  _loc2_++;
               }
               _loc1_++;
            }
            saveArr.length = GS.a0;
         }
      }
      
      public static function save() : Object
      {
         var _loc4_:uint = 0;
         var _loc5_:Gift = null;
         var _loc1_:Object = new Object();
         var _loc2_:Array = [];
         var _loc3_:uint = 0;
         while(_loc3_ < jfArr.length)
         {
            _loc4_ = 0;
            while(_loc4_ < jfArr[_loc3_].length)
            {
               _loc5_ = jfArr[_loc3_][_loc4_] as Gift;
               if(_loc5_.getState() != GS.a0)
               {
                  _loc2_.push(_loc5_.save());
               }
               _loc4_++;
            }
            _loc3_++;
         }
         _loc3_ = 0;
         while(_loc3_ < ptArr.length)
         {
            _loc4_ = 0;
            while(_loc4_ < ptArr[_loc3_].length)
            {
               _loc5_ = ptArr[_loc3_][_loc4_] as Gift;
               if(_loc5_.getState() != GS.a0)
               {
                  _loc2_.push(_loc5_.save());
               }
               _loc4_++;
            }
            _loc3_++;
         }
         _loc1_["sav"] = _loc2_;
         return _loc1_;
      }
      
      public static function read(param1:Object) : void
      {
         saveArr.length = GS.a0;
         var _loc2_:Array = param1["sav"];
         var _loc3_:uint = 0;
         while(_loc3_ < _loc2_.length)
         {
            saveArr.push(Gift.read(_loc2_[_loc3_]));
            _loc3_++;
         }
      }
      
      public static function closeData() : void
      {
         saveArr.length = GS.a0;
         CzBo = false;
      }
      
      private static function getArr(param1:Array, param2:Number) : Array
      {
         var _loc3_:Array = DeepCopyUtil.clone(param1);
         var _loc4_:Array = [];
         var _loc5_:uint = 0;
         while(_loc5_ < _loc3_.length)
         {
            if(_loc3_.length >= param2)
            {
               _loc4_.push(_loc3_.splice(0,param2));
            }
            else if(_loc3_.length > 0)
            {
               _loc4_.push(_loc3_.splice(0));
               break;
            }
            _loc5_ = --_loc5_ + 1;
         }
         return _loc4_;
      }
      
      public static function getJfByCuYe(param1:Number, param2:Number) : Gift
      {
         if(jfArr.length > GS.a0)
         {
            if(jfArr[param1][param2] != null)
            {
               return jfArr[param1][param2];
            }
         }
         return null;
      }
      
      public static function getPtByCuYe(param1:Number, param2:Number) : Gift
      {
         if(ptArr.length > GS.a0)
         {
            if(ptArr[param1][param2] != null)
            {
               return ptArr[param1][param2];
            }
         }
         return null;
      }
      
      public static function getJfLength() : Number
      {
         return jfLength.getValue();
      }
      
      public static function getGiftByReslutId(param1:Number) : Gift
      {
         var _loc3_:uint = 0;
         var _loc2_:uint = 0;
         while(_loc2_ < jfArr.length)
         {
            _loc3_ = 0;
            while(_loc3_ < jfArr[_loc2_].length)
            {
               if((jfArr[_loc2_][_loc3_] as Gift).getResultId() == param1)
               {
                  return jfArr[_loc2_][_loc3_];
               }
               _loc3_++;
            }
            _loc2_++;
         }
         return null;
      }
      
      public static function getGiftById(param1:Number) : Gift
      {
         var _loc3_:uint = 0;
         var _loc2_:uint = 0;
         while(_loc2_ < jfArr.length)
         {
            _loc3_ = 0;
            while(_loc3_ < jfArr[_loc2_].length)
            {
               if((jfArr[_loc2_][_loc3_] as Gift).getId() == param1)
               {
                  return jfArr[_loc2_][_loc3_];
               }
               _loc3_++;
            }
            _loc2_++;
         }
         return null;
      }
   }
}

