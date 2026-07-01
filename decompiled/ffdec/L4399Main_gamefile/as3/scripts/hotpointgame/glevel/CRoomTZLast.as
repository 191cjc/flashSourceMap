package hotpointgame.glevel
{
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   import hotpointgame.gview.*;
   import hotpointgame.models.goods.Goods;
   
   public class CRoomTZLast extends CRoomTZBase
   {
      
      public function CRoomTZLast(param1:Object)
      {
         super(param1);
      }
      
      override protected function overHandle(param1:CLevel) : void
      {
         if(jishu == 0)
         {
            GM.levelSD.addAch(param1.id,GS.a10,GS.a1);
            this.getAward(param1);
         }
         super.overHandle(param1);
      }
      
      private function getAward(param1:CLevel) : void
      {
         var _loc5_:Array = null;
         var _loc6_:Goods = null;
         jishu = GS.a1;
         var _loc2_:int = param1.getAexpByTZ() * tztLv.getValue();
         GM.cp.addExp(_loc2_);
         var _loc3_:Array = new Array();
         var _loc4_:int = int(GS.a1);
         while(_loc4_ <= GS.a10)
         {
            if(tztLv.getValue() >= _loc4_ * GS.a2)
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
         GM.aSaveData.tztR.addMaxLv(tztLv.getValue());
         GTZPingFeng.self.setData(_loc3_,[_loc2_,tztLv.getValue(),GM.aSaveData.tztR.maxLevel]);
         GTZPingFeng.open();
      }
   }
}

