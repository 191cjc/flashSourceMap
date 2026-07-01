package hotpointgame.gaction
{
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   import hotpointgame.gMonster.*;
   import hotpointgame.gameobj.ZtC;
   
   public class CActionZhaohuan extends CAction
   {
      
      private var zhaohuanObj:Object;
      
      public function CActionZhaohuan(param1:String)
      {
         super(param1);
      }
      
      override public function setData(param1:Object) : void
      {
         this.zhaohuanObj = param1.others.zo;
         super.setData(param1);
      }
      
      override protected function beforeByBullet(param1:ZtC) : void
      {
         var _loc2_:Array = null;
         var _loc3_:String = null;
         if(this.zhaohuanObj[currentFrameNum])
         {
            _loc2_ = this.zhaohuanObj[currentFrameNum];
            for each(_loc3_ in _loc2_)
            {
               if(GM.levelm.curLevel.id == GS.a1000 + GS.a11)
               {
                  (param1 as CMonsterZhaoHuangByHit).addXiaoDe(MonsterManager.creatMonsterBy1011Zhaohuan(_loc3_,param1.getZx() + Math.random() * 100 * param1.forth,param1.getZy()));
               }
               else
               {
                  (param1 as CMonsterZhaoHuangByHit).addXiaoDe(MonsterManager.creatMonster(_loc3_,param1.getZx() + Math.random() * 100 * param1.forth,param1.getZy()));
               }
            }
         }
      }
      
      override public function keYiUse(param1:ZtC) : Boolean
      {
         if(!cdisOver())
         {
            return false;
         }
         if((param1 as CMonsterZhaoHuangByHit).xiaoDeNum() > 0)
         {
            return false;
         }
         return true;
      }
   }
}

