package hotpointgame.glevel
{
   import flash.display.*;
   import flash.text.*;
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   import hotpointgame.gMonster.*;
   import hotpointgame.gview.*;
   import hotpointgame.models.bag.*;
   import hotpointgame.models.goods.Goods;
   import hotpointgame.utils.*;
   import hotpointgame.utils.gameloader.*;
   
   public class CRoomSurM extends CRoom
   {
      
      private var _curbm:VT = VT.createVT(0);
      
      private var _curbl:VT = VT.createVT(0);
      
      private var _bojishi:VT = VT.createVT(0);
      
      private var _sheeplv:VT = VT.createVT(0);
      
      private var _hpjishi:VT = VT.createVT(0);
      
      private var yunjishi:int = 1;
      
      private var bom:Array;
      
      private var baom:Array;
      
      private var jm:Array;
      
      private var yunArr:Array;
      
      private var showMc:MovieClip;
      
      public function CRoomSurM(param1:Object)
      {
         super(param1);
      }
      
      override public function gmUpdate(param1:CLevel) : void
      {
         var _loc2_:int = 0;
         if(GM.frameTime - enternum >= GS.a120)
         {
            if(this.sheeplv == 0)
            {
               this.sheeplv = GS.a1;
               this.curbm = GS.a1;
               this.curbl = GS.a1;
               this.bojishi = GM.frameTime;
               this.chumonst(this.bom[this.curbm]);
            }
            if(this.sheeplv == GS.a1)
            {
               if(this.curbm >= GS.a1 && this.curbm < GS.a20)
               {
                  if(this.curbl < GS.a29)
                  {
                     if(GM.frameTime - this.bojishi >= GS.a50)
                     {
                        this.curbl += GS.a1;
                        this.bojishi = GM.frameTime;
                        this.chumonst(this.bom[this.curbm]);
                        if(this.curbl == GS.a2)
                        {
                           this.chumonst(this.jm[this.curbm]);
                           this.jm[this.curbm] = null;
                        }
                     }
                  }
                  else if(this.curbl == GS.a29)
                  {
                     if(GM.frameTime - this.bojishi >= GS.a50)
                     {
                        this.bom[this.curbm] = null;
                        GM.levelm.clearallMAndBNoGa();
                        this.chumonst(this.baom[this.curbm]);
                        this.baom[this.curbm] = null;
                        this.sheeplv = GS.a2;
                        this.bojishi = GM.frameTime;
                     }
                  }
               }
            }
            if(this.sheeplv == GS.a2)
            {
               if(this.curbm >= GS.a1 && this.curbm < GS.a20)
               {
                  if((GM.frameTime - this.bojishi) % 30 == 0)
                  {
                     _loc2_ = 15 - int((GM.frameTime - this.bojishi) / 30);
                     this.showTextshi("" + _loc2_);
                     if(_loc2_ <= 0)
                     {
                        (this.showMc["djsbs"] as MovieClip).visible = false;
                     }
                  }
                  if(GM.frameTime - this.bojishi >= GS.a400 + GS.a50)
                  {
                     this.curbm += GS.a1;
                     this.showTextBo("第" + this.curbm + "波");
                     this.curbl = GS.a1;
                     this.bojishi = GM.frameTime;
                     this.chumonst(this.bom[this.curbm]);
                     if(this.curbm >= GS.a20)
                     {
                        this.bom[this.curbm] = null;
                        this.sheeplv = GS.a3;
                     }
                     else
                     {
                        this.sheeplv = GS.a1;
                     }
                  }
               }
            }
            if(this.sheeplv == GS.a3)
            {
               if(GM.levelm.getMonsterNum() == 0)
               {
                  this.sheeplv = GS.a4;
                  this.getAward(param1,GS.a20);
                  return;
               }
            }
            if(this.sheeplv <= GS.a3 && GM.cp.cHp == 0)
            {
               if(this.curbm > GS.a15 || this.hpjishi == GS.a180)
               {
                  this.sheeplv = GS.a5;
                  GM.levelm.clearallMAndBNoGa();
                  this.getAward(param1,this.curbm - GS.a1);
                  return;
               }
               if(GS.a180 - this.hpjishi > 0)
               {
                  if((GS.a180 - this.hpjishi) % 60 == 0)
                  {
                     GoodsManger.cwTs("" + int((GS.a180 - this.hpjishi) / 60) * 2 + " 秒内可以按 J 使用复活币复活!");
                  }
                  if(GM.ckey.isKey("复活"))
                  {
                     if(BagFactory.otherBag.deleteGoods(GS.a511032,GS.a1))
                     {
                        GM.cp.playerStateFull();
                        this.hpjishi = 0;
                        return;
                     }
                     if(BagFactory.otherBag.deleteGoods(GS.a631000,GS.a1))
                     {
                        GM.cp.playerStateFull();
                        this.hpjishi = 0;
                        return;
                     }
                     GoodsManger.cwTs("没有复活币了!");
                  }
                  this.hpjishi += GS.a1;
               }
            }
         }
         if(GM.ckey.isKey("5"))
         {
            if(this.curbm > GS.a15)
            {
               GoodsManger.cwTs("16波开始不可以使用一击必杀!");
            }
            else if(FlowInterface.redInBagDL(GS.a331116,GS.a1))
            {
               GM.levelm.killAllM();
               UTools.addPiaoMc("yijibisha");
            }
            else
            {
               GoodsManger.cwTs("一击必杀道具不足!");
            }
         }
         this.updateYun(param1);
         super.gmUpdate(param1);
      }
      
      override public function enterRoom(param1:CLevel) : void
      {
         GM.aSaveData.surmd.addNum();
         GM.testapi.saveDataBefore();
         this.curbm = 0;
         this.curbl = 0;
         this.bojishi = 0;
         this.sheeplv = 0;
         this.hpjishi = 0;
         this.yunjishi = 1;
         this.initM();
         super.enterRoom(param1);
         var _loc2_:Class = LoaderManager.getSwfClass("tsbs") as Class;
         this.showMc = new _loc2_() as MovieClip;
         (this.showMc["djsbs"] as MovieClip).visible = false;
         param1.getvs().addFixMcIn(this.showMc);
         this.showTextBo("第1波");
      }
      
      override public function exitRoom() : void
      {
         var _loc1_:Array = null;
         var _loc2_:MovieClip = null;
         GM.levelm.inty = 0;
         this.bom = null;
         this.baom = null;
         this.jm = null;
         if(this.yunArr != null)
         {
            for each(_loc1_ in this.yunArr)
            {
               _loc2_ = _loc1_[0];
               if(_loc2_.parent)
               {
                  _loc2_.parent.removeChild(_loc2_);
               }
            }
            this.yunArr = null;
         }
         if(this.showMc != null)
         {
            if(this.showMc.parent)
            {
               this.showMc.parent.removeChild(this.showMc);
            }
            this.showMc = null;
         }
         super.exitRoom();
      }
      
      override public function exitLevelClear() : void
      {
         var _loc1_:Array = null;
         var _loc2_:MovieClip = null;
         this.bom = null;
         this.baom = null;
         this.jm = null;
         if(this.yunArr != null)
         {
            for each(_loc1_ in this.yunArr)
            {
               _loc2_ = _loc1_[0];
               if(_loc2_.parent)
               {
                  _loc2_.parent.removeChild(_loc2_);
               }
            }
            this.yunArr = null;
         }
         if(this.showMc != null)
         {
            if(this.showMc.parent)
            {
               this.showMc.parent.removeChild(this.showMc);
            }
            this.showMc = null;
         }
         super.exitLevelClear();
      }
      
      private function showTextBo(param1:String) : void
      {
         var _loc2_:TextField = this.showMc["cs"]["sjrz"] as TextField;
         _loc2_.embedFonts = true;
         _loc2_.defaultTextFormat = new TextFormat(GM.fzfont.fontName);
         _loc2_.text = param1;
      }
      
      private function showTextshi(param1:String) : void
      {
         (this.showMc["djsbs"] as MovieClip).visible = true;
         var _loc2_:TextField = this.showMc["djsbs"]["tsbssz"] as TextField;
         _loc2_.embedFonts = true;
         _loc2_.defaultTextFormat = new TextFormat(GM.fzfont.fontName);
         _loc2_.text = param1;
      }
      
      private function initM() : void
      {
         var _loc2_:String = null;
         var _loc3_:Object = null;
         var _loc1_:int = int(GS.a1);
         this.bom = new Array();
         this.baom = new Array();
         this.jm = new Array();
         for each(_loc2_ in twoMonser)
         {
            _loc3_ = LevelDataManager.getMBO(_loc2_ + lstar);
            this.bom[_loc1_] = _loc3_.bo.ml;
            this.baom[_loc1_] = _loc3_.bo.bm;
            this.jm[_loc1_] = _loc3_.bo.jm;
            _loc1_ += GS.a1;
         }
         this.yunArr = new Array();
      }
      
      private function updateYun(param1:CLevel) : void
      {
         var _loc2_:Array = null;
         var _loc3_:MovieClip = null;
         var _loc4_:Array = null;
         var _loc5_:Class = null;
         var _loc6_:MovieClip = null;
         var _loc7_:Array = null;
         var _loc8_:MovieClip = null;
         for each(_loc2_ in this.yunArr)
         {
            _loc3_ = _loc2_[0];
            _loc3_.x -= _loc2_[1];
         }
         this.yunjishi += 1;
         if(this.yunjishi % 150 == 0)
         {
            _loc4_ = new Array();
            _loc5_ = LoaderManager.getSwfClass("yun" + int(Math.random() * 3 + 1)) as Class;
            _loc6_ = new _loc5_() as MovieClip;
            _loc6_.x = 1500;
            _loc6_.y = Math.random() * 260;
            param1.getvs().addMoveFixMcIn(_loc6_);
            _loc4_.push(_loc6_);
            _loc4_.push(Math.random() * 10 + 5);
            this.yunArr.push(_loc4_);
         }
         if(this.yunArr.length > 7)
         {
            _loc7_ = this.yunArr.shift();
            _loc8_ = _loc7_[0] as MovieClip;
            if(_loc8_.parent)
            {
               _loc8_.parent.removeChild(_loc8_);
            }
         }
      }
      
      private function chumonst(param1:Array) : void
      {
         var _loc2_:Object = null;
         var _loc3_:Array = null;
         for each(_loc2_ in param1)
         {
            _loc3_ = _loc2_.p;
            MonsterManager.creatMonster(_loc2_.m,_loc3_[0] + Math.random() * _loc3_[2],_loc3_[1] + Math.random() * _loc3_[3]);
         }
      }
      
      private function getAward(param1:CLevel, param2:int) : void
      {
         var _loc6_:Array = null;
         var _loc7_:Goods = null;
         var _loc3_:int = 0;
         if(param2 <= GS.a15)
         {
            _loc3_ = param2 * GS.a10000;
         }
         else
         {
            _loc3_ = GS.a15 * GS.a10000 + (param2 - GS.a15) * GS.a2000 * GS.a10;
         }
         GM.cp.addExp(_loc3_);
         var _loc4_:Array = new Array();
         var _loc5_:int = int(GS.a1);
         while(_loc5_ <= GS.a8)
         {
            if(_loc5_ <= GS.a3 && param2 >= GS.a5 * _loc5_ || _loc5_ > GS.a3 && param2 >= GS.a12 + _loc5_)
            {
               _loc6_ = param1.getSurmAward(_loc5_);
               if(_loc6_.length > 1)
               {
                  _loc7_ = _loc6_[0];
                  if(_loc7_.getType() == GS.a2 && _loc7_.getSmallType() == GS.a4)
                  {
                     GM.cp.addGodByRole(_loc7_.getOtherValue());
                     _loc4_[_loc5_] = [_loc7_.getName(),(_loc6_[1] as VT).getValue(),_loc7_.getFrame()];
                  }
                  else if(FlowInterface.addInBagDL(_loc7_,(_loc6_[1] as VT).getValue()))
                  {
                     _loc4_[_loc5_] = [_loc7_.getName(),(_loc6_[1] as VT).getValue(),_loc7_.getFrame()];
                  }
                  else
                  {
                     _loc4_[_loc5_] = ["手气不好",1,1735];
                  }
               }
               else if(_loc6_.length > 0)
               {
                  _loc4_[_loc5_] = ["手气不好",1,1735];
               }
               else
               {
                  _loc4_[_loc5_] = ["手气不好",1,1935];
               }
            }
            else
            {
               _loc4_[_loc5_] = new Array();
            }
            _loc5_++;
         }
         GM.aSaveData.surmd.addBomMax(param2);
         GM.testapi.saveDataBefore();
         SurMPingFeng.self.setData(_loc4_,[_loc3_]);
         SurMPingFeng.open();
      }
      
      public function get curbm() : int
      {
         return this._curbm.getValue();
      }
      
      public function set curbm(param1:int) : void
      {
         this._curbm.setValue(param1);
      }
      
      public function get curbl() : int
      {
         return this._curbl.getValue();
      }
      
      public function set curbl(param1:int) : void
      {
         this._curbl.setValue(param1);
      }
      
      public function get bojishi() : uint
      {
         return this._bojishi.getValue();
      }
      
      public function set bojishi(param1:uint) : void
      {
         this._bojishi.setValue(param1);
      }
      
      public function get sheeplv() : int
      {
         return this._sheeplv.getValue();
      }
      
      public function set sheeplv(param1:int) : void
      {
         this._sheeplv.setValue(param1);
      }
      
      public function get hpjishi() : int
      {
         return this._hpjishi.getValue();
      }
      
      public function set hpjishi(param1:int) : void
      {
         this._hpjishi.setValue(param1);
      }
   }
}

