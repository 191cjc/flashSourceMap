package hotpointgame.gameobj
{
   import com.adobeadobe.crypto.*;
   import mx.core.ByteArrayAsset;
   
   public class Xmldatacheck
   {
      
      public static var goodsxml:ByteArrayAsset;
      
      public static var onlinexml:ByteArrayAsset;
      
      public static var vipXml:ByteArrayAsset;
      
      public static var edJlXml:ByteArrayAsset;
      
      public static var shengxiaoduihuanXml:ByteArrayAsset;
      
      public static var czjlXml:ByteArrayAsset;
      
      private static var goodsstring:String = "e5343de7e5bea4122151b0a3b26763d7";
      
      private static var onlinestring:String = "9a4bac3733ac01c47da8f8ecfec21ee0";
      
      private static var vipXmlstring:String = "9b7f78182579fbfff04e08375f19ec15";
      
      private static var edJlXmlstring:String = "a2cca704cf6845a6f5df04626ed54fd6";
      
      private static var shengxiaoduihuanXmlstring:String = "f0780889e72c88845240591658bc3c42";
      
      private static var czjlXmlstring:String = "d18db3cfbc2618c4e49eaa8633794f5a";
      
      public function Xmldatacheck()
      {
         super();
      }
      
      public static function goodscheck() : Boolean
      {
         var _loc1_:String = MD5.hashBinary(goodsxml);
         if(_loc1_ === goodsstring)
         {
            return false;
         }
         return true;
      }
      
      public static function onlinecheck() : Boolean
      {
         var _loc1_:String = MD5.hashBinary(onlinexml);
         if(_loc1_ === onlinestring)
         {
            return false;
         }
         return true;
      }
      
      public static function vipxmlcheck() : Boolean
      {
         var _loc1_:String = MD5.hashBinary(vipXml);
         if(_loc1_ === vipXmlstring)
         {
            return false;
         }
         return true;
      }
      
      public static function edJlXmlcheck() : Boolean
      {
         var _loc1_:String = MD5.hashBinary(edJlXml);
         if(_loc1_ === edJlXmlstring)
         {
            return false;
         }
         return true;
      }
      
      public static function shengxiaoduihuanXmlcheck() : Boolean
      {
         var _loc1_:String = MD5.hashBinary(shengxiaoduihuanXml);
         if(_loc1_ === shengxiaoduihuanXmlstring)
         {
            return false;
         }
         return true;
      }
      
      public static function czjlXmlcheck() : Boolean
      {
         var _loc1_:String = MD5.hashBinary(czjlXml);
         if(_loc1_ === czjlXmlstring)
         {
            return false;
         }
         return true;
      }
   }
}

