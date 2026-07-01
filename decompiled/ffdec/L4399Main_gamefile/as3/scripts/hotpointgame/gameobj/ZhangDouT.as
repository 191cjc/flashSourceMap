package hotpointgame.gameobj
{
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import hotpointgame.common.*;
   
   public class ZhangDouT
   {
      
      protected var _ztGroup:VT = VT.createVT(0);
      
      protected var _ztType:VT = VT.createVT(0);
      
      public function ZhangDouT()
      {
         super();
      }
      
      public function bhitTestByPoint(param1:Number, param2:Number) : Boolean
      {
         return false;
      }
      
      public function bhitTestByObject(param1:DisplayObject) : Boolean
      {
         return false;
      }
      
      public function bhitTestByObjectAndPoint(param1:DisplayObject) : Boolean
      {
         return false;
      }
      
      public function bhitByObjectAndPoint(param1:DisplayObject, param2:FightData, param3:ZhangDouT) : int
      {
         return -1;
      }
      
      public function bhitByPoint(param1:Number, param2:Number, param3:FightData, param4:ZhangDouT) : int
      {
         return -1;
      }
      
      public function bhitByObject(param1:DisplayObject, param2:FightData, param3:ZhangDouT) : int
      {
         return -1;
      }
      
      public function bhit(param1:FightData, param2:ZhangDouT) : int
      {
         return 0;
      }
      
      public function bhitXianZhi(param1:int, param2:int) : void
      {
      }
      
      public function bhitBuffer(param1:Object) : void
      {
      }
      
      public function bhitHp(param1:int) : void
      {
      }
      
      public function getAttackValue() : Number
      {
         return 0;
      }
      
      public function getDefenceValue() : Number
      {
         return 0;
      }
      
      public function getWuxinSX(param1:int) : int
      {
         return 0;
      }
      
      public function getZtLevel() : int
      {
         return 1;
      }
      
      public function getWuxinKaxin(param1:int) : Number
      {
         return 0;
      }
      
      public function getBaojiJL() : Number
      {
         return 0;
      }
      
      public function isLive() : Boolean
      {
         return false;
      }
      
      public function getZTGroup() : int
      {
         return this.ztGroup;
      }
      
      public function setZTGroup(param1:int) : void
      {
         this.ztGroup = param1;
      }
      
      public function getZTType() : int
      {
         return this.ztType;
      }
      
      public function getZx() : Number
      {
         return 0;
      }
      
      public function setZx(param1:Number) : void
      {
      }
      
      public function getZy() : Number
      {
         return 0;
      }
      
      public function setZy(param1:Number) : void
      {
      }
      
      public function getXforth() : int
      {
         return 0;
      }
      
      public function getZmc() : MovieClip
      {
         return null;
      }
      
      public function get ztGroup() : int
      {
         return this._ztGroup.getValue();
      }
      
      public function set ztGroup(param1:int) : void
      {
         this._ztGroup.setValue(param1);
      }
      
      public function get ztType() : int
      {
         return this._ztType.getValue();
      }
      
      public function set ztType(param1:int) : void
      {
         this._ztType.setValue(param1);
      }
   }
}

