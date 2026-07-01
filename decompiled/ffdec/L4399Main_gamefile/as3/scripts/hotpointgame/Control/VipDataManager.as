package hotpointgame.Control
{
   import hotpointgame.common.*;
   import hotpointgame.gzhujiemian.*;
   import hotpointgame.repository.unionVip.*;
   
   public class VipDataManager
   {
      
      public static var vself:VipDataManager = new VipDataManager();
      
      private var _vipcong:VT = VT.createVT(0);
      
      private var _viplevel:VT = VT.createVT(0);
      
      public function VipDataManager()
      {
         super();
      }
      
      public function getVipL() : int
      {
         if(this.vipcong != GM.testapi.vipChongGod)
         {
            this.vipcong = GM.testapi.vipChongGod;
            if(this.vipcong >= GS.a10000 * GS.a32)
            {
               this.viplevel = GS.a8;
            }
            else if(this.vipcong >= GS.a10000 * GS.a16)
            {
               this.viplevel = GS.a7;
            }
            else if(this.vipcong >= GS.a10000 * GS.a8)
            {
               this.viplevel = GS.a6;
            }
            else if(this.vipcong >= GS.a10000 * GS.a4)
            {
               this.viplevel = GS.a5;
            }
            else if(this.vipcong >= GS.a10000 * GS.a2)
            {
               this.viplevel = GS.a4;
            }
            else if(this.vipcong >= GS.a10000)
            {
               this.viplevel = GS.a3;
            }
            else if(this.vipcong >= GS.a1000 * GS.a5)
            {
               this.viplevel = GS.a2;
            }
            else if(this.vipcong >= GS.a1000)
            {
               this.viplevel = GS.a1;
            }
            else
            {
               this.viplevel = GS.a0;
            }
            Czhujiemian.self.setVipLevel();
         }
         return this.viplevel;
      }
      
      public function getaddgodR() : Number
      {
         if(this.getVipL() > GS.a0)
         {
            return GS.a20 / GS.a100 + this.getGroupAddGod() + UnionVipFactory.getVipById(GoodsManger.dataList.uVipData.getVip()).getGold();
         }
         return GS.a0 + this.getGroupAddGod() + UnionVipFactory.getVipById(GoodsManger.dataList.uVipData.getVip()).getGold();
      }
      
      public function getaddexpR() : Number
      {
         if(this.getVipL() == GS.a8)
         {
            return GS.a30 / GS.a100 + this.getGroupAddExp() + UnionVipFactory.getVipById(GoodsManger.dataList.uVipData.getVip()).getExp();
         }
         if(this.getVipL() == GS.a7)
         {
            return GS.a20 / GS.a100 + this.getGroupAddExp() + UnionVipFactory.getVipById(GoodsManger.dataList.uVipData.getVip()).getExp();
         }
         if(this.getVipL() >= GS.a4)
         {
            return GS.a10 / GS.a100 + this.getGroupAddExp() + UnionVipFactory.getVipById(GoodsManger.dataList.uVipData.getVip()).getExp();
         }
         return GS.a0 + this.getGroupAddExp() + UnionVipFactory.getVipById(GoodsManger.dataList.uVipData.getVip()).getExp();
      }
      
      public function getaddpetexpR() : Number
      {
         if(this.getVipL() == GS.a5)
         {
            return GS.a5 / GS.a100 + this.getGroupAddExp() + UnionVipFactory.getVipById(GoodsManger.dataList.uVipData.getVip()).getCwExp();
         }
         if(this.getVipL() == GS.a6)
         {
            return GS.a10 / GS.a100 + this.getGroupAddExp() + UnionVipFactory.getVipById(GoodsManger.dataList.uVipData.getVip()).getCwExp();
         }
         if(this.getVipL() == GS.a7)
         {
            return GS.a20 / GS.a100 + this.getGroupAddExp() + UnionVipFactory.getVipById(GoodsManger.dataList.uVipData.getVip()).getCwExp();
         }
         if(this.getVipL() == GS.a8)
         {
            return GS.a30 / GS.a100 + this.getGroupAddExp() + UnionVipFactory.getVipById(GoodsManger.dataList.uVipData.getVip()).getCwExp();
         }
         return GS.a0 + this.getGroupAddExp() + UnionVipFactory.getVipById(GoodsManger.dataList.uVipData.getVip()).getCwExp();
      }
      
      public function diaoluostart() : Boolean
      {
         return this.getVipL() >= GS.a5;
      }
      
      public function getDiaoLouR() : Number
      {
         if(this.getVipL() == GS.a5)
         {
            return GS.a2;
         }
         if(this.getVipL() >= GS.a6)
         {
            return GS.a3;
         }
         return GS.a0;
      }
      
      public function getGroupAddExp() : Number
      {
         if(this.getGroupLv() > 0 && this.getGroupLv() < GS.a16)
         {
            return this.getGroupLv() / GS.a100;
         }
         return 0;
      }
      
      public function getGroupAddGod() : Number
      {
         if(this.getGroupLv() > 0 && this.getGroupLv() < GS.a16)
         {
            return (this.getGroupLv() * GS.a2 + GS.a3) / GS.a100;
         }
         return 0;
      }
      
      public function getGroupAddDiaoLou() : Number
      {
         if(this.getGroupLv() > 0 && this.getGroupLv() < GS.a16)
         {
            return this.getGroupLv() * GS.a02;
         }
         return 0;
      }
      
      public function getGroupLv() : int
      {
         return GoodsManger.dataList.unionData.getLevel();
      }
      
      public function get vipcong() : Number
      {
         return this._vipcong.getValue();
      }
      
      public function set vipcong(param1:Number) : void
      {
         this._vipcong.setValue(param1);
      }
      
      public function get viplevel() : int
      {
         return this._viplevel.getValue();
      }
      
      public function set viplevel(param1:int) : void
      {
         this._viplevel.setValue(param1);
      }
   }
}

