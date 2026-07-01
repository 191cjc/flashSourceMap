package hotpointgame.repository.jjia
{
   import hotpointgame.common.*;
   import hotpointgame.models.goods.Goods;
   
   public class JjiaFactory
   {
      
      public static var lvList:Array = [];
      
      public static var qhList:Array = [];
      
      public static var jhList:Array = [];
      
      public function JjiaFactory()
      {
         super();
      }
      
      public static function creatJiJiaLv(param1:XML) : *
      {
         var _loc2_:XML = null;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:String = null;
         var _loc7_:Number = NaN;
         var _loc8_:String = null;
         for each(_loc2_ in param1.等级属性)
         {
            _loc3_ = Number(_loc2_.id);
            _loc4_ = Number(_loc2_.物品ID);
            _loc5_ = Number(_loc2_.等级);
            _loc6_ = String(_loc2_.职业一);
            _loc7_ = Number(_loc2_.需求经验);
            _loc8_ = String(_loc2_.技能帧数);
            lvList.push(JjiaLvBasiData.createJjiaLvBasiData(_loc3_,_loc4_,_loc5_,_loc6_,_loc7_,_loc8_));
         }
      }
      
      public static function getDataByGoodsId(param1:Number) : Array
      {
         var _loc3_:JjiaLvBasiData = null;
         var _loc2_:Array = [];
         for each(_loc3_ in lvList)
         {
            if(_loc3_.getGoodsId() == param1)
            {
               _loc2_.push(_loc3_);
            }
         }
         if(_loc2_.length == 0)
         {
            throw new Error("没有此机甲ID数据" + param1);
         }
         return _loc2_;
      }
      
      public static function getJjLv(param1:Number, param2:Number) : Number
      {
         var _loc4_:JjiaLvBasiData = null;
         var _loc3_:Array = getDataByGoodsId(param1);
         for each(_loc4_ in _loc3_)
         {
            if(param2 < _loc4_.getNeedExp())
            {
               return _loc4_.getLv() - GS.a1;
            }
         }
         return GS.a100;
      }
      
      public static function getDataByIdAndLv(param1:Number, param2:Number) : JjiaLvBasiData
      {
         var _loc4_:JjiaLvBasiData = null;
         var _loc3_:* = getDataByGoodsId(param1);
         for each(_loc4_ in _loc3_)
         {
            if(_loc4_.getLv() == param2)
            {
               return _loc4_;
            }
         }
         return null;
      }
      
      public static function getjjlvSxValue(param1:Number, param2:Goods) : Number
      {
         var _loc3_:Number = getJjLv(param2.getId(),param2.getJexp());
         var _loc4_:JjiaLvBasiData = getDataByIdAndLv(param2.getId(),_loc3_);
         if(_loc4_ != null)
         {
            if(param1 == 1)
            {
               return _loc4_.getHp();
            }
            if(param1 == 12)
            {
               return _loc4_.getHd();
            }
            if(param1 == 3)
            {
               return _loc4_.getAtt();
            }
            if(param1 == 4)
            {
               return _loc4_.getFy();
            }
            if(param1 == 5)
            {
               return _loc4_.getBj() / GS.a10000;
            }
         }
         return 0;
      }
      
      public static function creatJiJiaQh(param1:XML) : *
      {
         var _loc2_:XML = null;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:String = null;
         var _loc7_:Number = NaN;
         for each(_loc2_ in param1.强化属性)
         {
            _loc3_ = Number(_loc2_.id);
            _loc4_ = Number(_loc2_.物品ID);
            _loc5_ = Number(_loc2_.等级);
            _loc6_ = String(_loc2_.职业一);
            _loc7_ = Number(_loc2_.需求数量);
            qhList.push(JjiaqhBasicData.createJjiaLvBasiData(_loc3_,_loc5_,_loc4_,_loc6_,_loc7_));
         }
      }
      
      public static function getQhDataByIdAndLv(param1:Number, param2:Number) : JjiaqhBasicData
      {
         var _loc4_:JjiaqhBasicData = null;
         var _loc3_:Array = [];
         for each(_loc4_ in qhList)
         {
            if(_loc4_.getGoodsId() == param1)
            {
               _loc3_.push(_loc4_);
            }
         }
         if(_loc3_.length < 0)
         {
            throw new Error("机甲强化数据没有" + param1);
         }
         for each(_loc4_ in _loc3_)
         {
            if(_loc4_.getLv() == param2)
            {
               return _loc4_;
            }
         }
         return null;
      }
      
      public static function getQhSxValue(param1:Number, param2:Number, param3:Number) : Number
      {
         var _loc4_:JjiaqhBasicData = getQhDataByIdAndLv(param3,param2);
         if(_loc4_ != null)
         {
            if(param1 == 1)
            {
               return _loc4_.getHp();
            }
            if(param1 == 12)
            {
               return _loc4_.getHd();
            }
            if(param1 == 3)
            {
               return _loc4_.getAtt();
            }
            if(param1 == 4)
            {
               return _loc4_.getFy();
            }
            if(param1 == 5)
            {
               return _loc4_.getBj() / GS.a10000;
            }
         }
         return 0;
      }
      
      public static function creatJiJiaJh(param1:XML) : void
      {
         var _loc2_:XML = null;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         for each(_loc2_ in param1.进化)
         {
            _loc3_ = Number(_loc2_.id);
            _loc4_ = Number(_loc2_.等级);
            _loc5_ = Number(_loc2_.需求经验);
            jhList.push(JjiaJhBasicData.createJjiaJhBasicData(_loc3_,_loc4_,_loc5_));
         }
      }
      
      public static function getJhDataByLv(param1:Number) : JjiaJhBasicData
      {
         var _loc2_:JjiaJhBasicData = null;
         for each(_loc2_ in jhList)
         {
            if(_loc2_.getLv() == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
   }
}

