package hotpointgame.gaction
{
   import hotpointgame.gameobj.ZhangDouT;
   import hotpointgame.gameobj.ZtC;
   
   public class CAZiBao extends CAction
   {
      
      private var ls:int;
      
      private var lsspeed:int;
      
      private var jieduan:int = 0;
      
      private var lsjs:int = 0;
      
      public function CAZiBao(param1:String)
      {
         super(param1);
      }
      
      override public function setData(param1:Object) : void
      {
         this.ls = param1.others.ls;
         this.lsspeed = param1.others.lsspeed;
         super.setData(param1);
      }
      
      override protected function actionStateUpdate(param1:ZtC) : Boolean
      {
         if(this.jieduan == 0 && param1.getCurrentFrameNum() == 135)
         {
            this.jieduan = 1;
            param1.gotoAndStopFrame(135);
         }
         if(this.jieduan == 1)
         {
            ++this.lsjs;
            if(this.lsjs > this.ls)
            {
               this.jieduan = 3;
               param1.gotoAndPlayFrame(144);
            }
         }
         if(this.jieduan == 2)
         {
            this.jieduan = 3;
            param1.gotoAndPlayFrame(144);
         }
         if(param1.getCurrentFrameNum() == 155)
         {
            param1.gotoAndStopFrame(155);
            param1.redHp(1000000,0,false);
            return true;
         }
         return false;
      }
      
      override public function attack(param1:ZtC, param2:Vector.<ZhangDouT>) : void
      {
         var _loc3_:ZhangDouT = null;
         var _loc4_:ZhangDouT = null;
         if(this.jieduan == 1)
         {
            for each(_loc3_ in param2)
            {
               if(_loc3_.bhitTestByObject(param1.getAhit()))
               {
                  this.jieduan = 2;
                  return;
               }
            }
            if(param2.length > 0)
            {
               if(param1.getZx() >= param2[0].getZx())
               {
                  param1.setForth(-1);
               }
               else
               {
                  param1.setForth(1);
               }
            }
         }
         if(this.jieduan == 3)
         {
            for each(_loc4_ in param2)
            {
               if(hitEnemy.indexOf(_loc4_) == -1)
               {
                  if(_loc4_.bhitByObject(param1.getAhit(),fda,param1) != -1)
                  {
                     hitEnemy[hitEnemy.length] = _loc4_;
                  }
               }
            }
         }
      }
      
      override public function getRunArr(param1:ZtC) : Array
      {
         if(this.jieduan == 1)
         {
            return [this.lsspeed * param1.forth,0];
         }
         return [0,0];
      }
      
      override public function exit() : void
      {
         this.jieduan = 0;
         this.lsjs = 0;
         super.exit();
      }
   }
}

