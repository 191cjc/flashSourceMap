package hotpointgame.glevel.leveldata
{
   import hotpointgame.common.*;
   
   public class LevelBD
   {
      
      private var _id:VT = VT.createVT(0);
      
      private var _lname:String = "";
      
      private var _enterlid:VT = VT.createVT(0);
      
      private var _enterpid:VT = VT.createVT(0);
      
      private var _passach:VT = VT.createVT(0);
      
      private var _maxach:VT = VT.createVT(0);
      
      private var _enterSe:String = "";
      
      private var _enterRm:String = "";
      
      private var _enterX:VT = VT.createVT(0);
      
      private var _enterY:VT = VT.createVT(0);
      
      public function LevelBD()
      {
         super();
      }
      
      public function get id() : int
      {
         return this._id.getValue();
      }
      
      public function set id(param1:int) : void
      {
         this._id.setValue(param1);
      }
      
      public function get lname() : String
      {
         return this._lname;
      }
      
      public function set lname(param1:String) : void
      {
         this._lname = param1;
      }
      
      public function get enterlid() : int
      {
         return this._enterlid.getValue();
      }
      
      public function set enterlid(param1:int) : void
      {
         this._enterlid.setValue(param1);
      }
      
      public function get enterpid() : int
      {
         return this._enterpid.getValue();
      }
      
      public function set enterpid(param1:int) : void
      {
         this._enterpid.setValue(param1);
      }
      
      public function get passach() : int
      {
         return this._passach.getValue();
      }
      
      public function set passach(param1:int) : void
      {
         this._passach.setValue(param1);
      }
      
      public function get maxach() : int
      {
         return this._maxach.getValue();
      }
      
      public function set maxach(param1:int) : void
      {
         this._maxach.setValue(param1);
      }
      
      public function get enterSe() : String
      {
         return this._enterSe;
      }
      
      public function set enterSe(param1:String) : void
      {
         this._enterSe = param1;
      }
      
      public function get enterRm() : String
      {
         return this._enterRm;
      }
      
      public function set enterRm(param1:String) : void
      {
         this._enterRm = param1;
      }
      
      public function get enterX() : int
      {
         return this._enterX.getValue();
      }
      
      public function set enterX(param1:int) : void
      {
         this._enterX.setValue(param1);
      }
      
      public function get enterY() : int
      {
         return this._enterY.getValue();
      }
      
      public function set enterY(param1:int) : void
      {
         this._enterY.setValue(param1);
      }
   }
}

