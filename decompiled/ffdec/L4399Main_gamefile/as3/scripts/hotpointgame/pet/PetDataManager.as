package hotpointgame.pet
{
   import com.adobeadobe.serialization.json.JSON;
   import hotpointgame.common.*;
   import hotpointgame.gMonster.*;
   import hotpointgame.gaction.*;
   import hotpointgame.gameobj.*;
   import hotpointgame.utils.*;
   
   public class PetDataManager
   {
      
      private static var petbArr:Object = new Object();
      
      private static var petactionData:Object = new Object();
      
      private static var ronghelvattArr:Object = new Object();
      
      private static var petSkillLvShow:Object = new Object();
      
      private static var lingwuSkill:Object = new Object();
      
      public function PetDataManager()
      {
         super();
      }
      
      public static function initCWdata(param1:XML) : void
      {
         var _loc2_:XML = null;
         var _loc3_:PetBaseD = null;
         var _loc4_:Array = null;
         var _loc5_:Array = null;
         for each(_loc2_ in param1.宠物)
         {
            _loc3_ = new PetBaseD();
            _loc3_.id = Number(_loc2_.ID);
            _loc3_.name = String(_loc2_.名字);
            _loc3_.framnum = Number(_loc2_.帧数);
            _loc3_.ppotLimit = Number(_loc2_.资质);
            _loc3_.pcolor = Number(_loc2_.品质);
            _loc3_.ptype = String(_loc2_.品种);
            _loc3_.pexp = Number(_loc2_.融合经验);
            _loc3_.pele = String(_loc2_.加载需求文件);
            _loc3_.gv = Number(_loc2_.重力);
            _loc4_ = UTools.sTnArr(String(_loc2_.警戒).split(","));
            _loc5_ = UTools.sTnArr(String(_loc2_.追踪距离).split(","));
            _loc3_.jingJie = new CMJingJie(_loc4_[0],_loc4_[1],_loc4_[2],_loc4_[3]);
            _loc3_.traceJuLi = new TraceJuLi(_loc5_[0],_loc5_[1],_loc5_[2],_loc5_[3]);
            petbArr[_loc3_.id] = _loc3_;
         }
      }
      
      public static function getPBD(param1:int) : PetBaseD
      {
         return petbArr[param1];
      }
      
      public static function initRongHeLv(param1:XML) : void
      {
         var _loc2_:XML = null;
         var _loc3_:PetRongHeAttBD = null;
         for each(_loc2_ in param1.融合等级属性)
         {
            _loc3_ = new PetRongHeAttBD();
            _loc3_.lv = Number(_loc2_.等级);
            _loc3_.hp = Number(_loc2_.生命);
            _loc3_.nl = Number(_loc2_.能量);
            _loc3_.att = Number(_loc2_.攻击);
            _loc3_.fy = Number(_loc2_.防御);
            _loc3_.bj = Number(_loc2_.暴击);
            _loc3_.sp = Number(_loc2_.速度);
            _loc3_.jin = Number(_loc2_.金);
            _loc3_.mu = Number(_loc2_.木);
            _loc3_.shui = Number(_loc2_.水);
            _loc3_.huo = Number(_loc2_.火);
            _loc3_.tu = Number(_loc2_.土);
            _loc3_.hd = Number(_loc2_.混沌);
            ronghelvattArr[_loc3_.lv] = _loc3_;
         }
      }
      
      public static function getRongHeLvBylv(param1:int) : PetRongHeAttBD
      {
         return ronghelvattArr[param1];
      }
      
      public static function initLingWuSkill(param1:XML) : void
      {
         var _loc2_:XML = null;
         var _loc3_:PetLingWuSkillBD = null;
         var _loc4_:Object = null;
         for each(_loc2_ in param1.宠物技能领悟)
         {
            _loc3_ = new PetLingWuSkillBD();
            _loc3_.pid = Number(_loc2_.针对的宠物ID);
            _loc3_.linglv = Number(_loc2_.领悟等级);
            _loc3_.linggod = Number(_loc2_.领悟需求晶币);
            _loc3_.lingrate = Number(_loc2_.进入下一等级概率);
            _loc3_.sidArr = String(_loc2_.领悟后获得技能与概率).split(",");
            _loc4_ = lingwuSkill[_loc3_.pid];
            if(_loc4_ != null)
            {
               _loc4_[_loc3_.linglv] = _loc3_;
            }
            else
            {
               _loc4_ = new Object();
               _loc4_[_loc3_.linglv] = _loc3_;
               lingwuSkill[_loc3_.pid] = _loc4_;
            }
         }
      }
      
      public static function getLingWuSkillByPetAndLv(param1:int, param2:int) : PetLingWuSkillBD
      {
         return lingwuSkill[param1][param2];
      }
      
      public static function initPetSkillShow(param1:XML) : void
      {
         var _loc2_:XML = null;
         var _loc3_:PetSkillShowBD = null;
         for each(_loc2_ in param1.宠物技能显示与说明)
         {
            _loc3_ = new PetSkillShowBD();
            _loc3_.sid = Number(_loc2_.技能编号);
            _loc3_.sfid = String(_loc2_.针对的技能列表ID);
            _loc3_.scolor = Number(_loc2_.技能品质);
            _loc3_.initexp = Number(_loc2_.初始经验);
            _loc3_.frameNum = Number(_loc2_.图标帧数);
            _loc3_.sname = String(_loc2_.技能名称);
            _loc3_.hurtIshu = Number(_loc2_.基数);
            _loc3_.potlimitv = Number(_loc2_.最低资质限制);
            _loc3_.hurtIxishu = Number(_loc2_.等级成长的技能伤害系数);
            _loc3_.sshuomi = String(_loc2_.技能说明).split("Z");
            petSkillLvShow[_loc3_.sid] = _loc3_;
         }
      }
      
      public static function getPetSkillShowById(param1:int) : PetSkillShowBD
      {
         return petSkillLvShow[param1];
      }
      
      public static function isYPetActionData(param1:String) : Boolean
      {
         if(petactionData[param1])
         {
            return true;
         }
         return false;
      }
      
      public static function getPetActionByName(param1:String) : CAction
      {
         var _loc2_:Object = petactionData[param1];
         var _loc3_:Class = ClassGet.getClassByNameAndAlias(_loc2_.classname) as Class;
         var _loc4_:CAction = new _loc3_(_loc2_.framename) as CAction;
         _loc4_.setData(_loc2_);
         _loc4_.setiniPetccd();
         return _loc4_;
      }
      
      public static function getPetActionByObject(param1:Object) : CAction
      {
         var _loc6_:String = null;
         var _loc7_:Class = null;
         var _loc8_:CAction = null;
         var _loc2_:Object = petactionData[param1.sname];
         var _loc3_:Object = new Object();
         _loc3_.fda = (_loc2_.fda as FightData).copycone(param1.shurt);
         _loc3_.skillsound = _loc2_.skillsound;
         _loc3_.acd = _loc2_.acd;
         _loc3_.cdrom = _loc2_.cdrom;
         _loc3_.pwd = _loc2_.pwd;
         _loc3_.dd = _loc2_.dd;
         _loc3_.zhendong = _loc2_.zhendong;
         _loc3_.gjH = _loc2_.gjH;
         _loc3_.ygravity = _loc2_.ygravity;
         _loc3_.mo = _loc2_.mo;
         _loc3_.lit = _loc2_.lit;
         var _loc4_:Object = _loc2_.bo;
         var _loc5_:Object = new Object();
         for(_loc6_ in _loc4_)
         {
            _loc5_[_loc6_] = _loc4_[_loc6_] + param1.slv;
         }
         _loc3_.bo = _loc5_;
         _loc3_.others = _loc2_.others;
         _loc3_.othersvt = _loc2_.othersvt;
         _loc3_.classname = _loc2_.classname;
         _loc3_.framename = _loc2_.framename;
         _loc7_ = ClassGet.getClassByNameAndAlias(_loc3_.classname) as Class;
         _loc8_ = new _loc7_(_loc3_.framename) as CAction;
         _loc8_.setData(_loc3_);
         _loc8_.setiniPetccd();
         return _loc8_;
      }
      
      public static function petActionDataInit(param1:XML) : void
      {
         var _loc2_:Object = null;
         var _loc3_:FightData = null;
         var _loc4_:XML = null;
         var _loc5_:Array = null;
         var _loc6_:Object = null;
         var _loc7_:Object = null;
         var _loc8_:String = null;
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
            petactionData[String(_loc4_.技能名称) + String(_loc4_.技能等级)] = _loc2_;
         }
      }
   }
}

