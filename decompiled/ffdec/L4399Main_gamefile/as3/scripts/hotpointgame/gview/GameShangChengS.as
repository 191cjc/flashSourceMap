package hotpointgame.gview
{
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   import hotpointgame.Control.*;
   import hotpointgame.common.event.*;
   import hotpointgame.ginit.*;
   import hotpointgame.gshangcheng.ShangChengBData;
   import hotpointgame.models.goods.Goods;
   import hotpointgame.repository.goods.GoodsData;
   import hotpointgame.utils.gameloader.*;
   
   public class GameShangChengS extends MovieClip
   {
      
      private var mc:MovieClip;
      
      private var pbd:ShangChengBData;
      
      private var mcmo:McBtnLianDong;
      
      public function GameShangChengS(param1:ShangChengBData)
      {
         super();
         this.pbd = param1;
         var _loc2_:GoodsData = FlowInterface.getGoodsBaseDataById(param1.propId);
         var _loc3_:Class = LoaderManager.getSwfClass("scgouwulan") as Class;
         this.mc = new _loc3_() as MovieClip;
         addChild(this.mc);
         this.mcmo = new McBtnLianDong();
         this.mcmo.addBtnNoLian(new McBtn(this.mc["j_6"]));
         this.mcmo.addBtnNoLian(new McBtn(this.mc["scshichuang"]));
         this.mcmo.addBtnNoLian(new McBtn(this.mc["scgoumai"]));
         if(this.pbd.isKYShiChuang == -1)
         {
            (this.mc["scshichuang"] as MovieClip).visible = false;
         }
         else
         {
            (this.mc["scshichuang"] as MovieClip).visible = true;
         }
         var _loc4_:Class = LoaderManager.getSwfClass("T_Box") as Class;
         var _loc5_:MovieClip = new _loc4_() as MovieClip;
         _loc5_.mouseEnabled = false;
         _loc5_.mouseChildren = false;
         (_loc5_["mask_mc"] as MovieClip).visible = false;
         (_loc5_["d_mc"] as MovieClip).visible = false;
         (_loc5_["gx_mc"] as MovieClip).visible = false;
         _loc5_.gotoAndStop(_loc2_.getFrame());
         _loc5_.x = 14;
         _loc5_.y = 23;
         this.mc.addChild(_loc5_);
         (this.mc["scbiaoqian"] as MovieClip).gotoAndStop(this.pbd.hotFlagFrameNum);
         this.mc.addChild(this.mc["scbiaoqian"]);
         (this.mc["scwupinmc"] as TextField).text = _loc2_.getName();
         (this.mc["scwupinmc"] as TextField).setTextFormat(_loc2_.getColorStr());
         (this.mc["scjingbia"] as TextField).text = String(this.pbd.showPrice);
         if(this.pbd.priceFlag == 1)
         {
            (this.mc["vipdz"] as MovieClip).gotoAndStop(1);
            (this.mc["vipdz"] as MovieClip).visible = false;
            (this.mc["scjingbib"] as TextField).text = "";
         }
         else if(this.pbd.priceFlag == 2)
         {
            (this.mc["vipdz"] as MovieClip).gotoAndStop(2);
            (this.mc["vipdz"] as MovieClip).visible = true;
            (this.mc["scjingbib"] as TextField).text = String(this.pbd.buyPrice);
         }
         else
         {
            (this.mc["vipdz"] as MovieClip).gotoAndStop(1);
            (this.mc["vipdz"] as MovieClip).visible = true;
            (this.mc["scjingbib"] as TextField).text = String(this.pbd.buyPrice);
         }
         this.mc.addEventListener(MouseEvent.CLICK,this.mcclicke);
         this.mc.addEventListener(MouseEvent.MOUSE_OVER,this.mcmoveovere);
         this.mc.addEventListener(MouseEvent.MOUSE_OUT,this.mcmoveoute);
      }
      
      public function removeSelf() : void
      {
         this.mc.removeEventListener(MouseEvent.CLICK,this.mcclicke);
         this.mc.removeEventListener(MouseEvent.MOUSE_OVER,this.mcmoveovere);
         this.mc.removeEventListener(MouseEvent.MOUSE_OUT,this.mcmoveoute);
         this.mcmo.remove();
         this.mcmo = null;
         this.pbd = null;
         removeChild(this.mc);
         this.mc = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
      
      private function mcclicke(param1:MouseEvent) : void
      {
         var _loc2_:Goods = null;
         if(param1.target.name != null)
         {
            if(param1.target.name == "scshichuang")
            {
               _loc2_ = FlowInterface.getGoodsById(this.pbd.propId);
               GameShangChengC.self.testChuangZB(_loc2_.getSmallType(),_loc2_.getFrame());
            }
            if(param1.target.name == "scgoumai")
            {
               GameShangChengC.self.buyShopByClick(this.pbd);
            }
         }
      }
      
      private function mcmoveovere(param1:MouseEvent) : void
      {
         if(param1.target.name != null && param1.target.name == "j_6")
         {
            Main.self.dispatchEvent(new GoodsEvent(GoodsEvent.DO_DISPLAY,FlowInterface.getGoodsById(this.pbd.propId)));
         }
      }
      
      private function mcmoveoute(param1:MouseEvent) : void
      {
         if(param1.target.name != null && param1.target.name == "j_6")
         {
            Main.self.dispatchEvent(new BtnEvent(BtnEvent.DO_OUT));
         }
      }
   }
}

