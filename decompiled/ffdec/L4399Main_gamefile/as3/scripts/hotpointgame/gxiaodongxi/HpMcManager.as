package hotpointgame.gxiaodongxi
{
   import flash.display.*;
   import hotpointgame.utils.gameloader.*;
   
   public class HpMcManager
   {
      
      public static var self:HpMcManager = new HpMcManager();
      
      private var mcArra:Vector.<MovieClip>;
      
      private var mcArrb:Vector.<MovieClip>;
      
      private var mcArrc:Vector.<MovieClip>;
      
      private var curn:int = -1;
      
      private var totaln:int = 50;
      
      private var totalnm:int;
      
      private var curnb:int = -1;
      
      private var totalnb:int = 15;
      
      private var totalnmb:int;
      
      private var curnc:int = -1;
      
      private var totalnc:int = 15;
      
      private var totalnmc:int;
      
      public function HpMcManager()
      {
         var _loc5_:MovieClip = null;
         var _loc6_:MovieClip = null;
         var _loc7_:MovieClip = null;
         this.mcArra = new Vector.<MovieClip>();
         this.mcArrb = new Vector.<MovieClip>();
         this.mcArrc = new Vector.<MovieClip>();
         this.totalnm = this.totaln - 1;
         this.totalnmb = this.totalnb - 1;
         this.totalnmc = this.totalnc - 1;
         super();
         var _loc1_:Class = LoaderManager.getSwfClass("gongjijihesu") as Class;
         var _loc2_:int = 0;
         while(_loc2_ < this.totaln)
         {
            _loc5_ = new _loc1_() as MovieClip;
            _loc5_.stop();
            (_loc5_["wuxing"] as MovieClip).gotoAndStop(1);
            _loc5_.cacheAsBitmap = true;
            this.mcArra.push(_loc5_);
            _loc2_++;
         }
         _loc1_ = LoaderManager.getSwfClass("beigongjijihesu") as Class;
         var _loc3_:int = 0;
         while(_loc3_ < this.totalnb)
         {
            _loc6_ = new _loc1_() as MovieClip;
            _loc6_.stop();
            (_loc6_["wuxing"] as MovieClip).gotoAndStop(1);
            _loc6_.cacheAsBitmap = true;
            this.mcArrb.push(_loc6_);
            _loc3_++;
         }
         _loc1_ = LoaderManager.getSwfClass("baojijihesu") as Class;
         var _loc4_:int = 0;
         while(_loc4_ < this.totalnc)
         {
            _loc7_ = new _loc1_() as MovieClip;
            _loc7_.stop();
            (_loc7_["wuxing"] as MovieClip).gotoAndStop(1);
            _loc7_.cacheAsBitmap = true;
            this.mcArrc.push(_loc7_);
            _loc4_++;
         }
      }
      
      public function getMonsterMc() : MovieClip
      {
         ++this.curn;
         if(this.curn > this.totalnm)
         {
            this.curn = 0;
         }
         return this.mcArra[this.curn];
      }
      
      public function getRoleMc() : MovieClip
      {
         ++this.curnb;
         if(this.curnb > this.totalnmb)
         {
            this.curnb = 0;
         }
         return this.mcArrb[this.curnb];
      }
      
      public function getBaojiMc() : MovieClip
      {
         ++this.curnc;
         if(this.curnc > this.totalnmc)
         {
            this.curnc = 0;
         }
         return this.mcArrc[this.curnc];
      }
   }
}

