package hotpointgame.gMonster
{
   import flash.display.MovieClip;
   
   public class CMonsterZhaoHuang extends CMonsterZhaoHuangByHit
   {
      
      public function CMonsterZhaoHuang(param1:MovieClip, param2:Number, param3:Number, param4:Object)
      {
         super(param1,param2,param3,param4);
      }
      
      override public function buNengBeida() : Boolean
      {
         if(xiaoDe.length > 0)
         {
            return true;
         }
         return super.buNengBeida();
      }
   }
}

