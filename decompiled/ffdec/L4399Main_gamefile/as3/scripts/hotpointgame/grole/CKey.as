package hotpointgame.grole
{
   import flash.display.Stage;
   import flash.ui.*;
   import flash.utils.*;
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   import hotpointgame.utils.keyboard.*;
   
   public class CKey
   {
      
      private var gameKeyboard:GameKeyboard;
      
      private var onlineArr:Array = ["左跑","右跑","左按住","右按住","上按住","下按住","聊天","攻击"];
      
      private var keyObj:Object = {
         "左":Keyboard.A,
         "右":Keyboard.D,
         "上":Keyboard.W,
         "下":Keyboard.S,
         "跳":Keyboard.K,
         "攻击":Keyboard.J,
         "跳冲":Keyboard.SPACE,
         "技能1":Keyboard.H,
         "技能2":Keyboard.U,
         "技能3":Keyboard.I,
         "技能4":Keyboard.O,
         "技能5":Keyboard.L,
         "技能6":Keyboard.N,
         "人形":Keyboard.Q,
         "原形":Keyboard.E,
         "枪攻":Keyboard.J,
         "剑攻":Keyboard.H,
         "传送门":Keyboard.W,
         "捡东西":Keyboard.SPACE,
         "聊天":Keyboard.ENTER,
         "引爆地雷":Keyboard.F,
         "宠物复活":Keyboard.E,
         "复活":Keyboard.J,
         "1":Keyboard.NUMBER_1,
         "2":Keyboard.NUMBER_2,
         "3":Keyboard.NUMBER_3,
         "4":Keyboard.NUMBER_4,
         "5":Keyboard.NUMBER_5,
         "G":Keyboard.G
      };
      
      private var isKeyObj:Object = new Object();
      
      private var filterObj:Object = new Object();
      
      public function CKey(param1:Stage)
      {
         super();
         this.initKey();
         this.initfilter();
         this.gameKeyboard = new GameKeyboard(param1);
         this.gameKeyboard.startListener();
      }
      
      public function initfilter() : void
      {
         this.filterObj["传送门"] = 0;
         this.filterObj["捡东西"] = 0;
         this.filterObj["聊天"] = 0;
         this.filterObj["去人形"] = 0;
         this.filterObj["5"] = 0;
      }
      
      public function initKey() : void
      {
         this.isKeyObj["左跑"] = [GameKeyboard.TWOKEY_COMMON_DOWN,this.keyObj["左"],this.keyObj["左"]];
         this.isKeyObj["右跑"] = [GameKeyboard.TWOKEY_COMMON_DOWN,this.keyObj["右"],this.keyObj["右"]];
         this.isKeyObj["左按住"] = [GameKeyboard.ONEKEY_DOWN_DOWN,this.keyObj["左"]];
         this.isKeyObj["右按住"] = [GameKeyboard.ONEKEY_DOWN_DOWN,this.keyObj["右"]];
         this.isKeyObj["上按住"] = [GameKeyboard.ONEKEY_DOWN_DOWN,this.keyObj["上"]];
         this.isKeyObj["下按住"] = [GameKeyboard.ONEKEY_DOWN_DOWN,this.keyObj["下"]];
         this.isKeyObj["去人形"] = [GameKeyboard.ONEKEY_DOWN_DOWN,this.keyObj["人形"]];
         this.isKeyObj["去原形"] = [GameKeyboard.ONEKEY_DOWN_DOWN,this.keyObj["原形"]];
         this.isKeyObj["枪攻"] = [GameKeyboard.ONEKEY_DOWN_DOWN,this.keyObj["枪攻"]];
         this.isKeyObj["剑攻"] = [GameKeyboard.ONEKEY_DOWN_DOWN,this.keyObj["剑攻"]];
         this.isKeyObj["跳"] = [GameKeyboard.ONEKEY_DOWN_DOWN,this.keyObj["跳"]];
         this.isKeyObj["攻击"] = [GameKeyboard.ONEKEY_DOWN_DOWN,this.keyObj["攻击"]];
         this.isKeyObj["跳冲"] = [GameKeyboard.ONEKEY_DOWN_DOWN,this.keyObj["跳冲"]];
         this.isKeyObj["阶段1"] = [GameKeyboard.TWOKEY_DOWN_C,this.keyObj["上"],this.keyObj["技能1"]];
         this.isKeyObj["技能1"] = [GameKeyboard.TWOKEY_DOWN_B,this.keyObj["下"],this.keyObj["攻击"]];
         this.isKeyObj["技能2"] = [GameKeyboard.ONEKEY_DOWN_DOWN,this.keyObj["技能1"]];
         this.isKeyObj["技能3"] = [GameKeyboard.ONEKEY_DOWN_DOWN,this.keyObj["技能2"]];
         this.isKeyObj["技能4"] = [GameKeyboard.ONEKEY_DOWN_DOWN,this.keyObj["技能3"]];
         this.isKeyObj["技能5"] = [GameKeyboard.ONEKEY_DOWN_DOWN,this.keyObj["技能4"]];
         this.isKeyObj["技能6"] = [GameKeyboard.ONEKEY_DOWN_DOWN,this.keyObj["技能5"]];
         this.isKeyObj["技能7"] = [GameKeyboard.ONEKEY_DOWN_DOWN,this.keyObj["技能6"]];
         this.isKeyObj["机甲技能1"] = [GameKeyboard.ONEKEY_DOWN_DOWN,this.keyObj["技能2"]];
         this.isKeyObj["机甲技能2"] = [GameKeyboard.ONEKEY_DOWN_DOWN,this.keyObj["技能3"]];
         this.isKeyObj["机甲技能3"] = [GameKeyboard.ONEKEY_DOWN_DOWN,this.keyObj["技能4"]];
         this.isKeyObj["机甲技能4"] = [GameKeyboard.ONEKEY_DOWN_DOWN,this.keyObj["技能5"]];
         this.isKeyObj["引爆地雷"] = [GameKeyboard.ONEKEY_DOWN_DOWN,this.keyObj["引爆地雷"]];
         this.isKeyObj["聊天"] = [GameKeyboard.ONEKEY_CLICK,this.keyObj["聊天"]];
         this.isKeyObj["复活"] = [GameKeyboard.ONEKEY_CLICK,this.keyObj["复活"]];
         this.isKeyObj["宠物复活"] = [GameKeyboard.ONEKEY_CLICK,this.keyObj["宠物复活"]];
         this.isKeyObj["捡东西"] = [GameKeyboard.ONEKEY_DOWN_DOWN,this.keyObj["捡东西"]];
         this.isKeyObj["传送门"] = [GameKeyboard.ONEKEY_CLICK,this.keyObj["传送门"]];
         this.isKeyObj["G"] = [GameKeyboard.ONEKEY_CLICK,this.keyObj["G"]];
         this.isKeyObj["1"] = [GameKeyboard.ONEKEY_CLICK,this.keyObj["1"]];
         this.isKeyObj["2"] = [GameKeyboard.ONEKEY_CLICK,this.keyObj["2"]];
         this.isKeyObj["3"] = [GameKeyboard.ONEKEY_CLICK,this.keyObj["3"]];
         this.isKeyObj["4"] = [GameKeyboard.ONEKEY_CLICK,this.keyObj["4"]];
         this.isKeyObj["5"] = [GameKeyboard.ONEKEY_CLICK,this.keyObj["5"]];
      }
      
      public function isKey(param1:String) : Boolean
      {
         var _loc4_:int = 0;
         if(Boolean(GM.onlineM.isConnectLine()) && GM.levelm.curLevel != null && GM.levelm.curLevel.id == GS.a9999)
         {
            if(this.onlineArr.indexOf(param1) == -1)
            {
               return false;
            }
         }
         if(getQualifiedClassName(Main.sg.focus) == "flash.text::TextField" && param1 != "聊天")
         {
            return false;
         }
         var _loc2_:Boolean = false;
         var _loc3_:Array = this.isKeyObj[param1];
         if(_loc3_)
         {
            _loc4_ = int(_loc3_[0]);
            if(_loc4_ <= 10)
            {
               _loc2_ = Boolean(this.gameKeyboard.isOkByOne(_loc3_[0],_loc3_[1]));
            }
            else if(_loc4_ <= 100)
            {
               _loc2_ = Boolean(this.gameKeyboard.isOkByTwo(_loc3_[0],_loc3_[1],_loc3_[2]));
            }
            else
            {
               _loc2_ = Boolean(this.gameKeyboard.isOkByThree(_loc3_[0],_loc3_[1],_loc3_[2],_loc3_[3]));
            }
         }
         if(_loc2_)
         {
            if(this.filterObj.hasOwnProperty(param1))
            {
               if(GM.frameTime - this.filterObj[param1] < 5)
               {
                  return false;
               }
               this.filterObj[param1] = GM.frameTime;
               return _loc2_;
            }
         }
         return _loc2_;
      }
   }
}

