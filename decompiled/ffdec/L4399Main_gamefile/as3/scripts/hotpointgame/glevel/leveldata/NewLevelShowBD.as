package hotpointgame.glevel.leveldata
{
   public class NewLevelShowBD
   {
      
      private var _id:int = 0;
      
      private var _suggAtt:Number = 0;
      
      private var _awardArr:Array = new Array();
      
      public function NewLevelShowBD()
      {
         super();
      }
      
      public function addAward(param1:String) : void
      {
         this.awardArr = param1.split("*");
      }
      
      public function get id() : int
      {
         return this._id;
      }
      
      public function set id(param1:int) : void
      {
         this._id = param1;
      }
      
      public function get suggAtt() : Number
      {
         return this._suggAtt;
      }
      
      public function set suggAtt(param1:Number) : void
      {
         this._suggAtt = param1;
      }
      
      public function get awardArr() : Array
      {
         return this._awardArr;
      }
      
      public function set awardArr(param1:Array) : void
      {
         this._awardArr = param1;
      }
   }
}

