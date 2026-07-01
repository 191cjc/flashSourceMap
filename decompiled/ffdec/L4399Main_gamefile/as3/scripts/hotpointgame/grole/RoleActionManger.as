package hotpointgame.grole
{
   import com.adobeadobe.serialization.json.JSON;
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   import hotpointgame.gMonster.*;
   import hotpointgame.gaction.*;
   import hotpointgame.gameobj.*;
   import hotpointgame.utils.*;
   
   public class RoleActionManger
   {
      
      private static var ractionData:Object = new Object();
      
      private static var womgunActionData:Object = new Object();
      
      private static var mapGunActionData:Object = new Object();
      
      private static var jijiaSkillData:Object = new Object();
      
      private static var gunLevelData:Vector.<RoleLevelData> = new Vector.<RoleLevelData>();
      
      private static var wgunLevelData:Vector.<RoleLevelData> = new Vector.<RoleLevelData>();
      
      public function RoleActionManger()
      {
         super();
      }
      
      public static function getRActionByName(param1:String) : CAction
      {
         var _loc4_:CAction = null;
         var _loc2_:Object = ractionData[param1];
         var _loc3_:Class = ClassGet.getClassByNameAndAlias(_loc2_.classname) as Class;
         var _loc5_:* = _loc2_.classname;
         switch(0)
         {
         }
         _loc4_ = new _loc3_(_loc2_.framename) as CAction;
         _loc4_.setccd(-5000);
         _loc4_.setData(_loc2_);
         return _loc4_;
      }
      
      public static function getRActionByNameBpkdata(param1:Number) : CAction
      {
         var _loc2_:Object = ractionData["跑1"];
         var _loc3_:MAZou = new MAZou("跑");
         _loc3_.setccd(-5000);
         _loc2_.othersvt.xspeed = VT.createVT(param1 * (GS.a1 + GS.a05));
         _loc3_.setData(_loc2_);
         return _loc3_;
      }
      
      public static function getWomGunActionByName(param1:String) : CAction
      {
         var _loc4_:CAction = null;
         var _loc2_:Object = womgunActionData[param1];
         var _loc3_:Class = ClassGet.getClassByNameAndAlias(_loc2_.classname) as Class;
         var _loc5_:* = _loc2_.classname;
         switch(0)
         {
         }
         _loc4_ = new _loc3_(_loc2_.framename) as CAction;
         _loc4_.setccd(-5000);
         _loc4_.setData(_loc2_);
         return _loc4_;
      }
      
      public static function getWomGunActionByNameBpkdata(param1:Number) : CAction
      {
         var _loc2_:Object = womgunActionData["跑1"];
         var _loc3_:MAZou = new MAZou("跑");
         _loc3_.setccd(-5000);
         _loc2_.othersvt.xspeed = VT.createVT(param1 * (GS.a1 + GS.a05));
         _loc3_.setData(_loc2_);
         return _loc3_;
      }
      
      public static function getJiJiaActionByName(param1:String) : CAction
      {
         var _loc4_:CAction = null;
         var _loc2_:Object = jijiaSkillData[param1];
         var _loc3_:Class = ClassGet.getClassByNameAndAlias(_loc2_.classname) as Class;
         var _loc5_:* = _loc2_.classname;
         switch(0)
         {
         }
         _loc4_ = new _loc3_(_loc2_.framename) as CAction;
         _loc4_.setccd(-5000);
         _loc4_.setData(_loc2_);
         return _loc4_;
      }
      
      public static function getJiJiaActionByNameBpkdata(param1:Number) : CAction
      {
         var _loc2_:Object = jijiaSkillData["" + "银翼战神" + "跑1"];
         var _loc3_:MAZou = new MAZou("跑");
         _loc3_.setccd(-5000);
         _loc2_.othersvt.xspeed = VT.createVT(param1 * (GS.a1 + GS.a05));
         _loc3_.setData(_loc2_);
         return _loc3_;
      }
      
      public static function getMapGunActionByName(param1:String) : CAction
      {
         var _loc4_:CAction = null;
         var _loc2_:Object = mapGunActionData[param1];
         var _loc3_:Class = ClassGet.getClassByNameAndAlias(_loc2_.classname) as Class;
         var _loc5_:* = _loc2_.classname;
         switch(0)
         {
         }
         _loc4_ = new _loc3_(_loc2_.framename) as CAction;
         _loc4_.setccd(-5000);
         _loc4_.setData(_loc2_);
         return _loc4_;
      }
      
      public static function getLevelData(param1:int) : RoleLevelData
      {
         if(FlowInterface.getJobByRole() == GS.a1)
         {
            return gunLevelData[param1];
         }
         if(FlowInterface.getJobByRole() == GS.a2)
         {
            return wgunLevelData[param1];
         }
         return null;
      }
      
      public static function levelDataInitGun(param1:XML) : void
      {
         levelDataInitByXml(param1,gunLevelData);
      }
      
      public static function levelDataInitWGun(param1:XML) : void
      {
         levelDataInitByXml(param1,wgunLevelData);
      }
      
      public static function levelDataInitByXml(param1:XML, param2:Vector.<RoleLevelData>) : void
      {
         var _loc3_:XML = null;
         var _loc4_:RoleLevelData = null;
         param2.push(new RoleLevelData());
         for each(_loc3_ in param1.角色等级属性)
         {
            _loc4_ = new RoleLevelData();
            _loc4_.level = Number(_loc3_.等级);
            _loc4_.nextexp = Number(_loc3_.经验值);
            _loc4_.rhp = Number(_loc3_.HP);
            _loc4_.rmp = Number(_loc3_.MP);
            _loc4_.rat = Number(_loc3_.攻击);
            _loc4_.rdf = Number(_loc3_.防御);
            _loc4_.rspeed = Number(_loc3_.速度);
            _loc4_.rbaoji = Number(_loc3_.暴击);
            _loc4_.maxGod = Number(_loc3_.拥有金币上限);
            _loc4_.toMaxLvExp = Number(_loc3_.距离满级经验);
            param2[_loc4_.level] = _loc4_;
         }
      }
      
      private static function actionDataInitByXml(param1:XML, param2:Object) : void
      {
         var _loc3_:Object = null;
         var _loc4_:FightData = null;
         var _loc5_:FightData = null;
         var _loc6_:XML = null;
         var _loc7_:Array = null;
         var _loc8_:Object = null;
         var _loc9_:Object = null;
         var _loc10_:String = null;
         var _loc11_:Array = null;
         for each(_loc6_ in param1.技能)
         {
            _loc3_ = new Object();
            _loc4_ = new FightData();
            _loc5_ = new FightData();
            if(String(_loc6_.技能名称) == "末日：枪神之舞")
            {
               _loc11_ = new Array();
               _loc11_ = String(_loc6_.击倒).split(",");
               _loc4_.jiDao = _loc11_[0];
               _loc5_.jiDao = _loc11_[1];
               _loc11_ = String(_loc6_.击倒抗性).split(",");
               _loc4_.jiDaoKanXin = _loc11_[0];
               _loc5_.jiDaoKanXin = _loc11_[1];
               _loc11_ = String(_loc6_.击倒系数).split(",");
               _loc4_.jiDaoXiShu = _loc11_[0];
               _loc5_.jiDaoXiShu = _loc11_[1];
               _loc11_ = String(_loc6_.击倒几帧).split(",");
               _loc4_.jiDaoZheng = _loc11_[0];
               _loc5_.jiDaoZheng = _loc11_[1];
               _loc11_ = String(_loc6_.失重).split(",");
               _loc4_.shiZhong = _loc11_[0];
               _loc5_.shiZhong = _loc11_[1];
               _loc11_ = String(_loc6_.失重抗性).split(",");
               _loc4_.shiZhongKanXin = _loc11_[0];
               _loc5_.shiZhongKanXin = _loc11_[1];
               _loc11_ = String(_loc6_.失重系数).split(",");
               _loc4_.shiZhongXiShu = _loc11_[0];
               _loc5_.shiZhongXiShu = _loc11_[1];
               _loc11_ = String(_loc6_.失重几帧).split(",");
               _loc4_.shiZhongZheng = _loc11_[0];
               _loc5_.shiZhongZheng = _loc11_[1];
               _loc11_ = String(_loc6_.挑高).split(",");
               _loc4_.tiaoGao = _loc11_[0];
               _loc5_.tiaoGao = _loc11_[1];
               _loc11_ = String(_loc6_.挑高缓动).split(",");
               _loc4_.tiaoGaoEase = _loc11_[0];
               _loc5_.tiaoGaoEase = _loc11_[1];
               _loc11_ = String(_loc6_.挑高抗性).split(",");
               _loc4_.tiaoGaoKanXin = _loc11_[0];
               _loc5_.tiaoGaoKanXin = _loc11_[1];
               _loc11_ = String(_loc6_.挑高值).split(",");
               _loc4_.tiaoGaoValue = _loc11_[0];
               _loc5_.tiaoGaoValue = _loc11_[1];
               _loc11_ = String(_loc6_.挑高系数).split(",");
               _loc4_.tiaoGaoXiShu = _loc11_[0];
               _loc5_.tiaoGaoXiShu = _loc11_[1];
               _loc11_ = String(_loc6_.挑高几帧).split(",");
               _loc4_.tiaoGaoZheng = _loc11_[0];
               _loc5_.tiaoGaoZheng = _loc11_[1];
               _loc11_ = String(_loc6_.硬直).split(",");
               _loc4_.yinZhi = _loc11_[0];
               _loc5_.yinZhi = _loc11_[1];
               _loc11_ = String(_loc6_.硬直抗性).split(",");
               _loc4_.yinZhiKanXin = _loc11_[0];
               _loc5_.yinZhiKanXin = _loc11_[1];
               _loc11_ = String(_loc6_.硬直系数).split(",");
               _loc4_.yinZhiXiShu = _loc11_[0];
               _loc5_.yinZhiXiShu = _loc11_[1];
               _loc11_ = String(_loc6_.硬直几帧).split(",");
               _loc4_.yinZhiZheng = _loc11_[0];
               _loc5_.yinZhiZheng = _loc11_[1];
               _loc11_ = String(_loc6_.震退).split(",");
               _loc4_.zhenTui = _loc11_[0];
               _loc5_.zhenTui = _loc11_[1];
               _loc11_ = String(_loc6_.震退缓动).split(",");
               _loc4_.zhenTuiEase = _loc11_[0];
               _loc5_.zhenTuiEase = _loc11_[1];
               _loc11_ = String(_loc6_.震退抗性).split(",");
               _loc4_.zhenTuiKanXin = _loc11_[0];
               _loc5_.zhenTuiKanXin = _loc11_[1];
               _loc11_ = String(_loc6_.震退类型).split(",");
               _loc4_.zhenTuiType = _loc11_[0];
               _loc5_.zhenTuiType = _loc11_[1];
               _loc11_ = String(_loc6_.震退值).split(",");
               _loc4_.zhenTuiValue = _loc11_[0];
               _loc5_.zhenTuiValue = _loc11_[1];
               _loc11_ = String(_loc6_.震退系数).split(",");
               _loc4_.zhenTuiXiShu = _loc11_[0];
               _loc5_.zhenTuiXiShu = _loc11_[1];
               _loc11_ = String(_loc6_.震退几帧).split(",");
               _loc4_.zhenTuiZheng = _loc11_[0];
               _loc5_.zhenTuiZheng = _loc11_[1];
               _loc11_ = String(_loc6_.打击效果).split(",");
               _loc4_.daJi = _loc11_[0];
               _loc5_.daJi = _loc11_[1];
               _loc11_ = String(_loc6_.伤害增幅).split(",");
               _loc4_.shangHaiBi = _loc11_[0];
               _loc5_.shangHaiBi = _loc11_[1];
               _loc11_ = String(_loc6_.伤害减幅).split(",");
               _loc4_.jiangShangBi = _loc11_[0];
               _loc5_.jiangShangBi = _loc11_[1];
               _loc11_ = String(_loc6_.束缚技限制).split(",");
               _loc4_.xianziKanXin = _loc11_[0];
               _loc5_.xianziKanXin = _loc11_[1];
               _loc11_ = String(_loc6_.招式标识).split(",");
               _loc4_.caflag = _loc11_[0];
               _loc5_.caflag = _loc11_[1];
               _loc11_ = String(_loc6_.穿墙标识).split(",");
               _loc4_.flag = _loc11_[0];
               _loc5_.flag = _loc11_[1];
               _loc11_ = String(_loc6_.技能特殊效果).split(",");
               if(String(_loc11_[0]) != "null")
               {
                  _loc4_.othersSkill = Number(_loc11_[0]);
               }
               if(String(_loc11_[1]) != "null")
               {
                  _loc5_.othersSkill = Number(_loc11_[1]);
               }
               _loc11_ = String(_loc6_.装备特殊效果).split(",");
               if(String(_loc11_[0]) != "null")
               {
                  _loc4_.goodsSkill = UTools.sTnArrAndVT(String(_loc11_[0]).split("#"));
               }
               if(String(_loc11_[1]) != "null")
               {
                  _loc5_.goodsSkill = UTools.sTnArrAndVT(String(_loc11_[1]).split("#"));
               }
               _loc4_.hitFlahE = String(_loc6_.打击光效);
               _loc5_.hitFlahE = String(_loc6_.打击光效);
               _loc4_.hitsound = String(_loc6_.击中声音);
               _loc5_.hitsound = String(_loc6_.击中声音);
               _loc4_.jiJiaAng = Number(_loc6_.怒气倍数);
               _loc5_.jiJiaAng = Number(_loc6_.怒气倍数);
               _loc3_.fdb = _loc5_;
            }
            else
            {
               _loc4_.jiDao = Number(_loc6_.击倒);
               _loc4_.jiDaoKanXin = Number(_loc6_.击倒抗性);
               _loc4_.jiDaoXiShu = Number(_loc6_.击倒系数);
               _loc4_.jiDaoZheng = Number(_loc6_.击倒几帧);
               _loc4_.shiZhong = Number(_loc6_.失重);
               _loc4_.shiZhongKanXin = Number(_loc6_.失重抗性);
               _loc4_.shiZhongXiShu = Number(_loc6_.失重系数);
               _loc4_.shiZhongZheng = Number(_loc6_.失重几帧);
               _loc4_.tiaoGao = Number(_loc6_.挑高);
               _loc4_.tiaoGaoEase = Number(_loc6_.挑高缓动);
               _loc4_.tiaoGaoKanXin = Number(_loc6_.挑高抗性);
               _loc4_.tiaoGaoValue = Number(_loc6_.挑高值);
               _loc4_.tiaoGaoXiShu = Number(_loc6_.挑高系数);
               _loc4_.tiaoGaoZheng = Number(_loc6_.挑高几帧);
               _loc4_.yinZhi = Number(_loc6_.硬直);
               _loc4_.yinZhiKanXin = Number(_loc6_.硬直抗性);
               _loc4_.yinZhiXiShu = Number(_loc6_.硬直系数);
               _loc4_.yinZhiZheng = Number(_loc6_.硬直几帧);
               _loc4_.zhenTui = Number(_loc6_.震退);
               _loc4_.zhenTuiEase = Number(_loc6_.震退缓动);
               _loc4_.zhenTuiKanXin = Number(_loc6_.震退抗性);
               _loc4_.zhenTuiType = Number(_loc6_.震退类型);
               _loc4_.zhenTuiValue = Number(_loc6_.震退值);
               _loc4_.zhenTuiXiShu = Number(_loc6_.震退系数);
               _loc4_.zhenTuiZheng = Number(_loc6_.震退几帧);
               _loc4_.daJi = Number(_loc6_.打击效果);
               _loc4_.shangHaiBi = Number(_loc6_.伤害增幅);
               _loc4_.jiangShangBi = Number(_loc6_.伤害减幅);
               _loc4_.xianziKanXin = Number(_loc6_.束缚技限制);
               _loc4_.caflag = Number(_loc6_.招式标识);
               _loc4_.flag = Number(_loc6_.穿墙标识);
               if(String(_loc6_.技能特殊效果) != "null")
               {
                  _loc4_.othersSkill = Number(_loc6_.技能特殊效果);
               }
               if(String(_loc6_.装备特殊效果) != "null")
               {
                  _loc4_.goodsSkill = UTools.sTnArrAndVT(String(_loc6_.装备特殊效果).split(","));
               }
               _loc4_.hitFlahE = String(_loc6_.打击光效);
               _loc4_.hitsound = String(_loc6_.击中声音);
               _loc4_.jiJiaAng = Number(_loc6_.怒气倍数);
            }
            _loc3_.fda = _loc4_;
            _loc3_.skillsound = com.adobeadobe.serialization.json.JSON.decode(String(_loc6_.技能声音));
            _loc3_.acd = VT.createVT(Number(_loc6_.技能CD));
            _loc3_.cdrom = VT.createVT(Number(_loc6_.CD随机浮动));
            _loc3_.pwd = VT.createVT(Number(_loc6_.能量消耗));
            _loc3_.dd = Number(_loc6_.自身打断);
            _loc3_.zhendong = com.adobeadobe.serialization.json.JSON.decode(String(_loc6_.震动));
            _loc7_ = UTools.sTnArr(String(_loc6_.攻击范围).split(","));
            _loc3_.gjH = new GJHuangWei(_loc7_[0],_loc7_[1],_loc7_[2],_loc7_[3]);
            _loc3_.ygravity = Number(_loc6_.忽略重力);
            _loc3_.mo = com.adobeadobe.serialization.json.JSON.decode(String(_loc6_.自身位移));
            _loc3_.lit = Number(_loc6_.空中地面限制);
            _loc3_.bo = com.adobeadobe.serialization.json.JSON.decode(String(_loc6_.生成子弹));
            _loc3_.others = com.adobeadobe.serialization.json.JSON.decode(String(_loc6_.其它));
            _loc8_ = com.adobeadobe.serialization.json.JSON.decode(String(_loc6_.其它vt));
            _loc9_ = new Object();
            for(_loc10_ in _loc8_)
            {
               _loc9_[_loc10_] = VT.createVT(_loc8_[_loc10_]);
            }
            _loc3_.othersvt = _loc9_;
            _loc3_.classname = String(_loc6_.类名);
            _loc3_.framename = String(_loc6_.动作名);
            param2[String(_loc6_.技能名称) + String(_loc6_.技能等级)] = _loc3_;
         }
      }
      
      public static function ractionDataInitByXml(param1:XML) : void
      {
         actionDataInitByXml(param1,ractionData);
      }
      
      public static function womgunSkillDataInit(param1:XML) : void
      {
         actionDataInitByXml(param1,womgunActionData);
      }
      
      public static function mapGunActionDataInitByXml(param1:XML) : void
      {
         actionDataInitByXml(param1,mapGunActionData);
      }
      
      public static function jiJiaActionDataInitByXml(param1:XML) : void
      {
         actionDataInitByXml(param1,jijiaSkillData);
      }
   }
}

