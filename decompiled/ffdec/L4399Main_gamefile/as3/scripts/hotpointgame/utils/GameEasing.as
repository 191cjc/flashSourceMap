package hotpointgame.utils
{
   import hotpointgame.common.*;
   
   public class GameEasing
   {
      
      public function GameEasing()
      {
         super();
      }
      
      public static function createRunArray(param1:Number = 0, param2:Number = 0, param3:int = 0, param4:int = 0) : Array
      {
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc5_:Array = [];
         if(param3 <= 3)
         {
            param4 = 0;
         }
         switch(param4)
         {
            case 0:
               _loc5_ = [param1 / param3,param2 / param3,0,0,param3,GS.a1];
               break;
            case 1:
               _loc6_ = Number(GS.a07);
               _loc7_ = param1 / param3 * _loc6_;
               _loc8_ = param2 / param3 * _loc6_;
               _loc9_ = param1 * (GS.a1 - _loc6_) / (param3 * param3 - param3 * (param3 - GS.a1) / GS.a2);
               _loc10_ = param2 * (GS.a1 - _loc6_) / (param3 * param3 - param3 * (param3 - GS.a1) / GS.a2);
               _loc5_ = [_loc7_,_loc8_,_loc9_,_loc10_,param3,GS.a1];
               break;
            case 2:
               _loc11_ = Number(GS.a03);
               _loc12_ = param1 / param3 * _loc11_;
               _loc13_ = param2 / param3 * _loc11_;
               _loc14_ = param1 * (GS.a1 - _loc11_) / (param3 * param3 - param3 * (param3 - GS.a1) / GS.a2);
               _loc15_ = param2 * (GS.a1 - _loc11_) / (param3 * param3 - param3 * (param3 - GS.a1) / GS.a2);
               _loc5_ = [_loc12_,_loc13_,_loc14_,_loc15_,param3,param3];
               break;
            default:
               _loc5_ = [0,0,0,0,0,0];
         }
         return _loc5_;
      }
      
      public static function getSpeedArray(param1:Array) : Array
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:* = int(param1.length - 1);
         while(_loc4_ >= 0)
         {
            if(param1[_loc4_][4] > 0)
            {
               _loc2_ += param1[_loc4_][0] + param1[_loc4_][2] * (Math.abs(param1[_loc4_][5] - param1[_loc4_][4]) + GS.a1);
               _loc3_ += param1[_loc4_][1] + param1[_loc4_][3] * (Math.abs(param1[_loc4_][5] - param1[_loc4_][4]) + GS.a1);
               --param1[_loc4_][4];
            }
            else
            {
               param1.splice(_loc4_,1);
            }
            _loc4_--;
         }
         return [_loc2_,_loc3_];
      }
   }
}

