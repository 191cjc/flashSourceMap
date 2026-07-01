package hotpointgame.Control
{
   import hotpointgame.common.*;
   import hotpointgame.datapk.PkKaiZong;
   import hotpointgame.glevel.*;
   import hotpointgame.gview.*;
   import hotpointgame.models.bag.*;
   import hotpointgame.models.goods.Goods;
   import hotpointgame.repository.goods.*;
   import hotpointgame.repository.goodsSkill.*;
   import hotpointgame.views.geneChangePanel.*;
   import hotpointgame.views.playerPanel.*;
   import hotpointgame.views.shopPanel.*;
   import hotpointgame.views.taskPanel.*;
   import hotpointgame.views.vipPanel.*;
   
   public class FlowInterface
   {
      
      public function FlowInterface()
      {
         super();
      }
      
      public static function isGkOk(param1:String) : void
      {
         TaskData.isGkOk(param1);
      }
      
      public static function getNewShop() : Boolean
      {
         return ShopData.getNewShop();
      }
      
      public static function npcTaskOpen() : void
      {
         NpcTaskPanel.open(0);
      }
      
      public static function isTaskOk() : void
      {
         TaskData.isTaskOk();
      }
      
      public static function isXtOk(param1:Number) : void
      {
         TaskData.isXtOk(param1);
      }
      
      public static function isEnemyOk(param1:String) : void
      {
         TaskData.isEnemyOk(param1);
      }
      
      public static function changeByEquipSlot(param1:int, param2:int, param3:String) : void
      {
         GM.cp.changeByEquipSlot(param1,param2,param3);
      }
      
      public static function isTaskIngById(param1:Number) : Boolean
      {
         return TaskData.isTaskIngById(param1);
      }
      
      public static function skillBookIsOk(param1:int) : Boolean
      {
         return GM.skillLvM.keyXueXiWxByJD(param1);
      }
      
      public static function useSkillBook(param1:int, param2:int) : void
      {
         GM.skillLvM.useSkillBook(param1,param2);
      }
      
      public static function useSkillBookByClear(param1:int) : Boolean
      {
         return GM.skillLvM.useSkillBookRester(param1);
      }
      
      public static function isXg() : Boolean
      {
         return BagFactory.isXg();
      }
      
      public static function findCheat(param1:Number) : void
      {
         GM.findCheatMax(param1);
      }
      
      public static function saveDataByKai(param1:Function = null) : void
      {
         GM.testapi.saveDataBefore(param1);
      }
      
      public static function saveDataByKaiOnlyShop(param1:Function = null) : void
      {
         GM.testapi.saveDataBeforeNoState(param1);
      }
      
      public static function djGouMai(param1:Number, param2:Number, param3:Number, param4:Function, param5:Number) : void
      {
         GM.testapi.getStateAndBuyShopProp(param1,param2,param3,param4,param5);
      }
      
      public static function gamePause() : void
      {
         Main.sg.frameRate = 0;
      }
      
      public static function gameContinue() : void
      {
         Main.sg.frameRate = 30;
      }
      
      public static function openSkillUp() : void
      {
         SkillGoUpC.open();
      }
      
      public static function getLevelName() : Array
      {
         return GM.levelm.getLevelName();
      }
      
      public static function isOverLevel(param1:String) : Boolean
      {
         var _loc2_:int = int(LevelDataManager.getLidByName(param1));
         var _loc3_:int = int(GM.levelSD.getOverProcess(_loc2_));
         if(_loc3_ == -1)
         {
            return false;
         }
         return true;
      }
      
      public static function getHpByRole() : Number
      {
         return GM.cp.getHpByRoleLevel();
      }
      
      public static function getNlByRole() : Number
      {
         return GM.cp.getMpByRoleLevel();
      }
      
      public static function getAttByRole() : Number
      {
         return GM.cp.getAttByRoleLevel();
      }
      
      public static function getFyByRole() : Number
      {
         return GM.cp.getDfByRoleLevel();
      }
      
      public static function getBjByRole() : Number
      {
         return GM.cp.getBjByRoleLevel();
      }
      
      public static function getSpByRole() : Number
      {
         return GM.cp.getSpeedByRoleLevel();
      }
      
      public static function getJobByRole() : Number
      {
         if(GM.testapi.jobFlag != GS.a1 && GM.testapi.jobFlag != GS.a2)
         {
            GM.aSaveData.checkfm.addFlagB(GS.a7,GM.testapi.jobFlag,0);
         }
         return GM.testapi.jobFlag;
      }
      
      public static function getJobxx() : String
      {
         if(getJobByRole() == 1)
         {
            return "绝影枪手";
         }
         if(getJobByRole() == 2)
         {
            return "炎蓝炮手";
         }
         return "";
      }
      
      public static function getLevelByRole() : Number
      {
         return GM.cp.getZtLevel();
      }
      
      public static function getExpByRole() : Number
      {
         return GM.cp.getExpByRoleLevel();
      }
      
      public static function getCurExpByRole() : Number
      {
         return GM.cp.getCurExpByRole();
      }
      
      public static function addExpByRole(param1:int) : void
      {
         GM.cp.addExp(param1);
      }
      
      public static function getGodByRole() : Number
      {
         return GM.cp.getGodByRole();
      }
      
      public static function getMaxGodByLevel() : Number
      {
         return GM.cp.getMaxGodByLevel();
      }
      
      public static function addGodByRole(param1:int) : void
      {
         GM.cp.addGodByRole(param1);
      }
      
      public static function redGodByRole(param1:int) : void
      {
         GM.cp.redGodByRole(param1);
      }
      
      public static function getDianJuanByRole() : Number
      {
         return GameShangChengC.self.dgMoney;
      }
      
      public static function redDianJuan(param1:int) : void
      {
         if(param1 > 0)
         {
            GameShangChengC.self.dgMoney -= param1;
            if(GameShangChengC.self.dgMoney < 0)
            {
               GameShangChengC.self.dgMoney = 0;
            }
         }
      }
      
      public static function redDianJuanByRole(param1:int) : void
      {
      }
      
      public static function openPlayerBag() : void
      {
         PlayerBagPanel.open();
      }
      
      public static function openPlayerTask() : void
      {
         PlayerTaskPanel.open();
      }
      
      public static function openShopJie() : void
      {
         NpcTaskPanel.open(2);
      }
      
      public static function openDevoJie() : void
      {
         NpcTaskPanel.open(1);
      }
      
      public static function openSkillJie() : void
      {
         NpcTaskPanel.open(3);
      }
      
      public static function npcGoto(param1:Number) : Number
      {
         return TaskData.getNpcNum(param1);
      }
      
      public static function save() : Object
      {
         return GoodsManger.save();
      }
      
      public static function readData(param1:Object = null) : void
      {
         GoodsManger.read(param1);
      }
      
      public static function exitGame() : void
      {
         GoodsManger.close();
      }
      
      public static function addInBagDL(param1:Goods, param2:Number) : Boolean
      {
         return BagFactory.addInBagDL(param1,param2);
      }
      
      public static function redInBagDL(param1:int, param2:int) : Boolean
      {
         return BagFactory.deteleGoods(param1,param2);
      }
      
      public static function isFullByIdandnum(param1:Goods, param2:int) : Boolean
      {
         return BagFactory.isFullBagOnlyOne(param1,param2);
      }
      
      public static function isKeYiFangById(param1:int, param2:int) : Boolean
      {
         return BagFactory.isFullById(param1,param2);
      }
      
      public static function createGoodsByCreateLevel(param1:Number) : Goods
      {
         return GoodsFactory.createGoodsByCreateLevel(param1);
      }
      
      public static function getSkillList() : Array
      {
         return BagFactory.equipSlot.getSkillList();
      }
      
      public static function getGoodsSkillById(param1:Number) : GoodsSkillData
      {
         return GoodsSkillFactory.getSkillDataById(param1);
      }
      
      public static function getHp(param1:Number = 0) : Number
      {
         return BagFactory.equipSlot.getHp(param1);
      }
      
      public static function getNl(param1:Number = 0) : Number
      {
         return BagFactory.equipSlot.getNl(param1);
      }
      
      public static function getAtt(param1:Number = 0) : Number
      {
         return BagFactory.equipSlot.getAtt(param1);
      }
      
      public static function getFy(param1:Number = 0) : Number
      {
         return BagFactory.equipSlot.getFy(param1);
      }
      
      public static function getBj() : Number
      {
         return BagFactory.equipSlot.getBj();
      }
      
      public static function getSp() : Number
      {
         return BagFactory.equipSlot.getSp();
      }
      
      public static function getJin() : Number
      {
         return BagFactory.equipSlot.getJin();
      }
      
      public static function getMu() : Number
      {
         return BagFactory.equipSlot.getMu();
      }
      
      public static function getShui() : Number
      {
         return BagFactory.equipSlot.getShui();
      }
      
      public static function getHuo() : Number
      {
         return BagFactory.equipSlot.getHuo();
      }
      
      public static function getTu() : Number
      {
         return BagFactory.equipSlot.getTu();
      }
      
      public static function getHd() : Number
      {
         return BagFactory.equipSlot.getHd();
      }
      
      public static function getEquipMcName(param1:int) : String
      {
         return BagFactory.getEquipMcName(param1);
      }
      
      public static function getEquipTuBiaoFrame(param1:int) : int
      {
         return BagFactory.getEquipMcFrame(param1);
      }
      
      public static function getEquipSlotId() : Array
      {
         return BagFactory.getEquipSlotId();
      }
      
      public static function getGoodsById(param1:int) : Goods
      {
         return GoodsFactory.createGoodsById(param1);
      }
      
      public static function getCurrTimer() : Number
      {
         return GM.serverDateC.getCurrentGameTime();
      }
      
      public static function getGoodsBaseDataById(param1:int) : GoodsData
      {
         return GoodsFactory.getGoodsById(param1);
      }
      
      public static function gotoShopPanel() : void
      {
         GM.testapi.gameChongMoney(GS.a100);
      }
      
      public static function getRoleState() : Number
      {
         if(GM.cp == null)
         {
            return GS.a0;
         }
         return GM.cp.getCplayerJiJIaState();
      }
      
      public static function jsSx() : void
      {
         BagFactory.equipSlot.jsSx(VipData.vip.getValue(),GoodsManger.dataList.uVipData.getVip());
      }
      
      public static function getGeneBo() : Boolean
      {
         return GeneData.tsBo;
      }
      
      public static function getYcArr() : Array
      {
         return BagFactory.equipSlot.getYcArr();
      }
      
      public static function showAndHSzType(param1:int, param2:Boolean) : void
      {
         GM.cp.typeShowAndH(param1,param2);
      }
      
      public static function countValueBysave(param1:Object) : PkKaiZong
      {
         return GoodsManger.getPkData(param1);
      }
      
      public static function getLxTime() : Number
      {
         return GM.testapi.leafLineTime;
      }
   }
}

