package hotpointgame.utils
{
   import flash.utils.*;
   
   public class DeepCopyUtil
   {
      
      public function DeepCopyUtil()
      {
         super();
      }
      
      public static function clone(param1:Object) : *
      {
         var _loc2_:ByteArray = new ByteArray();
         _loc2_.writeObject(param1);
         _loc2_.position = 0;
         return _loc2_.readObject();
      }
      
      public static function cloneBBBBBB(param1:Object) : ByteArray
      {
         var _loc2_:ByteArray = new ByteArray();
         _loc2_.writeObject(param1);
         _loc2_.position = 0;
         return _loc2_;
      }
      
      public static function encode(param1:String) : String
      {
         var _loc2_:ByteArray = DeepCopyUtil.cloneBBBBBB(param1);
         return Base64.encodeByteArray(_loc2_);
      }
      
      public static function decode(param1:String) : String
      {
         var _loc2_:ByteArray = Base64.decodeToByteArray(param1);
         _loc2_.position = 0;
         return _loc2_.readObject();
      }
   }
}

