package hotpointgame.utils.keyboard
{
   public class DownOrUp
   {
      
      public static var KEY_DOWN:uint = 0;
      
      public static var KEY_UP:uint = 1;
      
      private var state:uint;
      
      private var time:uint;
      
      public function DownOrUp(param1:uint, param2:uint)
      {
         super();
         this.state = param1;
         this.time = param2;
      }
      
      public function getState() : uint
      {
         return this.state;
      }
      
      public function getTime() : uint
      {
         return this.time;
      }
   }
}

