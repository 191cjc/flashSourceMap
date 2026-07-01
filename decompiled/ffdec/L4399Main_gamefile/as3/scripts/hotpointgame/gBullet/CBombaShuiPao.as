package hotpointgame.gBullet
{
   import flash.display.MovieClip;
   import hotpointgame.gameobj.ZhangDouT;
   
   public class CBombaShuiPao extends CBomba
   {
      
      private var hitEnemy:Array = [];
      
      private var shuiPaoNum:int = 0;
      
      public function CBombaShuiPao(param1:MovieClip, param2:ZhangDouT, param3:Object, param4:int = 0)
      {
         super(param1,param2,param3,param4);
      }
      
      override protected function dataInit(param1:Object) : void
      {
         this.shuiPaoNum = param1.others.shuiPaoNum;
         super.dataInit(param1);
      }
      
      override protected function bombaAttack(param1:Vector.<ZhangDouT>) : void
      {
         var _loc2_:ZhangDouT = null;
         for each(_loc2_ in param1)
         {
            if(this.hitEnemy.indexOf(_loc2_) == -1)
            {
               if(_loc2_.bhitByObject(getAhit(),fda,this) != -1)
               {
                  this.hitEnemy[this.hitEnemy.length] = _loc2_;
                  _loc2_.bhitXianZhi(4,this.shuiPaoNum);
               }
            }
         }
      }
      
      override public function remove() : void
      {
         this.hitEnemy.length = 0;
         super.remove();
      }
   }
}

