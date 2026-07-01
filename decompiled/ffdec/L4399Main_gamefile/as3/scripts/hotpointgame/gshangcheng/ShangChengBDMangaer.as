package hotpointgame.gshangcheng
{
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   
   public class ShangChengBDMangaer
   {
      
      private static var tjAll:Vector.<ShangChengBData> = new Vector.<ShangChengBData>();
      
      private static var tjRiXiao:Vector.<ShangChengBData> = new Vector.<ShangChengBData>();
      
      private static var tjNew:Vector.<ShangChengBData> = new Vector.<ShangChengBData>();
      
      private static var tjZheKou:Vector.<ShangChengBData> = new Vector.<ShangChengBData>();
      
      private static var szAll:Vector.<ShangChengBData> = new Vector.<ShangChengBData>();
      
      private static var szYiFu:Vector.<ShangChengBData> = new Vector.<ShangChengBData>();
      
      private static var szJianBang:Vector.<ShangChengBData> = new Vector.<ShangChengBData>();
      
      private static var szWuQi:Vector.<ShangChengBData> = new Vector.<ShangChengBData>();
      
      private static var szXuanGuan:Vector.<ShangChengBData> = new Vector.<ShangChengBData>();
      
      private static var djAll:Vector.<ShangChengBData> = new Vector.<ShangChengBData>();
      
      private static var djQiTa:Vector.<ShangChengBData> = new Vector.<ShangChengBData>();
      
      private static var petAll:Vector.<ShangChengBData> = new Vector.<ShangChengBData>();
      
      private static var petQiTa:Vector.<ShangChengBData> = new Vector.<ShangChengBData>();
      
      private static var tjAllw:Vector.<ShangChengBData> = new Vector.<ShangChengBData>();
      
      private static var tjRiXiaow:Vector.<ShangChengBData> = new Vector.<ShangChengBData>();
      
      private static var tjNeww:Vector.<ShangChengBData> = new Vector.<ShangChengBData>();
      
      private static var tjZheKouw:Vector.<ShangChengBData> = new Vector.<ShangChengBData>();
      
      private static var szAllw:Vector.<ShangChengBData> = new Vector.<ShangChengBData>();
      
      private static var szYiFuw:Vector.<ShangChengBData> = new Vector.<ShangChengBData>();
      
      private static var szJianBangw:Vector.<ShangChengBData> = new Vector.<ShangChengBData>();
      
      private static var szWuQiw:Vector.<ShangChengBData> = new Vector.<ShangChengBData>();
      
      private static var szXuanGuanw:Vector.<ShangChengBData> = new Vector.<ShangChengBData>();
      
      private static var djAllw:Vector.<ShangChengBData> = new Vector.<ShangChengBData>();
      
      private static var djQiTaw:Vector.<ShangChengBData> = new Vector.<ShangChengBData>();
      
      private static var petAllw:Vector.<ShangChengBData> = new Vector.<ShangChengBData>();
      
      private static var petQiTaw:Vector.<ShangChengBData> = new Vector.<ShangChengBData>();
      
      private static var pageNum:int = 9;
      
      public function ShangChengBDMangaer()
      {
         super();
      }
      
      public static function addBD(param1:ShangChengBData) : void
      {
         if(param1.tjtype != -1)
         {
            tjAll.push(param1);
            switch(param1.tjtype)
            {
               case 2:
                  tjRiXiao.push(param1);
                  break;
               case 3:
                  tjNew.push(param1);
                  break;
               case 4:
                  tjZheKou.push(param1);
            }
         }
         if(param1.sztype != -1)
         {
            szAll.push(param1);
            switch(param1.sztype)
            {
               case 2:
                  szYiFu.push(param1);
                  break;
               case 3:
                  szJianBang.push(param1);
                  break;
               case 4:
                  szWuQi.push(param1);
                  break;
               case 5:
                  szXuanGuan.push(param1);
            }
         }
         if(param1.djtype != -1)
         {
            djAll.push(param1);
            switch(param1.djtype)
            {
               case 2:
                  djQiTa.push(param1);
            }
         }
         if(param1.pettype != -1)
         {
            petAll.push(param1);
            switch(param1.pettype)
            {
               case 2:
                  petQiTa.push(param1);
            }
         }
      }
      
      public static function addBDw(param1:ShangChengBData) : void
      {
         if(param1.tjtype != -1)
         {
            tjAllw.push(param1);
            switch(param1.tjtype)
            {
               case 2:
                  tjRiXiaow.push(param1);
                  break;
               case 3:
                  tjNeww.push(param1);
                  break;
               case 4:
                  tjZheKouw.push(param1);
            }
         }
         if(param1.sztype != -1)
         {
            szAllw.push(param1);
            switch(param1.sztype)
            {
               case 2:
                  szYiFuw.push(param1);
                  break;
               case 3:
                  szJianBangw.push(param1);
                  break;
               case 4:
                  szWuQiw.push(param1);
                  break;
               case 5:
                  szXuanGuanw.push(param1);
            }
         }
         if(param1.djtype != -1)
         {
            djAllw.push(param1);
            switch(param1.djtype)
            {
               case 2:
                  djQiTaw.push(param1);
            }
         }
         if(param1.pettype != -1)
         {
            petAllw.push(param1);
            switch(param1.pettype)
            {
               case 2:
                  petQiTaw.push(param1);
            }
         }
      }
      
      public static function InitXmlData(param1:XML) : void
      {
         var _loc2_:XML = null;
         var _loc3_:ShangChengBData = null;
         for each(_loc2_ in param1.商城)
         {
            _loc3_ = new ShangChengBData();
            _loc3_.propId = Number(_loc2_.商城ID);
            _loc3_.buyId = Number(_loc2_.平台随机ID);
            _loc3_.showPrice = Number(_loc2_.显示价格);
            _loc3_.buyPrice = Number(_loc2_.真实价格);
            _loc3_.priceFlag = Number(_loc2_.标识);
            _loc3_.hotFlagFrameNum = Number(_loc2_.标签帧数);
            _loc3_.isKYShiChuang = Number(_loc2_.是否试穿);
            _loc3_.isShowBuyNum = Number(_loc2_.是否需要购买数量);
            _loc3_.tjtype = Number(_loc2_.推荐类);
            _loc3_.sztype = Number(_loc2_.时装类);
            _loc3_.djtype = Number(_loc2_.道具类);
            _loc3_.pettype = Number(_loc2_.宠物类);
            _loc3_.sorttj = Number(_loc2_.推荐类排序);
            _loc3_.sortother = Number(_loc2_.正常类排序);
            _loc3_.showJob = Number(_loc2_.职业);
            if(_loc3_.showJob == -GS.a1)
            {
               ShangChengBDMangaer.addBD(_loc3_);
               ShangChengBDMangaer.addBDw(_loc3_);
            }
            if(_loc3_.showJob == GS.a1)
            {
               ShangChengBDMangaer.addBD(_loc3_);
            }
            if(_loc3_.showJob == GS.a2)
            {
               ShangChengBDMangaer.addBDw(_loc3_);
            }
         }
         tjAll.sort(sortFuntj);
         tjRiXiao.sort(sortFuntj);
         tjNew.sort(sortFuntj);
         tjZheKou.sort(sortFuntj);
         szAll.sort(sortFunother);
         szYiFu.sort(sortFunother);
         szJianBang.sort(sortFunother);
         szWuQi.sort(sortFunother);
         szXuanGuan.sort(sortFunother);
         djAll.sort(sortFunother);
         djQiTa.sort(sortFunother);
         tjAllw.sort(sortFuntj);
         tjRiXiaow.sort(sortFuntj);
         tjNeww.sort(sortFuntj);
         tjZheKouw.sort(sortFuntj);
         szAllw.sort(sortFunother);
         szYiFuw.sort(sortFunother);
         szJianBangw.sort(sortFunother);
         szWuQiw.sort(sortFunother);
         szXuanGuanw.sort(sortFunother);
         djAllw.sort(sortFunother);
         djQiTaw.sort(sortFunother);
      }
      
      public static function getShopPage(param1:int, param2:int) : int
      {
         if(FlowInterface.getJobByRole() == GS.a1)
         {
            return getShopPagem(param1,param2);
         }
         return getShopPagew(param1,param2);
      }
      
      public static function getShopPagem(param1:int, param2:int) : int
      {
         var _loc3_:int = 0;
         switch(param1)
         {
            case 1:
               switch(param2)
               {
                  case 1:
                     _loc3_ = int(tjAll.length);
                     break;
                  case 2:
                     _loc3_ = int(tjRiXiao.length);
                     break;
                  case 3:
                     _loc3_ = int(tjNew.length);
                     break;
                  case 4:
                     _loc3_ = int(tjZheKou.length);
               }
               break;
            case 2:
               switch(param2)
               {
                  case 1:
                     _loc3_ = int(szAll.length);
                     break;
                  case 2:
                     _loc3_ = int(szYiFu.length);
                     break;
                  case 3:
                     _loc3_ = int(szJianBang.length);
                     break;
                  case 4:
                     _loc3_ = int(szWuQi.length);
                     break;
                  case 5:
                     _loc3_ = int(szXuanGuan.length);
               }
               break;
            case 3:
               switch(param2)
               {
                  case 1:
                     _loc3_ = int(djAll.length);
                     break;
                  case 2:
                     _loc3_ = int(djQiTa.length);
               }
               break;
            case 4:
               switch(param2)
               {
                  case 1:
                     _loc3_ = int(petAll.length);
                     break;
                  case 2:
                     _loc3_ = int(petQiTa.length);
               }
         }
         var _loc4_:int = _loc3_ / pageNum;
         if(_loc4_ == 0)
         {
            return 1;
         }
         if(_loc3_ % pageNum == 0)
         {
            return _loc4_;
         }
         return _loc4_ + 1;
      }
      
      public static function getShopPagew(param1:int, param2:int) : int
      {
         var _loc3_:int = 0;
         switch(param1)
         {
            case 1:
               switch(param2)
               {
                  case 1:
                     _loc3_ = int(tjAllw.length);
                     break;
                  case 2:
                     _loc3_ = int(tjRiXiaow.length);
                     break;
                  case 3:
                     _loc3_ = int(tjNeww.length);
                     break;
                  case 4:
                     _loc3_ = int(tjZheKouw.length);
               }
               break;
            case 2:
               switch(param2)
               {
                  case 1:
                     _loc3_ = int(szAllw.length);
                     break;
                  case 2:
                     _loc3_ = int(szYiFuw.length);
                     break;
                  case 3:
                     _loc3_ = int(szJianBangw.length);
                     break;
                  case 4:
                     _loc3_ = int(szWuQiw.length);
                     break;
                  case 5:
                     _loc3_ = int(szXuanGuanw.length);
               }
               break;
            case 3:
               switch(param2)
               {
                  case 1:
                     _loc3_ = int(djAllw.length);
                     break;
                  case 2:
                     _loc3_ = int(djQiTaw.length);
               }
               break;
            case 4:
               switch(param2)
               {
                  case 1:
                     _loc3_ = int(petAllw.length);
                     break;
                  case 2:
                     _loc3_ = int(petQiTaw.length);
               }
         }
         var _loc4_:int = _loc3_ / pageNum;
         if(_loc4_ == 0)
         {
            return 1;
         }
         if(_loc3_ % pageNum == 0)
         {
            return _loc4_;
         }
         return _loc4_ + 1;
      }
      
      public static function getShopList(param1:int, param2:int, param3:int) : Array
      {
         if(FlowInterface.getJobByRole() == GS.a1)
         {
            return getShopListm(param1,param2,param3);
         }
         return getShopListw(param1,param2,param3);
      }
      
      public static function getShopListm(param1:int, param2:int, param3:int) : Array
      {
         var _loc4_:Array = null;
         switch(param1)
         {
            case 1:
               switch(param2)
               {
                  case 1:
                     _loc4_ = getShopByArrayandPage(tjAll,param3);
                     break;
                  case 2:
                     _loc4_ = getShopByArrayandPage(tjRiXiao,param3);
                     break;
                  case 3:
                     _loc4_ = getShopByArrayandPage(tjNew,param3);
                     break;
                  case 4:
                     _loc4_ = getShopByArrayandPage(tjZheKou,param3);
               }
               break;
            case 2:
               switch(param2)
               {
                  case 1:
                     _loc4_ = getShopByArrayandPage(szAll,param3);
                     break;
                  case 2:
                     _loc4_ = getShopByArrayandPage(szYiFu,param3);
                     break;
                  case 3:
                     _loc4_ = getShopByArrayandPage(szJianBang,param3);
                     break;
                  case 4:
                     _loc4_ = getShopByArrayandPage(szWuQi,param3);
                     break;
                  case 5:
                     _loc4_ = getShopByArrayandPage(szXuanGuan,param3);
               }
               break;
            case 3:
               switch(param2)
               {
                  case 1:
                     _loc4_ = getShopByArrayandPage(djAll,param3);
                     break;
                  case 2:
                     _loc4_ = getShopByArrayandPage(djQiTa,param3);
               }
               break;
            case 4:
               switch(param2)
               {
                  case 1:
                     _loc4_ = getShopByArrayandPage(petAll,param3);
                     break;
                  case 2:
                     _loc4_ = getShopByArrayandPage(petQiTa,param3);
               }
         }
         if(_loc4_ == null)
         {
            GM.findCheatMax(GS.a34);
         }
         return _loc4_;
      }
      
      public static function getShopListw(param1:int, param2:int, param3:int) : Array
      {
         var _loc4_:Array = null;
         switch(param1)
         {
            case 1:
               switch(param2)
               {
                  case 1:
                     _loc4_ = getShopByArrayandPage(tjAllw,param3);
                     break;
                  case 2:
                     _loc4_ = getShopByArrayandPage(tjRiXiaow,param3);
                     break;
                  case 3:
                     _loc4_ = getShopByArrayandPage(tjNeww,param3);
                     break;
                  case 4:
                     _loc4_ = getShopByArrayandPage(tjZheKouw,param3);
               }
               break;
            case 2:
               switch(param2)
               {
                  case 1:
                     _loc4_ = getShopByArrayandPage(szAllw,param3);
                     break;
                  case 2:
                     _loc4_ = getShopByArrayandPage(szYiFuw,param3);
                     break;
                  case 3:
                     _loc4_ = getShopByArrayandPage(szJianBangw,param3);
                     break;
                  case 4:
                     _loc4_ = getShopByArrayandPage(szWuQiw,param3);
                     break;
                  case 5:
                     _loc4_ = getShopByArrayandPage(szXuanGuanw,param3);
               }
               break;
            case 3:
               switch(param2)
               {
                  case 1:
                     _loc4_ = getShopByArrayandPage(djAllw,param3);
                     break;
                  case 2:
                     _loc4_ = getShopByArrayandPage(djQiTaw,param3);
               }
               break;
            case 4:
               switch(param2)
               {
                  case 1:
                     _loc4_ = getShopByArrayandPage(petAllw,param3);
                     break;
                  case 2:
                     _loc4_ = getShopByArrayandPage(petQiTaw,param3);
               }
         }
         if(_loc4_ == null)
         {
            GM.findCheatMax(GS.a34);
         }
         return _loc4_;
      }
      
      private static function getShopByArrayandPage(param1:Vector.<ShangChengBData>, param2:int) : Array
      {
         var _loc3_:int = int(param1.length);
         if(param2 != 1 && _loc3_ <= (param2 - 1) * pageNum)
         {
            GM.findCheatMax(GS.a35);
         }
         var _loc4_:Array = new Array();
         var _loc5_:int = (param2 - 1) * pageNum;
         while(_loc5_ < _loc3_)
         {
            _loc4_.push(param1[_loc5_]);
            if(_loc4_.length >= 9)
            {
               break;
            }
            _loc5_++;
         }
         return _loc4_;
      }
      
      private static function sortFuntj(param1:ShangChengBData, param2:ShangChengBData) : int
      {
         if(param1.sorttj < param2.sorttj)
         {
            return -1;
         }
         if(param1.sorttj == param2.sorttj)
         {
            return 0;
         }
         return 1;
      }
      
      private static function sortFunother(param1:ShangChengBData, param2:ShangChengBData) : int
      {
         if(param1.sortother < param2.sortother)
         {
            return -1;
         }
         if(param1.sortother == param2.sortother)
         {
            return 0;
         }
         return 1;
      }
   }
}

