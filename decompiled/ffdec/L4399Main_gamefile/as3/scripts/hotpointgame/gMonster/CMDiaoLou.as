package hotpointgame.gMonster
{
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   import hotpointgame.models.goods.*;
   import hotpointgame.utils.*;
   
   public class CMDiaoLou
   {
      
      private var _diaoshiwang:Array = new Array();
      
      private var _diaoshiwangB:Array = new Array();
      
      private var _diaorenwu:Array = new Array();
      
      private var _diaoteshu:Array = new Array();
      
      public function CMDiaoLou()
      {
         super();
      }
      
      public function getDlGoods(param1:Number) : Vector.<Goods>
      {
         var _loc7_:Goods = null;
         var _loc8_:Goods = null;
         var _loc9_:Goods = null;
         var _loc10_:Number = NaN;
         var _loc11_:int = 0;
         var _loc12_:Goods = null;
         var _loc13_:Number = NaN;
         var _loc14_:int = 0;
         var _loc15_:Goods = null;
         var _loc2_:Vector.<Goods> = new Vector.<Goods>();
         var _loc3_:Number = 0;
         var _loc4_:int = 0;
         while(_loc4_ < this._diaoshiwang.length)
         {
            _loc3_ += (this._diaoshiwang[_loc4_][0] as VT).getValue();
            if(param1 <= _loc3_)
            {
               _loc7_ = FlowInterface.createGoodsByCreateLevel((this._diaoshiwang[_loc4_][1] as VT).getValue());
               if(_loc7_ != null)
               {
                  _loc2_.push(_loc7_);
               }
               break;
            }
            _loc4_++;
         }
         _loc3_ = 0;
         var _loc5_:int = 0;
         while(_loc5_ < this._diaoshiwangB.length)
         {
            _loc3_ += (this._diaoshiwangB[_loc5_][0] as VT).getValue();
            if(param1 <= _loc3_)
            {
               _loc8_ = FlowInterface.createGoodsByCreateLevel((this._diaoshiwangB[_loc5_][1] as VT).getValue());
               if(_loc8_ != null)
               {
                  _loc2_.push(_loc8_);
               }
               break;
            }
            _loc5_++;
         }
         var _loc6_:int = 0;
         while(_loc6_ < this._diaorenwu.length)
         {
            if(FlowInterface.isTaskIngById((this._diaorenwu[_loc6_][0] as VT).getValue()))
            {
               if(param1 <= (this._diaorenwu[_loc6_][1] as VT).getValue())
               {
                  _loc9_ = FlowInterface.createGoodsByCreateLevel((this._diaorenwu[_loc6_][2] as VT).getValue());
                  if(_loc9_ != null)
                  {
                     _loc2_.push(_loc9_);
                  }
               }
            }
            _loc6_++;
         }
         if(VipDataManager.vself.diaoluostart())
         {
            _loc10_ = 0;
            _loc11_ = 0;
            while(_loc11_ < this._diaoteshu.length)
            {
               _loc10_ += (this._diaoteshu[_loc11_][0] as VT).getValue() * VipDataManager.vself.getDiaoLouR();
               if(param1 <= _loc10_)
               {
                  _loc12_ = FlowInterface.createGoodsByCreateLevel((this._diaoteshu[_loc11_][1] as VT).getValue());
                  if(_loc12_ != null)
                  {
                     _loc2_.push(_loc12_);
                  }
                  break;
               }
               _loc11_++;
            }
         }
         if(VipDataManager.vself.getGroupLv() > 0)
         {
            _loc13_ = 0;
            _loc14_ = 0;
            while(_loc14_ < this._diaoteshu.length)
            {
               _loc13_ += (this._diaoteshu[_loc14_][0] as VT).getValue() * VipDataManager.vself.getGroupAddDiaoLou();
               if(param1 <= _loc13_)
               {
                  _loc15_ = FlowInterface.createGoodsByCreateLevel((this._diaoteshu[_loc14_][1] as VT).getValue());
                  if(_loc15_ != null)
                  {
                     _loc2_.push(_loc15_);
                  }
                  break;
               }
               _loc14_++;
            }
         }
         return _loc2_;
      }
      
      public function get diaoshiwang() : Array
      {
         return this._diaoshiwang;
      }
      
      public function set diaoshiwang(param1:Array) : void
      {
         var _loc2_:String = null;
         for each(_loc2_ in param1)
         {
            this._diaoshiwang[this._diaoshiwang.length] = UTools.sTnArrAndVT(_loc2_.split(","));
         }
      }
      
      public function get diaoshiwangB() : Array
      {
         return this._diaoshiwangB;
      }
      
      public function set diaoshiwangB(param1:Array) : void
      {
         var _loc2_:String = null;
         for each(_loc2_ in param1)
         {
            this._diaoshiwangB[this._diaoshiwangB.length] = UTools.sTnArrAndVT(_loc2_.split(","));
         }
      }
      
      public function get diaorenwu() : Array
      {
         return this._diaorenwu;
      }
      
      public function set diaorenwu(param1:Array) : void
      {
         var _loc2_:String = null;
         for each(_loc2_ in param1)
         {
            this._diaorenwu[this._diaorenwu.length] = UTools.sTnArrAndVT(_loc2_.split(","));
         }
      }
      
      public function get diaoteshu() : Array
      {
         return this._diaoteshu;
      }
      
      public function set diaoteshu(param1:Array) : void
      {
         var _loc2_:String = null;
         for each(_loc2_ in param1)
         {
            this._diaoteshu[this._diaoteshu.length] = UTools.sTnArrAndVT(_loc2_.split(","));
         }
      }
   }
}

