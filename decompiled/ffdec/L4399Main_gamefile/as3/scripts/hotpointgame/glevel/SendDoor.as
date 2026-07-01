package hotpointgame.glevel
{
   import flash.display.*;
   import flash.text.*;
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   import hotpointgame.utils.gameloader.*;
   
   public class SendDoor
   {
      
      private var _name:String = "a";
      
      private var sname:String = "b";
      
      private var showname:String = "";
      
      private var mcClass:String = "无";
      
      private var chuxian:Object;
      
      private var cxP:Array = [0,0];
      
      private var effectObj:Array = new Array();
      
      private var usetype:int = 0;
      
      private var tObj:Object = new Object();
      
      private var _useTimesMax:VT = VT.createVT(0);
      
      private var _useTimesCur:VT = VT.createVT(0);
      
      public function SendDoor(param1:String, param2:String, param3:String, param4:String, param5:Object, param6:Array, param7:Array, param8:int, param9:Object, param10:int)
      {
         super();
         this.name = param1;
         this.sname = param2;
         this.showname = param3;
         this.mcClass = param4;
         this.chuxian = param5;
         this.cxP = param6;
         this.effectObj = param7;
         this.usetype = param8;
         this.tObj = param9;
         this.useTimesMax = param10;
      }
      
      public function remove() : void
      {
      }
      
      public function useDoor(param1:Number, param2:Number, param3:Boolean) : Object
      {
         if(param1 > this.effectObj[0] && param1 < this.effectObj[1] && param2 > this.effectObj[2] && param2 < this.effectObj[3])
         {
            if(this.usetype == 0)
            {
               --this.useTimesCur;
               return this.getTarget();
            }
            if(this.usetype == 1)
            {
               if(GM.ckey.isKey("传送门"))
               {
                  --this.useTimesCur;
                  return this.getTarget();
               }
            }
         }
         return null;
      }
      
      public function getTarget() : Object
      {
         var _loc1_:Array = null;
         var _loc2_:int = 0;
         var _loc3_:Object = null;
         switch(this.tObj.type)
         {
            case "gd":
               return this.tObj.md;
            case "sj":
               _loc1_ = this.tObj.lb;
               _loc2_ = Math.random() * GS.a100;
               for each(_loc3_ in _loc1_)
               {
                  if(_loc2_ >= _loc3_.jla && _loc2_ <= _loc3_.jlb)
                  {
                     return _loc3_.md;
                  }
               }
               return null;
            default:
               throw new Error("target erroe!");
         }
      }
      
      public function getDoorMc() : MovieClip
      {
         var _loc1_:MovieClip = null;
         var _loc2_:Class = null;
         var _loc3_:TextField = null;
         if(this.mcClass == "yingcangmen")
         {
            _loc1_ = new MovieClip();
         }
         else
         {
            _loc2_ = LoaderManager.getSwfClass(this.mcClass) as Class;
            _loc1_ = new _loc2_() as MovieClip;
            _loc3_ = _loc1_["qianwangmudi"]["zhaoa"]["doorname"] as TextField;
            _loc3_.embedFonts = true;
            _loc3_.defaultTextFormat = new TextFormat(GM.fzfont.fontName);
            _loc3_.text = this.showname;
         }
         _loc1_.x = this.cxP[0];
         _loc1_.y = this.cxP[1];
         _loc1_.name = this.name;
         return _loc1_;
      }
      
      public function isChuXian(param1:CLevel) : Boolean
      {
         var _loc3_:Object = null;
         var _loc4_:Array = null;
         var _loc2_:Array = this.chuxian.cx;
         for each(_loc3_ in _loc2_)
         {
            switch(_loc3_.tj)
            {
               case "lv":
                  break;
               case "fjwc":
                  _loc4_ = _loc3_.fj;
                  if(param1.getRoomOverNum(_loc4_[0],_loc4_[1]) < _loc4_[2])
                  {
                     return false;
                  }
            }
         }
         return true;
      }
      
      public function get useTimesMax() : int
      {
         return this._useTimesMax.getValue();
      }
      
      public function set useTimesMax(param1:int) : void
      {
         this._useTimesMax.setValue(param1);
      }
      
      public function get useTimesCur() : int
      {
         return this._useTimesCur.getValue();
      }
      
      public function set useTimesCur(param1:int) : void
      {
         this._useTimesCur.setValue(param1);
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      public function set name(param1:String) : void
      {
         this._name = param1;
      }
   }
}

