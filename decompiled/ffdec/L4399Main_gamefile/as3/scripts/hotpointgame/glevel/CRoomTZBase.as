package hotpointgame.glevel
{
   import flash.text.*;
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   import hotpointgame.gview.*;
   import hotpointgame.models.bag.*;
   import hotpointgame.models.goods.Goods;
   
   public class CRoomTZBase extends CRoom
   {
      
      private var _jishu:VT = VT.createVT(0);
      
      private var _tJishi:VT = VT.createVT(0);
      
      public function CRoomTZBase(param1:Object)
      {
         super(param1);
      }
      
      override public function gmUpdate(param1:CLevel) : void
      {
         if(this.jishu == 0 && GM.frameTime - enterT > GS.a100)
         {
            if(GM.cp.cHp == 0)
            {
               if(this.tJishi == GS.a180)
               {
                  this.getAward(param1);
                  return;
               }
               if(GS.a180 - this.tJishi > 0)
               {
                  if((GS.a180 - this.tJishi) % 60 == 0)
                  {
                     GoodsManger.cwTs("" + int((GS.a180 - this.tJishi) / 60) * 2 + " 秒内可以按 J 使用复活币复活!");
                  }
                  if(GM.ckey.isKey("复活"))
                  {
                     if(BagFactory.otherBag.deleteGoods(GS.a511032,GS.a1))
                     {
                        GM.cp.playerStateFull();
                        this.tJishi = 0;
                        return;
                     }
                     if(BagFactory.otherBag.deleteGoods(GS.a631000,GS.a1))
                     {
                        GM.cp.playerStateFull();
                        this.tJishi = 0;
                        return;
                     }
                     GoodsManger.cwTs("没有复活币了!");
                  }
                  this.tJishi += GS.a1;
               }
            }
         }
         super.gmUpdate(param1);
      }
      
      override public function enterRoom(param1:CLevel) : void
      {
         var _loc2_:TextField = param1.getvs().getTZLvName();
         if(_loc2_ != null)
         {
            _loc2_.text = "" + tztLv.getValue() + "层";
            _loc2_.embedFonts = true;
            _loc2_.setTextFormat(new TextFormat(GM.fzfont.fontName,38,16777215));
         }
         var _loc3_:String = "裂缝空间层数" + tztLv.getValue() + "房间";
         if(_loc3_ != name.substr(0,name.length - GS.a1) && tztLv.getValue() - GM.aSaveData.tztR.maxLevel > GS.a1)
         {
            GM.findCheatMax(GS.a68);
            return;
         }
         this.jishu = 0;
         this.tJishi = 0;
         super.enterRoom(param1);
      }
      
      public function get jishu() : int
      {
         return this._jishu.getValue();
      }
      
      public function set jishu(param1:int) : void
      {
         this._jishu.setValue(param1);
      }
      
      private function getAward(param1:CLevel) : void
      {
         var _loc5_:Array = null;
         var _loc6_:Goods = null;
         this.jishu = GS.a1;
         var _loc2_:int = param1.getAexpByTZ() * (tztLv.getValue() - GS.a1);
         GM.cp.addExp(_loc2_);
         var _loc3_:Array = new Array();
         var _loc4_:int = int(GS.a1);
         while(_loc4_ <= GS.a10)
         {
            if(tztLv.getValue() - GS.a1 >= _loc4_ * GS.a2)
            {
               _loc5_ = param1.getKaiPaiAward();
               if(_loc5_.length > 1)
               {
                  _loc6_ = _loc5_[0];
                  if(_loc6_.getType() == GS.a2 && _loc6_.getSmallType() == GS.a4)
                  {
                     GM.cp.addGodByRole(_loc6_.getOtherValue());
                     _loc3_[_loc4_] = [_loc6_.getName(),(_loc5_[1] as VT).getValue(),_loc6_.getFrame()];
                  }
                  else if(FlowInterface.addInBagDL(_loc6_,(_loc5_[1] as VT).getValue()))
                  {
                     _loc3_[_loc4_] = [_loc6_.getName(),(_loc5_[1] as VT).getValue(),_loc6_.getFrame()];
                  }
                  else
                  {
                     _loc3_[_loc4_] = ["手气不好",1,1735];
                  }
               }
               else if(_loc5_.length > 0)
               {
                  _loc3_[_loc4_] = ["手气不好",1,1735];
               }
               else
               {
                  _loc3_[_loc4_] = ["手气不好",1,1935];
               }
            }
            else
            {
               _loc3_[_loc4_] = new Array();
            }
            _loc4_++;
         }
         GTZPingFeng.self.setData(_loc3_,[_loc2_,tztLv.getValue() - GS.a1,GM.aSaveData.tztR.maxLevel]);
         GTZPingFeng.open();
      }
      
      override protected function overHandle(param1:CLevel) : void
      {
         GM.aSaveData.tztR.addMaxLv(tztLv.getValue());
         super.overHandle(param1);
      }
      
      public function get tJishi() : int
      {
         return this._tJishi.getValue();
      }
      
      public function set tJishi(param1:int) : void
      {
         this._tJishi.setValue(param1);
      }
   }
}

