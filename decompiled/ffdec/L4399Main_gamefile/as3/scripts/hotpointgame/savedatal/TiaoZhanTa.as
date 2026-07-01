package hotpointgame.savedatal
{
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   
   public class TiaoZhanTa
   {
      
      private var _enterNum:VT = VT.createVT(0);
      
      private var _enterNumb:VT = VT.createVT(0);
      
      private var _maxLevel:VT = VT.createVT(0);
      
      public function TiaoZhanTa()
      {
         super();
      }
      
      public static function readData(param1:Object = null) : TiaoZhanTa
      {
         var _loc2_:TiaoZhanTa = new TiaoZhanTa();
         if(param1 != null)
         {
            _loc2_.enterNum = param1.en;
            _loc2_.maxLevel = param1.ml;
            if(_loc2_.maxLevel > GS.a20)
            {
               _loc2_.maxLevel = GS.a20;
            }
            _loc2_.enterNumb = param1.enb;
         }
         return _loc2_;
      }
      
      public function save() : Object
      {
         var _loc1_:Object = new Object();
         _loc1_.en = this.enterNum;
         _loc1_.ml = this.maxLevel;
         _loc1_.enb = this.enterNumb;
         return _loc1_;
      }
      
      public function everyDayUpdata() : void
      {
         this.enterNum = 0;
         this.enterNumb = 0;
      }
      
      public function addNum() : void
      {
         this.enterNum += GS.a1;
         if(this.enterNum > GS.a2)
         {
            GM.findCheatMax(GS.a69);
         }
      }
      
      public function addNumb() : void
      {
         this.enterNumb += GS.a1;
         if(this.enterNumb > GS.a1)
         {
            GM.findCheatMax(GS.a69);
         }
      }
      
      public function addMaxLv(param1:int) : void
      {
         if(param1 > this.maxLevel)
         {
            this.maxLevel = param1;
         }
         if(this.maxLevel > GS.a20)
         {
            this.maxLevel = 0;
         }
      }
      
      public function getPNSendMax() : int
      {
         return GS.a5;
      }
      
      public function getPNSendMin() : int
      {
         return GS.a4;
      }
      
      public function getSendGodMax() : int
      {
         return GS.a500 * GS.a10;
      }
      
      public function getSendGodMin() : int
      {
         return GS.a400 * GS.a10;
      }
      
      public function getSendLvMax() : int
      {
         if(this.maxLevel >= GS.a20)
         {
            return GS.a20;
         }
         return 0;
      }
      
      public function getSendLvMin() : int
      {
         if(this.maxLevel >= GS.a10)
         {
            return GS.a10;
         }
         return 0;
      }
      
      public function get enterNum() : int
      {
         return this._enterNum.getValue();
      }
      
      public function set enterNum(param1:int) : void
      {
         this._enterNum.setValue(param1);
      }
      
      public function get enterNumb() : int
      {
         return this._enterNumb.getValue();
      }
      
      public function set enterNumb(param1:int) : void
      {
         this._enterNumb.setValue(param1);
      }
      
      public function get maxLevel() : int
      {
         return this._maxLevel.getValue();
      }
      
      public function set maxLevel(param1:int) : void
      {
         this._maxLevel.setValue(param1);
      }
   }
}

