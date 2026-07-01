package hotpointgame.utils
{
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.geom.*;
   
   public class Pos
   {
      
      public function Pos()
      {
         super();
      }
      
      public static function l_To_G(param1:MovieClip) : Point
      {
         var _loc2_:Point = new Point(param1.x,param1.y);
         if(param1.parent)
         {
            _loc2_ = param1.parent.localToGlobal(_loc2_);
         }
         else
         {
            _loc2_ = param1.localToGlobal(_loc2_);
         }
         return _loc2_;
      }
      
      public static function displayA_x_y_To_displayB(param1:MovieClip, param2:DisplayObjectContainer) : Point
      {
         var _loc3_:Point = new Point(param1.x,param1.y);
         if(param1.parent)
         {
            _loc3_ = param1.parent.localToGlobal(_loc3_);
         }
         else
         {
            _loc3_ = param1.localToGlobal(_loc3_);
         }
         return param2.globalToLocal(_loc3_);
      }
      
      public static function p_To_G(param1:Point, param2:MovieClip) : Point
      {
         var _loc3_:Point = new Point();
         return param2.localToGlobal(param1);
      }
      
      public static function displayA_point_To_displayB(param1:Point, param2:MovieClip, param3:DisplayObjectContainer) : Point
      {
         var _loc4_:Point = new Point();
         _loc4_ = param2.localToGlobal(param1);
         return param3.globalToLocal(_loc4_);
      }
   }
}

