package hotpointgame.glevel
{
   import flash.display.MovieClip;
   import flash.text.*;
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   import hotpointgame.gMonster.*;
   import hotpointgame.gxiaodongxi.*;
   import hotpointgame.utils.gameloader.*;
   import hotpointgame.views.fbPanel.*;
   
   public class CRoomPassWuXin extends CRoomPass
   {
      
      private var timermc:MovieClip;
      
      private var timerflag:Boolean = true;
      
      private var flashBoss:Boolean = true;
      
      private var isflase:Boolean = true;
      
      public function CRoomPassWuXin(param1:Object)
      {
         super(param1);
      }
      
      override public function gmUpdate(param1:CLevel) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:MovieClip = null;
         var _loc5_:Class = null;
         var _loc6_:MovieClip = null;
         var _loc7_:Object = null;
         if(Boolean(this.timerflag) && (GM.frameTime - enterT) % 30 == 0)
         {
            _loc2_ = 90 - (GM.frameTime - enterT) / 30;
            if(_loc2_ >= 0)
            {
               _loc3_ = 0;
               while(_loc2_ > 59)
               {
                  _loc3_++;
                  _loc2_ -= 60;
               }
               if(_loc2_ > 9)
               {
                  (this.timermc.wuxingdaojushia as TextField).text = "" + _loc3_ + ":" + _loc2_;
               }
               else
               {
                  (this.timermc.wuxingdaojushia as TextField).text = "" + _loc3_ + ":0" + _loc2_;
               }
            }
         }
         if(Boolean(this.timerflag) && GM.frameTime - enterT > 300)
         {
            if(GM.levelm.getMonsterNum() == 0)
            {
               this.timerflag = false;
               param1.getvs().removeTimerJiMc();
               this.timermc = null;
               _loc4_ = param1.getvs().getZhongjingMc("shibanqinglong");
               _loc4_.parent.removeChild(_loc4_);
               _loc5_ = LoaderManager.getSwfClass(this.getMcName()) as Class;
               XiaoXiaoManager.addCGX(new CGXEvent(new _loc5_(),GM.einit,this.createLvMonsterWuxin));
            }
         }
         if(Boolean(this.timerflag) && GM.frameTime - enterT == GS.a2710)
         {
            this.timerflag = false;
            param1.getvs().removeTimerJiMc();
            this.timermc = null;
            GM.levelm.clearallMAndB();
            _loc6_ = param1.getvs().getZhongjingMc("shibanqinglong");
            _loc6_.gotoAndPlay(2);
            XiaoXiaoManager.addCGX(new CGXEvent(_loc6_,null,this.createLvMonster));
            _loc7_ = new Object();
            _loc7_.fudu = 6;
            _loc7_.chishu = 30;
            GM.levelm.setShakeMSpeed(_loc7_);
         }
         if(Boolean(this.isflase) && killBossNum > 0)
         {
            this.isflase = false;
            if(GM.levelm.curLevel.id >= GS.a3000 && GM.levelm.curLevel.id <= GS.a3000 + GS.a100)
            {
               FbData.addFbTimes(GM.levelm.curLevel.id);
            }
         }
         super.gmUpdate(param1);
      }
      
      override public function enterRoom(param1:CLevel) : void
      {
         var _loc2_:Class = LoaderManager.getSwfClass("wuxingdaojishi") as Class;
         this.timermc = new _loc2_();
         (this.timermc.wuxingdaojushia as TextField).text = "1:30";
         param1.getvs().addTimerJiMc(this.timermc);
         this.timerflag = true;
         this.flashBoss = true;
         this.isflase = true;
         super.enterRoom(param1);
      }
      
      override public function exitRoom() : void
      {
         if(this.timermc != null)
         {
            if(this.timermc.parent)
            {
               this.timermc.parent.removeChild(this.timermc);
            }
            this.timermc = null;
         }
         this.flashBoss = false;
         super.exitRoom();
      }
      
      override public function exitLevelClear() : void
      {
         if(this.timermc != null)
         {
            if(this.timermc.parent)
            {
               this.timermc.parent.removeChild(this.timermc);
            }
            this.timermc = null;
         }
         this.flashBoss = false;
         super.exitLevelClear();
      }
      
      private function createLvMonsterWuxin() : void
      {
         if(GM.levelm.upstate == GS.a1 && Boolean(this.flashBoss))
         {
            if(GM.levelm.curLevel.id >= GS.a3000 && GM.levelm.curLevel.id <= GS.a3000 + GS.a100)
            {
               MonsterManager.creatMonsterByFuBen("梦魇之境_神农遗迹青龙将军" + name.substr(14,1) + "觉醒",1600,650,GM.levelm.curLevel.id);
            }
            else
            {
               MonsterManager.creatMonster(this.getMonName(),1600,650);
            }
         }
      }
      
      private function createLvMonster() : void
      {
         if(GM.levelm.upstate == GS.a1 && Boolean(this.flashBoss))
         {
            if(GM.levelm.curLevel.id >= GS.a3000 && GM.levelm.curLevel.id <= GS.a3000 + GS.a100)
            {
               MonsterManager.creatMonsterByFuBen("梦魇之境_神农遗迹青龙将军",1600,650,GM.levelm.curLevel.id);
            }
            else
            {
               MonsterManager.creatMonster(this.getLlNmae() + "神农遗迹青龙将军",1600,650);
            }
         }
      }
      
      private function getMcName() : String
      {
         var _loc1_:String = name.substr(10,1);
         if(GM.levelm.curLevel.id >= GS.a3000 && GM.levelm.curLevel.id <= GS.a3000 + GS.a100)
         {
            _loc1_ = name.substr(14,1);
         }
         switch(_loc1_)
         {
            case "金":
               return "qingjinirong";
            case "木":
               return "qingmurong";
            case "水":
               return "qingshuirong";
            case "火":
               return "qinghuoirong";
            case "土":
               return "qingturong";
            default:
               GM.findCheatMax(GS.a26);
               return null;
         }
      }
      
      private function getMonName() : String
      {
         var _loc1_:String = name.substr(10,1);
         var _loc2_:String = "";
         switch(lstar)
         {
            case GS.a1:
               _loc2_ = "";
               break;
            case GS.a2:
               _loc2_ = "普通_";
               break;
            case GS.a3:
               _loc2_ = "困难_";
               break;
            case GS.a4:
               _loc2_ = "噩梦_";
               break;
            default:
               GM.findCheatMax(GS.a25);
         }
         return _loc2_ + "神农遗迹青龙将军" + _loc1_ + "觉醒";
      }
      
      private function getLlNmae() : String
      {
         var _loc1_:String = "";
         switch(lstar)
         {
            case GS.a1:
               _loc1_ = "";
               break;
            case GS.a2:
               _loc1_ = "普通_";
               break;
            case GS.a3:
               _loc1_ = "困难_";
               break;
            case GS.a4:
               _loc1_ = "噩梦_";
               break;
            default:
               GM.findCheatMax(GS.a24);
         }
         return _loc1_;
      }
   }
}

