package hotpointgame.views.geneChangePanel
{
   import flash.utils.*;
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   import hotpointgame.repository.geneChange.*;
   import hotpointgame.repository.goodsSkill.*;
   
   public class GeneData
   {
      
      public static var maxLevel:VT = VT.createVT(GS.a12);
      
      public static var levelArr:Array = [];
      
      public static var keyArr:Array = [];
      
      public static var times:VT = VT.createVT(GS.a1);
      
      public static var allTimes:VT = VT.createVT(GS.a20);
      
      public static var loadStateArr:Array = [];
      
      public static var beforeTime:Array = [];
      
      public static var mbTime:Array = [];
      
      public static var mbTimeXX:Array = [];
      
      public static var xsTime:Array = [];
      
      public static var timeBo:Array = [];
      
      public static var geneSkill:Array = [];
      
      public static var timeArr:Array = [0,GS.a1,GS.a1,GS.a2,GS.a2,GS.a3,GS.a4,GS.a5,GS.a7,GS.a10,GS.a14,GS.a20,GS.a28,GS.a40,GS.a58,GS.a58,GS.a58,GS.a58,GS.a58,GS.a58,GS.a58,GS.a58];
      
      public static var lkdjIdArr:Array = [0,GS.a563,GS.a564,GS.a565,GS.a566,GS.a567,GS.a568,GS.a569,GS.a570,GS.a571,GS.a572,GS.a572,GS.a572,GS.a572,GS.a572,GS.a572,GS.a572,GS.a572,GS.a572,GS.a572,GS.a572];
      
      public static var lkdjGoldArr:Array = [0,GS.a100,GS.a200,GS.a300,GS.a400,GS.a500,GS.a600,GS.a700,GS.a800,GS.a900,GS.a1000,GS.a1000,GS.a1000,GS.a1000,GS.a1000,GS.a1000,GS.a1000,GS.a1000,GS.a1000,GS.a1000,GS.a1000];
      
      public static var tsBo:Boolean = false;
      
      public static var mvBo:Boolean = false;
      
      public static var mvBoX:Boolean = false;
      
      public function GeneData()
      {
         super();
      }
      
      public static function initData() : void
      {
         var _loc1_:uint = 0;
         while(_loc1_ < GS.a7)
         {
            levelArr[_loc1_] = VT.createVT(GS.a0);
            keyArr[_loc1_] = VT.createVT(GS.a0);
            loadStateArr[_loc1_] = VT.createVT(GS.a0);
            beforeTime[_loc1_] = VT.createVT(-1);
            mbTime[_loc1_] = VT.createVT(-1);
            mbTimeXX[_loc1_] = VT.createVT(-1);
            xsTime[_loc1_] = VT.createVT(-1);
            timeBo[_loc1_] = VT.createVT(-1);
            geneSkill[_loc1_] = VT.createVT(-1);
            _loc1_++;
         }
         keyArr[GS.a5] = VT.createVT(GS.a1);
         times.setValue(GS.a1);
      }
      
      public static function closeData() : void
      {
         initData();
         tsBo = false;
         mvBo = false;
         mvBoX = false;
      }
      
      public static function save() : Object
      {
         var _loc1_:Object = new Object();
         var _loc2_:Array = [];
         var _loc3_:uint = 0;
         while(_loc3_ < levelArr.length)
         {
            _loc2_.push(levelArr[_loc3_].getValue());
            _loc3_++;
         }
         _loc1_["lv"] = _loc2_;
         var _loc4_:Array = [];
         _loc3_ = 0;
         while(_loc3_ < keyArr.length)
         {
            _loc4_.push(keyArr[_loc3_].getValue());
            _loc3_++;
         }
         _loc1_["ke"] = _loc4_;
         var _loc5_:Array = [];
         _loc3_ = 0;
         while(_loc3_ < loadStateArr.length)
         {
            _loc5_.push(loadStateArr[_loc3_].getValue());
            _loc3_++;
         }
         _loc1_["lo"] = _loc5_;
         var _loc6_:Array = [];
         _loc3_ = 0;
         while(_loc3_ < geneSkill.length)
         {
            _loc6_.push(geneSkill[_loc3_].getValue());
            _loc3_++;
         }
         _loc1_["sk"] = _loc6_;
         _loc1_["ts"] = times.getValue();
         _loc1_["mv"] = mvBo;
         _loc1_["mvx"] = mvBoX;
         return _loc1_;
      }
      
      public static function read(param1:Object) : void
      {
         var _loc2_:Array = param1["lv"];
         var _loc3_:uint = 0;
         while(_loc3_ < _loc2_.length)
         {
            levelArr[_loc3_] = VT.createVT(_loc2_[_loc3_]);
            _loc3_++;
         }
         var _loc4_:Array = param1["ke"];
         _loc3_ = 0;
         while(_loc3_ < _loc4_.length)
         {
            keyArr[_loc3_] = VT.createVT(_loc4_[_loc3_]);
            _loc3_++;
         }
         var _loc5_:Array = param1["lo"];
         _loc3_ = 0;
         while(_loc3_ < _loc5_.length)
         {
            loadStateArr[_loc3_] = VT.createVT(_loc5_[_loc3_]);
            _loc3_++;
         }
         var _loc6_:Array = param1["sk"];
         _loc3_ = 0;
         while(_loc3_ < _loc6_.length)
         {
            if(_loc6_[_loc3_] != "null")
            {
               geneSkill[_loc3_] = VT.createVT(_loc6_[_loc3_]);
            }
            else
            {
               geneSkill[_loc3_] = VT.createVT(-1);
            }
            _loc3_++;
         }
         times = VT.createVT(param1["ts"]);
         mvBo = param1["mv"];
         mvBoX = param1["mvx"];
         timesGoTo();
      }
      
      public static function clearTime() : void
      {
         times.setValue(GS.a1);
      }
      
      public static function zrTest(param1:Number, param2:Number) : void
      {
         if(param1 > 6)
         {
            param1 = 6;
         }
         if(param2 > maxLevel.getValue())
         {
            param2 = maxLevel.getValue();
         }
         levelArr[param1] = VT.createVT(param2);
         keyArr[param1] = VT.createVT(GS.a1);
         levelArr;
         var _loc3_:GeneChangeData = GeneChangeFactory.getGeneByData(FlowInterface.getJobByRole(),param1);
         var _loc4_:Number = _loc3_.getSkillId(param2);
         geneSkill[param1] = VT.createVT(_loc4_);
      }
      
      public static function getLkId(param1:Number) : Number
      {
         return lkdjIdArr[param1];
      }
      
      public static function getLkGold(param1:Number) : Number
      {
         return lkdjGoldArr[param1];
      }
      
      public static function clearLoadData(param1:Number) : void
      {
         setLoadState(param1,GS.a0);
         setBeForeTime(param1,-1);
         setMbTime(param1,-1);
         setXsTime(param1,-1);
         setTimeBo(param1,-1);
         setMbtimeXX(param1,-1);
      }
      
      public static function timesGoTo() : void
      {
         GM.testapi.getServerTimerByH(setBeginTime);
      }
      
      private static function setBeginTime(param1:Number) : void
      {
         var _loc2_:Number = getTimebyTimes(getTimes()) * GS.a60;
         var _loc3_:uint = 0;
         while(_loc3_ < GS.a7)
         {
            if(getLoadState(_loc3_) == GS.a1)
            {
               setMbtimeXX(_loc3_,_loc2_);
               setMbTime(_loc3_,getTimer() / GS.a1000 + _loc2_);
               setBeForeTime(_loc3_,param1);
            }
            _loc3_++;
         }
      }
      
      public static function getMbtimeXX(param1:Number) : Number
      {
         return mbTimeXX[param1].getValue();
      }
      
      public static function setMbtimeXX(param1:Number, param2:Number) : void
      {
         mbTimeXX[param1] = VT.createVT(param2);
      }
      
      public static function getGeneSkill() : Array
      {
         return geneSkill;
      }
      
      public static function setGeneSkill(param1:Number, param2:Number) : void
      {
         geneSkill[param1] = VT.createVT(param2);
      }
      
      public static function getSkillByType(param1:Number = 0) : Array
      {
         var _loc2_:Array = [];
         var _loc3_:uint = 0;
         while(_loc3_ < geneSkill.length)
         {
            if(geneSkill[_loc3_].getValue() != -1)
            {
               if(GoodsSkillFactory.getSkillDataById(geneSkill[_loc3_].getValue()).getType() == param1)
               {
                  _loc2_.push(GoodsSkillFactory.getSkillDataById(geneSkill[_loc3_].getValue()));
               }
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      public static function getXsTime(param1:Number) : Number
      {
         return xsTime[param1].getValue();
      }
      
      public static function setXsTime(param1:Number, param2:Number) : void
      {
         xsTime[param1] = VT.createVT(param2);
      }
      
      public static function getTimeBo(param1:Number) : Number
      {
         return timeBo[param1].getValue();
      }
      
      public static function setTimeBo(param1:Number, param2:Number) : void
      {
         timeBo[param1] = VT.createVT(param2);
      }
      
      public static function setMbTime(param1:Number, param2:Number) : void
      {
         mbTime[param1] = VT.createVT(param2);
         setXsTime(param1,param2);
      }
      
      public static function getMbTime(param1:Number) : Number
      {
         return mbTime[param1].getValue();
      }
      
      public static function setBeForeTime(param1:Number, param2:Number) : void
      {
         beforeTime[param1] = VT.createVT(param2);
      }
      
      public static function getBeForeTime(param1:Number) : Number
      {
         return beforeTime[param1].getValue();
      }
      
      public static function getLevelByType(param1:Number) : Number
      {
         return levelArr[param1].getValue();
      }
      
      public static function addLevelByType(param1:Number) : void
      {
         if(getLevelByType(param1) < maxLevel.getValue())
         {
            levelArr[param1] = VT.createVT(getLevelByType(param1) + GS.a1);
         }
      }
      
      public static function removeLevelByType(param1:Number) : void
      {
         if(getLevelByType(param1) > GS.a1)
         {
            levelArr[param1] = VT.createVT(getLevelByType(param1) - GS.a1);
         }
      }
      
      public static function isOpen(param1:Number) : Number
      {
         return keyArr[param1].getValue();
      }
      
      public static function openType(param1:Number) : void
      {
         keyArr[param1] = VT.createVT(GS.a1);
      }
      
      public static function getTimes() : Number
      {
         return times.getValue();
      }
      
      public static function addTimes() : void
      {
         if(times.getValue() < allTimes.getValue())
         {
            times.setValue(times.getValue() + GS.a1);
         }
      }
      
      public static function getTimebyTimes(param1:Number) : Number
      {
         return timeArr[param1];
      }
      
      public static function getLoadState(param1:Number) : Number
      {
         return loadStateArr[param1].getValue();
      }
      
      public static function setLoadState(param1:Number, param2:Number) : void
      {
         loadStateArr[param1] = VT.createVT(param2);
      }
      
      public static function getTypeNameByType(param1:Number) : String
      {
         switch(param1)
         {
            case 0:
               return "头部";
            case 1:
               return "躯干";
            case 2:
               return "核心";
            case 3:
               return "左手";
            case 4:
               return "右手";
            case 5:
               return "左脚";
            case 6:
               return "右脚";
            default:
               return "";
         }
      }
   }
}

