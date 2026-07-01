package hotpointgame.glevel
{
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   import hotpointgame.gMonster.*;
   
   public class CLSMP
   {
      
      protected var mstart:int = 2;
      
      protected var mstop:int = 2;
      
      protected var tnum:int = 2;
      
      protected var ml:Array = new Array();
      
      private var _cishu:VT = VT.createVT(0);
      
      protected var curstate:int = 0;
      
      protected var jishi:int = 0;
      
      public function CLSMP(param1:Object)
      {
         super();
         this.mstart = param1.mx;
         this.tnum = param1.tn;
         this.mstop = param1.mp;
         this.cishu = param1.cishu;
         this.ml = param1.ml;
      }
      
      public function gmUpdate() : Boolean
      {
         if(this.cishu <= 0)
         {
            return true;
         }
         if(this.curstate == 0)
         {
            if(GM.levelm.getMonsterNum() <= this.mstart)
            {
               this.curstate = 1;
               this.jishi = GM.frameTime;
            }
         }
         if(this.curstate == 1)
         {
            if(GM.frameTime - this.jishi > this.tnum)
            {
               this.curstate = 2;
            }
         }
         if(this.curstate == 2)
         {
            if(GM.levelm.getMonsterNum() <= this.mstop)
            {
               --this.cishu;
               this.shuamonst();
               this.curstate = 0;
               if(this.cishu <= 0)
               {
                  return true;
               }
            }
         }
         return false;
      }
      
      public function shuamonst() : void
      {
         var _loc1_:Object = null;
         var _loc2_:Array = null;
         for each(_loc1_ in this.ml)
         {
            _loc2_ = _loc1_.p;
            if(GM.levelm.curLevel.id >= GS.a980 && GM.levelm.curLevel.id <= GS.a998)
            {
               MonsterManager.creatMonsterByRoleA(_loc1_.m,_loc2_[0] + Math.random() * _loc2_[2],_loc2_[1] + Math.random() * _loc2_[3]);
            }
            else if(GM.levelm.curLevel.id >= GS.a1000 && GM.levelm.curLevel.id <= GS.a1000 * GS.a2)
            {
               MonsterManager.creatMonsterByRoleA(_loc1_.m,_loc2_[0] + Math.random() * _loc2_[2],_loc2_[1] + Math.random() * _loc2_[3]);
            }
            else if(GM.levelm.curLevel.id >= GS.a3000 && GM.levelm.curLevel.id <= GS.a3000 + GS.a100)
            {
               MonsterManager.creatMonsterByFuBen(_loc1_.m,_loc2_[0] + Math.random() * _loc2_[2],_loc2_[1] + Math.random() * _loc2_[3],GM.levelm.curLevel.id);
            }
            else if(GM.levelm.curLevel.id >= GS.a100 && GM.levelm.curLevel.id <= GS.a200)
            {
               MonsterManager.creatMonsterBy100Add(_loc1_.m,_loc2_[0] + Math.random() * _loc2_[2],_loc2_[1] + Math.random() * _loc2_[3],GM.levelm.curLevel.id);
            }
            else if(GM.levelm.curLevel.id > GS.a4000 && GM.levelm.curLevel.id <= GS.a4000 + GS.a7)
            {
               MonsterManager.creatMonsterBy100Add(_loc1_.m,_loc2_[0] + Math.random() * _loc2_[2],_loc2_[1] + Math.random() * _loc2_[3],GM.levelm.curLevel.id);
            }
            else
            {
               MonsterManager.creatMonster(_loc1_.m,_loc2_[0] + Math.random() * _loc2_[2],_loc2_[1] + Math.random() * _loc2_[3]);
            }
         }
      }
      
      public function remove() : void
      {
         this._cishu = null;
         this.ml = null;
      }
      
      public function get cishu() : int
      {
         return this._cishu.getValue();
      }
      
      public function set cishu(param1:int) : void
      {
         this._cishu.setValue(param1);
      }
   }
}

