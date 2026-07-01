package hotpointgame.views.taskPanel
{
   import hotpointgame.models.task.Task;
   
   public class taskSlot
   {
      
      private var slotArr:Array = [];
      
      private var slotNum:Number;
      
      public function taskSlot()
      {
         super();
      }
      
      public static function createSlot(param1:Number) : taskSlot
      {
         var _loc2_:taskSlot = new taskSlot();
         _loc2_.slotNum = param1;
         _loc2_.initSlot();
         return _loc2_;
      }
      
      public function getSlotArr() : Array
      {
         return this.slotArr;
      }
      
      public function initSlot() : void
      {
         var _loc1_:uint = 0;
         while(_loc1_ < this.slotNum)
         {
            this.slotArr[_loc1_] = null;
            _loc1_++;
         }
      }
      
      public function addSlot(param1:Task) : void
      {
         var _loc2_:uint = 0;
         while(_loc2_ < this.slotNum)
         {
            if(this.slotArr[_loc2_] == null)
            {
               this.slotArr[_loc2_] = param1;
               break;
            }
            _loc2_++;
         }
      }
      
      public function getTask(param1:Number) : Task
      {
         return this.slotArr[param1];
      }
      
      public function clearTask() : void
      {
         this.initSlot();
      }
   }
}

