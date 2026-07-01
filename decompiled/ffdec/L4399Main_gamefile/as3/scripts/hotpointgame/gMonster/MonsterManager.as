package hotpointgame.gMonster
{
   import com.adobeadobe.serialization.json.JSON;
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   import hotpointgame.gaction.*;
   import hotpointgame.gameobj.*;
   import hotpointgame.pet.PetR;
   import hotpointgame.utils.*;
   import hotpointgame.utils.gameloader.*;
   
   public class MonsterManager
   {
      
      private static var mactionData:Object;
      
      private static var mActionArr:Object = new Object();
      
      private static var mDataArr:Object = new Object();
      
      public function MonsterManager()
      {
         super();
      }
      
      public static function creatMapGunMonster(param1:String, param2:Number, param3:Number) : ZhangDouT
      {
         var _loc4_:Object = getMData(param1);
         var _loc5_:Class = LoaderManager.getSwfClass(_loc4_.mcclassname) as Class;
         var _loc6_:Class = ClassGet.getClassByNameAndAlias(_loc4_.classname) as Class;
         var _loc7_:CMonsterMapGun = new _loc6_(new _loc5_(),param2,param3,_loc4_) as CMonsterMapGun;
         GM.levelm.addMapGunMonster(_loc7_);
         return _loc7_;
      }
      
      public static function creatMonster(param1:String, param2:Number, param3:Number) : ZhangDouT
      {
         var _loc4_:Object = getMData(param1);
         var _loc5_:Class = LoaderManager.getSwfClass(_loc4_.mcclassname) as Class;
         var _loc6_:Class = ClassGet.getClassByNameAndAlias(_loc4_.classname) as Class;
         var _loc7_:CMonster = new _loc6_(new _loc5_(),param2,param3,_loc4_) as CMonster;
         GM.levelm.addMonster(_loc7_);
         return _loc7_;
      }
      
      public static function creatMonsterBy100Add(param1:String, param2:Number, param3:Number, param4:int) : ZhangDouT
      {
         var _loc5_:Object = getMData(param1);
         var _loc6_:Class = LoaderManager.getSwfClass(_loc5_.mcclassname) as Class;
         var _loc7_:Class = ClassGet.getClassByNameAndAlias(_loc5_.classname) as Class;
         var _loc8_:CMonster = new _loc7_(new _loc6_(),param2,param3,_loc5_) as CMonster;
         _loc8_.mlevel = GM.cp.getZtLevel();
         var _loc9_:PetR = GM.aSaveData.petm.getFightingPet();
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         if(_loc9_ != null)
         {
            _loc10_ = _loc9_.getAtt() / GS.a2;
            _loc11_ = _loc9_.getHp() / GS.a2;
         }
         var _loc12_:VT = VT.createVT(GS.a1000);
         var _loc13_:VT = VT.createVT(GS.a1000);
         var _loc14_:VT = VT.createVT(GS.a1000);
         var _loc15_:VT = VT.createVT(GS.a1);
         var _loc16_:VT = VT.createVT(GS.a1);
         var _loc17_:VT = VT.createVT(GS.a1);
         switch(param4)
         {
            case GS.a106:
               _loc12_.setValue(GS.a50);
               _loc13_.setValue(GS.a40);
               _loc14_.setValue(GS.a10);
               _loc15_.setValue(GS.a10);
               _loc16_.setValue(GS.a30);
               _loc17_.setValue(GS.a50);
               break;
            case GS.a107:
               _loc12_.setValue(GS.a300 + GS.a50);
               _loc13_.setValue(GS.a6);
               _loc14_.setValue(GS.a10);
               _loc15_.setValue(GS.a10);
               _loc16_.setValue(GS.a30);
               _loc17_.setValue(GS.a50);
               break;
            case GS.a108:
               _loc12_.setValue(GS.a400);
               _loc13_.setValue(GS.a40);
               _loc14_.setValue(GS.a20);
               _loc15_.setValue(GS.a10);
               _loc16_.setValue(GS.a30);
               _loc17_.setValue(GS.a50);
               break;
            case GS.a109:
               _loc12_.setValue(GS.a100);
               _loc13_.setValue(GS.a100);
               _loc14_.setValue(GS.a10);
               _loc15_.setValue(GS.a6);
               _loc16_.setValue(GS.a20);
               _loc17_.setValue(GS.a4);
               break;
            case GS.a110:
               _loc12_.setValue(GS.a800);
               _loc13_.setValue(GS.a10);
               _loc14_.setValue(GS.a100 + GS.a60);
               _loc15_.setValue(GS.a3);
               _loc16_.setValue(GS.a30);
               _loc17_.setValue(GS.a2);
               break;
            case GS.a100 + GS.a12:
               _loc12_.setValue(GS.a800);
               _loc13_.setValue(GS.a10);
               _loc14_.setValue(GS.a100 + GS.a60);
               _loc15_.setValue(GS.a3);
               _loc16_.setValue(GS.a30);
               _loc17_.setValue(GS.a2);
               break;
            case GS.a100 + GS.a13:
               _loc12_.setValue(GS.a400);
               _loc13_.setValue(GS.a8);
               _loc14_.setValue(GS.a10);
               _loc15_.setValue(GS.a3);
               _loc16_.setValue(GS.a30);
               _loc17_.setValue(GS.a4);
               break;
            case GS.a100 + GS.a14:
               _loc12_.setValue(GS.a800);
               _loc13_.setValue(GS.a40);
               _loc14_.setValue(GS.a20);
               _loc15_.setValue(GS.a3);
               _loc16_.setValue(GS.a30);
               _loc17_.setValue(GS.a4);
               break;
            case GS.a100 + GS.a15:
               _loc12_.setValue(GS.a800);
               _loc13_.setValue(GS.a40);
               _loc14_.setValue(GS.a10);
               _loc15_.setValue(GS.a2);
               _loc16_.setValue(GS.a30);
               _loc17_.setValue(GS.a4);
               break;
            case GS.a100 + GS.a16:
               _loc12_.setValue(GS.a600);
               _loc13_.setValue(GS.a600);
               _loc14_.setValue(GS.a10);
               _loc15_.setValue(GS.a3);
               _loc16_.setValue(GS.a3);
               _loc17_.setValue(GS.a4);
               break;
            case GS.a4000 + GS.a1:
               _loc12_.setValue(GS.a800);
               _loc13_.setValue(GS.a40);
               _loc14_.setValue(GS.a20);
               _loc15_.setValue(GS.a2);
               _loc16_.setValue(GS.a20);
               _loc17_.setValue(GS.a3);
               break;
            case GS.a4000 + GS.a2:
               _loc12_.setValue(GS.a800);
               _loc13_.setValue(GS.a40);
               _loc14_.setValue(GS.a20);
               _loc15_.setValue(GS.a2);
               _loc16_.setValue(GS.a20);
               _loc17_.setValue(GS.a3);
               break;
            case GS.a4000 + GS.a3:
               _loc12_.setValue(GS.a800);
               _loc13_.setValue(GS.a40);
               _loc14_.setValue(GS.a20);
               _loc15_.setValue(GS.a2);
               _loc16_.setValue(GS.a20);
               _loc17_.setValue(GS.a3);
               break;
            case GS.a4000 + GS.a4:
               _loc12_.setValue(GS.a800);
               _loc13_.setValue(GS.a40);
               _loc14_.setValue(GS.a20);
               _loc15_.setValue(GS.a2);
               _loc16_.setValue(GS.a20);
               _loc17_.setValue(GS.a3);
               break;
            case GS.a4000 + GS.a5:
               _loc12_.setValue(GS.a800);
               _loc13_.setValue(GS.a40);
               _loc14_.setValue(GS.a20);
               _loc15_.setValue(GS.a2);
               _loc16_.setValue(GS.a20);
               _loc17_.setValue(GS.a3);
               break;
            case GS.a4000 + GS.a6:
               _loc12_.setValue(GS.a800);
               _loc13_.setValue(GS.a40);
               _loc14_.setValue(GS.a20);
               _loc15_.setValue(GS.a2);
               _loc16_.setValue(GS.a20);
               _loc17_.setValue(GS.a3);
               break;
            case GS.a4000 + GS.a7:
               _loc12_.setValue(GS.a800);
               _loc13_.setValue(GS.a40);
               _loc14_.setValue(GS.a20);
               _loc15_.setValue(GS.a2);
               _loc16_.setValue(GS.a20);
               _loc17_.setValue(GS.a3);
         }
         _loc8_.mHp = _loc8_.cHp = (GM.cp.getAttackValue() + _loc10_) * fuBenBossType(_loc8_.boostype,_loc14_.getValue(),_loc13_.getValue(),_loc12_.getValue());
         _loc8_.avalue = (GM.cp.getHpMax() + _loc11_) / fuBenBossType(_loc8_.boostype,_loc17_.getValue(),_loc16_.getValue(),_loc15_.getValue());
         _loc8_.mhpTnByRoleA();
         GM.levelm.addMonster(_loc8_);
         return _loc8_;
      }
      
      public static function creatMonsterBy1011Zhaohuan(param1:String, param2:Number, param3:Number) : ZhangDouT
      {
         var _loc4_:Object = getMData(param1);
         var _loc5_:Class = LoaderManager.getSwfClass(_loc4_.mcclassname) as Class;
         var _loc6_:Class = ClassGet.getClassByNameAndAlias(_loc4_.classname) as Class;
         var _loc7_:CMonster = new _loc6_(new _loc5_(),param2,param3,_loc4_) as CMonster;
         _loc7_.mlevel = GM.cp.getZtLevel();
         _loc7_.mHp = _loc7_.cHp = GM.cp.getAttackValue() * GS.a80;
         _loc7_.avalue = GM.cp.getHpMax() / GS.a30;
         _loc7_.mhpTnByRoleA();
         GM.levelm.addMonster(_loc7_);
         return _loc7_;
      }
      
      public static function creatMonsterByRoleAAndId1009(param1:String, param2:Number, param3:Number) : ZhangDouT
      {
         var _loc7_:CMonster = null;
         var _loc4_:Object = getMData(param1);
         var _loc5_:Class = LoaderManager.getSwfClass(_loc4_.mcclassname) as Class;
         var _loc6_:Class = ClassGet.getClassByNameAndAlias(_loc4_.classname) as Class;
         _loc7_ = new _loc6_(new _loc5_(),param2,param3,_loc4_) as CMonster;
         _loc7_.mlevel = GM.cp.getZtLevel();
         var _loc8_:PetR = GM.aSaveData.petm.getFightingPet();
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         if(_loc8_ != null)
         {
            _loc9_ = _loc8_.getAtt() / GS.a5;
            _loc10_ = _loc8_.getHp() / GS.a5;
         }
         _loc7_.mHp = _loc7_.cHp = (GM.cp.getAttackValue() + _loc9_) * GS.a25;
         var _loc11_:Number = GM.cp.getDefenceValue() / Math.pow((GM.cp.getZtLevel() + GS.a20 + GS.a2) * GS.a05,GS.a1 + GS.a01) * GS.a001;
         var _loc12_:Number = _loc11_ / (GS.a1 + _loc11_);
         _loc7_.avalue = (GM.cp.getHpMax() + _loc10_) / GS.a30 / (1 - _loc12_);
         _loc7_.mhpTnByRoleA();
         GM.levelm.addMonster(_loc7_);
         return _loc7_;
      }
      
      public static function creatMonsterByRoleA(param1:String, param2:Number, param3:Number) : ZhangDouT
      {
         var _loc4_:Object = getMData(param1);
         var _loc5_:Class = LoaderManager.getSwfClass(_loc4_.mcclassname) as Class;
         var _loc6_:Class = ClassGet.getClassByNameAndAlias(_loc4_.classname) as Class;
         var _loc7_:CMonster = new _loc6_(new _loc5_(),param2,param3,_loc4_) as CMonster;
         _loc7_.mlevel = GM.cp.getZtLevel();
         var _loc8_:PetR = GM.aSaveData.petm.getFightingPet();
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         if(_loc8_ != null)
         {
            _loc9_ = _loc8_.getAtt() / GS.a5;
            _loc10_ = _loc8_.getHp() / GS.a5;
         }
         _loc7_.mHp = _loc7_.cHp = (GM.cp.getAttackValue() + _loc9_) * GS.a300;
         var _loc11_:Number = GM.cp.getDefenceValue() / Math.pow((GM.cp.getZtLevel() + GS.a20 + GS.a2) * GS.a05,GS.a1 + GS.a01) * GS.a001;
         var _loc12_:Number = _loc11_ / (GS.a1 + _loc11_);
         _loc7_.avalue = (GM.cp.getHpMax() + _loc10_) / GS.a15 / (1 - _loc12_);
         _loc7_.mhpTnByRoleA();
         GM.levelm.addMonster(_loc7_);
         return _loc7_;
      }
      
      public static function creatMonsterByFuBen(param1:String, param2:Number, param3:Number, param4:int) : ZhangDouT
      {
         var _loc5_:Object = getMData(param1);
         var _loc6_:Class = LoaderManager.getSwfClass(_loc5_.mcclassname) as Class;
         var _loc7_:Class = ClassGet.getClassByNameAndAlias(_loc5_.classname) as Class;
         var _loc8_:CMonster = new _loc7_(new _loc6_(),param2,param3,_loc5_) as CMonster;
         var _loc9_:VT = VT.createVT(GS.a500);
         if(param4 == GS.a3000 || param4 == GS.a3000 + GS.a1)
         {
            _loc9_ = VT.createVT(fuBenBossType(_loc8_.boostype,GS.a10,GS.a30,GS.a40));
         }
         else if(param4 == GS.a3000 + GS.a2 || param4 == GS.a3000 + GS.a3)
         {
            _loc9_ = VT.createVT(fuBenBossType(_loc8_.boostype,GS.a15,GS.a70,GS.a70));
         }
         else if(param4 == GS.a3000 + GS.a4)
         {
            _loc9_ = VT.createVT(fuBenBossType(_loc8_.boostype,GS.a23,GS.a110,GS.a110));
         }
         else if(param4 == GS.a3000 + GS.a5 || param4 == GS.a3000 + GS.a6 || param4 == GS.a3000 + GS.a7)
         {
            _loc9_ = VT.createVT(fuBenBossType(_loc8_.boostype,GS.a23,GS.a90,GS.a110));
         }
         else if(param4 == GS.a3000 + GS.a8 || param4 == GS.a3000 + GS.a9)
         {
            _loc9_ = VT.createVT(fuBenBossType(_loc8_.boostype,GS.a30,GS.a110 + GS.a10,GS.a110 + GS.a10));
         }
         else if(param4 == GS.a3000 + GS.a10 || param4 == GS.a3000 + GS.a11 || param4 == GS.a3000 + GS.a12 || param4 == GS.a3000 + GS.a13)
         {
            _loc9_ = VT.createVT(fuBenBossType(_loc8_.boostype,GS.a10,GS.a40,GS.a50));
         }
         if(param4 == GS.a3000 + GS.a8 || param4 == GS.a3000 + GS.a9 || param4 == GS.a3000 + GS.a10 || param4 == GS.a3000 + GS.a11 || param4 == GS.a3000 + GS.a12 || param4 == GS.a3000 + GS.a13)
         {
            _loc8_.mHp = _loc8_.cHp = GM.cp.getAttackValue() * _loc9_.getValue() + _loc8_.mHp;
         }
         else
         {
            _loc8_.mHp = _loc8_.cHp = GM.cp.getAttackValue() * _loc9_.getValue();
         }
         _loc8_.mhpTnByRoleA();
         GM.levelm.addMonster(_loc8_);
         return _loc8_;
      }
      
      private static function fuBenBossType(param1:int, param2:int, param3:int, param4:int) : int
      {
         if(param1 == GS.a10)
         {
            return param4;
         }
         if(param1 == GS.a2)
         {
            return param3;
         }
         return param2;
      }
      
      public static function mdataInitByXml(param1:XML) : void
      {
         var _loc2_:Object = null;
         var _loc3_:XML = null;
         var _loc4_:Array = null;
         var _loc5_:Array = null;
         var _loc6_:Array = null;
         var _loc7_:Array = null;
         var _loc8_:CMDiaoLou = null;
         var _loc9_:Array = null;
         var _loc10_:Array = null;
         for each(_loc3_ in param1.怪物)
         {
            _loc2_ = new Object();
            if(String(_loc3_.怪物二名) == "null")
            {
               _loc2_.ername = "";
            }
            else
            {
               _loc2_.ername = String(_loc3_.怪物二名);
            }
            _loc2_.mname = String(_loc3_.怪物名);
            _loc2_.showname = String(_loc3_.真实名称);
            _loc2_.mlevel = VT.createVT(Number(_loc3_.怪物等级));
            _loc2_.touframe = Number(_loc3_.头像帧数);
            _loc2_.mtype = Number(_loc3_.类型);
            _loc2_.boostype = Number(_loc3_.怪物级别分类);
            _loc2_.zg = VT.createVT(Number(_loc3_.阵营));
            _loc2_.mhpunit = Number(_loc3_.血量条基数);
            _loc2_.mhp = VT.createVT(Number(_loc3_.血量));
            _loc2_.av = VT.createVT(Number(_loc3_.攻击力));
            _loc2_.dv = VT.createVT(Number(_loc3_.护甲));
            _loc2_.gv = VT.createVT(Number(_loc3_.重力));
            _loc2_.wuxi = VT.createVT(Number(_loc3_.怪物五行));
            _loc2_.wxjin = VT.createVT(Number(_loc3_.金));
            _loc2_.wxmu = VT.createVT(Number(_loc3_.木));
            _loc2_.wxshui = VT.createVT(Number(_loc3_.水));
            _loc2_.wxfou = VT.createVT(Number(_loc3_.火));
            _loc2_.wxtu = VT.createVT(Number(_loc3_.土));
            _loc2_.wxhundun = VT.createVT(Number(_loc3_.混沌));
            _loc2_.jinyan = VT.createVT(Number(_loc3_.死亡给予玩家经验));
            if(String(_loc3_.死亡掉落) != "null")
            {
               _loc4_ = String(_loc3_.死亡掉落).split("#");
            }
            else
            {
               _loc4_ = [];
            }
            if(String(_loc3_.死亡掉落2) != "null")
            {
               _loc5_ = String(_loc3_.死亡掉落2).split("#");
            }
            else
            {
               _loc5_ = [];
            }
            if(String(_loc3_.任务掉落) != "null")
            {
               _loc6_ = String(_loc3_.任务掉落).split("#");
            }
            else
            {
               _loc6_ = [];
            }
            if(String(_loc3_.特殊物品掉落上限) != "null")
            {
               _loc7_ = String(_loc3_.特殊物品掉落上限).split("#");
            }
            else
            {
               _loc7_ = [];
            }
            _loc8_ = new CMDiaoLou();
            _loc8_.diaoshiwang = _loc4_;
            _loc8_.diaoshiwangB = _loc5_;
            _loc8_.diaorenwu = _loc6_;
            _loc8_.diaoteshu = _loc7_;
            _loc2_.dl = _loc8_;
            _loc9_ = UTools.sTnArr(String(_loc3_.警戒).split(","));
            _loc10_ = UTools.sTnArr(String(_loc3_.追踪距离).split(","));
            _loc2_.jingjie = new CMJingJie(_loc9_[0],_loc9_[1],_loc9_[2],_loc9_[3]);
            _loc2_.tracejuli = new TraceJuLi(_loc10_[0],_loc10_[1],_loc10_[2],_loc10_[3]);
            _loc2_.fzouA = Number(_loc3_.走帧定);
            _loc2_.fzouB = Number(_loc3_.走帧浮动);
            if(String(_loc3_.攻击列表) != "null")
            {
               _loc2_.aActionArr = String(_loc3_.攻击列表).split(",");
            }
            else
            {
               _loc2_.aActionArr = [];
            }
            if(String(_loc3_.死亡后出现的球) == "null")
            {
               _loc2_.mdeadcball = "";
            }
            else
            {
               _loc2_.mdeadcball = String(_loc3_.死亡后出现的球);
            }
            _loc2_.mjishicon = VT.createVT(Number(_loc3_.存在控制));
            _loc2_.mjishitimer = VT.createVT(Number(_loc3_.存在时间));
            _loc2_.classname = String(_loc3_.类名);
            _loc2_.mcclassname = String(_loc3_.元件名);
            mDataArr[_loc2_.ername + _loc2_.mname] = _loc2_;
         }
      }
      
      public static function mactionDataInitByXml(param1:XML) : void
      {
         var _loc2_:Object = null;
         var _loc3_:FightData = null;
         var _loc4_:XML = null;
         var _loc5_:Array = null;
         var _loc6_:Object = null;
         var _loc7_:Object = null;
         var _loc8_:String = null;
         if(mactionData == null)
         {
            mactionData = new Object();
            for each(_loc4_ in param1.技能)
            {
               _loc2_ = new Object();
               _loc3_ = new FightData();
               _loc3_.jiDao = Number(_loc4_.击倒);
               _loc3_.jiDaoKanXin = Number(_loc4_.击倒抗性);
               _loc3_.jiDaoXiShu = Number(_loc4_.击倒系数);
               _loc3_.jiDaoZheng = Number(_loc4_.击倒几帧);
               _loc3_.shiZhong = Number(_loc4_.失重);
               _loc3_.shiZhongKanXin = Number(_loc4_.失重抗性);
               _loc3_.shiZhongXiShu = Number(_loc4_.失重系数);
               _loc3_.shiZhongZheng = Number(_loc4_.失重几帧);
               _loc3_.tiaoGao = Number(_loc4_.挑高);
               _loc3_.tiaoGaoEase = Number(_loc4_.挑高缓动);
               _loc3_.tiaoGaoKanXin = Number(_loc4_.挑高抗性);
               _loc3_.tiaoGaoValue = Number(_loc4_.挑高值);
               _loc3_.tiaoGaoXiShu = Number(_loc4_.挑高系数);
               _loc3_.tiaoGaoZheng = Number(_loc4_.挑高几帧);
               _loc3_.yinZhi = Number(_loc4_.硬直);
               _loc3_.yinZhiKanXin = Number(_loc4_.硬直抗性);
               _loc3_.yinZhiXiShu = Number(_loc4_.硬直系数);
               _loc3_.yinZhiZheng = Number(_loc4_.硬直几帧);
               _loc3_.zhenTui = Number(_loc4_.震退);
               _loc3_.zhenTuiEase = Number(_loc4_.震退缓动);
               _loc3_.zhenTuiKanXin = Number(_loc4_.震退抗性);
               _loc3_.zhenTuiType = Number(_loc4_.震退类型);
               _loc3_.zhenTuiValue = Number(_loc4_.震退值);
               _loc3_.zhenTuiXiShu = Number(_loc4_.震退系数);
               _loc3_.zhenTuiZheng = Number(_loc4_.震退几帧);
               _loc3_.daJi = Number(_loc4_.打击效果);
               _loc3_.shangHaiBi = Number(_loc4_.伤害增幅);
               _loc3_.jiangShangBi = Number(_loc4_.伤害减幅);
               _loc3_.xianziKanXin = Number(_loc4_.束缚技限制);
               _loc3_.caflag = Number(_loc4_.招式标识);
               _loc3_.flag = Number(_loc4_.穿墙标识);
               if(String(_loc4_.技能特殊效果) != "null")
               {
                  _loc3_.othersSkill = Number(_loc4_.技能特殊效果);
               }
               if(String(_loc4_.装备特殊效果) != "null")
               {
                  _loc3_.goodsSkill = UTools.sTnArrAndVT(String(_loc4_.装备特殊效果).split("#"));
               }
               _loc3_.hitFlahE = String(_loc4_.打击光效);
               _loc3_.hitsound = String(_loc4_.击中声音);
               _loc2_.fda = _loc3_;
               _loc2_.skillsound = com.adobeadobe.serialization.json.JSON.decode(String(_loc4_.技能声音));
               _loc2_.acd = VT.createVT(Number(_loc4_.技能CD));
               _loc2_.cdrom = VT.createVT(Number(_loc4_.CD随机浮动));
               _loc2_.pwd = VT.createVT(Number(_loc4_.能量消耗));
               _loc2_.dd = Number(_loc4_.自身打断);
               _loc2_.zhendong = com.adobeadobe.serialization.json.JSON.decode(String(_loc4_.震动));
               _loc5_ = UTools.sTnArr(String(_loc4_.攻击范围).split(","));
               _loc2_.gjH = new GJHuangWei(_loc5_[0],_loc5_[1],_loc5_[2],_loc5_[3]);
               _loc2_.ygravity = Number(_loc4_.忽略重力);
               _loc2_.mo = com.adobeadobe.serialization.json.JSON.decode(String(_loc4_.自身位移));
               _loc2_.lit = Number(_loc4_.空中地面限制);
               _loc2_.bo = com.adobeadobe.serialization.json.JSON.decode(String(_loc4_.生成子弹));
               _loc2_.others = com.adobeadobe.serialization.json.JSON.decode(String(_loc4_.其它));
               _loc6_ = com.adobeadobe.serialization.json.JSON.decode(String(_loc4_.其它vt));
               _loc7_ = new Object();
               for(_loc8_ in _loc6_)
               {
                  _loc7_[_loc8_] = VT.createVT(_loc6_[_loc8_]);
               }
               _loc2_.othersvt = _loc7_;
               _loc2_.classname = String(_loc4_.类名);
               _loc2_.framename = String(_loc4_.动作名);
               mactionData[String(_loc4_.技能名称) + String(_loc4_.技能等级)] = _loc2_;
            }
         }
      }
      
      public static function getMData(param1:String) : Object
      {
         return mDataArr[param1];
      }
      
      public static function getMAction(param1:String) : CAction
      {
         return mActionArr[param1];
      }
      
      public static function isYActionData(param1:String) : Boolean
      {
         if(mactionData[param1])
         {
            return true;
         }
         return false;
      }
      
      public static function getMActionByName(param1:String) : CAction
      {
         var _loc4_:CAction = null;
         var _loc2_:Object = mactionData[param1];
         var _loc3_:Class = ClassGet.getClassByNameAndAlias(_loc2_.classname) as Class;
         var _loc5_:* = _loc2_.classname;
         switch(0)
         {
         }
         _loc4_ = new _loc3_(_loc2_.framename) as CAction;
         _loc4_.setData(_loc2_);
         _loc4_.setccd(GM.frameTime);
         return _loc4_;
      }
   }
}

