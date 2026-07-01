package hotpointgame.glevel
{
   import flash.display.*;
   import flash.text.*;
   import hotpointgame.Control.*;
   import hotpointgame.models.goods.Goods;
   import hotpointgame.utils.gameloader.*;
   
   public class DiaoLouGoods
   {
      
      public static var cArr:Array = new Array("0xFFFFFF","0x33CCFF","0xFF33FF","0xFF9900");
      
      private var mc:MovieClip;
      
      private var _gd:Goods;
      
      private var gh:Number;
      
      private var gw:Number;
      
      private var upstate:int = 0;
      
      public function DiaoLouGoods(param1:Goods, param2:Number, param3:Number)
      {
         super();
         var _loc4_:Class = LoaderManager.getSwfClass("wupintubiao") as Class;
         this.mc = new _loc4_() as MovieClip;
         this.gh = this.mc.height;
         this.gw = this.mc.width;
         this.mc.gotoAndStop(param1.getFrame());
         this.mc.x = param2 + (Math.random() - 0.5) * 100 - this.gw / 2;
         this.mc.y = param3 - 100;
         var _loc5_:Array = GM.levelm.getRoomLockp();
         if(this.mc.x < _loc5_[0])
         {
            this.mc.x = _loc5_[0] + 50;
         }
         if(this.mc.x > _loc5_[1])
         {
            this.mc.x = _loc5_[1] - 50;
         }
         this._gd = param1;
         var _loc6_:TextField = this.mc["pinzhiwenben"] as TextField;
         _loc6_.embedFonts = true;
         _loc6_.defaultTextFormat = new TextFormat(GM.fzfont.fontName,11,cArr[this._gd.getColor()]);
         _loc6_.text = this._gd.getName();
         GM.levelm.getVs().addDiaoLougMc(this.mc);
      }
      
      public function gmUpdate() : void
      {
         if(this.upstate == 0)
         {
            if(GM.levelm.hitTestByGoods(GM.levelm.getLx() + this.mc.x + this.gw / 2,GM.levelm.getLy() + this.mc.y + this.gw / 2))
            {
               this.upstate = 1;
            }
            else
            {
               this.mc.y += 16;
            }
         }
      }
      
      public function gmRest() : void
      {
         this.upstate = 0;
         var _loc1_:Array = GM.levelm.getRoomLockp();
         this.mc.x = GM.cp.getXforth() * -100 + GM.cp.getZx() - this.gw / 2;
         this.mc.y = GM.cp.getZy() - 150;
         if(this.mc.x < _loc1_[0])
         {
            this.mc.x = _loc1_[0] + 50;
         }
         if(this.mc.x > _loc1_[1])
         {
            this.mc.x = _loc1_[1] - 50;
         }
      }
      
      public function hitTest(param1:Number, param2:Number) : Boolean
      {
         if(param1 > this.mc.x - 50 && param1 < this.mc.x + this.gw + 50 && param2 > this.mc.y - 50 && param2 < this.mc.y + this.gh + 100)
         {
            return true;
         }
         return false;
      }
      
      public function remove() : void
      {
         if(this.mc.parent)
         {
            this.mc.parent.removeChild(this.mc);
         }
         this.mc = null;
         this.gd = null;
      }
      
      public function get gd() : Goods
      {
         return this._gd;
      }
      
      public function set gd(param1:Goods) : void
      {
         this._gd = param1;
      }
   }
}

