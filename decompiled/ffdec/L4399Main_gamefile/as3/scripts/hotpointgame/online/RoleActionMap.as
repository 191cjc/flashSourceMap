package hotpointgame.online
{
   public class RoleActionMap
   {
      
      private var insMap:Array = new Array();
      
      private var stringMint:Object = new Object();
      
      private var actionMint:Object = new Object();
      
      public function RoleActionMap()
      {
         super();
         this.insMap = ["不用","待机","走","跑","跳","攻击","技能1","技能2","技能3","技能4","技能5","技能6","技能7","阶段1","阶段2","阶段3","阶段4","普通武器跳击","跑攻","跳冲","倒地","被打","冰冻","眩晕","水泡","束缚","石化","死亡","起身",undefined,"普通武器跳击1","普通武器跳击2","跳冲1","跳冲2","引爆","仅方向","方向走","方向跑"];
         var _loc1_:int = 1;
         while(_loc1_ < this.insMap.length)
         {
            this.stringMint["-" + _loc1_] = [-1,this.insMap[_loc1_]];
            this.stringMint["" + _loc1_] = [1,this.insMap[_loc1_]];
            this.actionMint["-1" + this.insMap[_loc1_]] = -1 * _loc1_;
            this.actionMint["1" + this.insMap[_loc1_]] = _loc1_;
            _loc1_++;
         }
      }
      
      public function getForthAndAction(param1:int) : Array
      {
         return this.stringMint["" + param1];
      }
      
      public function getIntByfa(param1:int, param2:String) : int
      {
         if(this.actionMint["" + param1 + param2] != null)
         {
            return this.actionMint["" + param1 + param2];
         }
         return 0;
      }
   }
}

