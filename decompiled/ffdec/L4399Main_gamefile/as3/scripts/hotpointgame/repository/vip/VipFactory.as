package hotpointgame.repository.vip
{
   import hotpointgame.common.*;
   
   public class VipFactory
   {
      
      private static var vipList:Array = [];
      
      public function VipFactory()
      {
         super();
      }
      
      public static function createVipFactory(param1:XML) : void
      {
         var _loc2_:XML = null;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc16_:Number = NaN;
         var _loc17_:Number = NaN;
         var _loc18_:VipBasicData = null;
         for each(_loc2_ in param1.vip)
         {
            _loc3_ = Number(_loc2_.id);
            _loc4_ = Number(_loc2_.充值);
            _loc5_ = String(_loc2_.奖励id);
            _loc6_ = String(_loc2_.奖励数量);
            _loc7_ = Number(_loc2_.HP);
            _loc8_ = Number(_loc2_.能量);
            _loc9_ = Number(_loc2_.攻击);
            _loc10_ = Number(_loc2_.防御);
            _loc11_ = Number(_loc2_.暴击);
            _loc12_ = Number(_loc2_.金);
            _loc13_ = Number(_loc2_.木);
            _loc14_ = Number(_loc2_.水);
            _loc15_ = Number(_loc2_.火);
            _loc16_ = Number(_loc2_.土);
            _loc17_ = Number(_loc2_.混沌);
            _loc18_ = VipBasicData.createVipData(_loc3_,_loc4_,_loc5_,_loc6_,_loc7_,_loc8_,_loc9_,_loc10_,_loc11_,_loc12_,_loc13_,_loc14_,_loc15_,_loc16_,_loc17_);
            vipList.unshift(_loc18_);
         }
      }
      
      public static function getDataByCz(param1:Number) : Number
      {
         var _loc2_:uint = 0;
         while(_loc2_ < vipList.length)
         {
            if(param1 >= (vipList[_loc2_] as VipBasicData).getNeedXz())
            {
               return (vipList[_loc2_] as VipBasicData).getId();
            }
            _loc2_++;
         }
         return -1;
      }
      
      public static function getVipById(param1:Number) : VipBasicData
      {
         var _loc2_:VipBasicData = null;
         for each(_loc2_ in vipList)
         {
            if(_loc2_.getId() == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public static function getNl(param1:Number) : Number
      {
         var _loc2_:VT = VT.createVT(GS.a0);
         if(getVipById(param1) != null)
         {
            _loc2_.setValue(getVipById(param1).getNl());
         }
         return _loc2_.getValue();
      }
      
      public static function getHp(param1:Number) : Number
      {
         var _loc2_:VT = VT.createVT(GS.a0);
         if(getVipById(param1) != null)
         {
            _loc2_.setValue(getVipById(param1).getHp());
         }
         return _loc2_.getValue();
      }
      
      public static function getAtt(param1:Number) : Number
      {
         var _loc2_:VT = VT.createVT(GS.a0);
         if(getVipById(param1) != null)
         {
            _loc2_.setValue(getVipById(param1).getAtt());
         }
         return _loc2_.getValue();
      }
      
      public static function getFy(param1:Number) : Number
      {
         var _loc2_:VT = VT.createVT(GS.a0);
         if(getVipById(param1) != null)
         {
            _loc2_.setValue(getVipById(param1).getFy());
         }
         return _loc2_.getValue();
      }
      
      public static function getBj(param1:Number) : Number
      {
         var _loc2_:VT = VT.createVT(GS.a0);
         if(getVipById(param1) != null)
         {
            _loc2_.setValue(getVipById(param1).getBj());
         }
         return _loc2_.getValue();
      }
      
      public static function getJin(param1:Number) : Number
      {
         var _loc2_:VT = VT.createVT(GS.a0);
         if(getVipById(param1) != null)
         {
            _loc2_.setValue(getVipById(param1).getJin());
         }
         return _loc2_.getValue();
      }
      
      public static function getMu(param1:Number) : Number
      {
         var _loc2_:VT = VT.createVT(GS.a0);
         if(getVipById(param1) != null)
         {
            _loc2_.setValue(getVipById(param1).getMu());
         }
         return _loc2_.getValue();
      }
      
      public static function getShui(param1:Number) : Number
      {
         var _loc2_:VT = VT.createVT(GS.a0);
         if(getVipById(param1) != null)
         {
            _loc2_.setValue(getVipById(param1).getShui());
         }
         return _loc2_.getValue();
      }
      
      public static function getHuo(param1:Number) : Number
      {
         var _loc2_:VT = VT.createVT(GS.a0);
         if(getVipById(param1) != null)
         {
            _loc2_.setValue(getVipById(param1).getHuo());
         }
         return _loc2_.getValue();
      }
      
      public static function getTu(param1:Number) : Number
      {
         var _loc2_:VT = VT.createVT(GS.a0);
         if(getVipById(param1) != null)
         {
            _loc2_.setValue(getVipById(param1).getTu());
         }
         return _loc2_.getValue();
      }
      
      public static function getHd(param1:Number) : Number
      {
         var _loc2_:VT = VT.createVT(GS.a0);
         if(getVipById(param1) != null)
         {
            _loc2_.setValue(getVipById(param1).getHd());
         }
         return _loc2_.getValue();
      }
   }
}

