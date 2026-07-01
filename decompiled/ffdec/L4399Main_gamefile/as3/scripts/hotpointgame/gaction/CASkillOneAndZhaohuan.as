package hotpointgame.gaction
{
   import hotpointgame.gMonster.*;
   import hotpointgame.gameobj.ZhangDouT;
   import hotpointgame.gameobj.ZtC;
   
   public class CASkillOneAndZhaohuan extends CAction
   {
      
      private var hitFrame:Array;
      
      private var zhaohuanObj:Object;
      
      private var zhflag:int = 0;
      
      public function CASkillOneAndZhaohuan(param1:String)
      {
         super(param1);
      }
      
      override public function setData(param1:Object) : void
      {
         this.zhaohuanObj = param1.others.zo;
         this.hitFrame = param1.others.hf;
         super.setData(param1);
      }
      
      override public function attack(param1:ZtC, param2:Vector.<ZhangDouT>) : void
      {
         var _loc3_:ZhangDouT = null;
         var _loc4_:Array = null;
         var _loc5_:String = null;
         if(currentFrameNum >= this.hitFrame[0] && currentFrameNum <= this.hitFrame[1])
         {
            for each(_loc3_ in param2)
            {
               if(hitEnemy.indexOf(_loc3_) == -1)
               {
                  if(_loc3_.bhitByObject(param1.getAhit(),fda,param1) != -1)
                  {
                     if(this.zhflag == 0)
                     {
                        _loc4_ = this.zhaohuanObj as Array;
                        for each(_loc5_ in _loc4_)
                        {
                           (param1 as CMonsterZhaoHuangByHit).addXiaoDe(MonsterManager.creatMonster(_loc5_,_loc3_.getZx(),_loc3_.getZy()));
                        }
                        this.zhflag = 8;
                     }
                     hitEnemy[hitEnemy.length] = _loc3_;
                  }
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
      
      override public function exit() : void
      {
         this.zhflag = 0;
         super.exit();
      }
   }
}

