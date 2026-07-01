package hotpointgame.gxiaodongxi
{
   public class XiaoXiaoManager
   {
      
      public static var xarr:Vector.<CGX> = new Vector.<CGX>();
      
      public function XiaoXiaoManager()
      {
         super();
      }
      
      public static function addCGX(param1:CGX) : void
      {
         xarr[xarr.length] = param1;
      }
      
      public static function gmUpdate() : void
      {
         var _loc1_:int = int(xarr.length);
         var _loc2_:* = int(_loc1_ - 1);
         while(_loc2_ >= 0)
         {
            if(xarr[_loc2_].gmUpdate())
            {
               xarr[_loc2_].remove();
               xarr.splice(_loc2_,1);
            }
            _loc2_--;
         }
      }
      
      public static function remove() : void
      {
         var _loc1_:CGX = null;
         for each(_loc1_ in xarr)
         {
            _loc1_.remove();
         }
         xarr.length = 0;
      }
   }
}

