package hotpointgame.gameobj
{
   import flash.display.*;
   import flash.geom.Point;
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   import hotpointgame.gBullet.*;
   import hotpointgame.gaction.CAction;
   import hotpointgame.gbuffer.*;
   import hotpointgame.grole.*;
   import hotpointgame.models.bag.*;
   import hotpointgame.repository.goodsSkill.GoodsSkillData;
   import hotpointgame.utils.*;
   import hotpointgame.utils.gameloader.*;
   
   public class ZtC extends ZhangDouT
   {
      
      protected var _forth:int = 1;
      
      protected var _skyType:int = 0;
      
      protected var _cHp:VT = VT.createVT(0);
      
      protected var _mHp:VT = VT.createVT(0);
      
      protected var _cmp:VT = VT.createVT(0);
      
      protected var _mmp:VT = VT.createVT(0);
      
      private var _curAction:CAction;
      
      protected var _bHeight:int = 0;
      
      protected var _bWidth:int = 0;
      
      protected var _zCd:ztcCD = new ztcCD();
      
      protected var _bCd:ZtCBufferManager = new ZtCBufferManager();
      
      protected var _currentState:VT = VT.createVT(0);
      
      protected var _gravity:VT = VT.createVT(GS.a3);
      
      protected var _gravityNum:int = 0;
      
      protected var _currentFrameName:String = "待机";
      
      protected var _runArr:Array = new Array();
      
      protected var _jiansu:VT = VT.createVT(GS.a1);
      
      protected var byhitFlashE:Object = new Object();
      
      public function ZtC()
      {
         super();
      }
      
      public function gotoFrame(param1:String) : void
      {
      }
      
      public function allMcStop() : void
      {
      }
      
      public function allMcPlay() : void
      {
      }
      
      public function gotoAndStopFrame(param1:Object) : void
      {
      }
      
      public function gotoAndPlayFrame(param1:Object) : void
      {
      }
      
      public function getCurrentFrameNum() : int
      {
         return 0;
      }
      
      public function getFrameLabel() : String
      {
         return "";
      }
      
      public function getAhit() : MovieClip
      {
         return null;
      }
      
      public function getOtherHit(param1:String) : MovieClip
      {
         return null;
      }
      
      public function addFlashE(param1:String) : void
      {
         if(param1 != "null")
         {
            this.byhitFlashE[param1] = "";
         }
      }
      
      public function addBufferMc(param1:MovieClip) : void
      {
      }
      
      public function removeBufferMc(param1:MovieClip) : void
      {
      }
      
      public function getBullet(param1:String) : MovieClip
      {
         return null;
      }
      
      public function getAllBulletByClass(param1:Class) : Array
      {
         return null;
      }
      
      public function getXiaZhiMc(param1:String) : MovieClip
      {
         return null;
      }
      
      public function remove() : void
      {
         this.curAction.exit();
         this.curAction = null;
         this._zCd = null;
         this.bCd.removeAllBuffer(this);
         this.bCd = null;
         this.runArr.length = 0;
         this.runArr = null;
      }
      
      public function attackEnemy(param1:Vector.<ZhangDouT>) : void
      {
         this.bCd.attack(this,param1);
         this.curAction.attack(this,param1);
      }
      
      public function addSkillStatus(param1:Object) : void
      {
         var _loc2_:Object = new Object();
         switch((param1.type as VT).getValue())
         {
            case 1:
               this.zCd.weizhanTime = (param1.valuea as VT).getValue();
               break;
            case 2:
               this.addHp((param1.valuea as VT).getValue());
               break;
            case 3:
               this.addHpByPerc((param1.valuea as VT).getValue());
               break;
            case 4:
               _loc2_ = new Object();
               _loc2_.flaname = "zhuangtai_gjl";
               _loc2_.name = "gb怪攻击力";
               _loc2_.classname = "MAddatt";
               _loc2_.bhi = 999;
               _loc2_.hurt = (param1.valuea as VT).getValue();
               _loc2_.bnum = (param1.lt as VT).getValue();
               this.bCd.addBuffer(_loc2_,this);
               break;
            case 5:
               this.addHpByPerc((param1.valuea as VT).getValue());
               break;
            case 6:
               _loc2_ = new Object();
               _loc2_.flaname = "zhuangtai_hj";
               _loc2_.name = "gb怪防御";
               _loc2_.classname = "MAddDenf";
               _loc2_.bhi = 999;
               _loc2_.hurt = (param1.valuea as VT).getValue();
               _loc2_.bnum = (param1.lt as VT).getValue();
               this.bCd.addBuffer(_loc2_,this);
               break;
            case 7:
               _loc2_ = new Object();
               _loc2_.flaname = "zhuangtai_yd";
               _loc2_.name = "gb怪速度";
               _loc2_.classname = "MAddSpeed";
               _loc2_.bhi = 999;
               _loc2_.hurt = (param1.valuea as VT).getValue();
               _loc2_.bnum = (param1.lt as VT).getValue();
               this.bCd.addBuffer(_loc2_,this);
         }
      }
      
      public function setForth(param1:int) : void
      {
      }
      
      public function addHp(param1:int) : void
      {
         this.cHp += param1;
         if(this.cHp > this.mHp)
         {
            this.cHp = this.mHp;
         }
      }
      
      public function addHpByPerc(param1:Number) : void
      {
      }
      
      public function addMp(param1:int) : void
      {
      }
      
      public function redHp(param1:int, param2:int, param3:Boolean) : void
      {
         this.cHp -= param1;
         if(this.cHp < 0)
         {
            this.cHp = 0;
         }
      }
      
      public function redMp(param1:int) : void
      {
      }
      
      public function playPiaoByVip(param1:MovieClip, param2:int, param3:int = 0) : void
      {
         var _loc4_:String = null;
         var _loc5_:int = 0;
         if(param2 > 999999 || param2 < 0 || param3 > 999999 || param3 < 0)
         {
            return;
         }
         this.playPiao(param1,param2);
         if(param3 > 0)
         {
            (param1["g"] as MovieClip).visible = true;
            _loc4_ = String(param3);
            _loc5_ = _loc4_.length;
            if(param3 > 99999)
            {
               (param1["m"] as MovieClip).gotoAndStop(int(_loc4_.substr(_loc5_ - 1,1)) + 1);
               (param1["l"] as MovieClip).gotoAndStop(int(_loc4_.substr(_loc5_ - 2,1)) + 1);
               (param1["k"] as MovieClip).gotoAndStop(int(_loc4_.substr(_loc5_ - 3,1)) + 1);
               (param1["j"] as MovieClip).gotoAndStop(int(_loc4_.substr(_loc5_ - 4,1)) + 1);
               (param1["i"] as MovieClip).gotoAndStop(int(_loc4_.substr(_loc5_ - 5,1)) + 1);
               (param1["h"] as MovieClip).gotoAndStop(int(_loc4_.substr(_loc5_ - 6,1)) + 1);
               return;
            }
            if(param3 > 9999)
            {
               (param1["m"] as MovieClip).gotoAndStop(11);
               (param1["l"] as MovieClip).gotoAndStop(int(_loc4_.substr(_loc5_ - 1,1)) + 1);
               (param1["k"] as MovieClip).gotoAndStop(int(_loc4_.substr(_loc5_ - 2,1)) + 1);
               (param1["j"] as MovieClip).gotoAndStop(int(_loc4_.substr(_loc5_ - 3,1)) + 1);
               (param1["i"] as MovieClip).gotoAndStop(int(_loc4_.substr(_loc5_ - 4,1)) + 1);
               (param1["h"] as MovieClip).gotoAndStop(int(_loc4_.substr(_loc5_ - 5,1)) + 1);
               return;
            }
            if(param3 > 999)
            {
               (param1["m"] as MovieClip).gotoAndStop(11);
               (param1["l"] as MovieClip).gotoAndStop(11);
               (param1["k"] as MovieClip).gotoAndStop(int(_loc4_.substr(_loc5_ - 1,1)) + 1);
               (param1["j"] as MovieClip).gotoAndStop(int(_loc4_.substr(_loc5_ - 2,1)) + 1);
               (param1["i"] as MovieClip).gotoAndStop(int(_loc4_.substr(_loc5_ - 3,1)) + 1);
               (param1["h"] as MovieClip).gotoAndStop(int(_loc4_.substr(_loc5_ - 4,1)) + 1);
               return;
            }
            if(param3 > 99)
            {
               (param1["m"] as MovieClip).gotoAndStop(11);
               (param1["l"] as MovieClip).gotoAndStop(11);
               (param1["k"] as MovieClip).gotoAndStop(11);
               (param1["j"] as MovieClip).gotoAndStop(int(_loc4_.substr(_loc5_ - 1,1)) + 1);
               (param1["i"] as MovieClip).gotoAndStop(int(_loc4_.substr(_loc5_ - 2,1)) + 1);
               (param1["h"] as MovieClip).gotoAndStop(int(_loc4_.substr(_loc5_ - 3,1)) + 1);
               return;
            }
            if(param3 > 9)
            {
               (param1["m"] as MovieClip).gotoAndStop(11);
               (param1["l"] as MovieClip).gotoAndStop(11);
               (param1["k"] as MovieClip).gotoAndStop(11);
               (param1["j"] as MovieClip).gotoAndStop(11);
               (param1["i"] as MovieClip).gotoAndStop(int(_loc4_.substr(_loc5_ - 1,1)) + 1);
               (param1["h"] as MovieClip).gotoAndStop(int(_loc4_.substr(_loc5_ - 2,1)) + 1);
               return;
            }
            if(param3 >= 0)
            {
               (param1["m"] as MovieClip).gotoAndStop(11);
               (param1["l"] as MovieClip).gotoAndStop(11);
               (param1["k"] as MovieClip).gotoAndStop(11);
               (param1["j"] as MovieClip).gotoAndStop(11);
               (param1["i"] as MovieClip).gotoAndStop(11);
               (param1["h"] as MovieClip).gotoAndStop(int(_loc4_.substr(_loc5_ - 1,1)) + 1);
               return;
            }
         }
         else
         {
            (param1["g"] as MovieClip).visible = false;
            (param1["h"] as MovieClip).gotoAndStop(11);
            (param1["i"] as MovieClip).gotoAndStop(11);
            (param1["j"] as MovieClip).gotoAndStop(11);
            (param1["k"] as MovieClip).gotoAndStop(11);
            (param1["l"] as MovieClip).gotoAndStop(11);
            (param1["m"] as MovieClip).gotoAndStop(11);
         }
      }
      
      public function playPiao(param1:MovieClip, param2:int) : void
      {
         if(param2 > 999999 || param2 < 0)
         {
            return;
         }
         param1.x = getZx() + 10;
         param1.y = getZy() - this.bHeight - 10;
         GM.levelm.getVs().addPiaoPiao(param1);
         var _loc3_:String = String(param2);
         var _loc4_:int = _loc3_.length;
         if(param2 > 99999)
         {
            param1.x -= 30;
            (param1["a"] as MovieClip).gotoAndStop(int(_loc3_.substr(_loc4_ - 1,1)) + 1);
            (param1["b"] as MovieClip).gotoAndStop(int(_loc3_.substr(_loc4_ - 2,1)) + 1);
            (param1["c"] as MovieClip).gotoAndStop(int(_loc3_.substr(_loc4_ - 3,1)) + 1);
            (param1["d"] as MovieClip).gotoAndStop(int(_loc3_.substr(_loc4_ - 4,1)) + 1);
            (param1["e"] as MovieClip).gotoAndStop(int(_loc3_.substr(_loc4_ - 5,1)) + 1);
            (param1["f"] as MovieClip).gotoAndStop(int(_loc3_.substr(_loc4_ - 6,1)) + 1);
            return;
         }
         if(param2 > 9999)
         {
            param1.x -= 25;
            (param1["a"] as MovieClip).gotoAndStop(11);
            (param1["b"] as MovieClip).gotoAndStop(int(_loc3_.substr(_loc4_ - 1,1)) + 1);
            (param1["c"] as MovieClip).gotoAndStop(int(_loc3_.substr(_loc4_ - 2,1)) + 1);
            (param1["d"] as MovieClip).gotoAndStop(int(_loc3_.substr(_loc4_ - 3,1)) + 1);
            (param1["e"] as MovieClip).gotoAndStop(int(_loc3_.substr(_loc4_ - 4,1)) + 1);
            (param1["f"] as MovieClip).gotoAndStop(int(_loc3_.substr(_loc4_ - 5,1)) + 1);
            return;
         }
         if(param2 > 999)
         {
            param1.x -= 20;
            (param1["a"] as MovieClip).gotoAndStop(11);
            (param1["b"] as MovieClip).gotoAndStop(11);
            (param1["c"] as MovieClip).gotoAndStop(int(_loc3_.substr(_loc4_ - 1,1)) + 1);
            (param1["d"] as MovieClip).gotoAndStop(int(_loc3_.substr(_loc4_ - 2,1)) + 1);
            (param1["e"] as MovieClip).gotoAndStop(int(_loc3_.substr(_loc4_ - 3,1)) + 1);
            (param1["f"] as MovieClip).gotoAndStop(int(_loc3_.substr(_loc4_ - 4,1)) + 1);
            return;
         }
         if(param2 > 99)
         {
            param1.x -= 15;
            (param1["a"] as MovieClip).gotoAndStop(11);
            (param1["b"] as MovieClip).gotoAndStop(11);
            (param1["c"] as MovieClip).gotoAndStop(11);
            (param1["d"] as MovieClip).gotoAndStop(int(_loc3_.substr(_loc4_ - 1,1)) + 1);
            (param1["e"] as MovieClip).gotoAndStop(int(_loc3_.substr(_loc4_ - 2,1)) + 1);
            (param1["f"] as MovieClip).gotoAndStop(int(_loc3_.substr(_loc4_ - 3,1)) + 1);
            return;
         }
         if(param2 > 9)
         {
            param1.x -= 10;
            (param1["a"] as MovieClip).gotoAndStop(11);
            (param1["b"] as MovieClip).gotoAndStop(11);
            (param1["c"] as MovieClip).gotoAndStop(11);
            (param1["d"] as MovieClip).gotoAndStop(11);
            (param1["e"] as MovieClip).gotoAndStop(int(_loc3_.substr(_loc4_ - 1,1)) + 1);
            (param1["f"] as MovieClip).gotoAndStop(int(_loc3_.substr(_loc4_ - 2,1)) + 1);
            return;
         }
         if(param2 >= 0)
         {
            (param1["a"] as MovieClip).gotoAndStop(11);
            (param1["b"] as MovieClip).gotoAndStop(11);
            (param1["c"] as MovieClip).gotoAndStop(11);
            (param1["d"] as MovieClip).gotoAndStop(11);
            (param1["e"] as MovieClip).gotoAndStop(11);
            (param1["f"] as MovieClip).gotoAndStop(int(_loc3_.substr(_loc4_ - 1,1)) + 1);
            return;
         }
      }
      
      public function playRHP(param1:MovieClip, param2:int, param3:int) : void
      {
         if(param2 > 999999)
         {
            return;
         }
         var _loc4_:Number = Math.random() - 0.5;
         param1.x = getZx() + _loc4_ * 100;
         param1.y = getZy() - this.bHeight - 30 + _loc4_ * 50;
         GM.levelm.getVs().addPiaoHp(param1);
         var _loc5_:String = String(param2);
         var _loc6_:int = _loc5_.length;
         (param1["wuxing"] as MovieClip).gotoAndStop(param3 + 1);
         if(param2 > 99999)
         {
            (param1["a"] as MovieClip).gotoAndStop(int(_loc5_.substr(_loc6_ - 1,1)) + 1);
            (param1["b"] as MovieClip).gotoAndStop(int(_loc5_.substr(_loc6_ - 2,1)) + 1);
            (param1["c"] as MovieClip).gotoAndStop(int(_loc5_.substr(_loc6_ - 3,1)) + 1);
            (param1["d"] as MovieClip).gotoAndStop(int(_loc5_.substr(_loc6_ - 4,1)) + 1);
            (param1["e"] as MovieClip).gotoAndStop(int(_loc5_.substr(_loc6_ - 5,1)) + 1);
            (param1["f"] as MovieClip).gotoAndStop(int(_loc5_.substr(_loc6_ - 6,1)) + 1);
            return;
         }
         if(param2 > 9999)
         {
            (param1["a"] as MovieClip).gotoAndStop(11);
            (param1["b"] as MovieClip).gotoAndStop(int(_loc5_.substr(_loc6_ - 1,1)) + 1);
            (param1["c"] as MovieClip).gotoAndStop(int(_loc5_.substr(_loc6_ - 2,1)) + 1);
            (param1["d"] as MovieClip).gotoAndStop(int(_loc5_.substr(_loc6_ - 3,1)) + 1);
            (param1["e"] as MovieClip).gotoAndStop(int(_loc5_.substr(_loc6_ - 4,1)) + 1);
            (param1["f"] as MovieClip).gotoAndStop(int(_loc5_.substr(_loc6_ - 5,1)) + 1);
            return;
         }
         if(param2 > 999)
         {
            (param1["a"] as MovieClip).gotoAndStop(11);
            (param1["b"] as MovieClip).gotoAndStop(11);
            (param1["c"] as MovieClip).gotoAndStop(int(_loc5_.substr(_loc6_ - 1,1)) + 1);
            (param1["d"] as MovieClip).gotoAndStop(int(_loc5_.substr(_loc6_ - 2,1)) + 1);
            (param1["e"] as MovieClip).gotoAndStop(int(_loc5_.substr(_loc6_ - 3,1)) + 1);
            (param1["f"] as MovieClip).gotoAndStop(int(_loc5_.substr(_loc6_ - 4,1)) + 1);
            return;
         }
         if(param2 > 99)
         {
            (param1["a"] as MovieClip).gotoAndStop(11);
            (param1["b"] as MovieClip).gotoAndStop(11);
            (param1["c"] as MovieClip).gotoAndStop(11);
            (param1["d"] as MovieClip).gotoAndStop(int(_loc5_.substr(_loc6_ - 1,1)) + 1);
            (param1["e"] as MovieClip).gotoAndStop(int(_loc5_.substr(_loc6_ - 2,1)) + 1);
            (param1["f"] as MovieClip).gotoAndStop(int(_loc5_.substr(_loc6_ - 3,1)) + 1);
            return;
         }
         if(param2 > 9)
         {
            (param1["a"] as MovieClip).gotoAndStop(11);
            (param1["b"] as MovieClip).gotoAndStop(11);
            (param1["c"] as MovieClip).gotoAndStop(11);
            (param1["d"] as MovieClip).gotoAndStop(11);
            (param1["e"] as MovieClip).gotoAndStop(int(_loc5_.substr(_loc6_ - 1,1)) + 1);
            (param1["f"] as MovieClip).gotoAndStop(int(_loc5_.substr(_loc6_ - 2,1)) + 1);
            return;
         }
         if(param2 >= 0)
         {
            (param1["a"] as MovieClip).gotoAndStop(11);
            (param1["b"] as MovieClip).gotoAndStop(11);
            (param1["c"] as MovieClip).gotoAndStop(11);
            (param1["d"] as MovieClip).gotoAndStop(11);
            (param1["e"] as MovieClip).gotoAndStop(11);
            (param1["f"] as MovieClip).gotoAndStop(int(_loc5_.substr(_loc6_ - 1,1)) + 1);
            return;
         }
      }
      
      public function buNengBeida() : Boolean
      {
         if(this.zCd.weizhanTime > 0 || this.currentState >= GS.a2 || this.currentState == -1)
         {
            return true;
         }
         return false;
      }
      
      public function wuxinShuXinKezhi(param1:int, param2:int) : Number
      {
         return this.wuxinKValue(param1,param2,-GS.a015,-GS.a02,GS.a015,GS.a02,0);
      }
      
      public function wuxinKanXinKezhi(param1:int, param2:int) : Number
      {
         return this.wuxinKValue(param1,param2,0,0,GS.a1 + GS.a04,GS.a1 + GS.a09,GS.a1);
      }
      
      public function yazhiChengkezhi(param1:int, param2:Number, param3:Number, param4:int, param5:int) : Number
      {
         return (param1 + (param1 / param2 - param1 / param3) * GS.a0028 / GS.a0005 * param3) * this.wuxinKanXinKezhi(param4,param5);
      }
      
      public function jianShangBaiBi(param1:Number, param2:int) : Number
      {
         var _loc3_:Number = param1 / Math.pow((param2 + GS.a20 + GS.a2) * GS.a05,GS.a1 + GS.a01) * GS.a001;
         return _loc3_ / (GS.a1 + _loc3_);
      }
      
      public function wuxinKValue(param1:int, param2:int, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number) : Number
      {
         var _loc8_:Number = NaN;
         var _loc9_:int = 0;
         var _loc10_:int = 1;
         var _loc11_:int = 2;
         var _loc12_:int = 3;
         var _loc13_:int = 4;
         var _loc14_:int = 5;
         var _loc15_:int = 6;
         switch(param1)
         {
            case _loc9_:
               switch(param2)
               {
                  case _loc9_:
                     _loc8_ = param7;
                     break;
                  case _loc10_:
                     _loc8_ = param3;
                     break;
                  case _loc11_:
                     _loc8_ = param3;
                     break;
                  case _loc12_:
                     _loc8_ = param3;
                     break;
                  case _loc13_:
                     _loc8_ = param3;
                     break;
                  case _loc14_:
                     _loc8_ = param3;
                     break;
                  case _loc15_:
                     _loc8_ = param4;
                     break;
                  default:
                     throw new Error("kx no false;");
               }
               break;
            case _loc10_:
               switch(param2)
               {
                  case _loc9_:
                     _loc8_ = param5;
                     break;
                  case _loc10_:
                     _loc8_ = param7;
                     break;
                  case _loc11_:
                     _loc8_ = param5;
                     break;
                  case _loc12_:
                     _loc8_ = param7;
                     break;
                  case _loc13_:
                     _loc8_ = param3;
                     break;
                  case _loc14_:
                     _loc8_ = param7;
                     break;
                  case _loc15_:
                     _loc8_ = param4;
                     break;
                  default:
                     throw new Error("kx no false;");
               }
               break;
            case _loc11_:
               switch(param2)
               {
                  case _loc9_:
                     _loc8_ = param5;
                     break;
                  case _loc10_:
                     _loc8_ = param3;
                     break;
                  case _loc11_:
                     _loc8_ = param7;
                     break;
                  case _loc12_:
                     _loc8_ = param7;
                     break;
                  case _loc13_:
                     _loc8_ = param7;
                     break;
                  case _loc14_:
                     _loc8_ = param5;
                     break;
                  case _loc15_:
                     _loc8_ = param4;
                     break;
                  default:
                     throw new Error("kx no false;");
               }
               break;
            case _loc12_:
               switch(param2)
               {
                  case _loc9_:
                     _loc8_ = param5;
                     break;
                  case _loc10_:
                     _loc8_ = param7;
                     break;
                  case _loc11_:
                     _loc8_ = param7;
                     break;
                  case _loc12_:
                     _loc8_ = param7;
                     break;
                  case _loc13_:
                     _loc8_ = param5;
                     break;
                  case _loc14_:
                     _loc8_ = param3;
                     break;
                  case _loc15_:
                     _loc8_ = param4;
                     break;
                  default:
                     throw new Error("kx no false;");
               }
               break;
            case _loc13_:
               switch(param2)
               {
                  case _loc9_:
                     _loc8_ = param5;
                     break;
                  case _loc10_:
                     _loc8_ = param5;
                     break;
                  case _loc11_:
                     _loc8_ = param7;
                     break;
                  case _loc12_:
                     _loc8_ = param3;
                     break;
                  case _loc13_:
                     _loc8_ = param7;
                     break;
                  case _loc14_:
                     _loc8_ = param7;
                     break;
                  case _loc15_:
                     _loc8_ = param4;
                     break;
                  default:
                     throw new Error("kx no false;");
               }
               break;
            case _loc14_:
               switch(param2)
               {
                  case _loc9_:
                     _loc8_ = param5;
                     break;
                  case _loc10_:
                     _loc8_ = param7;
                     break;
                  case _loc11_:
                     _loc8_ = param3;
                     break;
                  case _loc12_:
                     _loc8_ = param5;
                     break;
                  case _loc13_:
                     _loc8_ = param7;
                     break;
                  case _loc14_:
                     _loc8_ = param7;
                     break;
                  case _loc15_:
                     _loc8_ = param4;
                     break;
                  default:
                     throw new Error("kx no false;");
               }
               break;
            case _loc15_:
               switch(param2)
               {
                  case _loc9_:
                     _loc8_ = param6;
                     break;
                  case _loc10_:
                     _loc8_ = param6;
                     break;
                  case _loc11_:
                     _loc8_ = param6;
                     break;
                  case _loc12_:
                     _loc8_ = param6;
                     break;
                  case _loc13_:
                     _loc8_ = param6;
                     break;
                  case _loc14_:
                     _loc8_ = param6;
                     break;
                  case _loc15_:
                     _loc8_ = param7;
                     break;
                  default:
                     throw new Error("kx no false;");
               }
               break;
            default:
               throw new Error("kx no false;");
         }
         return _loc8_;
      }
      
      override public function isLive() : Boolean
      {
         if(this.currentState >= GS.a2)
         {
            return false;
         }
         return true;
      }
      
      override public function bhit(param1:FightData, param2:ZhangDouT) : int
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:Boolean = false;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:int = 0;
         var _loc15_:int = 0;
         var _loc16_:int = 0;
         var _loc17_:int = 0;
         var _loc18_:Number = NaN;
         var _loc19_:Number = NaN;
         var _loc20_:Number = NaN;
         var _loc21_:Number = NaN;
         var _loc22_:Number = NaN;
         var _loc23_:Number = NaN;
         var _loc24_:Number = NaN;
         var _loc25_:Number = NaN;
         var _loc26_:Number = NaN;
         var _loc27_:Number = NaN;
         var _loc28_:Number = NaN;
         var _loc29_:Number = NaN;
         var _loc30_:Number = NaN;
         var _loc31_:Number = NaN;
         var _loc32_:Number = NaN;
         var _loc33_:Number = NaN;
         var _loc34_:Number = NaN;
         var _loc35_:Number = NaN;
         var _loc36_:Number = NaN;
         var _loc37_:Number = NaN;
         var _loc38_:Number = NaN;
         var _loc39_:Number = NaN;
         var _loc40_:Number = NaN;
         var _loc41_:Boolean = false;
         var _loc42_:Number = NaN;
         var _loc43_:int = 0;
         var _loc44_:GoodsSkillData = null;
         var _loc45_:int = 0;
         var _loc46_:GoodsSkillData = null;
         var _loc3_:FightData = this.curAction.getFd();
         if(param1.daJi != 0)
         {
            _loc4_ = _loc3_.coundYinZhi(param1);
            _loc5_ = _loc3_.coundJiDao(param1);
            if(_loc4_ > 0 && _loc5_ == 0)
            {
               this._zCd.yinZhi = _loc4_;
            }
            if(_loc4_ == 0 && _loc5_ > 0)
            {
               this._zCd.jiDao = _loc5_;
            }
            if(_loc4_ > 0 && _loc5_ > 0)
            {
               this._zCd.setYinZhiAndjiDao(_loc4_,_loc5_);
            }
            _loc6_ = _loc3_.coundShiZhong(param1);
            if(_loc6_ > 0)
            {
               this._zCd.shiZhong = _loc6_;
            }
            _loc7_ = true;
            _loc8_ = _loc3_.coundZhenTui(param1);
            if(_loc8_ != 0)
            {
               _loc10_ = 0;
               if(param1.zhenTuiType == 0)
               {
                  _loc10_ = param2.getZx() > getZx() ? -1 : int(GS.a1);
               }
               else
               {
                  _loc10_ = param2.getXforth();
               }
               this.runArr.length = 0;
               _loc7_ = false;
               this.runArr[this.runArr.length] = GameEasing.createRunArray(_loc10_ * _loc8_,0,param1.zhenTuiZheng,param1.zhenTuiEase);
            }
            _loc9_ = _loc3_.coundTiaoGao(param1);
            if(_loc9_ != 0)
            {
               if(_loc7_)
               {
                  this.runArr.length = 0;
               }
               this.runArr[this.runArr.length] = GameEasing.createRunArray(0,_loc9_,param1.tiaoGaoZheng,param1.tiaoGaoEase);
            }
         }
         if(param1.shangHaiBi != 0)
         {
            _loc11_ = Math.random();
            if(param1.othersSkill != 0)
            {
               _loc44_ = FlowInterface.getGoodsSkillById(param1.othersSkill);
               this.bufEffectH(_loc11_,_loc44_);
            }
            if(param1.goodsSkill.length > 0)
            {
               _loc45_ = 0;
               while(_loc45_ < param1.goodsSkill.length)
               {
                  _loc46_ = BagFactory.equipSlot.getSkillList()[(param1.goodsSkill[_loc45_] as VT).getValue()];
                  if(_loc46_ != null)
                  {
                     if(_loc46_.getStype() == GS.a18)
                     {
                        if(_loc11_ < _loc46_.getPro() / GS.a10000)
                        {
                           if(param2 is CPlayer)
                           {
                              (param2 as CPlayer).addHp(_loc46_.getValue());
                           }
                        }
                     }
                     else if(_loc46_.getStype() == GS.a20)
                     {
                        if(_loc11_ < _loc46_.getPro() / GS.a10000)
                        {
                           if(param2 is CPlayer)
                           {
                              (param2 as CPlayer).zCd.addAttBuf(_loc46_.getValue(),_loc46_.getCtime());
                           }
                        }
                     }
                     else if(_loc46_.getStype() == GS.a22)
                     {
                        if(_loc11_ < _loc46_.getPro() / GS.a10000)
                        {
                           if(param2 is CPlayer)
                           {
                              (param2 as CPlayer).zCd.weizhanTime = _loc46_.getCtime();
                           }
                        }
                     }
                     else
                     {
                        this.bufEffectH(_loc11_,_loc46_);
                     }
                  }
                  _loc45_++;
               }
            }
            _loc12_ = param2.getAttackValue();
            _loc13_ = getDefenceValue();
            _loc14_ = param2.getWuxinSX(getZtLevel());
            _loc15_ = getWuxinSX(param2.getZtLevel());
            _loc16_ = param2.getZtLevel();
            _loc17_ = getZtLevel();
            _loc18_ = param2.getWuxinKaxin(GS.a1);
            _loc19_ = param2.getWuxinKaxin(GS.a2);
            _loc20_ = param2.getWuxinKaxin(GS.a3);
            _loc21_ = param2.getWuxinKaxin(GS.a4);
            _loc22_ = param2.getWuxinKaxin(GS.a5);
            _loc23_ = param2.getWuxinKaxin(GS.a6);
            _loc24_ = getWuxinKaxin(GS.a1);
            _loc25_ = getWuxinKaxin(GS.a2);
            _loc26_ = getWuxinKaxin(GS.a3);
            _loc27_ = getWuxinKaxin(GS.a4);
            _loc28_ = getWuxinKaxin(GS.a5);
            _loc29_ = getWuxinKaxin(GS.a6);
            _loc30_ = this.wuxinShuXinKezhi(_loc14_,_loc15_);
            if(_loc17_ - _loc16_ >= GS.a10)
            {
               _loc31_ = _loc16_ + GS.a10;
               _loc32_ = _loc17_ - GS.a10;
            }
            else if(_loc17_ - _loc16_ <= -GS.a10)
            {
               _loc31_ = _loc16_ - GS.a10;
               _loc32_ = _loc17_ + GS.a10;
            }
            else
            {
               _loc31_ = _loc17_;
               _loc32_ = _loc16_;
            }
            _loc33_ = Math.pow(Math.pow(_loc31_,GS.a1 + GS.a04) + GS.a80,GS.a05);
            _loc34_ = Math.pow(Math.pow(_loc16_,GS.a1 + GS.a04) + GS.a80,GS.a05);
            _loc35_ = _loc12_ * (GS.a1 + _loc30_ + (this.yazhiChengkezhi(_loc18_,_loc33_,_loc34_,GS.a1,_loc15_) + this.yazhiChengkezhi(_loc19_,_loc33_,_loc34_,GS.a2,_loc15_) + this.yazhiChengkezhi(_loc20_,_loc33_,_loc34_,GS.a3,_loc15_) + this.yazhiChengkezhi(_loc21_,_loc33_,_loc34_,GS.a4,_loc15_) + this.yazhiChengkezhi(_loc22_,_loc33_,_loc34_,GS.a5,_loc15_) + this.yazhiChengkezhi(_loc23_,_loc33_,_loc34_,GS.a6,_loc15_)) / _loc34_ * GS.a8 / GS.a1000);
            _loc36_ = this.wuxinShuXinKezhi(_loc15_,_loc14_);
            _loc37_ = GS.a2 * this.jianShangBaiBi(_loc13_ * (GS.a1 + _loc36_),_loc32_) - this.jianShangBaiBi(_loc13_ * (GS.a1 + _loc36_),_loc17_);
            _loc38_ = Math.pow(Math.pow(_loc32_,GS.a1 + GS.a04) + GS.a80,GS.a05);
            _loc39_ = Math.pow(Math.pow(_loc17_,GS.a1 + GS.a04) + GS.a80,GS.a05);
            _loc40_ = GS.a1 / (GS.a1 / (GS.a1 - _loc37_) + (this.yazhiChengkezhi(_loc24_,_loc38_,_loc39_,GS.a1,_loc14_) + this.yazhiChengkezhi(_loc25_,_loc38_,_loc39_,GS.a2,_loc14_) + this.yazhiChengkezhi(_loc26_,_loc38_,_loc39_,GS.a3,_loc14_) + this.yazhiChengkezhi(_loc27_,_loc38_,_loc39_,GS.a4,_loc14_) + this.yazhiChengkezhi(_loc28_,_loc38_,_loc39_,GS.a5,_loc14_) + this.yazhiChengkezhi(_loc29_,_loc38_,_loc39_,GS.a6,_loc14_)) / _loc39_ * GS.a0028);
            _loc41_ = param2.getBaojiJL() > _loc11_ ? true : false;
            _loc42_ = _loc35_ * _loc40_ * (param1.shangHaiBi * (GS.a1 + (_loc11_ - GS.a05) * GS.a01)) * _loc3_.jiangShangBi;
            if(_loc41_)
            {
               _loc42_ += _loc42_;
            }
            _loc43_ = _loc30_ > 0 ? _loc14_ : 0;
            this.redHp(Math.ceil(_loc42_),_loc43_,_loc41_);
            return Math.ceil(_loc42_);
         }
         return 0;
      }
      
      override public function bhitXianZhi(param1:int, param2:int) : void
      {
         if(this.curAction.getFd().xianziKanXin > 0)
         {
            return;
         }
         switch(param1)
         {
            case 0:
               this._zCd.bingDong = param2;
               break;
            case 1:
               this._zCd.shiHua = param2;
               break;
            case 2:
               this._zCd.shuFu = param2;
               break;
            case 3:
               this._zCd.xuanYun = param2;
               break;
            case 4:
               this._zCd.shuiPao = param2;
         }
      }
      
      override public function bhitBuffer(param1:Object) : void
      {
         this.bCd.addBuffer(param1,this);
      }
      
      override public function bhitHp(param1:int) : void
      {
         this.redHp(param1,0,false);
      }
      
      public function bufEffectH(param1:Number, param2:GoodsSkillData) : void
      {
         var _loc3_:Object = null;
         var _loc4_:Object = null;
         var _loc5_:Object = null;
         var _loc6_:String = null;
         var _loc7_:Object = null;
         var _loc8_:Class = null;
         var _loc9_:MovieClip = null;
         var _loc10_:Point = null;
         var _loc11_:Class = null;
         var _loc12_:ZtB = null;
         var _loc13_:String = null;
         var _loc14_:Object = null;
         var _loc15_:Class = null;
         var _loc16_:MovieClip = null;
         var _loc17_:Point = null;
         var _loc18_:Class = null;
         var _loc19_:ZtB = null;
         if(Math.random() < param2.getPro() / GS.a10000)
         {
            switch(param2.getStype())
            {
               case 1:
                  if(this.curAction.getFd().xianziKanXin > 0)
                  {
                     return;
                  }
                  this._zCd.bingDong = param2.getCtime();
                  break;
               case 2:
                  if(this.curAction.getFd().xianziKanXin > 0)
                  {
                     return;
                  }
                  this._zCd.shiHua = param2.getCtime();
                  break;
               case 3:
                  if(this.curAction.getFd().xianziKanXin > 0)
                  {
                     return;
                  }
                  this._zCd.xuanYun = param2.getCtime();
                  break;
               case 4:
                  if(this.curAction.getFd().xianziKanXin > 0)
                  {
                     return;
                  }
                  this._zCd.shuiPao = param2.getCtime();
                  break;
               case 5:
                  if(this.curAction.getFd().xianziKanXin > 0)
                  {
                     return;
                  }
                  this._zCd.shuFu = param2.getCtime();
                  break;
               case 6:
                  _loc3_ = new Object();
                  _loc3_.flaname = "zhuangtai_jianshu";
                  _loc3_.name = "减速";
                  _loc3_.classname = "fferJiangSu";
                  _loc3_.bhi = param2.getCvalue();
                  _loc3_.hurt = param2.getValue();
                  _loc3_.bnum = param2.getCtime();
                  this.bCd.addBuffer(_loc3_,this);
                  break;
               case 7:
                  _loc4_ = new Object();
                  _loc4_.flaname = "zhuangtai_zhongdu";
                  _loc4_.name = "中毒";
                  _loc4_.classname = "ffer";
                  _loc4_.bhi = param2.getCvalue();
                  _loc4_.hurt = param2.getValue();
                  _loc4_.bnum = param2.getCtime();
                  this.bCd.addBuffer(_loc4_,this);
                  break;
               case 8:
                  _loc5_ = new Object();
                  _loc5_.flaname = "zhuangtai_zhuoshang";
                  _loc5_.name = "灼伤";
                  _loc5_.classname = "ffer";
                  _loc5_.bhi = param2.getCvalue();
                  _loc5_.hurt = param2.getValue();
                  _loc5_.bnum = param2.getCtime();
                  this.bCd.addBuffer(_loc5_,this);
                  break;
               case 19:
                  _loc6_ = param2.getZdStr();
                  _loc7_ = ZtBFactory.getBulletData(_loc6_);
                  _loc8_ = LoaderManager.getSwfClass(_loc7_.flaname) as Class;
                  _loc9_ = new _loc8_() as MovieClip;
                  _loc10_ = Pos.l_To_G(GM.cp.getZmc());
                  _loc9_.x = _loc10_.x;
                  _loc9_.y = _loc10_.y - 100;
                  Main.sg.addChild(_loc9_);
                  _loc11_ = ClassGet.getClassByNameAndAlias(_loc7_.classname) as Class;
                  _loc12_ = new _loc11_(_loc9_,GM.cp,_loc7_,this.forth) as ZtB;
                  GM.levelm.addBullet(_loc12_);
                  return;
               case 21:
                  _loc13_ = param2.getZdStr();
                  _loc14_ = ZtBFactory.getBulletData(_loc13_);
                  _loc15_ = LoaderManager.getSwfClass(_loc14_.flaname) as Class;
                  _loc16_ = new _loc15_() as MovieClip;
                  _loc17_ = Pos.l_To_G(GM.cp.getZmc());
                  _loc16_.rotation = 90;
                  _loc16_.x = _loc17_.x;
                  _loc16_.y = _loc17_.y - 100;
                  Main.sg.addChild(_loc16_);
                  _loc18_ = ClassGet.getClassByNameAndAlias(_loc14_.classname) as Class;
                  _loc19_ = new _loc18_(_loc16_,GM.cp,_loc14_,this.forth) as ZtB;
                  GM.levelm.addBullet(_loc19_);
                  return;
            }
         }
      }
      
      public function addBuffByTq(param1:int) : void
      {
         var _loc2_:Object = null;
         var _loc3_:Object = null;
         var _loc4_:Object = null;
         switch(param1)
         {
            case 1:
               _loc2_ = new Object();
               _loc2_.flaname = "zhuangtai_zhongdu";
               _loc2_.name = "中毒";
               _loc2_.classname = "ffer";
               _loc2_.bhi = GS.a30;
               _loc2_.hurt = GS.a100;
               _loc2_.bnum = GS.a600;
               this.bCd.addBuffer(_loc2_,this);
               break;
            case 2:
               _loc3_ = new Object();
               _loc3_.flaname = "zhuangtai_jianshu";
               _loc3_.name = "减速";
               _loc3_.classname = "fferJiangSu";
               _loc3_.bhi = 0;
               _loc3_.hurt = GS.a03;
               _loc3_.bnum = GS.a300;
               this.bCd.addBuffer(_loc3_,this);
               break;
            case 3:
               _loc4_ = new Object();
               _loc4_.flaname = "zhuangtai_zhuoshang";
               _loc4_.name = "灼伤";
               _loc4_.classname = "ffer";
               _loc4_.bhi = GS.a30;
               _loc4_.hurt = GS.a100;
               _loc4_.bnum = GS.a300;
               this.bCd.addBuffer(_loc4_,this);
               break;
            case 4:
               this.zCd.bingDong = GS.a60;
               break;
            case 5:
               this.zCd.xuanYun = GS.a60;
         }
      }
      
      public function get curAction() : CAction
      {
         return this._curAction;
      }
      
      public function set curAction(param1:CAction) : void
      {
         this._curAction = param1;
      }
      
      public function get forth() : int
      {
         return this._forth;
      }
      
      public function get skyType() : int
      {
         return this._skyType;
      }
      
      public function set skyType(param1:int) : void
      {
         this._skyType = param1;
      }
      
      public function get zCd() : ztcCD
      {
         return this._zCd;
      }
      
      public function getCurrentState() : int
      {
         return this.currentState;
      }
      
      public function get jiansu() : Number
      {
         return this._jiansu.getValue() + this.zCd.getTqatt(GS.a5);
      }
      
      public function set jiansu(param1:Number) : void
      {
         this._jiansu.setValue(param1);
      }
      
      public function get cmp() : int
      {
         return this._cmp.getValue();
      }
      
      public function set cmp(param1:int) : void
      {
         this._cmp.setValue(param1);
      }
      
      public function get cHp() : int
      {
         return this._cHp.getValue();
      }
      
      public function set cHp(param1:int) : void
      {
         this._cHp.setValue(param1);
      }
      
      public function get mHp() : int
      {
         return this._mHp.getValue();
      }
      
      public function set mHp(param1:int) : void
      {
         this._mHp.setValue(param1);
      }
      
      public function get mmp() : int
      {
         return this._mmp.getValue();
      }
      
      public function set mmp(param1:int) : void
      {
         this._mmp.setValue(param1);
      }
      
      public function get currentFrameName() : String
      {
         return this._currentFrameName;
      }
      
      public function set currentFrameName(param1:String) : void
      {
         this._currentFrameName = param1;
      }
      
      public function get currentState() : int
      {
         return this._currentState.getValue();
      }
      
      public function set currentState(param1:int) : void
      {
         this._currentState.setValue(param1);
      }
      
      public function get gravity() : int
      {
         return this._gravity.getValue();
      }
      
      public function set gravity(param1:int) : void
      {
         this._gravity.setValue(param1);
      }
      
      public function get runArr() : Array
      {
         return this._runArr;
      }
      
      public function set runArr(param1:Array) : void
      {
         this._runArr = param1;
      }
      
      public function get gravityNum() : int
      {
         return this._gravityNum;
      }
      
      public function set gravityNum(param1:int) : void
      {
         this._gravityNum = param1;
      }
      
      public function get bHeight() : int
      {
         return this._bHeight;
      }
      
      public function set bHeight(param1:int) : void
      {
         this._bHeight = param1;
      }
      
      public function get bWidth() : int
      {
         return this._bWidth;
      }
      
      public function set bWidth(param1:int) : void
      {
         this._bWidth = param1;
      }
      
      public function get bCd() : ZtCBufferManager
      {
         return this._bCd;
      }
      
      public function set bCd(param1:ZtCBufferManager) : void
      {
         this._bCd = param1;
      }
   }
}

