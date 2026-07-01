package hotpointgame.repository.geneChange
{
   import hotpointgame.common.*;
   
   public class GeneChangeData
   {
      
      private var _id:VT;
      
      private var _type:VT;
      
      private var _playerId:VT;
      
      private var _djId:Array = [];
      
      private var _djGold:Array = [];
      
      private var _gl:Array = [];
      
      private var _djGl:Array = [];
      
      private var _openId:Array = [];
      
      private var _openNum:Array = [];
      
      private var _gold:Array = [];
      
      private var _playerLevel:Array = [];
      
      private var _goodsOne:Array = [];
      
      private var _numOne:Array = [];
      
      private var _skillArr:Array = [];
      
      public function GeneChangeData()
      {
         super();
      }
      
      public static function createGeneChangeData(param1:Number, param2:Number, param3:Number, param4:String, param5:String, param6:String, param7:String, param8:String, param9:String, param10:String, param11:String, param12:String, param13:String, param14:String) : GeneChangeData
      {
         var _loc15_:GeneChangeData = new GeneChangeData();
         _loc15_._id = VT.createVT(param1);
         _loc15_._type = VT.createVT(param2);
         _loc15_._playerId = VT.createVT(param3);
         _loc15_._gold = strToArr(param4);
         _loc15_._djId = strToArr(param5);
         _loc15_._djGold = strToArr(param6);
         _loc15_._gl = strToArr(param7);
         _loc15_._djGl = strToArr(param8);
         _loc15_._openId = strToArr(param9);
         _loc15_._openNum = strToArr(param10);
         _loc15_._goodsOne = strToArr(param12);
         _loc15_._playerLevel = strToArr(param11);
         _loc15_._numOne = strToArr(param13);
         _loc15_._skillArr = strToArr(param14);
         return _loc15_;
      }
      
      private static function strToArr(param1:String) : Array
      {
         var _loc2_:Array = param1.split("*");
         var _loc3_:Array = [];
         var _loc4_:uint = 0;
         while(_loc4_ < _loc2_.length)
         {
            if(Boolean(Number(_loc2_[_loc4_])) || _loc2_[_loc4_] == 0)
            {
               _loc3_.push(VT.createVT(Number(_loc2_[_loc4_])));
            }
            else
            {
               _loc3_.push(String(_loc2_[_loc4_]));
            }
            _loc4_++;
         }
         return _loc3_;
      }
      
      public function getId() : Number
      {
         return this._id.getValue();
      }
      
      public function getType() : Number
      {
         return this._type.getValue();
      }
      
      public function getPlayId() : Number
      {
         return this._playerId.getValue();
      }
      
      public function getGold(param1:Number) : Number
      {
         return this._gold[param1 - 1].getValue();
      }
      
      public function getDjId(param1:Number) : Number
      {
         return this._djId[param1 - 1].getValue();
      }
      
      public function getDjGold(param1:Number) : Number
      {
         return this._djGold[param1 - 1].getValue();
      }
      
      public function getGl(param1:Number) : Number
      {
         return this._gl[param1 - 1].getValue();
      }
      
      public function getDjGl(param1:Number) : Number
      {
         return this._djGl[param1 - 1].getValue();
      }
      
      public function getOpenId() : Array
      {
         var _loc1_:Array = [];
         var _loc2_:uint = 0;
         while(_loc2_ < this._openId.length)
         {
            _loc1_.push(this._openId[_loc2_].getValue());
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function getOpenNum() : Array
      {
         var _loc1_:Array = [];
         var _loc2_:uint = 0;
         while(_loc2_ < this._openNum.length)
         {
            _loc1_.push(this._openNum[_loc2_].getValue());
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function getPlayerLevel(param1:Number) : Number
      {
         return this._playerLevel[param1 - 1].getValue();
      }
      
      public function getGoodsId(param1:Number) : Number
      {
         return this._goodsOne[param1 - 1].getValue();
      }
      
      public function getGoodsNum(param1:Number) : Number
      {
         return this._numOne[param1 - 1].getValue();
      }
      
      public function getSkillId(param1:Number) : Number
      {
         return this._skillArr[param1 - 1].getValue();
      }
   }
}

