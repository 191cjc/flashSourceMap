package hotpointgame.gskilllevel
{
   import hotpointgame.common.*;
   
   public class SkillLevelBData
   {
      
      private var _id:VT = VT.createVT(0);
      
      private var _tubiaoF:VT = VT.createVT(0);
      
      private var _donghuaF:VT = VT.createVT(0);
      
      private var _name:String = "";
      
      private var _lv:VT = VT.createVT(0);
      
      private var _lvlimit:VT = VT.createVT(0);
      
      private var _upach:VT = VT.createVT(0);
      
      private var _upplv:VT = VT.createVT(0);
      
      private var _upgod:VT = VT.createVT(0);
      
      private var _namealv:String = "";
      
      private var _wuxinn:String = "";
      
      private var _wuxinnb:String = "";
      
      private var _cdcd:String = "";
      
      private var _mpmp:String = "";
      
      private var _skylimit:String = "";
      
      private var _keyc:String = "";
      
      private var _miaoshu:String = "";
      
      private var _npca:String = "";
      
      private var _npcb:String = "";
      
      private var _npcc:String = "";
      
      public function SkillLevelBData()
      {
         super();
      }
      
      public function npctalkall() : String
      {
         var _loc1_:int = Math.random() * 3;
         switch(_loc1_)
         {
            case 0:
               return this.npca;
            case 1:
               return this.npcb;
            default:
               return this.npcc;
         }
      }
      
      public function get id() : int
      {
         return this._id.getValue();
      }
      
      public function set id(param1:int) : void
      {
         this._id.setValue(param1);
      }
      
      public function get tubiaoF() : int
      {
         return this._tubiaoF.getValue();
      }
      
      public function set tubiaoF(param1:int) : void
      {
         this._tubiaoF.setValue(param1);
      }
      
      public function get donghuaF() : int
      {
         return this._donghuaF.getValue();
      }
      
      public function set donghuaF(param1:int) : void
      {
         this._donghuaF.setValue(param1);
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      public function set name(param1:String) : void
      {
         this._name = param1;
      }
      
      public function get lv() : int
      {
         return this._lv.getValue();
      }
      
      public function set lv(param1:int) : void
      {
         this._lv.setValue(param1);
      }
      
      public function get lvlimit() : int
      {
         return this._lvlimit.getValue();
      }
      
      public function set lvlimit(param1:int) : void
      {
         this._lvlimit.setValue(param1);
      }
      
      public function get upach() : int
      {
         return this._upach.getValue();
      }
      
      public function set upach(param1:int) : void
      {
         this._upach.setValue(param1);
      }
      
      public function get upplv() : int
      {
         return this._upplv.getValue();
      }
      
      public function set upplv(param1:int) : void
      {
         this._upplv.setValue(param1);
      }
      
      public function get upgod() : int
      {
         return this._upgod.getValue();
      }
      
      public function set upgod(param1:int) : void
      {
         this._upgod.setValue(param1);
      }
      
      public function get namealv() : String
      {
         return this._namealv;
      }
      
      public function set namealv(param1:String) : void
      {
         this._namealv = param1;
      }
      
      public function get wuxinn() : String
      {
         return this._wuxinn;
      }
      
      public function set wuxinn(param1:String) : void
      {
         this._wuxinn = param1;
      }
      
      public function get wuxinnb() : String
      {
         return this._wuxinnb;
      }
      
      public function set wuxinnb(param1:String) : void
      {
         this._wuxinnb = param1;
      }
      
      public function get cdcd() : String
      {
         return this._cdcd;
      }
      
      public function set cdcd(param1:String) : void
      {
         this._cdcd = param1;
      }
      
      public function get mpmp() : String
      {
         return this._mpmp;
      }
      
      public function set mpmp(param1:String) : void
      {
         this._mpmp = param1;
      }
      
      public function get skylimit() : String
      {
         return this._skylimit;
      }
      
      public function set skylimit(param1:String) : void
      {
         this._skylimit = param1;
      }
      
      public function get keyc() : String
      {
         return this._keyc;
      }
      
      public function set keyc(param1:String) : void
      {
         this._keyc = param1;
      }
      
      public function get miaoshu() : String
      {
         return this._miaoshu;
      }
      
      public function set miaoshu(param1:String) : void
      {
         this._miaoshu = param1;
      }
      
      public function get npca() : String
      {
         return this._npca;
      }
      
      public function set npca(param1:String) : void
      {
         this._npca = param1;
      }
      
      public function get npcb() : String
      {
         return this._npcb;
      }
      
      public function set npcb(param1:String) : void
      {
         this._npcb = param1;
      }
      
      public function get npcc() : String
      {
         return this._npcc;
      }
      
      public function set npcc(param1:String) : void
      {
         this._npcc = param1;
      }
   }
}

