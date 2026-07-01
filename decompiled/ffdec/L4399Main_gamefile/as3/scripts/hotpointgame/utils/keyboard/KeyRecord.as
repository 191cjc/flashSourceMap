package hotpointgame.utils.keyboard
{
   public class KeyRecord
   {
      
      private var record:Vector.<DownOrUp> = new Vector.<DownOrUp>();
      
      private var lastIsUp:Boolean = true;
      
      public function KeyRecord()
      {
         super();
      }
      
      public function push(param1:uint, param2:uint) : void
      {
         var _loc3_:int = 50;
         if(this.record.length > _loc3_)
         {
            this.record = this.record.slice(_loc3_ - 11);
         }
         var _loc4_:int = int(this.record.length);
         if(_loc4_ == 0 || this.record[_loc4_ - 1].getState() != param1)
         {
            this.record.push(new DownOrUp(param1,param2));
            this.lastIsUp = param1 == DownOrUp.KEY_UP ? true : false;
         }
      }
      
      public function isUp() : Boolean
      {
         return this.lastIsUp;
      }
      
      public function lastOneDownTime() : uint
      {
         var _loc1_:int = int(this.record.length);
         var _loc2_:int = 0;
         switch(_loc1_)
         {
            case 0:
               _loc2_ = 0;
               break;
            case 1:
               if(this.lastIsUp)
               {
                  _loc2_ = 0;
               }
               else
               {
                  _loc2_ = int(this.record[_loc1_ - 1].getTime());
               }
               break;
            default:
               if(this.lastIsUp)
               {
                  _loc2_ = int(this.record[_loc1_ - 2].getTime());
               }
               else
               {
                  _loc2_ = int(this.record[_loc1_ - 1].getTime());
               }
         }
         return _loc2_;
      }
      
      public function lastTwoDownTime() : uint
      {
         var _loc1_:int = int(this.record.length);
         var _loc2_:uint = 0;
         if(_loc1_ >= 3)
         {
            if(this.lastIsUp)
            {
               if(_loc1_ > 3)
               {
                  _loc2_ = uint(this.record[_loc1_ - 4].getTime());
               }
            }
            else
            {
               _loc2_ = uint(this.record[_loc1_ - 3].getTime());
            }
         }
         return _loc2_;
      }
      
      public function lastThreeDownTime() : uint
      {
         var _loc1_:int = int(this.record.length);
         var _loc2_:uint = 0;
         if(_loc1_ >= 5)
         {
            if(this.lastIsUp)
            {
               if(_loc1_ > 5)
               {
                  _loc2_ = uint(this.record[_loc1_ - 6].getTime());
               }
            }
            else
            {
               _loc2_ = uint(this.record[_loc1_ - 5].getTime());
            }
         }
         return _loc2_;
      }
      
      private function lastTimeByTimes(param1:int) : uint
      {
         return 0;
      }
   }
}

