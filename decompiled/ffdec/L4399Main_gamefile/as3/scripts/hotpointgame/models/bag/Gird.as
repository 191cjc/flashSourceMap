package hotpointgame.models.bag
{
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   import hotpointgame.models.goods.*;
   
   public class Gird
   {
      
      private var _gs:Goods = null;
      
      private var _gn:VT = VT.createVT(GS.a0);
      
      private var _keyNum:VT = VT.createVT(-1);
      
      public function Gird()
      {
         super();
      }
      
      public static function readData(param1:Object) : Gird
      {
         var _loc2_:Gird = new Gird();
         if(param1["gs"] != "null")
         {
            _loc2_._gs = Goods.readData(param1["gs"]);
         }
         else
         {
            _loc2_._gs = null;
         }
         _loc2_._gn = VT.createVT(param1["gn"]);
         if(param1["key"] != null)
         {
            _loc2_._keyNum = VT.createVT(param1["key"]);
         }
         return _loc2_;
      }
      
      public static function creatGird() : Gird
      {
         return new Gird();
      }
      
      public function save() : Object
      {
         var _loc1_:Object = new Object();
         if(this._gs != null)
         {
            _loc1_["gs"] = this._gs.save();
         }
         else
         {
            _loc1_["gs"] = "null";
         }
         _loc1_["gn"] = this._gn.getValue();
         _loc1_["key"] = this._keyNum.getValue();
         return _loc1_;
      }
      
      public function addGoods(param1:Goods, param2:Number) : Boolean
      {
         if(this._keyNum.getValue() == GS.a0)
         {
            if(param2 > GS.a0)
            {
               if(param1.getOverlapping() != -1)
               {
                  if(this.gs == null)
                  {
                     this._gs = param1;
                     this._gn.setValue(this._gn.getValue() + param2);
                     return true;
                  }
                  if(Boolean(this._gs.compareById(param1.getId())) && this._gn.getValue() + param2 <= this._gs.getOverlapping())
                  {
                     this._gn.setValue(this._gn.getValue() + param2);
                     return true;
                  }
               }
               else if(this._gs == null)
               {
                  this._gs = param1;
                  this._gn.setValue(this._gn.getValue() + GS.a1);
                  return true;
               }
            }
            else
            {
               FlowInterface.findCheat(GS.a100);
            }
         }
         return false;
      }
      
      public function deleteGoods(param1:Number) : Boolean
      {
         if(param1 > GS.a0)
         {
            if(this._gs != null && this._gn.getValue() >= param1)
            {
               this._gn.setValue(this._gn.getValue() - param1);
               if(this._gn.getValue() == GS.a0)
               {
                  this._gs = null;
               }
               return true;
            }
         }
         else
         {
            FlowInterface.findCheat(GS.a101);
         }
         return false;
      }
      
      public function getKey() : Number
      {
         return this._keyNum.getValue();
      }
      
      public function openGird() : void
      {
         this._keyNum.setValue(GS.a0);
      }
      
      public function getGoods() : Goods
      {
         return this._gs;
      }
      
      public function getGoodsNum() : Number
      {
         return this._gn.getValue();
      }
      
      public function getGirdNum(param1:Goods) : Number
      {
         if(this._keyNum.getValue() == GS.a0)
         {
            if(this._gs != null)
            {
               if(this._gs.getOverlapping() != -1)
               {
                  if(this._gs.compareById(param1.getId()))
                  {
                     return this._gs.getOverlapping() - this._gn.getValue();
                  }
                  return GS.a0;
               }
               return GS.a0;
            }
            if(param1.getOverlapping() == -1)
            {
               return GS.a1;
            }
            return param1.getOverlapping();
         }
         return GS.a0;
      }
      
      public function compareById(param1:Number) : Boolean
      {
         if(this._gs != null)
         {
            return this._gs.compareById(param1);
         }
         return false;
      }
      
      public function get gs() : Goods
      {
         return this._gs;
      }
      
      public function set gs(param1:Goods) : void
      {
         this._gs = param1;
      }
      
      public function get gn() : VT
      {
         return this._gn;
      }
      
      public function set gn(param1:VT) : void
      {
         this._gn = param1;
      }
      
      public function get keyNum() : VT
      {
         return this._keyNum;
      }
      
      public function set keyNum(param1:VT) : void
      {
         this._keyNum = param1;
      }
   }
}

