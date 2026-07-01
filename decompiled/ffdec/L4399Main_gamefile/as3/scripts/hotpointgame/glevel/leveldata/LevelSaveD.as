package hotpointgame.glevel.leveldata
{
   import hotpointgame.common.*;
   import hotpointgame.glevel.*;
   
   public class LevelSaveD
   {
      
      private var _id:VT = VT.createVT(0);
      
      private var _lAchieve:VT = VT.createVT(0);
      
      private var _lOver:VT = VT.createVT(0);
      
      private var _tempbd:LevelBD;
      
      public function LevelSaveD()
      {
         super();
      }
      
      public static function readData(param1:Object) : LevelSaveD
      {
         var _loc2_:LevelSaveD = new LevelSaveD();
         _loc2_.id = param1.id;
         _loc2_.lAchieve = param1.ach;
         _loc2_.lOver = param1.ov;
         return _loc2_;
      }
      
      public function remove() : void
      {
         this._id = null;
         this._lAchieve = null;
         this._lOver = null;
         this._tempbd = null;
      }
      
      public function save() : Object
      {
         var _loc1_:Object = new Object();
         _loc1_.id = this.id;
         _loc1_.ach = this.lAchieve;
         _loc1_.ov = this.lOver;
         return _loc1_;
      }
      
      public function hasOver() : Boolean
      {
         if(this.lAchieve >= this.tempbd.passach)
         {
            return true;
         }
         return false;
      }
      
      public function addAchieve(param1:int) : void
      {
         if(param1 > 0)
         {
            this.lAchieve += param1;
            if(this.lAchieve > this.tempbd.maxach)
            {
               this.lAchieve = this.tempbd.maxach;
            }
         }
      }
      
      public function addLstar(param1:int) : void
      {
         if(this.lOver < param1)
         {
            this.lOver = param1;
         }
      }
      
      public function get tempbd() : LevelBD
      {
         if(this._tempbd == null)
         {
            this._tempbd = LevelDataManager.getLevelBD(this.id);
         }
         return this._tempbd;
      }
      
      public function get id() : int
      {
         return this._id.getValue();
      }
      
      public function set id(param1:int) : void
      {
         this._id.setValue(param1);
      }
      
      public function get lAchieve() : int
      {
         return this._lAchieve.getValue();
      }
      
      public function set lAchieve(param1:int) : void
      {
         this._lAchieve.setValue(param1);
      }
      
      public function get lOver() : int
      {
         return this._lOver.getValue();
      }
      
      public function set lOver(param1:int) : void
      {
         this._lOver.setValue(param1);
      }
   }
}

