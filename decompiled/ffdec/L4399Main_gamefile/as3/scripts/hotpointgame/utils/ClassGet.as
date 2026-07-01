package hotpointgame.utils
{
   import flash.net.*;
   import flash.utils.*;
   
   public class ClassGet
   {
      
      public function ClassGet()
      {
         super();
      }
      
      public static function getClassByName(param1:String) : Class
      {
         return getDefinitionByName(param1) as Class;
      }
      
      public static function getClassByNameAndAlias(param1:String) : Class
      {
         return getClassByAlias("XSWF" + param1) as Class;
      }
   }
}

