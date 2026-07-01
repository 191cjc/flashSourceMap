package hotpointgame.gameobj
{
   import hotpointgame.common.*;
   import hotpointgame.gzhujiemian.*;
   
   public class ztcCD
   {
      
      private var _yinZhi:VT = VT.createVT(-GS.a1);
      
      private var _jiDao:VT = VT.createVT(-GS.a1);
      
      private var _bingDong:VT = VT.createVT(-GS.a1);
      
      private var _shiHua:VT = VT.createVT(-GS.a1);
      
      private var _xuanYun:VT = VT.createVT(-GS.a1);
      
      private var _shuFu:VT = VT.createVT(-GS.a1);
      
      private var _shuiPao:VT = VT.createVT(-GS.a1);
      
      private var _shiZhong:VT = VT.createVT(-GS.a1);
      
      private var _deiji:VT = VT.createVT(-GS.a1);
      
      private var _zou:VT = VT.createVT(-GS.a1);
      
      private var _resetjidao:VT = VT.createVT(-GS.a1);
      
      private var _weizhanTime:VT = VT.createVT(-GS.a1);
      
      private var _attvalue:VT = VT.createVT(-GS.a1);
      
      private var _attvaluejishi:VT = VT.createVT(-GS.a1);
      
      private var _attKillm:VT = VT.createVT(0);
      
      private var _attTqjishi:VT = VT.createVT(0);
      
      private var _fyTqjishi:VT = VT.createVT(0);
      
      private var _bjTqjishi:VT = VT.createVT(0);
      
      private var _hundunTqjishi:VT = VT.createVT(0);
      
      private var _speedTqjishi:VT = VT.createVT(0);
      
      public function ztcCD()
      {
         super();
      }
      
      public function gmUpdate(param1:ZtC) : void
      {
         this._yinZhi.setValue(this.yinZhi - GS.a1);
         if(param1.skyType == 0 && this.yinZhi < 0)
         {
            this._jiDao.setValue(this.jiDao - GS.a1);
         }
         this._bingDong.setValue(this.bingDong - GS.a1);
         this._shiHua.setValue(this.shiHua - GS.a1);
         this._xuanYun.setValue(this.xuanYun - GS.a1);
         this._shuFu.setValue(this.shuFu - GS.a1);
         this._shuiPao.setValue(this.shuiPao - GS.a1);
         this._shiZhong.setValue(this.shiZhong - GS.a1);
         this._deiji.setValue(this.deiji - GS.a1);
         this._zou.setValue(this.zou - GS.a1);
         this._weizhanTime.setValue(this.weizhanTime - GS.a1);
         this._attvaluejishi.setValue(this.attvaluejishi - GS.a1);
         this._attTqjishi.setValue(this.attTqjishi - GS.a1);
         this._fyTqjishi.setValue(this.fyTqjishi - GS.a1);
         this._bjTqjishi.setValue(this.bjTqjishi - GS.a1);
         this._hundunTqjishi.setValue(this.hundunTqjishi - GS.a1);
         this._speedTqjishi.setValue(this.speedTqjishi - GS.a1);
      }
      
      public function gmUpdateb() : void
      {
         Czhujiemian.self.attBuffUpdate();
      }
      
      public function get bingDong() : int
      {
         return this._bingDong.getValue();
      }
      
      public function set bingDong(param1:int) : void
      {
         if(this.shiHua > -GS.a1)
         {
            return;
         }
         if(this.bingDong < param1)
         {
            this._bingDong.setValue(param1);
            this._xuanYun.setValue(-GS.a1);
            this._shuFu.setValue(-GS.a1);
            this._shuiPao.setValue(-GS.a1);
            this._jiDao.setValue(-GS.a1);
            this._yinZhi.setValue(-GS.a1);
            return;
         }
      }
      
      public function get shiHua() : int
      {
         return this._shiHua.getValue();
      }
      
      public function set shiHua(param1:int) : void
      {
         if(this.bingDong > -GS.a1)
         {
            return;
         }
         if(this.shiHua < param1)
         {
            this._shiHua.setValue(param1);
            this._xuanYun.setValue(-GS.a1);
            this._shuFu.setValue(-GS.a1);
            this._shuiPao.setValue(-GS.a1);
            this._jiDao.setValue(-GS.a1);
            this._yinZhi.setValue(-GS.a1);
            return;
         }
      }
      
      public function get xuanYun() : int
      {
         return this._xuanYun.getValue();
      }
      
      public function set xuanYun(param1:int) : void
      {
         if(this.bingDong < 0 && this.shiHua < 0 && this.shuFu < 0 && this.shuiPao < 0)
         {
            if(this.xuanYun < param1)
            {
               this._xuanYun.setValue(param1);
               this._jiDao.setValue(-GS.a1);
               this._yinZhi.setValue(-GS.a1);
            }
         }
      }
      
      public function get shuFu() : int
      {
         return this._shuFu.getValue();
      }
      
      public function set shuFu(param1:int) : void
      {
         if(this.bingDong < 0 && this.shiHua < 0 && this.xuanYun < 0 && this.shuiPao < 0)
         {
            if(this.shuFu < param1)
            {
               this._shuFu.setValue(param1);
               this._jiDao.setValue(-GS.a1);
               this._yinZhi.setValue(-GS.a1);
            }
         }
      }
      
      public function get shuiPao() : int
      {
         return this._shuiPao.getValue();
      }
      
      public function set shuiPao(param1:int) : void
      {
         if(this.bingDong < 0 && this.shiHua < 0 && this.xuanYun < 0 && this.shuFu < 0)
         {
            if(this.shuiPao < param1)
            {
               this._shuiPao.setValue(param1);
               this._jiDao.setValue(-GS.a1);
               this._yinZhi.setValue(-GS.a1);
            }
         }
      }
      
      public function get yinZhi() : int
      {
         return this._yinZhi.getValue();
      }
      
      public function set yinZhi(param1:int) : void
      {
         if(this.bingDong < 0 && this.shiHua < 0 && this.xuanYun < 0 && this.shuFu < 0 && this.shuiPao < 0)
         {
            if(this.jiDao < 0)
            {
               if(this.yinZhi < param1)
               {
                  this._yinZhi.setValue(param1);
               }
            }
            else if(this.yinZhi < 0)
            {
               this.resetjidao = GS.a1;
            }
         }
      }
      
      public function get jiDao() : int
      {
         return this._jiDao.getValue();
      }
      
      public function set jiDao(param1:int) : void
      {
         if(this.bingDong < 0 && this.shiHua < 0 && this.xuanYun < 0 && this.shuFu < 0 && this.shuiPao < 0)
         {
            this._yinZhi.setValue(-GS.a1);
            if(this.jiDao > -GS.a1)
            {
               this.resetjidao = GS.a1;
            }
            if(this.jiDao < param1)
            {
               this._jiDao.setValue(param1);
            }
         }
      }
      
      public function setYinZhiAndjiDao(param1:int, param2:int) : void
      {
         if(this.bingDong < 0 && this.shiHua < 0 && this.xuanYun < 0 && this.shuFu < 0 && this.shuiPao < 0)
         {
            if(this.yinZhi > -GS.a1 || this.yinZhi < 0 && this.jiDao < 0)
            {
               this._yinZhi.setValue(param1);
               this._jiDao.setValue(param2);
            }
            else
            {
               this.resetjidao = GS.a1;
               if(this.jiDao < param2)
               {
                  this._jiDao.setValue(param2);
               }
            }
         }
      }
      
      public function get deiji() : int
      {
         return this._deiji.getValue();
      }
      
      public function set deiji(param1:int) : void
      {
         this._deiji.setValue(param1);
         this._zou.setValue(-GS.a1);
      }
      
      public function get zou() : int
      {
         return this._zou.getValue();
      }
      
      public function set zou(param1:int) : void
      {
         this._zou.setValue(param1);
         this._deiji.setValue(-GS.a1);
      }
      
      public function getValueByName(param1:String) : int
      {
         if(param1 == "冰冻")
         {
            return this.bingDong;
         }
         if(param1 == "眩晕")
         {
            return this.xuanYun;
         }
         if(param1 == "水泡")
         {
            return this.shuiPao;
         }
         if(param1 == "束缚")
         {
            return this.shuFu;
         }
         if(param1 == "石化")
         {
            return this.shiHua;
         }
         return -GS.a1;
      }
      
      public function get shiZhong() : int
      {
         return this._shiZhong.getValue();
      }
      
      public function set shiZhong(param1:int) : void
      {
         if(this.shiZhong < param1)
         {
            this._shiZhong.setValue(param1);
         }
      }
      
      public function get weizhanTime() : int
      {
         return this._weizhanTime.getValue();
      }
      
      public function set weizhanTime(param1:int) : void
      {
         if(this.weizhanTime < param1)
         {
            this._weizhanTime.setValue(param1);
         }
      }
      
      public function get resetjidao() : int
      {
         return this._resetjidao.getValue();
      }
      
      public function set resetjidao(param1:int) : void
      {
         this._resetjidao.setValue(param1);
      }
      
      public function addAttBuf(param1:Number, param2:Number) : void
      {
         if(this.attvaluejishi < 0)
         {
            this.attvaluejishi = param2;
            this.attvalue = param1 / GS.a10000;
         }
      }
      
      public function getAddAtt() : Number
      {
         if(this.attvaluejishi > 0 && this.attvalue > 0)
         {
            return this.attvalue + this.attKillm;
         }
         return this.attKillm;
      }
      
      public function addKillmAtt(param1:Number) : void
      {
         this.attKillm = param1 / GS.a10000;
      }
      
      public function removeKillmAtt() : void
      {
         this.attKillm = 0;
      }
      
      public function setTqatt(param1:Number) : void
      {
         switch(param1)
         {
            case GS.a1:
               this.bjTqjishi = GS.a20 * GS.a30;
               break;
            case GS.a2:
               this.fyTqjishi = GS.a10 * GS.a30;
               break;
            case GS.a3:
               this.attTqjishi = GS.a15 * GS.a30;
               break;
            case GS.a4:
               this.hundunTqjishi = GS.a15 * GS.a30;
               break;
            case GS.a5:
               this.speedTqjishi = GS.a20 * GS.a30;
         }
      }
      
      public function getTqatt(param1:Number) : Number
      {
         switch(param1)
         {
            case GS.a1:
               if(this.bjTqjishi > 0)
               {
                  return GS.a01;
               }
               break;
            case GS.a2:
               if(this.fyTqjishi > 0)
               {
                  return GS.a15 / GS.a100;
               }
               break;
            case GS.a3:
               if(this.attTqjishi > 0)
               {
                  return GS.a01;
               }
               break;
            case GS.a4:
               if(this.hundunTqjishi > 0)
               {
                  return GS.a01;
               }
               break;
            case GS.a5:
               if(this.speedTqjishi > 0)
               {
                  return GS.a03;
               }
         }
         return 0;
      }
      
      public function get attvaluejishi() : Number
      {
         return this._attvaluejishi.getValue();
      }
      
      public function set attvaluejishi(param1:Number) : void
      {
         this._attvaluejishi.setValue(param1);
      }
      
      public function get attvalue() : Number
      {
         return this._attvalue.getValue();
      }
      
      public function set attvalue(param1:Number) : void
      {
         this._attvalue.setValue(param1);
      }
      
      public function get attKillm() : Number
      {
         return this._attKillm.getValue();
      }
      
      public function set attKillm(param1:Number) : void
      {
         this._attKillm.setValue(param1);
      }
      
      public function get attTqjishi() : Number
      {
         return this._attTqjishi.getValue();
      }
      
      public function set attTqjishi(param1:Number) : void
      {
         this._attTqjishi.setValue(param1);
      }
      
      public function get fyTqjishi() : Number
      {
         return this._fyTqjishi.getValue();
      }
      
      public function set fyTqjishi(param1:Number) : void
      {
         this._fyTqjishi.setValue(param1);
      }
      
      public function get bjTqjishi() : Number
      {
         return this._bjTqjishi.getValue();
      }
      
      public function set bjTqjishi(param1:Number) : void
      {
         this._bjTqjishi.setValue(param1);
      }
      
      public function get hundunTqjishi() : Number
      {
         return this._hundunTqjishi.getValue();
      }
      
      public function set hundunTqjishi(param1:Number) : void
      {
         this._hundunTqjishi.setValue(param1);
      }
      
      public function get speedTqjishi() : Number
      {
         return this._speedTqjishi.getValue();
      }
      
      public function set speedTqjishi(param1:Number) : void
      {
         this._speedTqjishi.setValue(param1);
      }
   }
}

