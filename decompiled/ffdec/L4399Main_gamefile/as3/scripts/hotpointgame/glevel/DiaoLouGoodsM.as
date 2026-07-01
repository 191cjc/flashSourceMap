package hotpointgame.glevel
{
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   import hotpointgame.models.goods.Goods;
   
   public class DiaoLouGoodsM
   {
      
      private var dlArr:Vector.<DiaoLouGoods> = new Vector.<DiaoLouGoods>();
      
      public function DiaoLouGoodsM()
      {
         super();
      }
      
      public function addGoods(param1:Goods, param2:Number, param3:Number) : void
      {
         this.dlArr.push(new DiaoLouGoods(param1,param2,param3));
      }
      
      public function gmUpdate() : void
      {
         var _loc1_:DiaoLouGoods = null;
         var _loc2_:int = 0;
         var _loc3_:* = 0;
         for each(_loc1_ in this.dlArr)
         {
            _loc1_.gmUpdate();
         }
         if(GM.ckey.isKey("捡东西"))
         {
            _loc2_ = int(this.dlArr.length);
            _loc3_ = int(_loc2_ - 1);
            while(_loc3_ >= 0)
            {
               if(this.dlArr[_loc3_].hitTest(GM.cp.getZx(),GM.cp.getZy()))
               {
                  switch(this.dlArr[_loc3_].gd.getId())
                  {
                     case GS.a331094:
                     case GS.a331151:
                     case GS.a331153:
                     case GS.a331154:
                     case GS.a331155:
                     case GS.a631004:
                     case GS.a631005:
                        GM.aSaveData.checkfm.addFlag(GS.a6,this.dlArr[_loc3_].gd.getId());
                        GM.testapi.saveDataBeforeNoState();
                  }
                  if(this.dlArr[_loc3_].gd.getType() == 0 && this.dlArr[_loc3_].gd.getSmallType() == GS.a20)
                  {
                     if(GM.cp.pickGun(this.dlArr[_loc3_].gd))
                     {
                        this.dlArr[_loc3_].remove();
                        this.dlArr.splice(_loc3_,1);
                     }
                     else
                     {
                        this.dlArr[_loc3_].gmRest();
                     }
                  }
                  else if(this.dlArr[_loc3_].gd.getType() == GS.a2 && this.dlArr[_loc3_].gd.getSmallType() == GS.a4)
                  {
                     GM.cp.addGodByRoleByVip(this.dlArr[_loc3_].gd.getOtherValue());
                     this.dlArr[_loc3_].remove();
                     this.dlArr.splice(_loc3_,1);
                  }
                  else if(this.dlArr[_loc3_].gd.getType() == GS.a2 && this.dlArr[_loc3_].gd.getSmallType() == GS.a2)
                  {
                     if(this.dlArr[_loc3_].gd.isBfb())
                     {
                        GM.cp.addHpByPerc(this.dlArr[_loc3_].gd.getOtherValue());
                     }
                     else
                     {
                        GM.cp.addHp(this.dlArr[_loc3_].gd.getOtherValue());
                     }
                     this.dlArr[_loc3_].remove();
                     this.dlArr.splice(_loc3_,1);
                  }
                  else if(this.dlArr[_loc3_].gd.getType() == GS.a2 && this.dlArr[_loc3_].gd.getSmallType() == GS.a3)
                  {
                     if(this.dlArr[_loc3_].gd.isBfb())
                     {
                        GM.cp.addMpBfb(this.dlArr[_loc3_].gd.getOtherValue());
                     }
                     else
                     {
                        GM.cp.addMp(this.dlArr[_loc3_].gd.getOtherValue());
                     }
                     this.dlArr[_loc3_].remove();
                     this.dlArr.splice(_loc3_,1);
                  }
                  else if(this.dlArr[_loc3_].gd.getType() == GS.a2 && this.dlArr[_loc3_].gd.getSmallType() == GS.a7)
                  {
                     if(GM.cp.pickGunClip(this.dlArr[_loc3_].gd.getOtherValue()))
                     {
                        this.dlArr[_loc3_].remove();
                        this.dlArr.splice(_loc3_,1);
                     }
                     else
                     {
                        this.dlArr[_loc3_].gmRest();
                     }
                  }
                  else if(FlowInterface.addInBagDL(this.dlArr[_loc3_].gd,GS.a1))
                  {
                     this.dlArr[_loc3_].remove();
                     this.dlArr.splice(_loc3_,1);
                  }
                  else
                  {
                     this.dlArr[_loc3_].gmRest();
                  }
                  return;
               }
               _loc3_--;
            }
         }
      }
      
      public function getNum() : int
      {
         return this.dlArr.length;
      }
      
      public function remove() : void
      {
         var _loc1_:DiaoLouGoods = null;
         for each(var _loc4_ in this.dlArr)
         {
            _loc1_ = _loc4_;
            _loc4_;
            _loc1_.remove();
         }
         this.dlArr.length = 0;
      }
   }
}

