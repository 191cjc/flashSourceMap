package hotpointgame.glevel
{
   import com.adobeadobe.serialization.json.JSON;
   import hotpointgame.common.*;
   import hotpointgame.glevel.leveldata.*;
   import hotpointgame.utils.*;
   
   public class LevelDataManager
   {
      
      private static var Cbo:Object = new Object();
      
      private static var Cdoor:Object = new Object();
      
      private static var Croom:Object = new Object();
      
      private static var Csce:Object = new Object();
      
      private static var Clel:Object = new Object();
      
      private static var lbd:LevelBDList = new LevelBDList();
      
      private static var newlevelshowls:Array = new Array();
      
      public function LevelDataManager()
      {
         super();
      }
      
      public static function createCbo(param1:XML, param2:int) : void
      {
         var _loc3_:Object = null;
         var _loc4_:XML = null;
         for each(_loc4_ in param1.刷怪列表)
         {
            _loc3_ = new Object();
            _loc3_.name = String(_loc4_.波数名称);
            _loc3_.twon = String(_loc4_.二名);
            _loc3_.tj = com.adobeadobe.serialization.json.JSON.decode(String(_loc4_.条件));
            _loc3_.bo = com.adobeadobe.serialization.json.JSON.decode(String(_loc4_.波数刷怪信息));
            Cbo["" + _loc3_.name + param2] = _loc3_;
         }
      }
      
      public static function createCdoor(param1:XML) : void
      {
         var _loc2_:XML = null;
         var _loc3_:String = null;
         for each(_loc2_ in param1.传送门)
         {
            _loc3_ = "";
            if(String(_loc2_.传送门显示名字) != "null")
            {
               _loc3_ = String(_loc2_.传送门显示名字);
            }
            Cdoor[String(_loc2_.名字)] = new SendDoor(String(_loc2_.名字),String(_loc2_.传送门属于场景),_loc3_,String(_loc2_.传送门元件),com.adobeadobe.serialization.json.JSON.decode(String(_loc2_.出现条件)),UTools.sTnArr(String(_loc2_.出现位置).split(",")),UTools.sTnArr(String(_loc2_.有效区域).split(",")),Number(_loc2_.使用方式),com.adobeadobe.serialization.json.JSON.decode(String(_loc2_.目的地)),Number(_loc2_.使用次数));
         }
      }
      
      public static function createCroom(param1:XML, param2:int) : void
      {
         var _loc3_:Object = null;
         var _loc4_:XML = null;
         var _loc5_:Array = null;
         var _loc6_:Array = null;
         var _loc7_:String = null;
         for each(_loc4_ in param1.房间)
         {
            _loc3_ = new Object();
            _loc3_.id = Number(_loc4_.房间ID);
            _loc3_._name = String(_loc4_.房间名字);
            _loc3_._classname = String(_loc4_.类名);
            _loc3_._bsound = String(_loc4_.背景音乐);
            _loc3_._sname = String(_loc4_.归属支线);
            _loc3_._douHuaMcname = String(_loc4_.显示名字);
            _loc3_._lname = String(_loc4_.归属关卡);
            _loc3_._pFoot = Number(_loc4_.房间玩家脚点);
            _loc3_.enum = Number(_loc4_.刷怪上限);
            _loc3_.rtoup = UTools.sTnArrInP(String(_loc4_.拖屏范围).split(","));
            _loc3_.rlp = UTools.sTnArrInP(String(_loc4_.玩家锁屏范围).split(","));
            _loc3_.rlm = UTools.sTnArrInP(String(_loc4_.怪物锁屏范围).split(","));
            _loc3_._type = Number(_loc4_.房间类型);
            _loc3_.beffect = Number(_loc4_.启用标识);
            _loc3_.tiaozhanglv = VT.createVT(Number(_loc4_.层数));
            _loc3_.rtoupb = UTools.sTnArrInP(String(_loc4_.关卡完成拖屏范围).split(","));
            _loc3_.rlpb = UTools.sTnArrInP(String(_loc4_.通关后玩家锁屏范围).split(","));
            _loc3_.resetFlag = Number(_loc4_.重新完成);
            if(String(_loc4_.首次刷怪列表) == "null")
            {
               _loc3_.oneMonser = [];
            }
            else
            {
               _loc3_.oneMonser = String(_loc4_.首次刷怪列表).split(",");
            }
            if(String(_loc4_.二次刷怪列表) == "null")
            {
               _loc3_.twoMonser = [];
            }
            else
            {
               _loc3_.twoMonser = String(_loc4_.二次刷怪列表).split(",");
            }
            if(String(_loc4_.障碍物) == "null")
            {
               _loc3_.zhanaiwulist = [];
            }
            else
            {
               _loc3_.zhanaiwulist = String(_loc4_.障碍物).split("#");
            }
            if(String(_loc4_.场景道具) == "null")
            {
               _loc3_.mapgood = [];
            }
            else
            {
               _loc5_ = String(_loc4_.场景道具).split("|");
               _loc6_ = [];
               for each(_loc7_ in _loc5_)
               {
                  _loc6_[_loc6_.length] = UTools.sTnArrAndVT(_loc7_.split(","));
               }
               _loc3_.mapgood = _loc6_;
            }
            _loc3_.lstar = VT.createVT(param2);
            _loc3_.oneFlag = com.adobeadobe.serialization.json.JSON.decode(String(_loc4_.过关条件));
            _loc3_.twoFlag = com.adobeadobe.serialization.json.JSON.decode(String(_loc4_.二次过关条件));
            _loc3_.nexroom = com.adobeadobe.serialization.json.JSON.decode(String(_loc4_.下一房间列表));
            Croom["" + _loc3_._name + param2] = _loc3_;
         }
      }
      
      public static function createCsce(param1:XML, param2:int) : void
      {
         var _loc3_:Object = null;
         var _loc4_:XML = null;
         for each(_loc4_ in param1.场景)
         {
            _loc3_ = new Object();
            _loc3_.id = Number(_loc4_.场景ID);
            _loc3_._name = String(_loc4_.场景名);
            _loc3_.swfList = String(_loc4_.加载需求).split(",");
            _loc3_.mcclass = String(_loc4_.场景元件);
            _loc3_._touPx = Number(_loc4_.X轴拖屏);
            _loc3_._touPy = Number(_loc4_.Y轴拖屏);
            _loc3_.roomObj = String(_loc4_.房间列表).split(",");
            _loc3_._sceSpeed = UTools.sTnArr(String(_loc4_.场景速度).split(","));
            _loc3_.lstar = VT.createVT(param2);
            if(String(_loc4_.传送门列表) == "null")
            {
               _loc3_.doorList = [];
            }
            else
            {
               _loc3_.doorList = String(_loc4_.传送门列表).split(",");
            }
            Csce["" + _loc3_._name + param2] = _loc3_;
         }
      }
      
      public static function createClel(param1:XML) : void
      {
         var _loc2_:Object = null;
         var _loc3_:LevelBD = null;
         var _loc4_:XML = null;
         var _loc5_:Object = null;
         var _loc6_:Array = null;
         var _loc7_:Array = null;
         var _loc8_:String = null;
         for each(_loc4_ in param1.关卡)
         {
            _loc2_ = new Object();
            _loc3_ = new LevelBD();
            _loc2_.id = VT.createVT(Number(_loc4_.关卡ID));
            _loc3_.id = Number(_loc4_.关卡ID);
            _loc2_._name = String(_loc4_.关卡名);
            _loc3_.lname = String(_loc4_.关卡名);
            _loc3_.enterSe = String(_loc4_.进入场景);
            _loc3_.enterRm = String(_loc4_.进入房间);
            _loc3_.enterX = Number(_loc4_.进入X);
            _loc3_.enterY = Number(_loc4_.进入Y);
            _loc2_._dname = String(_loc4_.归属大关);
            _loc2_._diff = VT.createVT(Number(_loc4_.难度));
            _loc2_._enterlid = VT.createVT(Number(_loc4_.进入条件ID));
            _loc3_.enterlid = Number(_loc4_.进入条件ID);
            _loc2_._enterpid = VT.createVT(Number(_loc4_.物品ID));
            _loc3_.enterpid = Number(_loc4_.物品ID);
            _loc2_._passach = VT.createVT(Number(_loc4_.过关需求关卡成就));
            _loc3_.passach = Number(_loc4_.过关需求关卡成就);
            _loc2_._mach = VT.createVT(Number(_loc4_.成就最大值));
            _loc3_.maxach = Number(_loc4_.成就最大值);
            _loc5_ = com.adobeadobe.serialization.json.JSON.decode(String(_loc4_.成就奖励经验));
            if(!_loc5_.hasOwnProperty("cj"))
            {
               _loc5_.cj = [];
               _loc5_.sz = [];
            }
            _loc2_._achexpkey = UTools.sTnArrAndVT(_loc5_.cj);
            _loc2_._achexpvalue = UTools.sTnArrAndVT(_loc5_.sz);
            _loc5_ = com.adobeadobe.serialization.json.JSON.decode(String(_loc4_.成就奖励金币));
            if(!_loc5_.hasOwnProperty("cj"))
            {
               _loc5_.cj = [];
               _loc5_.sz = [];
            }
            _loc2_._achgodkey = UTools.sTnArrAndVT(_loc5_.cj);
            _loc2_._achgodvalue = UTools.sTnArrAndVT(_loc5_.sz);
            _loc2_._awardfixexp = VT.createVT(Number(_loc4_.过关奖励经验));
            _loc2_._awardfixgod = VT.createVT(Number(_loc4_.过关奖励金币));
            _loc2_._awardfixach = VT.createVT(Number(_loc4_.过关奖励成就));
            if(String(_loc4_.剩余生命额外奖励) != null)
            {
               _loc2_._awardblife = UTools.sTnArrAndVT(String(_loc4_.剩余生命额外奖励).split(","));
            }
            else
            {
               _loc2_._awardblife = [];
            }
            if(String(_loc4_.中立怪个数) != null)
            {
               _loc2_._awardbmoney = UTools.sTnArrAndVT(String(_loc4_.中立怪个数).split(","));
            }
            else
            {
               _loc2_._awardbmoney = [];
            }
            if(String(_loc4_.被击数) != null)
            {
               _loc2_._awardbhit = UTools.sTnArrAndVT(String(_loc4_.被击数).split(","));
            }
            else
            {
               _loc2_._awardbhit = [];
            }
            _loc5_ = com.adobeadobe.serialization.json.JSON.decode(String(_loc4_.经验等级惩罚));
            if(!_loc5_.hasOwnProperty("lv"))
            {
               _loc5_.lv = [];
               _loc5_.sz = [];
            }
            _loc2_._punexpkey = UTools.sTnArrAndVT(_loc5_.lv);
            _loc2_._punexpvalue = UTools.sTnArrAndVT(_loc5_.sz);
            _loc5_ = com.adobeadobe.serialization.json.JSON.decode(String(_loc4_.晶币等级惩罚));
            if(!_loc5_.hasOwnProperty("lv"))
            {
               _loc5_.lv = [];
               _loc5_.sz = [];
            }
            _loc2_._pungodkey = UTools.sTnArrAndVT(_loc5_.lv);
            _loc2_._pungodvalue = UTools.sTnArrAndVT(_loc5_.sz);
            if(String(_loc4_.开牌奖励) != "null")
            {
               _loc6_ = String(_loc4_.开牌奖励).split("#");
               _loc7_ = new Array();
               for each(_loc8_ in _loc6_)
               {
                  _loc7_.push(UTools.sTnArrAndVT(_loc8_.split(",")));
               }
               _loc2_._kaipai = _loc7_;
            }
            else
            {
               _loc2_._kaipai = [];
            }
            if(String(_loc4_.关卡元件) == "null")
            {
               _loc2_.mcclass = [];
            }
            else
            {
               _loc2_.mcclass = String(_loc4_.关卡元件).split(",");
            }
            _loc2_.sceneList = String(_loc4_.场景列表).split(",");
            Clel[_loc2_._name + Number(_loc4_.难度)] = _loc2_;
            lbd.addBD(_loc3_);
         }
      }
      
      public static function initnewlevelshowbd(param1:XML) : void
      {
         var _loc2_:XML = null;
         var _loc3_:NewLevelShowBD = null;
         for each(_loc2_ in param1.异星战场)
         {
            _loc3_ = new NewLevelShowBD();
            _loc3_.id = int(_loc2_.关卡ID) - 2000;
            _loc3_.suggAtt = Number(_loc2_.推荐战斗力);
            _loc3_.addAward(String(_loc2_.奖励));
            newlevelshowls[_loc3_.id] = _loc3_;
         }
      }
      
      public static function getCLevel(param1:String) : CLevel
      {
         return new CLevel(Clel[param1]);
      }
      
      public static function getCLevelPkaward() : Array
      {
         return Clel["竞技场" + GS.a1]._kaipai;
      }
      
      public static function getCscene(param1:String) : CScene
      {
         return new CScene(Csce[param1]);
      }
      
      public static function getCroom(param1:String) : CRoom
      {
         var _loc2_:Object = Croom[param1];
         return new (ClassGet.getClassByNameAndAlias(_loc2_._classname))(_loc2_);
      }
      
      public static function getMBO(param1:String) : Object
      {
         return Cbo[param1];
      }
      
      public static function getSeedDoor(param1:String) : SendDoor
      {
         var _loc2_:SendDoor = Cdoor[param1] as SendDoor;
         _loc2_.useTimesCur = _loc2_.useTimesMax;
         return _loc2_;
      }
      
      public static function getLevelBD(param1:int) : LevelBD
      {
         return lbd.getBD(param1);
      }
      
      public static function getTotalMaxAch(param1:Array) : int
      {
         return lbd.getTotalMaxAch(param1);
      }
      
      public static function getLidByName(param1:String) : int
      {
         return lbd.getLidByName(param1);
      }
      
      public static function getNewLevelBd(param1:int) : NewLevelShowBD
      {
         return newlevelshowls[param1];
      }
   }
}

