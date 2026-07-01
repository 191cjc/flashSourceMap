package hotpointgame.gameobj
{
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.geom.Point;
   import hotpointgame.common.*;
   import hotpointgame.utils.*;
   import hotpointgame.utils.gsound.*;
   
   public class ZShiTou extends ZdtDF
   {
      
      protected var dfmc:MovieClip;
      
      protected var _currentState:VT = VT.createVT(0);
      
      protected var _hitnumMax:VT = VT.createVT(10);
      
      public function ZShiTou(param1:MovieClip, param2:Number, param3:Number, param4:Object)
      {
         super();
         this.dfmc = param1;
         this.dfmc.x = param2;
         this.dfmc.y = param3;
         this.dfmc.gotoAndStop(1);
         this.hitnumMax = (param4.hurtnum as VT).getValue();
      }
      
      override public function gmUpdate(param1:Vector.<ZhangDouT>) : int
      {
         if(this.currentState == 0)
         {
            if(this.hitnumMax < 0)
            {
               this.changestatueOne();
            }
         }
         if(this.currentState == GS.a1)
         {
            if(this.dfmc.currentLabel != "爆炸")
            {
               this.changestatueTwo();
            }
         }
         return this.currentState;
      }
      
      override public function remove() : void
      {
         if(this.dfmc.parent)
         {
            this.dfmc.parent.removeChild(this.dfmc);
         }
         this.dfmc = null;
      }
      
      public function moveHitTest(param1:Number, param2:Number) : Boolean
      {
         return this.getHitMove().hitTestPoint(param1,param2,true);
      }
      
      private function changestatueOne() : void
      {
         this.currentState = GS.a1;
         this.dfmc.gotoAndPlay("爆炸");
      }
      
      private function changestatueTwo() : void
      {
         this.currentState = GS.a2;
         this.dfmc.gotoAndStop(this.dfmc.totalFrames);
      }
      
      private function getHitRangle() : MovieClip
      {
         return this.dfmc["mbyhit"];
      }
      
      private function getHitMove() : MovieClip
      {
         return this.dfmc["mhtest"];
      }
      
      override public function bhitTestByPoint(param1:Number, param2:Number) : Boolean
      {
         return this.getHitRangle().hitTestPoint(param1,param2,true);
      }
      
      override public function bhitTestByObject(param1:DisplayObject) : Boolean
      {
         return param1.hitTestObject(this.getHitRangle());
      }
      
      override public function bhitTestByObjectAndPoint(param1:DisplayObject) : Boolean
      {
         var _loc2_:Point = Pos.l_To_G(this.dfmc);
         if(param1.hitTestPoint(_loc2_.x,_loc2_.y,true))
         {
            return true;
         }
         if(param1.hitTestPoint(_loc2_.x,_loc2_.y - this.dfmc.height,true))
         {
            return true;
         }
         return false;
      }
      
      override public function bhitByObjectAndPoint(param1:DisplayObject, param2:FightData, param3:ZhangDouT) : int
      {
         if(this.bhitTestByObjectAndPoint(param1))
         {
            if(param2.hitsound != "null")
            {
               SoundManager.addOnlySound(param2.hitsound);
            }
            return this.bhit(param2,param3);
         }
         return -1;
      }
      
      override public function bhitByPoint(param1:Number, param2:Number, param3:FightData, param4:ZhangDouT) : int
      {
         if(this.bhitTestByPoint(param1,param2))
         {
            if(param3.hitsound != "null")
            {
               SoundManager.addOnlySound(param3.hitsound);
            }
            return this.bhit(param3,param4);
         }
         return -1;
      }
      
      override public function bhitByObject(param1:DisplayObject, param2:FightData, param3:ZhangDouT) : int
      {
         if(this.bhitTestByObject(param1))
         {
            if(param2.hitsound != "null")
            {
               SoundManager.addOnlySound(param2.hitsound);
            }
            return this.bhit(param2,param3);
         }
         return -1;
      }
      
      override public function bhit(param1:FightData, param2:ZhangDouT) : int
      {
         --this.hitnumMax;
         return 0;
      }
      
      override public function getZmc() : MovieClip
      {
         return this.dfmc;
      }
      
      override public function getZx() : Number
      {
         return this.dfmc.x;
      }
      
      override public function getZy() : Number
      {
         return this.dfmc.y;
      }
      
      public function get currentState() : int
      {
         return this._currentState.getValue();
      }
      
      public function set currentState(param1:int) : void
      {
         this._currentState.setValue(param1);
      }
      
      public function get hitnumMax() : int
      {
         return this._hitnumMax.getValue();
      }
      
      public function set hitnumMax(param1:int) : void
      {
         this._hitnumMax.setValue(param1);
      }
   }
}

