package hotpointgame.gameobj
{
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.geom.Point;
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   import hotpointgame.gMonster.*;
   import hotpointgame.utils.*;
   import hotpointgame.utils.gsound.*;
   
   public class YbBall extends ZdtDF
   {
      
      protected var dfmc:MovieClip;
      
      protected var _currentState:VT = VT.createVT(0);
      
      protected var attvalue:VT = VT.createVT(0);
      
      protected var xspeed:Number = 0;
      
      private var yspeed:Number = 3;
      
      private var aspeed:Number = 0;
      
      private var speedforth:int = 0;
      
      private var xaddspeed:VT = VT.createVT(GS.a05);
      
      private var ballRadius:VT = VT.createVT(GS.a23);
      
      private var b2pir:VT = VT.createVT(GS.a60 * GS.a6 / (GS.a2 * Math.PI * this.ballRadius.getValue()));
      
      protected var _skyType:int = 0;
      
      protected var hitEnemy:Array = [];
      
      public function YbBall(param1:MovieClip, param2:Number, param3:Number, param4:Number)
      {
         super();
         this.attvalue.setValue(param4);
         this.dfmc = param1;
         this.dfmc.x = param2;
         this.dfmc.y = param3;
         this.dfmc.gotoAndStop(1);
      }
      
      override public function gmUpdate(param1:Vector.<ZhangDouT>) : int
      {
         if(this.currentState == 0)
         {
            if(this.xspeed > 0)
            {
               this.aspeed = this.xspeed * this.b2pir.getValue();
            }
            else
            {
               this.aspeed = 0;
            }
            this.dfmc.rotation += this.aspeed * this.speedforth;
            this.moveAndHit(param1);
         }
         if(this.currentState == GS.a1)
         {
            if(this.dfmc.currentLabel != "爆炸")
            {
               this.changestatueTwo();
            }
            this.attackEnemy(param1);
         }
         return this.currentState;
      }
      
      override public function remove() : void
      {
         this.hitEnemy.length = 0;
         if(this.dfmc.parent)
         {
            this.dfmc.parent.removeChild(this.dfmc);
         }
         this.dfmc = null;
      }
      
      public function attackEnemy(param1:Vector.<ZhangDouT>) : void
      {
         var _loc2_:ZhangDouT = null;
         for each(_loc2_ in param1)
         {
            if(_loc2_ is CMonster && (_loc2_ as CMonster).boostype == GS.a10)
            {
               if(this.hitEnemy.indexOf(_loc2_) == -1)
               {
                  if(_loc2_.bhitTestByObject(this.getHitRangle()))
                  {
                     this.hitEnemy[this.hitEnemy.length] = _loc2_;
                     _loc2_.bhitHp(this.attvalue.getValue() * (GS.a05 + this.xspeed * GS.a01));
                     (_loc2_ as ZtC).bufEffectH(Math.random(),FlowInterface.getGoodsSkillById(GS.a34));
                  }
               }
            }
         }
      }
      
      private function moveAndHit(param1:Vector.<ZhangDouT>) : void
      {
         var _loc4_:Boolean = false;
         var _loc16_:ZhangDouT = null;
         var _loc17_:ZhangDouT = null;
         var _loc18_:Boolean = false;
         var _loc19_:Boolean = false;
         var _loc20_:ZhangDouT = null;
         var _loc2_:int = this.xspeed * this.speedforth;
         if(this._skyType == 1)
         {
            this.yspeed += 1;
         }
         var _loc3_:int = int(this.yspeed);
         if(_loc2_ > 0)
         {
            _loc4_ = true;
         }
         var _loc5_:int = Math.abs(_loc2_);
         var _loc6_:int = Math.abs(_loc3_);
         var _loc7_:Number = Number(GM.levelm.getLx());
         var _loc8_:Number = Number(GM.levelm.getLy());
         var _loc9_:Number = this.dfmc.x + _loc7_;
         var _loc10_:Number = this.dfmc.y + _loc8_;
         var _loc11_:Point = Pos.l_To_G(this.dfmc);
         var _loc12_:Number = _loc11_.x;
         var _loc13_:Number = _loc11_.y;
         var _loc14_:* = _loc5_;
         while(_loc14_ > 0)
         {
            if(_loc4_)
            {
               if(GM.levelm.hitTestByMmonsterX(_loc12_ + this.ballRadius.getValue(),_loc13_,GS.a1))
               {
                  this.changestatueOne();
                  break;
               }
               for each(_loc16_ in param1)
               {
                  if(_loc16_ is CMonster && (_loc16_ as CMonster).boostype == GS.a10)
                  {
                     if(_loc16_.bhitTestByPoint(_loc12_,_loc13_))
                     {
                        this.changestatueOne();
                        return;
                     }
                  }
               }
               _loc9_++;
               _loc12_++;
            }
            else if(!_loc4_)
            {
               if(GM.levelm.hitTestByMmonsterX(_loc12_ - this.ballRadius.getValue(),_loc13_,GS.a1))
               {
                  this.changestatueOne();
                  break;
               }
               for each(_loc17_ in param1)
               {
                  if(_loc17_ is CMonster && (_loc17_ as CMonster).boostype == GS.a10)
                  {
                     if(_loc17_.bhitTestByPoint(_loc12_,_loc13_))
                     {
                        this.changestatueOne();
                        return;
                     }
                  }
               }
               _loc9_--;
               _loc12_--;
            }
            _loc14_--;
         }
         this.dfmc.x = _loc9_ - _loc7_;
         var _loc15_:* = _loc6_;
         while(_loc15_ > 0)
         {
            _loc18_ = Boolean(GM.levelm.hitTestByMmonsterY(_loc12_,_loc13_ + this.ballRadius.getValue() - 3,GS.a1));
            _loc19_ = Boolean(GM.levelm.hitTestByMmonsterY(_loc12_,_loc13_ + this.ballRadius.getValue() - 1,GS.a1));
            if(_loc18_)
            {
               _loc10_ -= 2;
               _loc13_ -= 2;
               this._skyType = 0;
            }
            else
            {
               if(_loc19_)
               {
                  this._skyType = 0;
                  break;
               }
               for each(_loc20_ in param1)
               {
                  if(_loc20_ is CMonster && (_loc20_ as CMonster).boostype == GS.a10)
                  {
                     if(_loc20_.bhitTestByPoint(_loc12_,_loc13_))
                     {
                        this.changestatueOne();
                        return;
                     }
                  }
               }
               _loc10_++;
               _loc13_++;
               this._skyType = 1;
            }
            _loc15_--;
         }
         this.dfmc.y = _loc10_ - _loc8_;
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
      
      protected function getHitRangle() : MovieClip
      {
         return this.dfmc["bahitab"];
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
         if(param1.hitTestPoint(_loc2_.x,_loc2_.y + this.ballRadius.getValue(),true))
         {
            return true;
         }
         if(param1.hitTestPoint(_loc2_.x,_loc2_.y - this.ballRadius.getValue(),true))
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
         if(this.speedforth == 0)
         {
            this.speedforth = param2.getZx() > this.getZx() ? -1 : int(GS.a1);
         }
         this.xspeed += this.xaddspeed.getValue();
         if(this.xspeed > GS.a15)
         {
            this.xspeed = GS.a15;
         }
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
   }
}

