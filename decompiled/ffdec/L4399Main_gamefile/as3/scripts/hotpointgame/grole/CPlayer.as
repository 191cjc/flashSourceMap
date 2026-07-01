package hotpointgame.grole
{
   import flash.display.MovieClip;
   import hotpointgame.common.*;
   import hotpointgame.gameobj.ZtC;
   import hotpointgame.gzhujiemian.GunSlotM;
   import hotpointgame.models.goods.Goods;
   
   public class CPlayer extends ZtC
   {
      
      public var actionObj:Object = {};
      
      public function CPlayer()
      {
         super();
      }
      
      public function gmUpdate() : void
      {
      }
      
      public function skillUp(param1:int, param2:int) : void
      {
      }
      
      public function skillUpByWuXin(param1:int, param2:String, param3:int) : void
      {
      }
      
      public function skillUpWuXinByClear(param1:int) : void
      {
      }
      
      public function acationCdinitByPk() : void
      {
      }
      
      public function changePowerAndForth(param1:int = 0) : void
      {
      }
      
      public function changeForthNotPower(param1:int = 0) : void
      {
      }
      
      public function switchJiJia() : void
      {
      }
      
      public function switchRenr() : void
      {
      }
      
      public function switchRenrBydead() : void
      {
      }
      
      public function getCplayerJiJIaState() : Number
      {
         return 0;
      }
      
      public function changeByEquipSlot(param1:int, param2:int, param3:String) : void
      {
      }
      
      public function pickGun(param1:Goods) : Boolean
      {
         return false;
      }
      
      public function pickGunClip(param1:int) : Boolean
      {
         return false;
      }
      
      public function openNewslot() : void
      {
      }
      
      public function getOpenSlotNum() : int
      {
         return 0;
      }
      
      public function changeLevelClearGun() : void
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
      
      public function playerContinue() : void
      {
      }
      
      public function playerStateFull() : void
      {
      }
      
      public function typeShowAndH(param1:int, param2:Boolean) : void
      {
      }
      
      public function mpUpdateP() : void
      {
      }
      
      public function get gunslot() : GunSlotM
      {
         return null;
      }
      
      public function set gunslot(param1:GunSlotM) : void
      {
      }
      
      public function get mp() : MPlayer
      {
         return null;
      }
      
      public function set mp(param1:MPlayer) : void
      {
      }
      
      public function getCPlayByHit() : MovieClip
      {
         return null;
      }
      
      public function getToMaxLvExp() : uint
      {
         return null;
      }
      
      public function getFightSocre() : Number
      {
         return 0;
      }
      
      public function addJJAnger(param1:Number) : void
      {
      }
      
      public function addJJAngerByGM() : void
      {
      }
      
      public function redJJAnger() : void
      {
      }
      
      public function clearZeroAnger() : void
      {
      }
      
      public function get curjjAnger() : Number
      {
         return 0;
      }
      
      public function set curjjAnger(param1:Number) : void
      {
      }
      
      public function get maxjjAnger() : Number
      {
         return 0;
      }
      
      public function set maxjjAnger(param1:Number) : void
      {
      }
      
      public function get jjAngerFlag() : Number
      {
         return 0;
      }
      
      public function set jjAngerFlag(param1:Number) : void
      {
      }
      
      public function get jijiachangestate() : int
      {
         return 0;
      }
      
      public function set jijiachangestate(param1:int) : void
      {
      }
      
      public function curHpRat() : int
      {
         return 0;
      }
      
      public function getHpByRoleLevel() : Number
      {
         return 0;
      }
      
      public function getMpByRoleLevel() : Number
      {
         return 0;
      }
      
      public function getAttByRoleLevel() : Number
      {
         return 0;
      }
      
      public function getDfByRoleLevel() : Number
      {
         return 0;
      }
      
      public function getBjByRoleLevel() : Number
      {
         return 0;
      }
      
      public function getSpeedByRoleLevel() : Number
      {
         return 0;
      }
      
      public function getExpByRoleLevel() : Number
      {
         return 0;
      }
      
      public function getCurExpByRole() : Number
      {
         return 0;
      }
      
      public function getHpMax() : int
      {
         return 0;
      }
      
      public function getGodByRole() : Number
      {
         return 0;
      }
      
      public function getMaxGodByLevel() : Number
      {
         return 0;
      }
      
      public function addGodByRole(param1:int) : void
      {
      }
      
      public function addGodByRoleByVip(param1:int) : void
      {
      }
      
      public function redGodByRole(param1:int) : void
      {
      }
      
      public function addExp(param1:int) : void
      {
      }
      
      public function addExpByVip(param1:int) : void
      {
      }
      
      public function addMpBfb(param1:Number) : void
      {
         var _loc2_:int = this.mp.mpMax * param1 / GS.a10000;
         addMp(_loc2_);
      }
      
      public function save() : Object
      {
         return null;
      }
      
      public function getJobName() : String
      {
         return null;
      }
      
      public function addMaxHpByPk() : void
      {
      }
      
      public function removeMaxHpByPk() : void
      {
      }
   }
}

