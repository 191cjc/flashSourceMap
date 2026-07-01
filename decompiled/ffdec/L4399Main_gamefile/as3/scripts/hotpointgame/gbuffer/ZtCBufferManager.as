package hotpointgame.gbuffer
{
   import hotpointgame.common.*;
   import hotpointgame.gameobj.ZhangDouT;
   import hotpointgame.gameobj.ZtC;
   import hotpointgame.utils.*;
   import hotpointgame.utils.gameloader.*;
   
   public class ZtCBufferManager
   {
      
      private var bufferArr:Vector.<ZtcBuffer> = new Vector.<ZtcBuffer>();
      
      public function ZtCBufferManager()
      {
         super();
      }
      
      public function addBuffer(param1:Object, param2:ZtC) : void
      {
         var _loc3_:ZtcBuffer = null;
         var _loc4_:Class = null;
         var _loc5_:Class = null;
         var _loc6_:ZtcBuffer = null;
         for each(_loc3_ in this.bufferArr)
         {
            if(_loc3_.bname == param1.name)
            {
               return;
            }
         }
         _loc4_ = LoaderManager.getSwfClass(param1.flaname) as Class;
         _loc5_ = ClassGet.getClassByNameAndAlias("ZtcBu" + param1.classname);
         _loc6_ = new _loc5_(new _loc4_(),param2,param1);
         this.bufferArr[this.bufferArr.length] = _loc6_;
      }
      
      public function gmUpdate(param1:ZtC) : void
      {
         var _loc2_:int = int(this.bufferArr.length);
         var _loc3_:* = int(_loc2_ - 1);
         while(_loc3_ >= 0)
         {
            if(this.bufferArr[_loc3_].gmUpdate(param1) < 0)
            {
               this.bufferArr[_loc3_].remove(param1);
               this.bufferArr.splice(_loc3_,1);
            }
            _loc3_--;
         }
      }
      
      public function attack(param1:ZtC, param2:Vector.<ZhangDouT>) : void
      {
         var _loc3_:ZtcBuffer = null;
         for each(_loc3_ in this.bufferArr)
         {
            _loc3_.attack(param1,param2);
         }
      }
      
      public function removeAllBuffer(param1:ZtC) : void
      {
         var _loc2_:int = int(this.bufferArr.length);
         var _loc3_:* = int(_loc2_ - 1);
         while(_loc3_ >= 0)
         {
            this.bufferArr[_loc3_].remove(param1);
            this.bufferArr.splice(_loc3_,1);
            _loc3_--;
         }
         this.bufferArr.length = 0;
      }
      
      public function getJiangSu() : Array
      {
         var _loc1_:ZtcBuffer = null;
         for each(_loc1_ in this.bufferArr)
         {
            if(_loc1_ as ZtcBufferJiangSu)
            {
               return [_loc1_.bnum,_loc1_.hurt];
            }
         }
         return null;
      }
      
      public function getAddatt() : Number
      {
         var _loc1_:ZtcBuffer = null;
         for each(_loc1_ in this.bufferArr)
         {
            if(_loc1_ as ZtcBuMAddatt)
            {
               return _loc1_.hurt;
            }
         }
         return GS.a1;
      }
      
      public function getAddDenf() : Number
      {
         var _loc1_:ZtcBuffer = null;
         for each(_loc1_ in this.bufferArr)
         {
            if(_loc1_ as ZtcBuMAddDenf)
            {
               return _loc1_.hurt;
            }
         }
         return GS.a1;
      }
      
      public function getAddSpeed() : Number
      {
         var _loc1_:ZtcBuffer = null;
         for each(_loc1_ in this.bufferArr)
         {
            if(_loc1_ as ZtcBuMAddSpeed)
            {
               return _loc1_.hurt;
            }
         }
         return GS.a1;
      }
   }
}

