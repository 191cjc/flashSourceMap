package hotpointgame.utils
{
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   import hotpointgame.gxiaodongxi.*;
   import hotpointgame.utils.gameloader.*;
   
   public class UTools
   {
      
      public static var updateUrl:String = "http://my.4399.com/forums-thread-tagid-81881-id-42565545.html";
      
      public static var updateUrl1:String = "http://my.4399.com/forums-thread-tagid-81881-id-42565545.html";
      
      public static var updateUrl2:String = "http://my.4399.com/forums-thread-tagid-81881-id-42565545.html";
      
      public static var updateUrl3:String = "http://my.4399.com/forums-thread-tagid-81881-id-42565545.html";
      
      public function UTools()
      {
         super();
      }
      
      public static function sTnArr(param1:Array) : Array
      {
         var _loc2_:Array = new Array();
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            _loc2_[_loc3_] = Number(param1[_loc3_]);
            _loc3_++;
         }
         return _loc2_;
      }
      
      public static function sTnArrAndVT(param1:Array) : Array
      {
         var _loc2_:Array = new Array();
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            _loc2_[_loc3_] = VT.createVT(Number(param1[_loc3_]));
            _loc3_++;
         }
         return _loc2_;
      }
      
      public static function sTnArrInP(param1:Array) : Array
      {
         var _loc2_:Array = new Array();
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            if(param1[_loc3_] != "p")
            {
               _loc2_[_loc3_] = Number(param1[_loc3_]);
            }
            else
            {
               _loc2_[_loc3_] = "p";
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      public static function addPiaoMc(param1:String) : void
      {
         var _loc2_:Class = LoaderManager.getSwfClass(param1) as Class;
         XiaoXiaoManager.addCGX(new CGXFrame(new _loc2_(),GM.tsUp));
      }
      
      public static function getTitlemcName(param1:String) : String
      {
         switch(param1)
         {
            case "溪谷小筑守卫兵":
               return "chxg";
            case "野人部落保卫者":
               return "chyr";
            case "神农祭坛守护者":
               return "chjt";
            case "海底基地之第二领主":
               return "chhd";
            default:
               return "";
         }
      }
   }
}

