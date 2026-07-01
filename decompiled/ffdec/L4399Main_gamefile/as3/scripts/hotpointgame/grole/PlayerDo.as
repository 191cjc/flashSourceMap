package hotpointgame.grole
{
   import flash.display.MovieClip;
   import hotpointgame.common.*;
   import hotpointgame.gaction.CAction;
   
   public class PlayerDo
   {
      
      protected var _curAction:CAction;
      
      protected var _currentState:VT = VT.createVT(0);
      
      public function PlayerDo()
      {
         super();
      }
      
      public function remove() : void
      {
      }
      
      public function gmUpdate(param1:CPlayer) : void
      {
      }
      
      public function typeShowAndH(param1:int, param2:Boolean) : void
      {
      }
      
      public function reEnter(param1:CPlayer) : void
      {
      }
      
      public function addHitFlashEMc(param1:MovieClip) : void
      {
      }
      
      public function changeByEquipSlot(param1:int, param2:String) : void
      {
      }
      
      public function baseToMap(param1:String) : void
      {
      }
      
      public function mapToBase() : void
      {
      }
      
      public function mapToMap(param1:String) : void
      {
      }
      
      public function lostMapWeapon() : void
      {
      }
      
      public function playerStop() : void
      {
      }
      
      public function playerStopByJiJia() : void
      {
      }
      
      public function playerContinue() : void
      {
      }
      
      public function playerStateFull(param1:CPlayer) : void
      {
      }
      
      public function addJJAnger(param1:CPlayer, param2:Number) : void
      {
      }
      
      public function getByhit() : MovieClip
      {
         return null;
      }
      
      public function getPlayerMc() : MovieClip
      {
         return null;
      }
      
      public function gotoAndStopFrame(param1:Object) : void
      {
      }
      
      public function gotoAndPlayFrame(param1:Object) : void
      {
      }
      
      public function getCurrentFrameNum() : int
      {
         return 0;
      }
      
      public function getFrameLabel() : String
      {
         return "";
      }
      
      public function getAhit() : MovieClip
      {
         return null;
      }
      
      public function setForth(param1:int) : void
      {
      }
      
      public function addBufferMc(param1:MovieClip) : void
      {
      }
      
      public function removeBufferMc(param1:MovieClip) : void
      {
      }
      
      public function getBullet(param1:String, param2:String) : MovieClip
      {
         return null;
      }
      
      public function getAllBulletByClass(param1:String, param2:Class) : Array
      {
         return null;
      }
      
      public function getXiaZhiMc(param1:String) : MovieClip
      {
         return null;
      }
      
      public function getx() : Number
      {
         return 0;
      }
      
      public function setx(param1:Number) : void
      {
      }
      
      public function gety() : Number
      {
         return 0;
      }
      
      public function sety(param1:Number) : void
      {
      }
      
      public function get curAction() : CAction
      {
         return this._curAction;
      }
      
      public function set curAction(param1:CAction) : void
      {
         this._curAction = param1;
      }
      
      public function get currentState() : int
      {
         return this._currentState.getValue();
      }
      
      public function set currentState(param1:int) : void
      {
         this._currentState.setValue(param1);
      }
   }
}

