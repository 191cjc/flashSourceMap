package hotpointgame.gBullet
{
   import flash.display.MovieClip;
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   import hotpointgame.gameobj.*;
   import hotpointgame.utils.*;
   
   public class CBombaKuanBulltButton extends CBombaKuan
   {
      
      private var bulletObj:String;
      
      public function CBombaKuanBulltButton(param1:MovieClip, param2:ZhangDouT, param3:Object, param4:int = 0)
      {
         super(param1,param2,param3,param4);
      }
      
      override protected function dataInit(param1:Object) : void
      {
         this.bulletObj = param1.others.bos;
         super.dataInit(param1);
      }
      
      override protected function beforeUpdate(param1:Vector.<ZhangDouT>) : void
      {
         if(runState == 0)
         {
            if(currentFrameNum > 5)
            {
               if(GM.ckey.isKey("技能6"))
               {
                  runState == GS.a1;
                  this.enterRunStataOne();
               }
            }
         }
      }
      
      override protected function enterRunStataOne() : void
      {
         super.enterRunStataOne();
         var _loc1_:Object = ZtBFactory.getBulletData(this.bulletObj);
         var _loc2_:Class = ClassGet.getClassByNameAndAlias(_loc1_.classname) as Class;
         var _loc3_:ZtB = new _loc2_(getOtherAhit(_loc1_.flaname),fz,_loc1_,_forth) as ZtB;
         GM.levelm.addBullet(_loc3_);
      }
      
      override public function remove() : void
      {
         this.bulletObj = null;
         super.remove();
      }
   }
}

