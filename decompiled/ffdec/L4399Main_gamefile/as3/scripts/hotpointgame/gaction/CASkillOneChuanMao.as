package hotpointgame.gaction
{
   import hotpointgame.common.*;
   import hotpointgame.gMonster.*;
   import hotpointgame.gameobj.ZtC;
   
   public class CASkillOneChuanMao extends CASkillOne
   {
      
      private var curframState:int = 0;
      
      private var hpjishi:int = 0;
      
      private var mxyArr:Array = [[-571,0],[-395,0],[-205,0],[201,0],[400,0]];
      
      private var hforstart:int;
      
      private var hforstop:int;
      
      private var hforfnum:int;
      
      private var hforhphi:int;
      
      private var hforhpper:Number;
      
      private var zhaohuanObj:Object;
      
      private var chuanmaoArr:Vector.<CMonster> = new Vector.<CMonster>();
      
      public function CASkillOneChuanMao(param1:String)
      {
         super(param1);
      }
      
      override public function setData(param1:Object) : void
      {
         this.hforstart = param1.others.hstart;
         this.hforstop = param1.others.hstop;
         this.hforfnum = param1.others.ht;
         this.hforhphi = param1.others.hti;
         this.hforhpper = param1.others.hhp;
         this.zhaohuanObj = param1.others.zo;
         super.setData(param1);
      }
      
      override protected function actionStateUpdate(param1:ZtC) : Boolean
      {
         var _loc2_:Array = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Boolean = false;
         var _loc6_:* = 0;
         var _loc7_:CMonster = null;
         if(this.curframState == 0)
         {
            if(param1.getCurrentFrameNum() == this.hforstart)
            {
               _loc2_ = this.zhaohuanObj as Array;
               _loc3_ = 0;
               while(_loc3_ < _loc2_.length)
               {
                  this.chuanmaoArr.push(MonsterManager.creatMonster(_loc2_[_loc3_],param1.getZx() + this.mxyArr[_loc3_][0] * (-1 * param1.getXforth()),param1.getZy() + this.mxyArr[_loc3_][1]));
                  _loc3_++;
               }
               hitEnemy.length = 0;
               this.curframState = GS.a1;
            }
            return false;
         }
         if(this.curframState == GS.a1)
         {
            if(this.hpjishi % this.hforhphi == 0)
            {
               param1.addHpByPerc(this.hforhpper);
            }
            ++this.hpjishi;
            if(param1.getCurrentFrameNum() == this.hforstop)
            {
               param1.gotoAndPlayFrame(this.hforstart);
            }
            _loc4_ = int(this.chuanmaoArr.length);
            _loc5_ = false;
            _loc6_ = int(_loc4_ - 1);
            while(_loc6_ >= 0)
            {
               if(!this.chuanmaoArr[_loc6_].isLive())
               {
                  _loc5_ = true;
                  break;
               }
               _loc6_--;
            }
            if(_loc5_)
            {
               for each(_loc7_ in this.chuanmaoArr)
               {
                  _loc7_.killMe();
               }
               this.chuanmaoArr.length = 0;
            }
            if(this.hpjishi >= this.hforfnum || this.chuanmaoArr.length == 0)
            {
               this.curframState = GS.a2;
               param1.gotoAndPlayFrame(this.hforstop + 1);
            }
            return false;
         }
         if(param1.getFrameLabel() != flaFrameName)
         {
            return true;
         }
         return false;
      }
      
      override public function exit() : void
      {
         var _loc1_:CMonster = null;
         this.curframState = 0;
         this.hpjishi = 0;
         for each(_loc1_ in this.chuanmaoArr)
         {
            _loc1_.killMe();
         }
         this.chuanmaoArr.length = 0;
         super.exit();
      }
   }
}

