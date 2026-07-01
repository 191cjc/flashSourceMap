package hotpointgame.gMonster
{
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import hotpointgame.Control.*;
   import hotpointgame.gameobj.FightData;
   import hotpointgame.gameobj.ZhangDouT;
   import hotpointgame.utils.gsound.*;
   
   public class CMonsterBianFu extends CMonster
   {
      
      public function CMonsterBianFu(param1:MovieClip, param2:Number, param3:Number, param4:Object)
      {
         super(param1,param2,param3,param4);
      }
      
      override public function bhitTestByPoint(param1:Number, param2:Number) : Boolean
      {
         if(buNengBeida())
         {
            return false;
         }
         if(_vm.getMc("mbyhit").hitTestPoint(param1,param2,true))
         {
            return true;
         }
         if(_vm.getMc("mbyhitb").hitTestPoint(param1,param2,true))
         {
            return true;
         }
         return false;
      }
      
      override public function bhitTestByObject(param1:DisplayObject) : Boolean
      {
         if(buNengBeida())
         {
            return false;
         }
         if(param1.hitTestObject(_vm.getMc("mbyhit")))
         {
            return true;
         }
         if(param1.hitTestObject(_vm.getMc("mbyhitb")))
         {
            return true;
         }
         return false;
      }
      
      override public function bhitByPoint(param1:Number, param2:Number, param3:FightData, param4:ZhangDouT) : int
      {
         var _loc5_:int = -1;
         if(_vm.getMc("mbyhit").hitTestPoint(param1,param2,true))
         {
            GM.levelm.curLevel.addLianJIShu();
            GM.cp.addJJAnger(param3.jiJiaAng);
            if(param3.hitsound != "null")
            {
               SoundManager.addOnlySound(param3.hitsound);
            }
            addFlashE(param3.hitFlahE);
            _loc5_ += bhit(param3,param4);
         }
         if(_vm.getMc("mbyhitb").hitTestPoint(param1,param2,true))
         {
            GM.levelm.curLevel.addLianJIShu();
            GM.cp.addJJAnger(param3.jiJiaAng);
            if(param3.hitsound != "null")
            {
               SoundManager.addOnlySound(param3.hitsound);
            }
            addFlashE(param3.hitFlahE);
            _loc5_ += bhit(param3,param4);
         }
         return _loc5_;
      }
      
      override public function bhitByObject(param1:DisplayObject, param2:FightData, param3:ZhangDouT) : int
      {
         var _loc4_:int = -1;
         if(param1.hitTestObject(_vm.getMc("mbyhit")))
         {
            GM.levelm.curLevel.addLianJIShu();
            GM.cp.addJJAnger(param2.jiJiaAng);
            if(param2.hitsound != "null")
            {
               SoundManager.addOnlySound(param2.hitsound);
            }
            addFlashE(param2.hitFlahE);
            _loc4_ += bhit(param2,param3);
         }
         if(param1.hitTestObject(_vm.getMc("mbyhitb")))
         {
            GM.levelm.curLevel.addLianJIShu();
            GM.cp.addJJAnger(param2.jiJiaAng);
            if(param2.hitsound != "null")
            {
               SoundManager.addOnlySound(param2.hitsound);
            }
            addFlashE(param2.hitFlahE);
            _loc4_ += bhit(param2,param3);
         }
         return _loc4_;
      }
      
      private function bhitbf(param1:FightData, param2:ZhangDouT) : int
      {
         return 0;
      }
   }
}

