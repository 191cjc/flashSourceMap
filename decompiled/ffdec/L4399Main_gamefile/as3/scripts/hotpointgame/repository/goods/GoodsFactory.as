package hotpointgame.repository.goods
{
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   import hotpointgame.models.goods.*;
   
   public class GoodsFactory
   {
      
      private static var goodsList:Array = [];
      
      public static var goodsXXX:Array = [];
      
      public static var goodsMaxList:Array = [];
      
      public function GoodsFactory()
      {
         super();
      }
      
      public static function creatGsnFactory(param1:XML) : *
      {
         var _loc2_:XML = null;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:GoodsNumBasicData = null;
         for each(_loc2_ in param1.最大数量)
         {
            _loc3_ = Number(_loc2_.ID);
            _loc4_ = Number(_loc2_.物品ID);
            _loc5_ = Number(_loc2_.物品数量);
            _loc6_ = GoodsNumBasicData.createGsnData(_loc3_,_loc4_,_loc5_);
            goodsMaxList.push(_loc6_);
         }
      }
      
      public static function creatGoodsFactory(param1:XML) : *
      {
         var _loc5_:XML = null;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:String = null;
         var _loc9_:Number = NaN;
         var _loc10_:XMLList = null;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc16_:String = null;
         var _loc17_:Number = NaN;
         var _loc18_:Number = NaN;
         var _loc19_:Number = NaN;
         var _loc20_:Number = NaN;
         var _loc21_:Boolean = false;
         var _loc22_:Boolean = false;
         var _loc23_:String = null;
         var _loc24_:Number = NaN;
         var _loc25_:Number = NaN;
         var _loc26_:String = null;
         var _loc27_:Number = NaN;
         var _loc28_:Number = NaN;
         var _loc29_:Number = NaN;
         var _loc30_:Number = NaN;
         var _loc31_:Number = NaN;
         var _loc32_:Number = NaN;
         var _loc33_:Number = NaN;
         var _loc34_:Number = NaN;
         var _loc35_:Number = NaN;
         var _loc36_:Number = NaN;
         var _loc37_:Number = NaN;
         var _loc38_:Number = NaN;
         var _loc39_:Number = NaN;
         var _loc40_:XMLList = null;
         var _loc41_:XMLList = null;
         var _loc42_:Number = NaN;
         var _loc43_:Number = NaN;
         var _loc44_:Number = NaN;
         var _loc45_:Number = NaN;
         var _loc46_:Number = NaN;
         var _loc47_:String = null;
         var _loc48_:String = null;
         var _loc49_:String = null;
         var _loc50_:Boolean = false;
         var _loc51_:Number = NaN;
         var _loc52_:Boolean = false;
         var _loc53_:String = null;
         var _loc54_:String = null;
         var _loc55_:String = null;
         var _loc56_:String = null;
         var _loc57_:String = null;
         var _loc58_:Array = null;
         var _loc59_:Array = null;
         var _loc60_:Array = null;
         var _loc61_:XML = null;
         var _loc62_:XML = null;
         var _loc63_:XML = null;
         var _loc64_:GoodsData = null;
         var _loc2_:String = param1.toXMLString();
         var _loc3_:RegExp = /&lt;/g;
         var _loc4_:RegExp = /&gt;/g;
         _loc2_ = _loc2_.replace(_loc3_,"<");
         _loc2_ = _loc2_.replace(_loc4_,">");
         param1 = new XML(_loc2_);
         for each(_loc5_ in param1.物品)
         {
            _loc6_ = Number(_loc5_.共有.id);
            _loc7_ = Number(_loc5_.共有.帧数);
            _loc8_ = String(_loc5_.共有.名称);
            _loc9_ = Number(_loc5_.共有.颜色);
            _loc10_ = _loc5_.共有.固定属性;
            _loc11_ = Number(_loc5_.共有.价值);
            _loc12_ = Number(_loc5_.共有.使用等级);
            _loc13_ = Number(_loc5_.共有.创建等级);
            _loc14_ = Number(_loc5_.共有.类型);
            _loc15_ = Number(_loc5_.共有.小类型);
            _loc16_ = String(_loc5_.共有.说明);
            _loc17_ = Number(_loc5_.共有.价格);
            _loc18_ = Number(_loc5_.共有.叠加数);
            _loc19_ = Number(_loc5_.共有.结束时间);
            _loc20_ = Number(_loc5_.共有.背包);
            _loc21_ = (_loc5_.共有.是否出售.toString() == "true") as Boolean;
            _loc22_ = (_loc5_.共有.是否使用.toString() == "true") as Boolean;
            _loc23_ = String(_loc5_.共有.固定百分比);
            _loc24_ = Number(_loc5_.共有.阶段);
            _loc25_ = Number(_loc5_.共有.合成价格);
            _loc26_ = String(_loc5_.共有.合成区间);
            _loc27_ = Number(_loc5_.共有.商城价格);
            _loc28_ = Number(_loc5_.共有.完美度);
            _loc29_ = Number(_loc5_.共有.是否完美);
            _loc30_ = Number(_loc5_.共有.完美ID);
            _loc31_ = Number(_loc5_.共有.完美晶币);
            _loc32_ = Number(_loc5_.共有.完美数量);
            _loc33_ = Number(_loc5_.共有.完美上限);
            _loc34_ = Number(_loc5_.装备.强化);
            _loc35_ = Number(_loc5_.装备.攻击改造);
            _loc36_ = Number(_loc5_.装备.防御改造);
            _loc37_ = Number(_loc5_.装备.副炮改造);
            _loc38_ = Number(_loc5_.装备.职业);
            _loc39_ = Number(_loc5_.装备.套装id);
            _loc40_ = _loc5_.装备.五行抗性;
            _loc41_ = _loc5_.装备.技能;
            _loc42_ = Number(_loc5_.装备.宝石槽);
            _loc43_ = Number(_loc5_.装备.武器类型);
            _loc44_ = Number(_loc5_.装备.射速);
            _loc45_ = Number(_loc5_.装备.弹药);
            _loc46_ = Number(_loc5_.装备.弹药上限);
            _loc47_ = String(_loc5_.装备.元件名);
            _loc48_ = String(_loc5_.装备.普攻);
            _loc49_ = String(_loc5_.装备.跳射);
            _loc50_ = (_loc5_.装备.五行百分比.toString() == "true") as Boolean;
            _loc51_ = Number(_loc5_.其他.值);
            _loc52_ = (_loc5_.其他.百分比.toString() == "true") as Boolean;
            _loc53_ = _loc5_.其他.礼物id;
            _loc54_ = _loc5_.其他.礼物数量;
            _loc55_ = _loc5_.其他.需求id;
            _loc56_ = _loc5_.其他.需求数量;
            _loc57_ = _loc5_.其他.奖励概率;
            _loc58_ = [];
            _loc59_ = [];
            _loc60_ = [];
            for each(_loc61_ in _loc41_)
            {
               if(_loc61_.技能a != -1)
               {
                  _loc60_.push(VT.createVT(_loc61_.技能a));
               }
               if(_loc61_.技能b != -1)
               {
                  _loc60_.push(VT.createVT(_loc61_.技能b));
               }
               if(_loc61_.技能c != -1)
               {
                  _loc60_.push(VT.createVT(_loc61_.技能c));
               }
            }
            for each(_loc62_ in _loc40_)
            {
               if(_loc62_.金 != -1)
               {
                  _loc59_.push(BasicSx.creatBasicSx(7,Number(_loc62_.金)));
               }
               if(_loc62_.木 != -1)
               {
                  _loc59_.push(BasicSx.creatBasicSx(8,Number(_loc62_.木)));
               }
               if(_loc62_.水 != -1)
               {
                  _loc59_.push(BasicSx.creatBasicSx(9,Number(_loc62_.水)));
               }
               if(_loc62_.火 != -1)
               {
                  _loc59_.push(BasicSx.creatBasicSx(10,Number(_loc62_.火)));
               }
               if(_loc62_.土 != -1)
               {
                  _loc59_.push(BasicSx.creatBasicSx(11,Number(_loc62_.土)));
               }
               if(_loc62_.混沌 != -1)
               {
                  _loc59_.push(BasicSx.creatBasicSx(12,Number(_loc62_.混沌)));
               }
            }
            for each(_loc63_ in _loc10_)
            {
               if(_loc63_.生命 != -1)
               {
                  _loc58_.push(BasicSx.creatBasicSx(1,Number(_loc63_.生命)));
               }
               if(_loc63_.能量 != -1)
               {
                  _loc58_.push(BasicSx.creatBasicSx(2,Number(_loc63_.能量)));
               }
               if(_loc63_.攻击 != -1)
               {
                  _loc58_.push(BasicSx.creatBasicSx(3,Number(_loc63_.攻击)));
               }
               if(_loc63_.防御 != -1)
               {
                  _loc58_.push(BasicSx.creatBasicSx(4,Number(_loc63_.防御)));
               }
               if(_loc63_.暴击 != -1)
               {
                  _loc58_.push(BasicSx.creatBasicSx(5,Number(_loc63_.暴击)));
               }
               if(_loc63_.速度 != -1)
               {
                  _loc58_.push(BasicSx.creatBasicSx(6,Number(_loc63_.速度)));
               }
               if(_loc63_.金 != -1)
               {
                  _loc58_.push(BasicSx.creatBasicSx(7,Number(_loc63_.金)));
               }
               if(_loc63_.木 != -1)
               {
                  _loc58_.push(BasicSx.creatBasicSx(8,Number(_loc63_.木)));
               }
               if(_loc63_.水 != -1)
               {
                  _loc58_.push(BasicSx.creatBasicSx(9,Number(_loc63_.水)));
               }
               if(_loc63_.火 != -1)
               {
                  _loc58_.push(BasicSx.creatBasicSx(10,Number(_loc63_.火)));
               }
               if(_loc63_.土 != -1)
               {
                  _loc58_.push(BasicSx.creatBasicSx(11,Number(_loc63_.土)));
               }
               if(_loc63_.混沌 != -1)
               {
                  _loc58_.push(BasicSx.creatBasicSx(12,Number(_loc63_.混沌)));
               }
            }
            _loc64_ = new GoodsData();
            _loc64_.createSameData(_loc6_,_loc7_,_loc8_,_loc9_,_loc58_,_loc11_,_loc12_,_loc13_,_loc14_,_loc15_,_loc16_,_loc17_,_loc18_,_loc19_,_loc20_,_loc21_,_loc22_,_loc23_,_loc24_,_loc25_,_loc26_,_loc27_,_loc29_,_loc30_,_loc31_,_loc32_,_loc33_);
            if(_loc14_ == 0)
            {
               _loc64_.creatEquipData(_loc34_,_loc38_,_loc59_,_loc60_,_loc42_,_loc39_,_loc35_,_loc36_,_loc37_,_loc43_,_loc44_,_loc45_,_loc46_,_loc47_,_loc48_,_loc49_,_loc50_);
            }
            else if(_loc14_ == 2)
            {
               _loc64_.creatOtherData(_loc51_,_loc52_,_loc53_,_loc54_,_loc55_,_loc56_,_loc57_);
            }
            goodsList[_loc6_] = _loc64_;
         }
      }
      
      public static function createGoodsByCreateLevelList(param1:Array) : Goods
      {
         var _loc3_:GoodsData = null;
         var _loc5_:Number = NaN;
         var _loc2_:Array = [];
         for each(_loc3_ in goodsList)
         {
            for each(_loc5_ in param1)
            {
               if(_loc3_ != null && _loc3_.getCreateLevel() == _loc5_)
               {
                  _loc2_.push(_loc3_);
               }
            }
         }
         if(_loc2_.length == 0)
         {
            throw new Error("没有这个的创建等级物品");
         }
         var _loc4_:int = Math.floor(Math.random() * _loc2_.length);
         _loc3_ = _loc2_[_loc4_] as GoodsData;
         return _loc3_.createGoods();
      }
      
      public static function createGoodsByCreateLevel(param1:Number) : Goods
      {
         var _loc3_:GoodsData = null;
         var _loc2_:Array = [];
         for each(_loc3_ in goodsList)
         {
            if(_loc3_ != null && _loc3_.getCreateLevel() == param1)
            {
               _loc2_.push(_loc3_);
            }
         }
         if(_loc2_.length == 0)
         {
            return null;
         }
         var _loc4_:int = Math.floor(Math.random() * _loc2_.length);
         _loc3_ = _loc2_[_loc4_] as GoodsData;
         return _loc3_.createGoods();
      }
      
      public static function createGoodsById(param1:Number) : Goods
      {
         if(getGoodsById(param1) != null)
         {
            return getGoodsById(param1).createGoods();
         }
         return null;
      }
      
      public static function getGoodsById(param1:Number) : GoodsData
      {
         var _loc2_:GoodsData = null;
         if(goodsList[param1] != null)
         {
            _loc2_ = goodsList[param1];
            if(param1 != _loc2_.getId())
            {
               GM.aSaveData.checkfm.addFlag(GS.a51,param1);
               GM.testapi.saveDataBeforeNoState();
               FlowInterface.findCheat(GS.a106);
            }
            return _loc2_;
         }
         GM.aSaveData.checkfm.addFlag(GS.a9,param1);
         GM.testapi.saveDataBeforeNoState();
         FlowInterface.findCheat(GS.a107);
         return null;
      }
      
      public static function getSuitName(param1:*) : Array
      {
         var _loc5_:GoodsData = null;
         var _loc2_:Array = [];
         var _loc3_:Array = [];
         var _loc4_:uint = 0;
         while(_loc4_ < goodsList.length)
         {
            if(goodsList[_loc4_] != null)
            {
               _loc5_ = goodsList[_loc4_] as GoodsData;
               if(_loc5_.getSuite() == param1)
               {
                  _loc2_.push(_loc5_.getName());
               }
            }
            _loc4_++;
         }
         _loc4_ = 0;
         while(_loc4_ < _loc2_.length)
         {
            if(_loc3_.indexOf(_loc2_[_loc4_]) == -1)
            {
               _loc3_.push(_loc2_[_loc4_]);
            }
            _loc4_++;
         }
         if(_loc3_.length == 0)
         {
            return null;
         }
         return _loc3_;
      }
      
      public static function getBagNum(param1:Number) : Number
      {
         return getGoodsById(param1).getbagNum();
      }
      
      public static function getGoodsIdByJz(param1:Number, param2:Goods) : Array
      {
         var _loc7_:GoodsData = null;
         var _loc8_:Number = NaN;
         var _loc9_:uint = 0;
         var _loc10_:GoodsData = null;
         var _loc11_:GoodsData = null;
         var _loc3_:Array = [];
         var _loc4_:uint = 0;
         while(_loc4_ < goodsList.length)
         {
            if(goodsList[_loc4_] != null)
            {
               _loc7_ = goodsList[_loc4_] as GoodsData;
               if(param2.getType() == GS.a0)
               {
                  if(_loc7_.getType() == param2.getType() && _loc7_.getSmallType() == param2.getSmallType() && _loc7_.getJob() == param2.getJob() && param2.getJd() == _loc7_.getJd())
                  {
                     _loc3_ = getGoodsTj(param1,_loc7_,_loc3_);
                  }
               }
               else if(_loc7_.getType() == param2.getType() && _loc7_.getSmallType() == param2.getSmallType() && param2.getJd() == _loc7_.getJd())
               {
                  _loc3_ = getGoodsTj(param1,_loc7_,_loc3_);
               }
            }
            _loc4_++;
         }
         var _loc5_:Array = [];
         var _loc6_:Array = [];
         _loc4_ = 0;
         while(_loc4_ < _loc3_.length)
         {
            _loc7_ = _loc3_[_loc4_] as GoodsData;
            if(_loc5_.indexOf(_loc7_) == -1)
            {
               _loc5_.push(_loc7_);
            }
            _loc4_++;
         }
         _loc4_ = 0;
         while(_loc4_ < _loc5_.length)
         {
            _loc8_ = 0;
            if(!_loc6_[_loc4_])
            {
               _loc6_[_loc4_] = [];
            }
            _loc9_ = 0;
            while(_loc9_ < _loc3_.length)
            {
               if(_loc5_[_loc4_] == _loc3_[_loc9_])
               {
                  _loc8_++;
               }
               _loc9_++;
            }
            _loc6_[_loc4_] = [_loc5_[_loc4_],_loc8_ * GS.a1000];
            _loc4_++;
         }
         _loc4_ = 0;
         while(_loc4_ < _loc6_.length)
         {
            _loc8_ = 0;
            _loc10_ = _loc6_[_loc4_][0] as GoodsData;
            _loc9_ = 0;
            while(_loc9_ < _loc6_.length)
            {
               _loc11_ = _loc6_[_loc9_][0] as GoodsData;
               if(_loc10_.getHcQj()[0] == _loc11_.getHcQj()[0] && _loc10_.getHcQj()[1] == _loc11_.getHcQj()[1])
               {
                  _loc8_++;
               }
               _loc9_++;
            }
            _loc6_[_loc4_][1] = Math.floor(_loc6_[_loc4_][1] / _loc8_);
            _loc4_++;
         }
         return _loc6_;
      }
      
      private static function getGoodsTj(param1:Number, param2:GoodsData, param3:Array) : Array
      {
         if(param1 + GS.a1 > param2.getHcQj()[0] && param1 + GS.a1 <= param2.getHcQj()[1])
         {
            param3.push(param2);
         }
         if(param1 + GS.a2 > param2.getHcQj()[0] && param1 + GS.a2 <= param2.getHcQj()[1])
         {
            param3.push(param2);
         }
         if(param1 - GS.a8 > param2.getHcQj()[0] && param1 - GS.a8 <= param2.getHcQj()[1])
         {
            param3.push(param2);
         }
         if(param1 - GS.a7 > param2.getHcQj()[0] && param1 - GS.a7 <= param2.getHcQj()[1])
         {
            param3.push(param2);
         }
         if(param1 - GS.a6 > param2.getHcQj()[0] && param1 - GS.a6 <= param2.getHcQj()[1])
         {
            param3.push(param2);
         }
         if(param1 - GS.a5 > param2.getHcQj()[0] && param1 - GS.a5 <= param2.getHcQj()[1])
         {
            param3.push(param2);
         }
         if(param1 - GS.a4 > param2.getHcQj()[0] && param1 - GS.a4 <= param2.getHcQj()[1])
         {
            param3.push(param2);
         }
         if(param1 - GS.a3 > param2.getHcQj()[0] && param1 - GS.a3 <= param2.getHcQj()[1])
         {
            param3.push(param2);
         }
         if(param1 - GS.a2 > param2.getHcQj()[0] && param1 - GS.a2 <= param2.getHcQj()[1])
         {
            param3.push(param2);
         }
         if(param1 - GS.a1 > param2.getHcQj()[0] && param1 - GS.a1 <= param2.getHcQj()[1])
         {
            param3.push(param2);
         }
         return param3;
      }
      
      public static function getIdArrBySmType(param1:Number) : Array
      {
         var _loc3_:GoodsData = null;
         var _loc2_:Array = [];
         for each(_loc3_ in goodsList)
         {
            if(_loc3_ != null)
            {
               if(_loc3_.getSmallType() == param1)
               {
                  _loc2_.push(_loc3_);
               }
            }
         }
         return _loc2_;
      }
   }
}

