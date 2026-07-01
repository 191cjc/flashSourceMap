package hotpointgame.gameobj
{
   import hotpointgame.common.*;
   
   public class FightData
   {
      
      private var _yinZhi:VT = VT.createVT(0);
      
      private var _yinZhiZheng:VT = VT.createVT(0);
      
      private var _yinZhiKanXin:VT = VT.createVT(0);
      
      private var _yinZhiXiShu:VT = VT.createVT(0);
      
      private var _tiaoGao:VT = VT.createVT(0);
      
      private var _tiaoGaoValue:VT = VT.createVT(0);
      
      private var _tiaoGaoZheng:VT = VT.createVT(0);
      
      private var _tiaoGaoKanXin:VT = VT.createVT(0);
      
      private var _tiaoGaoXiShu:VT = VT.createVT(0);
      
      private var _tiaoGaoEase:VT = VT.createVT(0);
      
      private var _zhenTui:VT = VT.createVT(0);
      
      private var _zhenTuiValue:VT = VT.createVT(0);
      
      private var _zhenTuiZheng:VT = VT.createVT(0);
      
      private var _zhenTuiKanXin:VT = VT.createVT(0);
      
      private var _zhenTuiXiShu:VT = VT.createVT(0);
      
      private var _zhenTuiEase:VT = VT.createVT(0);
      
      private var _zhenTuiType:VT = VT.createVT(0);
      
      private var _shiZhong:VT = VT.createVT(0);
      
      private var _shiZhongZheng:VT = VT.createVT(0);
      
      private var _shiZhongKanXin:VT = VT.createVT(0);
      
      private var _shiZhongXiShu:VT = VT.createVT(0);
      
      private var _jiDao:VT = VT.createVT(0);
      
      private var _jiDaoZheng:VT = VT.createVT(0);
      
      private var _jiDaoKanXin:VT = VT.createVT(0);
      
      private var _jiDaoXiShu:VT = VT.createVT(0);
      
      private var _daJi:VT = VT.createVT(0);
      
      private var _shangHaiBi:VT = VT.createVT(0);
      
      private var _jiangShangBi:VT = VT.createVT(0);
      
      private var _caflag:VT = VT.createVT(0);
      
      private var _flag:VT = VT.createVT(0);
      
      private var _xianziKanXin:VT = VT.createVT(0);
      
      private var _othersSkill:VT = VT.createVT(0);
      
      private var _hitsound:String = "null";
      
      private var _hitFlahE:String = "null";
      
      private var _goodsSkill:Array = [];
      
      private var _jiJiaAng:VT = VT.createVT(0);
      
      public function FightData()
      {
         super();
      }
      
      public function coundYinZhi(param1:FightData, param2:Number = 0) : int
      {
         if(param1.yinZhi > this.yinZhiKanXin + param2)
         {
            return param1.yinZhiZheng * this.yinZhiXiShu;
         }
         return 0;
      }
      
      public function coundJiDao(param1:FightData, param2:Number = 0) : int
      {
         if(param1.jiDao > this.jiDaoKanXin + param2)
         {
            return param1.jiDaoZheng * this.jiDaoXiShu;
         }
         return 0;
      }
      
      public function coundTiaoGao(param1:FightData, param2:Number = 0) : int
      {
         if(param1.tiaoGao > this.tiaoGaoKanXin + param2)
         {
            return param1.tiaoGaoValue * this.tiaoGaoXiShu;
         }
         return 0;
      }
      
      public function coundZhenTui(param1:FightData, param2:Number = 0) : int
      {
         if(param1.zhenTui > this.zhenTuiKanXin + param2)
         {
            return param1.zhenTuiValue * this.zhenTuiXiShu;
         }
         return 0;
      }
      
      public function coundShiZhong(param1:FightData, param2:Number = 0) : int
      {
         if(param1.shiZhong > this.shiZhongKanXin + param2)
         {
            return param1.shiZhongZheng * this.shiZhongXiShu;
         }
         return 0;
      }
      
      public function get yinZhi() : Number
      {
         return this._yinZhi.getValue();
      }
      
      public function set yinZhi(param1:Number) : void
      {
         this._yinZhi.setValue(param1);
      }
      
      public function get yinZhiZheng() : Number
      {
         return this._yinZhiZheng.getValue();
      }
      
      public function set yinZhiZheng(param1:Number) : void
      {
         this._yinZhiZheng.setValue(param1);
      }
      
      public function get yinZhiKanXin() : Number
      {
         return this._yinZhiKanXin.getValue();
      }
      
      public function set yinZhiKanXin(param1:Number) : void
      {
         this._yinZhiKanXin.setValue(param1);
      }
      
      public function get yinZhiXiShu() : Number
      {
         return this._yinZhiXiShu.getValue();
      }
      
      public function set yinZhiXiShu(param1:Number) : void
      {
         this._yinZhiXiShu.setValue(param1);
      }
      
      public function get tiaoGao() : Number
      {
         return this._tiaoGao.getValue();
      }
      
      public function set tiaoGao(param1:Number) : void
      {
         this._tiaoGao.setValue(param1);
      }
      
      public function get tiaoGaoValue() : Number
      {
         return this._tiaoGaoValue.getValue();
      }
      
      public function set tiaoGaoValue(param1:Number) : void
      {
         this._tiaoGaoValue.setValue(param1);
      }
      
      public function get tiaoGaoZheng() : Number
      {
         return this._tiaoGaoZheng.getValue();
      }
      
      public function set tiaoGaoZheng(param1:Number) : void
      {
         this._tiaoGaoZheng.setValue(param1);
      }
      
      public function get tiaoGaoKanXin() : Number
      {
         return this._tiaoGaoKanXin.getValue();
      }
      
      public function set tiaoGaoKanXin(param1:Number) : void
      {
         this._tiaoGaoKanXin.setValue(param1);
      }
      
      public function get tiaoGaoXiShu() : Number
      {
         return this._tiaoGaoXiShu.getValue();
      }
      
      public function set tiaoGaoXiShu(param1:Number) : void
      {
         this._tiaoGaoXiShu.setValue(param1);
      }
      
      public function get tiaoGaoEase() : Number
      {
         return this._tiaoGaoEase.getValue();
      }
      
      public function set tiaoGaoEase(param1:Number) : void
      {
         this._tiaoGaoEase.setValue(param1);
      }
      
      public function get zhenTui() : Number
      {
         return this._zhenTui.getValue();
      }
      
      public function set zhenTui(param1:Number) : void
      {
         this._zhenTui.setValue(param1);
      }
      
      public function get zhenTuiValue() : Number
      {
         return this._zhenTuiValue.getValue();
      }
      
      public function set zhenTuiValue(param1:Number) : void
      {
         this._zhenTuiValue.setValue(param1);
      }
      
      public function get zhenTuiZheng() : Number
      {
         return this._zhenTuiZheng.getValue();
      }
      
      public function set zhenTuiZheng(param1:Number) : void
      {
         this._zhenTuiZheng.setValue(param1);
      }
      
      public function get zhenTuiKanXin() : Number
      {
         return this._zhenTuiKanXin.getValue();
      }
      
      public function set zhenTuiKanXin(param1:Number) : void
      {
         this._zhenTuiKanXin.setValue(param1);
      }
      
      public function get zhenTuiXiShu() : Number
      {
         return this._zhenTuiXiShu.getValue();
      }
      
      public function set zhenTuiXiShu(param1:Number) : void
      {
         this._zhenTuiXiShu.setValue(param1);
      }
      
      public function get zhenTuiEase() : Number
      {
         return this._zhenTuiEase.getValue();
      }
      
      public function set zhenTuiEase(param1:Number) : void
      {
         this._zhenTuiEase.setValue(param1);
      }
      
      public function get zhenTuiType() : Number
      {
         return this._zhenTuiType.getValue();
      }
      
      public function set zhenTuiType(param1:Number) : void
      {
         this._zhenTuiType.setValue(param1);
      }
      
      public function get shiZhong() : Number
      {
         return this._shiZhong.getValue();
      }
      
      public function set shiZhong(param1:Number) : void
      {
         this._shiZhong.setValue(param1);
      }
      
      public function get shiZhongZheng() : Number
      {
         return this._shiZhongZheng.getValue();
      }
      
      public function set shiZhongZheng(param1:Number) : void
      {
         this._shiZhongZheng.setValue(param1);
      }
      
      public function get shiZhongKanXin() : Number
      {
         return this._shiZhongKanXin.getValue();
      }
      
      public function set shiZhongKanXin(param1:Number) : void
      {
         this._shiZhongKanXin.setValue(param1);
      }
      
      public function get shiZhongXiShu() : Number
      {
         return this._shiZhongXiShu.getValue();
      }
      
      public function set shiZhongXiShu(param1:Number) : void
      {
         this._shiZhongXiShu.setValue(param1);
      }
      
      public function get jiDao() : Number
      {
         return this._jiDao.getValue();
      }
      
      public function set jiDao(param1:Number) : void
      {
         this._jiDao.setValue(param1);
      }
      
      public function get jiDaoZheng() : Number
      {
         return this._jiDaoZheng.getValue();
      }
      
      public function set jiDaoZheng(param1:Number) : void
      {
         this._jiDaoZheng.setValue(param1);
      }
      
      public function get jiDaoKanXin() : Number
      {
         return this._jiDaoKanXin.getValue();
      }
      
      public function set jiDaoKanXin(param1:Number) : void
      {
         this._jiDaoKanXin.setValue(param1);
      }
      
      public function get jiDaoXiShu() : Number
      {
         return this._jiDaoXiShu.getValue();
      }
      
      public function set jiDaoXiShu(param1:Number) : void
      {
         this._jiDaoXiShu.setValue(param1);
      }
      
      public function get shangHaiBi() : Number
      {
         return this._shangHaiBi.getValue();
      }
      
      public function set shangHaiBi(param1:Number) : void
      {
         this._shangHaiBi.setValue(param1);
      }
      
      public function get jiangShangBi() : Number
      {
         return this._jiangShangBi.getValue();
      }
      
      public function set jiangShangBi(param1:Number) : void
      {
         this._jiangShangBi.setValue(param1);
      }
      
      public function get daJi() : Number
      {
         return this._daJi.getValue();
      }
      
      public function set daJi(param1:Number) : void
      {
         this._daJi.setValue(param1);
      }
      
      public function get flag() : Number
      {
         return this._flag.getValue();
      }
      
      public function set flag(param1:Number) : void
      {
         this._flag.setValue(param1);
      }
      
      public function get xianziKanXin() : Number
      {
         return this._xianziKanXin.getValue();
      }
      
      public function set xianziKanXin(param1:Number) : void
      {
         this._xianziKanXin.setValue(param1);
      }
      
      public function get caflag() : Number
      {
         return this._caflag.getValue();
      }
      
      public function set caflag(param1:Number) : void
      {
         this._caflag.setValue(param1);
      }
      
      public function get othersSkill() : int
      {
         return this._othersSkill.getValue();
      }
      
      public function set othersSkill(param1:int) : void
      {
         this._othersSkill.setValue(param1);
      }
      
      public function get goodsSkill() : Array
      {
         return this._goodsSkill;
      }
      
      public function set goodsSkill(param1:Array) : void
      {
         this._goodsSkill = param1;
      }
      
      public function get hitsound() : String
      {
         return this._hitsound;
      }
      
      public function set hitsound(param1:String) : void
      {
         this._hitsound = param1;
      }
      
      public function get hitFlahE() : String
      {
         return this._hitFlahE;
      }
      
      public function set hitFlahE(param1:String) : void
      {
         this._hitFlahE = param1;
      }
      
      public function get jiJiaAng() : Number
      {
         return this._jiJiaAng.getValue();
      }
      
      public function set jiJiaAng(param1:Number) : void
      {
         this._jiJiaAng.setValue(param1);
      }
      
      public function copycone(param1:Number) : FightData
      {
         var _loc2_:FightData = new FightData();
         _loc2_.jiDao = this.jiDao;
         _loc2_.jiDaoKanXin = this.jiDaoKanXin;
         _loc2_.jiDaoXiShu = this.jiDaoXiShu;
         _loc2_.jiDaoZheng = this.jiDaoZheng;
         _loc2_.shiZhong = this.shiZhong;
         _loc2_.shiZhongKanXin = this.shiZhongKanXin;
         _loc2_.shiZhongXiShu = this.shiZhongXiShu;
         _loc2_.shiZhongZheng = this.shiZhongZheng;
         _loc2_.tiaoGao = this.tiaoGao;
         _loc2_.tiaoGaoEase = this.tiaoGaoEase;
         _loc2_.tiaoGaoKanXin = this.tiaoGaoKanXin;
         _loc2_.tiaoGaoValue = this.tiaoGaoValue;
         _loc2_.tiaoGaoXiShu = this.tiaoGaoXiShu;
         _loc2_.tiaoGaoZheng = this.tiaoGaoZheng;
         _loc2_.yinZhi = this.yinZhi;
         _loc2_.yinZhiKanXin = this.yinZhiKanXin;
         _loc2_.yinZhiXiShu = this.yinZhiXiShu;
         _loc2_.yinZhiZheng = this.yinZhiZheng;
         _loc2_.zhenTui = this.zhenTui;
         _loc2_.zhenTuiEase = this.zhenTuiEase;
         _loc2_.zhenTuiKanXin = this.zhenTuiKanXin;
         _loc2_.zhenTuiType = this.zhenTuiType;
         _loc2_.zhenTuiValue = this.zhenTuiValue;
         _loc2_.zhenTuiXiShu = this.zhenTuiXiShu;
         _loc2_.zhenTuiZheng = this.zhenTuiZheng;
         _loc2_.daJi = this.daJi;
         _loc2_.shangHaiBi = param1;
         _loc2_.jiangShangBi = this.jiangShangBi;
         _loc2_.xianziKanXin = this.xianziKanXin;
         _loc2_.caflag = this.caflag;
         _loc2_.flag = this.flag;
         _loc2_.othersSkill = this.othersSkill;
         _loc2_.goodsSkill = this.goodsSkill;
         _loc2_.hitFlahE = this.hitFlahE;
         _loc2_.hitsound = this.hitsound;
         _loc2_.jiJiaAng = this.jiJiaAng;
         return _loc2_;
      }
   }
}

