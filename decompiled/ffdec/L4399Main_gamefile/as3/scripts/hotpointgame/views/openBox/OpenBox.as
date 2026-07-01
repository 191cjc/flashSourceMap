package hotpointgame.views.openBox
{
   import flash.display.MovieClip;
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   import hotpointgame.common.basicBtn.*;
   import hotpointgame.common.event.*;
   import hotpointgame.common.newBasicBtn.*;
   import hotpointgame.models.bag.*;
   import hotpointgame.repository.goods.*;
   import hotpointgame.repository.openBox.*;
   import hotpointgame.views.shipPanel.*;
   import hotpointgame.views.unionPanel.*;
   
   public class OpenBox extends MovieClip
   {
      
      private static var _instance:OpenBox;
      
      private var needId:VT = VT.createVT(GS.a331358 + GS.a8);
      
      public function OpenBox()
      {
         super();
      }
      
      public static function open() : void
      {
         var _loc1_:Array = null;
         if(_instance == null)
         {
            if(GM.loaderM.keYiUse())
            {
               _loc1_ = new Array();
               _loc1_.push("ts44");
               GM.loaderM.setLoadData(_loc1_);
               GM.loaderM.completeF = loadOver;
               GM.loaderM.startLoadDataJieM();
               return;
            }
            return;
         }
         _instance.initPanel();
      }
      
      public static function loadOver() : void
      {
         _instance = new OpenBox();
         _instance.initPanel();
      }
      
      private function initPanel() : void
      {
         if(BagFactory.getNumById(this.needId.getValue()) > GS.a0)
         {
            if(ShipData.tl.getValue() >= GS.a3)
            {
               GoodsManger.openBoxMovicpStr(0,0,this.openOk,"Ts_201");
            }
            else
            {
               GoodsManger.cwTs("体力不足");
            }
         }
         else
         {
            GoodsManger.cwTs("银河海盗的财宝箱不足");
         }
      }
      
      private function openOk() : void
      {
         var _loc1_:VT = VT.createVT(Math.random() * GS.a10000);
         var _loc2_:OpenBoxBasicData = OpenBoxFactory.getGoodsByGl(_loc1_.getValue());
         if(_loc2_ != null)
         {
            DataIngPanel.open("存档中");
            BagFactory.deteleGoods(this.needId.getValue(),GS.a1);
            ShipData.deleteTl(GS.a3);
            GM.levelm.addDiaoLouByBaoXian(GoodsFactory.createGoodsById(_loc2_.getGoodsId()));
            FlowInterface.saveDataByKai(this.saveFun);
         }
      }
      
      private function saveFun() : void
      {
         DataIngPanel.close();
      }
   }
}

