package hotpointgame.utils.keyboard
{
   import flash.display.Stage;
   import flash.events.*;
   import flash.utils.*;
   
   public class GameKeyboard
   {
      
      public static var ONEKEY_CLICK:uint = 1;
      
      public static var ONEKEY_DOWN:uint = 2;
      
      public static var ONEKEY_DOWN_DOWN:uint = 3;
      
      public static var TWOKEY_COMMON:uint = 11;
      
      public static var TWOKEY_COMMON_DOWN:uint = 12;
      
      public static var TWOKEY_CLICK:uint = 13;
      
      public static var TWOKEY_DOWN:uint = 14;
      
      public static var TWOKEY_DOWN_B:uint = 15;
      
      public static var TWOKEY_DOWN_C:uint = 16;
      
      public static var TWOKEY_TWODOWN:uint = 17;
      
      public static var THREEKEY_COMMON:uint = 101;
      
      public static var THREEKEY_TWODOWN:uint = 102;
      
      public static var THREEKEY_TWODOWNONE:uint = 103;
      
      private var supportKeyNum:int = 300;
      
      private var downEffectTime:uint = 70;
      
      private var downAndDownTime:uint = 300;
      
      private var _stage:Stage;
      
      private var keyRecord:Vector.<KeyRecord> = null;
      
      public function GameKeyboard(param1:Stage)
      {
         super();
         this._stage = param1;
         this.init();
      }
      
      public function init() : void
      {
         this.keyRecord = new Vector.<KeyRecord>();
         var _loc1_:int = 0;
         while(_loc1_ < this.supportKeyNum)
         {
            this.keyRecord[_loc1_] = new KeyRecord();
            _loc1_++;
         }
         this.startListener();
      }
      
      public function Destroy() : void
      {
         this.keyRecord = null;
         this.stopListener();
      }
      
      public function startListener() : void
      {
         this._stage.addEventListener(KeyboardEvent.KEY_DOWN,this.downHandle);
         this._stage.addEventListener(KeyboardEvent.KEY_UP,this.upHandle);
         this._stage.addEventListener(Event.DEACTIVATE,this.deactivateHandle);
      }
      
      public function stopListener() : void
      {
         this._stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.downHandle);
         this._stage.removeEventListener(KeyboardEvent.KEY_UP,this.upHandle);
         this._stage.removeEventListener(Event.DEACTIVATE,this.deactivateHandle);
      }
      
      private function downHandle(param1:KeyboardEvent) : void
      {
         var _loc2_:uint = param1.keyCode;
         this.keyRecord[_loc2_].push(DownOrUp.KEY_DOWN,getTimer());
      }
      
      private function upHandle(param1:KeyboardEvent) : void
      {
         var _loc2_:uint = param1.keyCode;
         this.keyRecord[_loc2_].push(DownOrUp.KEY_UP,getTimer());
      }
      
      private function deactivateHandle(param1:Event) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.supportKeyNum)
         {
            this.keyRecord[_loc2_].push(DownOrUp.KEY_UP,getTimer());
            _loc2_++;
         }
      }
      
      public function isOkByOne(param1:uint, param2:uint) : Boolean
      {
         var _loc3_:Boolean = false;
         var _loc4_:uint = uint(getTimer());
         switch(param1)
         {
            case ONEKEY_CLICK:
               if(_loc4_ - this.keyRecord[param2].lastOneDownTime() < this.downEffectTime)
               {
                  _loc3_ = true;
               }
               break;
            case ONEKEY_DOWN:
               if(!this.keyRecord[param2].isUp())
               {
                  if(_loc4_ - this.keyRecord[param2].lastOneDownTime() < this.downEffectTime)
                  {
                     _loc3_ = true;
                  }
               }
               break;
            case ONEKEY_DOWN_DOWN:
               if(!this.keyRecord[param2].isUp())
               {
                  _loc3_ = true;
               }
               break;
            default:
               _loc3_ = false;
         }
         return _loc3_;
      }
      
      public function isOkByTwo(param1:uint, param2:uint, param3:uint) : Boolean
      {
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:Boolean = false;
         var _loc9_:Boolean = false;
         var _loc4_:Boolean = false;
         var _loc5_:uint = uint(getTimer());
         switch(param1)
         {
            case TWOKEY_COMMON:
               _loc6_ = uint(this.keyRecord[param3].lastOneDownTime());
               if(_loc5_ - _loc6_ < this.downEffectTime)
               {
                  if(param2 == param3)
                  {
                     _loc7_ = uint(this.keyRecord[param2].lastTwoDownTime());
                     if(_loc6_ - _loc7_ < this.downAndDownTime)
                     {
                        _loc4_ = true;
                     }
                  }
                  else
                  {
                     _loc7_ = uint(this.keyRecord[param2].lastOneDownTime());
                     if(_loc6_ - _loc7_ < 0)
                     {
                        _loc7_ = uint(this.keyRecord[param2].lastTwoDownTime());
                     }
                     if(_loc6_ - _loc7_ < this.downAndDownTime)
                     {
                        _loc4_ = true;
                     }
                  }
               }
               break;
            case TWOKEY_COMMON_DOWN:
               if(this.keyRecord[param3].isUp())
               {
                  _loc6_ = uint(this.keyRecord[param3].lastOneDownTime());
                  if(_loc5_ - _loc6_ < this.downEffectTime)
                  {
                     if(param2 == param3)
                     {
                        _loc7_ = uint(this.keyRecord[param2].lastTwoDownTime());
                        if(_loc6_ - _loc7_ < this.downAndDownTime)
                        {
                           _loc4_ = true;
                        }
                     }
                     else
                     {
                        _loc7_ = uint(this.keyRecord[param2].lastOneDownTime());
                        if(_loc6_ - _loc7_ < 0)
                        {
                           _loc7_ = uint(this.keyRecord[param2].lastTwoDownTime());
                        }
                        if(_loc6_ - _loc7_ < this.downAndDownTime)
                        {
                           _loc4_ = true;
                        }
                     }
                  }
               }
               else
               {
                  _loc6_ = uint(this.keyRecord[param3].lastOneDownTime());
                  if(param2 == param3)
                  {
                     _loc7_ = uint(this.keyRecord[param2].lastTwoDownTime());
                     if(_loc6_ - _loc7_ < this.downAndDownTime)
                     {
                        _loc4_ = true;
                     }
                  }
                  else
                  {
                     _loc7_ = uint(this.keyRecord[param2].lastOneDownTime());
                     if(_loc6_ - _loc7_ < 0)
                     {
                        _loc7_ = uint(this.keyRecord[param2].lastTwoDownTime());
                     }
                     if(_loc6_ - _loc7_ < this.downAndDownTime)
                     {
                        _loc4_ = true;
                     }
                  }
               }
               break;
            case TWOKEY_CLICK:
               _loc6_ = uint(this.keyRecord[param3].lastOneDownTime());
               _loc8_ = false;
               if(_loc5_ - _loc6_ < this.downEffectTime)
               {
                  if(param2 == param3)
                  {
                     _loc8_ = true;
                  }
                  else if(this.keyRecord[param2].isUp())
                  {
                     _loc8_ = true;
                  }
                  else
                  {
                     _loc8_ = false;
                  }
                  if(_loc8_)
                  {
                     if(param2 == param3)
                     {
                        _loc7_ = uint(this.keyRecord[param2].lastTwoDownTime());
                        if(_loc6_ - _loc7_ < this.downAndDownTime)
                        {
                           _loc4_ = true;
                        }
                     }
                     else
                     {
                        _loc7_ = uint(this.keyRecord[param2].lastOneDownTime());
                        if(_loc6_ - _loc7_ < 0)
                        {
                           _loc7_ = uint(this.keyRecord[param2].lastTwoDownTime());
                        }
                        if(_loc6_ - _loc7_ < this.downAndDownTime)
                        {
                           _loc4_ = true;
                        }
                     }
                  }
               }
               break;
            case TWOKEY_DOWN:
               if(param2 != param3)
               {
                  _loc6_ = uint(this.keyRecord[param3].lastOneDownTime());
                  _loc9_ = false;
                  if(_loc5_ - _loc6_ < this.downEffectTime)
                  {
                     if(this.keyRecord[param2].isUp())
                     {
                        _loc9_ = false;
                     }
                     else
                     {
                        _loc9_ = true;
                     }
                     if(_loc9_)
                     {
                        _loc7_ = uint(this.keyRecord[param2].lastOneDownTime());
                        if(_loc6_ - _loc7_ < 0)
                        {
                           _loc7_ = uint(this.keyRecord[param2].lastTwoDownTime());
                        }
                        if(_loc6_ - _loc7_ < this.downAndDownTime)
                        {
                           _loc4_ = true;
                        }
                     }
                  }
               }
               break;
            case TWOKEY_DOWN_B:
               if(param2 != param3)
               {
                  _loc6_ = uint(this.keyRecord[param3].lastOneDownTime());
                  if(_loc5_ - _loc6_ < this.downEffectTime)
                  {
                     if(this.keyRecord[param2].isUp())
                     {
                        _loc4_ = false;
                     }
                     else
                     {
                        _loc4_ = true;
                     }
                  }
               }
               break;
            case TWOKEY_DOWN_C:
               if(param2 != param3)
               {
                  if(!this.keyRecord[param2].isUp())
                  {
                     if(!this.keyRecord[param3].isUp())
                     {
                        _loc4_ = true;
                     }
                  }
               }
               break;
            case TWOKEY_TWODOWN:
               if(param2 != param3)
               {
                  _loc6_ = uint(this.keyRecord[param3].lastOneDownTime());
                  _loc7_ = uint(this.keyRecord[param2].lastOneDownTime());
                  if(_loc5_ - _loc6_ < this.downEffectTime && _loc5_ - _loc7_ < this.downEffectTime)
                  {
                     _loc4_ = true;
                  }
               }
               break;
            default:
               _loc4_ = false;
         }
         return _loc4_;
      }
      
      public function isOkByThree(param1:uint, param2:uint, param3:uint, param4:uint) : Boolean
      {
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         var _loc9_:uint = 0;
         var _loc5_:Boolean = false;
         var _loc6_:uint = uint(getTimer());
         switch(param1)
         {
            case THREEKEY_COMMON:
               _loc7_ = uint(this.keyRecord[param4].lastOneDownTime());
               if(_loc6_ - _loc7_ < this.downEffectTime)
               {
                  if(param3 == param4 && param2 == param3)
                  {
                     _loc8_ = uint(this.keyRecord[param3].lastTwoDownTime());
                     if(_loc7_ - _loc8_ < this.downAndDownTime)
                     {
                        _loc9_ = uint(this.keyRecord[param2].lastThreeDownTime());
                        if(_loc8_ - _loc9_ < this.downAndDownTime)
                        {
                           _loc5_ = true;
                        }
                     }
                  }
                  else if(param3 == param4 && param2 != param3)
                  {
                     _loc8_ = uint(this.keyRecord[param3].lastTwoDownTime());
                     if(_loc7_ - _loc8_ < this.downAndDownTime)
                     {
                        _loc9_ = uint(this.keyRecord[param2].lastOneDownTime());
                        if(_loc8_ - _loc9_ < 0)
                        {
                           _loc9_ = uint(this.keyRecord[param2].lastTwoDownTime());
                        }
                        if(_loc8_ - _loc9_ < this.downAndDownTime)
                        {
                           _loc5_ = true;
                        }
                     }
                  }
                  else if(param3 != param4 && param2 == param3)
                  {
                     _loc8_ = uint(this.keyRecord[param3].lastOneDownTime());
                     if(_loc7_ - _loc8_ < 0)
                     {
                        _loc8_ = uint(this.keyRecord[param3].lastTwoDownTime());
                        _loc9_ = uint(this.keyRecord[param2].lastThreeDownTime());
                     }
                     else
                     {
                        _loc9_ = uint(this.keyRecord[param2].lastTwoDownTime());
                     }
                     if(_loc7_ - _loc8_ < this.downAndDownTime && _loc8_ - _loc9_ < this.downAndDownTime)
                     {
                        _loc5_ = true;
                     }
                  }
                  else if(param3 != param4 && param2 != param3 && param2 == param4)
                  {
                     _loc8_ = uint(this.keyRecord[param3].lastOneDownTime());
                     if(_loc7_ - _loc8_ < 0)
                     {
                        _loc8_ = uint(this.keyRecord[param3].lastTwoDownTime());
                     }
                     if(_loc7_ - _loc8_ < this.downAndDownTime)
                     {
                        _loc9_ = uint(this.keyRecord[param2].lastTwoDownTime());
                        if(_loc8_ - _loc9_ < this.downAndDownTime)
                        {
                           _loc5_ = true;
                        }
                     }
                  }
                  else if(param3 != param4 && param2 != param3 && param2 != param4)
                  {
                     _loc8_ = uint(this.keyRecord[param3].lastOneDownTime());
                     if(_loc7_ - _loc8_ < 0)
                     {
                        _loc8_ = uint(this.keyRecord[param3].lastTwoDownTime());
                     }
                     if(_loc7_ - _loc8_ < this.downAndDownTime)
                     {
                        _loc9_ = uint(this.keyRecord[param2].lastOneDownTime());
                        if(_loc8_ - _loc9_ < 0)
                        {
                           _loc9_ = uint(this.keyRecord[param2].lastTwoDownTime());
                        }
                        if(_loc8_ - _loc9_ < this.downAndDownTime)
                        {
                           _loc5_ = true;
                        }
                     }
                  }
               }
               break;
            case THREEKEY_TWODOWN:
               if(param3 != param4 && param2 != param3 && param2 != param4)
               {
                  _loc7_ = uint(this.keyRecord[param4].lastOneDownTime());
                  if(_loc6_ - _loc7_ < this.downEffectTime)
                  {
                     if(!this.keyRecord[param3].isUp() && !this.keyRecord[param2].isUp())
                     {
                        _loc8_ = uint(this.keyRecord[param3].lastOneDownTime());
                        _loc9_ = uint(this.keyRecord[param2].lastOneDownTime());
                        if(_loc7_ - _loc8_ < this.downAndDownTime && _loc7_ - _loc9_ < this.downAndDownTime && _loc7_ - _loc8_ > 0 && _loc7_ - _loc9_ > 0)
                        {
                           _loc5_ = true;
                        }
                     }
                  }
               }
               break;
            case THREEKEY_TWODOWNONE:
               if(this.keyRecord[param3].isUp())
               {
                  _loc8_ = uint(this.keyRecord[param3].lastOneDownTime());
                  if(_loc6_ - _loc8_ < this.downEffectTime)
                  {
                     if(param2 == param3)
                     {
                        _loc9_ = uint(this.keyRecord[param2].lastTwoDownTime());
                        if(_loc8_ - _loc9_ < this.downAndDownTime)
                        {
                           _loc5_ = true;
                        }
                     }
                     else
                     {
                        _loc9_ = uint(this.keyRecord[param2].lastOneDownTime());
                        if(_loc8_ - _loc9_ < 0)
                        {
                           _loc9_ = uint(this.keyRecord[param2].lastTwoDownTime());
                        }
                        if(_loc8_ - _loc9_ < this.downAndDownTime)
                        {
                           _loc5_ = true;
                        }
                     }
                  }
               }
               else
               {
                  _loc8_ = uint(this.keyRecord[param3].lastOneDownTime());
                  if(param2 == param3)
                  {
                     _loc9_ = uint(this.keyRecord[param2].lastTwoDownTime());
                     if(_loc8_ - _loc9_ < this.downAndDownTime)
                     {
                        _loc5_ = true;
                     }
                  }
                  else
                  {
                     _loc9_ = uint(this.keyRecord[param2].lastOneDownTime());
                     if(_loc8_ - _loc9_ < 0)
                     {
                        _loc9_ = uint(this.keyRecord[param2].lastTwoDownTime());
                     }
                     if(_loc8_ - _loc9_ < this.downAndDownTime)
                     {
                        _loc5_ = true;
                     }
                  }
               }
               if(_loc5_)
               {
                  if(!this.keyRecord[param4].isUp())
                  {
                     _loc5_ = true;
                  }
                  else
                  {
                     _loc5_ = false;
                  }
               }
               break;
            default:
               _loc5_ = false;
         }
         return _loc5_;
      }
   }
}

