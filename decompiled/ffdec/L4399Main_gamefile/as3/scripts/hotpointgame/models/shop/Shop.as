package hotpointgame.models.shop
{
   import hotpointgame.common.*;
   import hotpointgame.repository.goods.*;
   import hotpointgame.repository.shop.*;
   
   public class Shop
   {
      
      private var _id:VT;
      
      public function Shop()
      {
         super();
      }
      
      public static function createShop(param1:Number) : Shop
      {
         var _loc2_:Shop = new Shop();
         _loc2_._id = VT.createVT(param1);
         return _loc2_;
      }
      
      public function getId() : Number
      {
         return this._id.getValue();
      }
      
      public function getjd() : Number
      {
         return this.getShopData().getjd();
      }
      
      public function getName() : String
      {
         return this.getShopData().getName();
      }
      
      public function getColor() : Number
      {
         return this.getShopData().getColor();
      }
      
      public function getGold() : Number
      {
         return this.getShopData().getGold();
      }
      
      public function getShopNum() : String
      {
         return this.getShopData().getShopNum();
      }
      
      public function getFrame() : Number
      {
         return this.getShopData().getFrame();
      }
      
      public function getLevel() : String
      {
         return this.getShopData().getLevel();
      }
      
      public function cxGl() : Number
      {
         return this.getShopData().cxGl();
      }
      
      public function getIdArr() : Array
      {
         return this.getShopData().getIdArr();
      }
      
      public function getNumArr() : Array
      {
         return this.getShopData().getNumArr();
      }
      
      public function getGlArr() : Array
      {
         return this.getShopData().getGlArr();
      }
      
      public function isId() : Boolean
      {
         return this.getShopData().isId();
      }
      
      public function isDj() : Boolean
      {
         return this.getShopData().isDj();
      }
      
      public function getSm() : String
      {
         return this.getShopData().getSm();
      }
      
      public function getShopId() : Number
      {
         return this.getShopData().getShopId();
      }
      
      public function getGoodsId(param1:Number) : Array
      {
         var _loc3_:uint = 0;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Array = null;
         var _loc2_:Number = 0;
         if(!this.isId())
         {
            _loc3_ = 0;
            while(true)
            {
               if(_loc3_ < this.getIdArr().length)
               {
                  _loc2_ += this.getGlArr()[_loc3_];
                  if(_loc2_ >= param1)
                  {
                     break;
                  }
                  _loc3_++;
                  continue;
               }
            }
            _loc4_ = Number(this.getIdArr()[_loc3_]);
            _loc5_ = Number(this.getNumArr()[_loc3_]);
            _loc6_ = [_loc4_];
            return new Array(GoodsFactory.createGoodsByCreateLevelList(_loc6_).getId(),_loc5_);
         }
         if(this.getIdArr().length == 1)
         {
            return this.getIdArr()[0];
         }
         if(this.getIdArr().length > 1)
         {
            _loc3_ = 0;
            while(_loc3_ < this.getIdArr().length)
            {
               _loc2_ += this.getGlArr()[_loc3_];
               if(_loc2_ >= param1)
               {
                  return new Array(this.getIdArr()[_loc3_],this.getNumArr()[_loc3_]);
               }
               _loc3_++;
            }
            throw new Error("商品概率错了,总和没10000");
         }
         return [];
      }
      
      public function getShopData() : ShopBasicData
      {
         return ShopGoodsFactory.getDataById(this._id.getValue());
      }
   }
}

