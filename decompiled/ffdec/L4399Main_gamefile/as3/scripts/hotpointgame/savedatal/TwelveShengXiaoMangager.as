package hotpointgame.savedatal
{
   import hotpointgame.common.*;
   
   public class TwelveShengXiaoMangager
   {
      
      private static var twelvearr:Array = new Array();
      
      private static var twelveDuiHuan:Array = new Array();
      
      public function TwelveShengXiaoMangager()
      {
         super();
      }
      
      public static function initSXdata(param1:XML) : void
      {
         var _loc2_:XML = null;
         var _loc3_:TwelveDouHunBaseData = null;
         for each(_loc2_ in param1.十二生肖)
         {
            _loc3_ = new TwelveDouHunBaseData();
            _loc3_.name = String(_loc2_.名称);
            _loc3_.id = Number(_loc2_.生肖ID);
            _loc3_.pId = Number(_loc2_.融化需求ID);
            _loc3_.pgod = Number(_loc2_.融化需求晶币);
            _loc3_.attB = Number(_loc2_.增加属性基数);
            _loc3_.attBW = Number(_loc2_.职业二增加属性基数);
            _loc3_.attname = String(_loc2_.显示增加属性的名字);
            twelvearr[_loc3_.id] = _loc3_;
         }
      }
      
      public static function initDuiHuan(param1:XML) : void
      {
         var _loc2_:XML = null;
         var _loc3_:TwelveDuiHuanBaseData = null;
         for each(_loc2_ in param1.生肖之力)
         {
            _loc3_ = new TwelveDuiHuanBaseData();
            _loc3_.id = Number(_loc2_.序列号);
            _loc3_.pgod = Number(_loc2_.出售价格);
            _loc3_.pid = Number(_loc2_.兑换物品ID);
            _loc3_.pfnum = Number(_loc2_.图标帧数);
            twelveDuiHuan[_loc3_.id] = _loc3_;
         }
      }
      
      public static function getDHGeNum() : int
      {
         return twelveDuiHuan.length - GS.a1;
      }
      
      public static function getDHBaseNumById(param1:int) : TwelveDuiHuanBaseData
      {
         return twelveDuiHuan[param1];
      }
      
      public static function getDouHunDataById(param1:int) : TwelveDouHunBaseData
      {
         return twelvearr[param1];
      }
      
      public static function getDouHuanNum() : int
      {
         return twelvearr.length - GS.a1;
      }
   }
}

