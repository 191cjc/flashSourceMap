package hotpointgame.savedatal
{
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   
   public class TwelveDouHunBaseData
   {
      
      private var _name:String = "";
      
      private var _id:VT = VT.createVT(0);
      
      private var _pId:VT = VT.createVT(0);
      
      private var _pgod:VT = VT.createVT(0);
      
      private var _attB:VT = VT.createVT(0);
      
      private var _attBW:VT = VT.createVT(0);
      
      private var _attname:String = "";
      
      public function TwelveDouHunBaseData()
      {
         super();
      }
      
      public function getAddAtt() : Number
      {
         if(FlowInterface.getJobByRole() == GS.a1)
         {
            return this.attB;
         }
         return this.attBW;
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      public function set name(param1:String) : void
      {
         this._name = param1;
      }
      
      public function get id() : int
      {
         return this._id.getValue();
      }
      
      public function set id(param1:int) : void
      {
         this._id.setValue(param1);
      }
      
      public function get pId() : int
      {
         return this._pId.getValue();
      }
      
      public function set pId(param1:int) : void
      {
         this._pId.setValue(param1);
      }
      
      public function get pgod() : int
      {
         return this._pgod.getValue();
      }
      
      public function set pgod(param1:int) : void
      {
         this._pgod.setValue(param1);
      }
      
      public function get attB() : Number
      {
         return this._attB.getValue();
      }
      
      public function set attB(param1:Number) : void
      {
         this._attB.setValue(param1);
      }
      
      public function get attname() : String
      {
         return this._attname;
      }
      
      public function set attname(param1:String) : void
      {
         this._attname = param1;
      }
      
      public function get attBW() : Number
      {
         return this._attBW.getValue();
      }
      
      public function set attBW(param1:Number) : void
      {
         this._attBW.setValue(param1);
      }
   }
}

