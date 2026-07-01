package hotpointgame.glevel
{
   public class CLSMPmanager
   {
      
      private var boArr:Vector.<CLSMP> = new Vector.<CLSMP>();
      
      private var otherArr:Vector.<CLSMP> = new Vector.<CLSMP>();
      
      public function CLSMPmanager()
      {
         super();
      }
      
      public function addBo(param1:CLSMP) : void
      {
         this.boArr.push(param1);
      }
      
      public function addother(param1:CLSMP) : void
      {
         this.otherArr.push(param1);
      }
      
      public function gmUpdate() : Boolean
      {
         var _loc1_:Boolean = true;
         if(this.boArr.length > 0)
         {
            _loc1_ = false;
            if(this.boArr[0].gmUpdate())
            {
               this.boArr.splice(0,1);
            }
         }
         var _loc2_:int = int(this.otherArr.length);
         var _loc3_:* = int(_loc2_ - 1);
         while(_loc3_ >= 0)
         {
            if(this.otherArr[_loc3_].gmUpdate())
            {
               this.otherArr.splice(_loc3_,1);
            }
            _loc3_--;
         }
         if(_loc2_ > 0)
         {
            return false;
         }
         return _loc1_;
      }
      
      public function clearAll() : void
      {
         var _loc1_:CLSMP = null;
         var _loc2_:CLSMP = null;
         for each(_loc1_ in this.boArr)
         {
            _loc1_.remove();
         }
         for each(_loc2_ in this.otherArr)
         {
            _loc2_.remove();
         }
         this.boArr.length = 0;
         this.otherArr.length = 0;
      }
   }
}

