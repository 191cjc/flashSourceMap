package hotpointgame.pet
{
   import hotpointgame.common.*;
   import hotpointgame.utils.*;
   
   public class PetLingWuSkillBD
   {
      
      private var _pid:VT = VT.createVT(0);
      
      private var _linglv:VT = VT.createVT(0);
      
      private var _lingrate:VT = VT.createVT(0);
      
      private var _linggod:VT = VT.createVT(0);
      
      private var _sidArr:Array = new Array();
      
      public function PetLingWuSkillBD()
      {
         super();
      }
      
      public function get pid() : int
      {
         return this._pid.getValue();
      }
      
      public function set pid(param1:int) : void
      {
         this._pid.setValue(param1);
      }
      
      public function get linglv() : int
      {
         return this._linglv.getValue();
      }
      
      public function set linglv(param1:int) : void
      {
         this._linglv.setValue(param1);
      }
      
      public function get lingrate() : int
      {
         return this._lingrate.getValue();
      }
      
      public function set lingrate(param1:int) : void
      {
         this._lingrate.setValue(param1);
      }
      
      public function get linggod() : int
      {
         return this._linggod.getValue();
      }
      
      public function set linggod(param1:int) : void
      {
         this._linggod.setValue(param1);
      }
      
      public function get sidArr() : Array
      {
         return this._sidArr;
      }
      
      public function set sidArr(param1:Array) : void
      {
         var _loc2_:String = null;
         for each(_loc2_ in param1)
         {
            this._sidArr[this._sidArr.length] = UTools.sTnArrAndVT(_loc2_.split("*"));
         }
      }
      
      public function bDLWSkill() : int
      {
         var _loc1_:int = Math.random() * GS.a10000;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(_loc3_ < this._sidArr.length)
         {
            _loc2_ += (this._sidArr[_loc3_][1] as VT).getValue();
            if(_loc2_ >= _loc1_)
            {
               return (this._sidArr[_loc3_][0] as VT).getValue();
            }
            _loc3_++;
         }
         throw new Error("领悟技能" + this.pid + "机率总数不到 10000");
      }
   }
}

