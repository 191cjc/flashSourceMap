package hotpointgame.gBullet
{
   import com.adobeadobe.serialization.json.JSON;
   import hotpointgame.common.*;
   import hotpointgame.gameobj.*;
   import hotpointgame.utils.*;
   
   public class ZtBFactory
   {
      
      private static var bulletData:Object;
      
      public function ZtBFactory()
      {
         super();
      }
      
      public static function dataInitByXml(param1:XML, param2:XML) : void
      {
         var _loc3_:Object = null;
         var _loc4_:FightData = null;
         var _loc5_:FightData = null;
         var _loc6_:XML = null;
         var _loc7_:XML = null;
         var _loc8_:Object = null;
         var _loc9_:Object = null;
         var _loc10_:String = null;
         var _loc11_:Array = null;
         var _loc12_:Array = null;
         var _loc13_:int = 0;
         var _loc14_:Object = null;
         var _loc15_:Object = null;
         var _loc16_:String = null;
         var _loc17_:Object = null;
         var _loc18_:Object = null;
         var _loc19_:String = null;
         if(bulletData == null)
         {
            bulletData = new Object();
            for each(_loc6_ in param1.子弹)
            {
               _loc3_ = new Object();
               _loc4_ = new FightData();
               _loc5_ = new FightData();
               if(String(_loc6_.源名) == "火焰弹" || String(_loc6_.源名) == "光·Only shot")
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
                     _loc4_.goodsSkill = UTools.sTnArrAndVT(String(_loc11_[0]).split(","));
                  }
                  if(String(_loc11_[1]) != "null")
                  {
                     _loc5_.goodsSkill = UTools.sTnArrAndVT(String(_loc11_[1]).split(","));
                  }
                  _loc4_.hitFlahE = String(_loc6_.打击光效);
                  _loc4_.hitsound = String(_loc6_.击中声音);
                  _loc5_.hitFlahE = String(_loc6_.打击光效);
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
               _loc3_.createsound = String(_loc6_.生成声音);
               _loc3_.bombsound = String(_loc6_.爆炸声音);
               _loc3_.runMaxOver = Number(_loc6_.存在之后);
               _loc3_.runStateOver = Number(_loc6_.运行之后);
               _loc3_.runMaxNum = Number(_loc6_.存在帧数);
               _loc3_.bSpeed = Number(_loc6_.速度);
               _loc3_.hp = Number(_loc6_.血量);
               _loc3_.yba = Number(_loc6_.被打);
               _loc3_.chuanMonster = Number(_loc6_.穿怪);
               if(String(_loc6_.出那个怪) == "null")
               {
                  _loc3_.cumonstername = "";
               }
               else
               {
                  _loc3_.cumonstername = String(_loc6_.出那个怪);
               }
               _loc3_.dmclevel = Number(_loc6_.子弹层级);
               _loc3_.zhendong = com.adobeadobe.serialization.json.JSON.decode(String(_loc6_.震动));
               _loc3_.others = com.adobeadobe.serialization.json.JSON.decode(String(_loc6_.其它));
               _loc8_ = com.adobeadobe.serialization.json.JSON.decode(String(_loc6_.其它vt));
               _loc9_ = new Object();
               for(_loc10_ in _loc8_)
               {
                  _loc9_[_loc10_] = VT.createVT(_loc8_[_loc10_]);
               }
               _loc3_.othersvt = _loc9_;
               _loc3_.classname = String(_loc6_.类名);
               _loc3_.flaname = String(_loc6_.元件名);
               bulletData[String(_loc6_.源名) + String(_loc6_.二名)] = _loc3_;
            }
            for each(_loc7_ in param2.子弹)
            {
               _loc3_ = new Object();
               _loc4_ = new FightData();
               if(String(_loc7_.二名) == "10")
               {
                  _loc12_ = String(_loc7_.伤害增幅).split("*");
                  _loc13_ = 1;
                  while(_loc13_ <= 100)
                  {
                     _loc3_ = new Object();
                     _loc4_ = new FightData();
                     _loc4_.jiDao = Number(_loc7_.击倒);
                     _loc4_.jiDaoKanXin = Number(_loc7_.击倒抗性);
                     _loc4_.jiDaoXiShu = Number(_loc7_.击倒系数);
                     _loc4_.jiDaoZheng = Number(_loc7_.击倒几帧);
                     _loc4_.shiZhong = Number(_loc7_.失重);
                     _loc4_.shiZhongKanXin = Number(_loc7_.失重抗性);
                     _loc4_.shiZhongXiShu = Number(_loc7_.失重系数);
                     _loc4_.shiZhongZheng = Number(_loc7_.失重几帧);
                     _loc4_.tiaoGao = Number(_loc7_.挑高);
                     _loc4_.tiaoGaoEase = Number(_loc7_.挑高缓动);
                     _loc4_.tiaoGaoKanXin = Number(_loc7_.挑高抗性);
                     _loc4_.tiaoGaoValue = Number(_loc7_.挑高值);
                     _loc4_.tiaoGaoXiShu = Number(_loc7_.挑高系数);
                     _loc4_.tiaoGaoZheng = Number(_loc7_.挑高几帧);
                     _loc4_.yinZhi = Number(_loc7_.硬直);
                     _loc4_.yinZhiKanXin = Number(_loc7_.硬直抗性);
                     _loc4_.yinZhiXiShu = Number(_loc7_.硬直系数);
                     _loc4_.yinZhiZheng = Number(_loc7_.硬直几帧);
                     _loc4_.zhenTui = Number(_loc7_.震退);
                     _loc4_.zhenTuiEase = Number(_loc7_.震退缓动);
                     _loc4_.zhenTuiKanXin = Number(_loc7_.震退抗性);
                     _loc4_.zhenTuiType = Number(_loc7_.震退类型);
                     _loc4_.zhenTuiValue = Number(_loc7_.震退值);
                     _loc4_.zhenTuiXiShu = Number(_loc7_.震退系数);
                     _loc4_.zhenTuiZheng = Number(_loc7_.震退几帧);
                     _loc4_.daJi = Number(_loc7_.打击效果);
                     _loc4_.shangHaiBi = Number(_loc12_[1]) * _loc13_ + Number(_loc12_[0]);
                     _loc4_.jiangShangBi = Number(_loc7_.伤害减幅);
                     _loc4_.xianziKanXin = Number(_loc7_.束缚技限制);
                     _loc4_.caflag = Number(_loc7_.招式标识);
                     _loc4_.flag = Number(_loc7_.穿墙标识);
                     if(String(_loc7_.技能特殊效果) != "null")
                     {
                        _loc4_.othersSkill = Number(_loc7_.技能特殊效果);
                     }
                     if(String(_loc7_.装备特殊效果) != "null")
                     {
                        _loc4_.goodsSkill = UTools.sTnArrAndVT(String(_loc7_.装备特殊效果).split(","));
                     }
                     _loc4_.hitFlahE = String(_loc7_.打击光效);
                     _loc4_.hitsound = String(_loc7_.击中声音);
                     _loc4_.jiJiaAng = Number(_loc7_.怒气倍数);
                     _loc3_.fda = _loc4_;
                     _loc3_.createsound = String(_loc7_.生成声音);
                     _loc3_.bombsound = String(_loc7_.爆炸声音);
                     _loc3_.runMaxOver = Number(_loc7_.存在之后);
                     _loc3_.runStateOver = Number(_loc7_.运行之后);
                     _loc3_.runMaxNum = Number(_loc7_.存在帧数);
                     _loc3_.bSpeed = Number(_loc7_.速度);
                     _loc3_.hp = Number(_loc7_.血量);
                     _loc3_.yba = Number(_loc7_.被打);
                     _loc3_.chuanMonster = Number(_loc7_.穿怪);
                     if(String(_loc7_.出那个怪) == "null")
                     {
                        _loc3_.cumonstername = "";
                     }
                     else
                     {
                        _loc3_.cumonstername = String(_loc7_.出那个怪);
                     }
                     _loc3_.dmclevel = Number(_loc7_.子弹层级);
                     _loc3_.zhendong = com.adobeadobe.serialization.json.JSON.decode(String(_loc7_.震动));
                     _loc3_.others = com.adobeadobe.serialization.json.JSON.decode(String(_loc7_.其它));
                     _loc14_ = com.adobeadobe.serialization.json.JSON.decode(String(_loc7_.其它vt));
                     _loc15_ = new Object();
                     for(_loc16_ in _loc14_)
                     {
                        _loc15_[_loc16_] = VT.createVT(_loc14_[_loc16_]);
                     }
                     _loc3_.othersvt = _loc15_;
                     _loc3_.classname = String(_loc7_.类名);
                     _loc3_.flaname = String(_loc7_.元件名);
                     bulletData[String(_loc7_.源名) + _loc13_] = _loc3_;
                     _loc13_++;
                  }
               }
               else
               {
                  _loc3_ = new Object();
                  _loc4_ = new FightData();
                  _loc4_.jiDao = Number(_loc7_.击倒);
                  _loc4_.jiDaoKanXin = Number(_loc7_.击倒抗性);
                  _loc4_.jiDaoXiShu = Number(_loc7_.击倒系数);
                  _loc4_.jiDaoZheng = Number(_loc7_.击倒几帧);
                  _loc4_.shiZhong = Number(_loc7_.失重);
                  _loc4_.shiZhongKanXin = Number(_loc7_.失重抗性);
                  _loc4_.shiZhongXiShu = Number(_loc7_.失重系数);
                  _loc4_.shiZhongZheng = Number(_loc7_.失重几帧);
                  _loc4_.tiaoGao = Number(_loc7_.挑高);
                  _loc4_.tiaoGaoEase = Number(_loc7_.挑高缓动);
                  _loc4_.tiaoGaoKanXin = Number(_loc7_.挑高抗性);
                  _loc4_.tiaoGaoValue = Number(_loc7_.挑高值);
                  _loc4_.tiaoGaoXiShu = Number(_loc7_.挑高系数);
                  _loc4_.tiaoGaoZheng = Number(_loc7_.挑高几帧);
                  _loc4_.yinZhi = Number(_loc7_.硬直);
                  _loc4_.yinZhiKanXin = Number(_loc7_.硬直抗性);
                  _loc4_.yinZhiXiShu = Number(_loc7_.硬直系数);
                  _loc4_.yinZhiZheng = Number(_loc7_.硬直几帧);
                  _loc4_.zhenTui = Number(_loc7_.震退);
                  _loc4_.zhenTuiEase = Number(_loc7_.震退缓动);
                  _loc4_.zhenTuiKanXin = Number(_loc7_.震退抗性);
                  _loc4_.zhenTuiType = Number(_loc7_.震退类型);
                  _loc4_.zhenTuiValue = Number(_loc7_.震退值);
                  _loc4_.zhenTuiXiShu = Number(_loc7_.震退系数);
                  _loc4_.zhenTuiZheng = Number(_loc7_.震退几帧);
                  _loc4_.daJi = Number(_loc7_.打击效果);
                  _loc4_.shangHaiBi = Number(_loc7_.伤害增幅);
                  _loc4_.jiangShangBi = Number(_loc7_.伤害减幅);
                  _loc4_.xianziKanXin = Number(_loc7_.束缚技限制);
                  _loc4_.caflag = Number(_loc7_.招式标识);
                  _loc4_.flag = Number(_loc7_.穿墙标识);
                  if(String(_loc7_.技能特殊效果) != "null")
                  {
                     _loc4_.othersSkill = Number(_loc7_.技能特殊效果);
                  }
                  if(String(_loc7_.装备特殊效果) != "null")
                  {
                     _loc4_.goodsSkill = UTools.sTnArrAndVT(String(_loc7_.装备特殊效果).split(","));
                  }
                  _loc4_.hitFlahE = String(_loc7_.打击光效);
                  _loc4_.hitsound = String(_loc7_.击中声音);
                  _loc4_.jiJiaAng = Number(_loc7_.怒气倍数);
                  _loc3_.fda = _loc4_;
                  _loc3_.createsound = String(_loc7_.生成声音);
                  _loc3_.bombsound = String(_loc7_.爆炸声音);
                  _loc3_.runMaxOver = Number(_loc7_.存在之后);
                  _loc3_.runStateOver = Number(_loc7_.运行之后);
                  _loc3_.runMaxNum = Number(_loc7_.存在帧数);
                  _loc3_.bSpeed = Number(_loc7_.速度);
                  _loc3_.hp = Number(_loc7_.血量);
                  _loc3_.yba = Number(_loc7_.被打);
                  _loc3_.chuanMonster = Number(_loc7_.穿怪);
                  if(String(_loc7_.出那个怪) == "null")
                  {
                     _loc3_.cumonstername = "";
                  }
                  else
                  {
                     _loc3_.cumonstername = String(_loc7_.出那个怪);
                  }
                  _loc3_.dmclevel = Number(_loc7_.子弹层级);
                  _loc3_.zhendong = com.adobeadobe.serialization.json.JSON.decode(String(_loc7_.震动));
                  _loc3_.others = com.adobeadobe.serialization.json.JSON.decode(String(_loc7_.其它));
                  _loc17_ = com.adobeadobe.serialization.json.JSON.decode(String(_loc7_.其它vt));
                  _loc18_ = new Object();
                  for(_loc19_ in _loc17_)
                  {
                     _loc18_[_loc19_] = VT.createVT(_loc17_[_loc19_]);
                  }
                  _loc3_.othersvt = _loc18_;
                  _loc3_.classname = String(_loc7_.类名);
                  _loc3_.flaname = String(_loc7_.元件名);
                  bulletData[String(_loc7_.源名) + String(_loc7_.二名)] = _loc3_;
               }
            }
         }
      }
      
      public static function getBulletData(param1:String) : Object
      {
         return bulletData[param1];
      }
   }
}

