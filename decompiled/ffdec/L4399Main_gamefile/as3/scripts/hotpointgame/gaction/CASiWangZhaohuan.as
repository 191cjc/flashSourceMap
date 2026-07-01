package hotpointgame.gaction
{
   import hotpointgame.gMonster.*;
   import hotpointgame.gameobj.ZtC;
   
   public class CASiWangZhaohuan extends CASiWang
   {
      
      private var zhaohuanObj:Object;
      
      public function CASiWangZhaohuan(param1:String)
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
               MonsterManager.creatMonster(_loc3_,param1.getZx(),param1.getZy());
            }
         }
      }
   }
}

