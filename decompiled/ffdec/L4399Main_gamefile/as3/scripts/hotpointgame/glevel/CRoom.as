package hotpointgame.glevel
{
   import flash.display.*;
   import flash.geom.*;
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   import hotpointgame.gameobj.*;
   import hotpointgame.gxiaodongxi.*;
   import hotpointgame.gzhujiemian.*;
   import hotpointgame.utils.gameloader.*;
   import hotpointgame.utils.gsound.*;
   
   public class CRoom
   {
      
      private var id:Number = 0;
      
      private var _name:String = "";
      
      private var _pFoot:Number = 50;
      
      private var rtoup:Array;
      
      private var rlp:Array;
      
      private var rlm:Array;
      
      protected var tztLv:VT;
      
      private var _type:VT;
      
      private var beffect:int = 0;
      
      private var rtoupb:Array;
      
      private var rlpb:Array;
      
      private var douHuaMcname:String = "";
      
      private var resetFlag:int = 0;
      
      private var _enterlimit:VT;
      
      private var oneMonser:Array;
      
      protected var twoMonser:Array;
      
      private var oneFlag:Object;
      
      private var twoFlag:Object;
      
      private var nexroom:Vector.<CNextRoom>;
      
      private var mapgood:Array;
      
      private var mapSound:String = "mp3kaichang";
      
      private var _lstar:VT;
      
      private var _killNum:VT;
      
      private var _killBossNum:VT;
      
      private var _enternum:VT;
      
      private var _curstate:VT;
      
      private var _shuamFlag:VT;
      
      private var _upstate:VT;
      
      private var _overnum:VT;
      
      private var zhangaiwuarr:Array;
      
      protected var enterT:int = 0;
      
      private var clsmpm:CLSMPmanager;
      
      public function CRoom(param1:Object)
      {
         var _loc4_:Object = null;
         var _loc5_:int = 0;
         this.rtoup = new Array();
         this.rlp = new Array();
         this.rlm = new Array();
         this._type = VT.createVT(0);
         this.rtoupb = [0,6100,0,706];
         this.rlpb = [0,5800,0,1000];
         this._enterlimit = VT.createVT(0);
         this.oneMonser = new Array();
         this.twoMonser = new Array();
         this.oneFlag = new Object();
         this.twoFlag = new Object();
         this.nexroom = new Vector.<CNextRoom>();
         this._lstar = VT.createVT(0);
         this._killNum = VT.createVT(0);
         this._killBossNum = VT.createVT(0);
         this._enternum = VT.createVT(0);
         this._curstate = VT.createVT(0);
         this._shuamFlag = VT.createVT(0);
         this._upstate = VT.createVT(0);
         this._overnum = VT.createVT(0);
         this.clsmpm = new CLSMPmanager();
         super();
         this.id = param1.id;
         this._name = param1._name;
         this.mapSound = param1._bsound;
         this._pFoot = param1._pFoot;
         this.rtoup = param1.rtoup;
         this.rlp = param1.rlp;
         this.rlm = param1.rlm;
         this.tztLv = VT.createVT((param1.tiaozhanglv as VT).getValue());
         this.type = param1._type;
         this.beffect = param1.beffect;
         this.rtoupb = param1.rtoupb;
         this.rlpb = param1.rlpb;
         this.oneMonser = param1.oneMonser;
         this.twoMonser = param1.twoMonser;
         this.oneFlag = param1.oneFlag;
         this.twoFlag = param1.twoFlag;
         this.resetFlag = param1.resetFlag;
         this.enterlimit = param1.enum;
         this.douHuaMcname = param1._douHuaMcname;
         var _loc2_:Array = param1.zhanaiwulist;
         this.zhangaiwuarr = new Array();
         if(_loc2_.length > 0)
         {
            _loc5_ = 0;
            while(_loc5_ < _loc2_.length)
            {
               this.zhangaiwuarr[_loc5_] = String(_loc2_[_loc5_]).split(",");
               _loc5_++;
            }
         }
         this.lstar = (param1.lstar as VT).getValue();
         var _loc3_:Array = param1.nexroom;
         for each(_loc4_ in _loc3_)
         {
            this.nexroom.push(new CNextRoom(_loc4_));
         }
         this.mapgood = param1.mapgood;
      }
      
      public function gmUpdate(param1:CLevel) : void
      {
         if(GM.frameTime - this.enterT == 65 && this.enternum == 1)
         {
            FlowInterface.npcTaskOpen();
            FlowInterface.isTaskOk();
         }
         if(GM.frameTime - this.enterT == 5 && this.enternum == 1)
         {
            if(this.douHuaMcname != "null")
            {
               XiaoXiaoManager.addCGX(new CGXFrame(LoaderManager.getMcByClassName(this.douHuaMcname),GM.cb));
            }
         }
         if((GM.frameTime - this.enterT) % 30 == 0)
         {
            GM.levelm.curLevel.changeMonsterArrow();
         }
         if(this.upstate == 0)
         {
            if(this.shuamFlag == 0)
            {
               if(this.clsmpm.gmUpdate())
               {
                  this.shuamFlag = 1;
               }
            }
            if(this.shuamFlag == 1 && this.curstate == 0)
            {
               if(this.isover())
               {
                  this.overHandle(param1);
               }
            }
            if(this.curstate == 0)
            {
               if(this.otherisover())
               {
                  this.overHandle(param1);
               }
            }
            if(this.curstate == 1)
            {
               this.CurstateOne(param1);
            }
         }
      }
      
      protected function CurstateOne(param1:CLevel) : void
      {
         var _loc2_:CNextRoom = null;
         for each(_loc2_ in this.nexroom)
         {
            if(_loc2_.ishit(GM.cp.getZx(),GM.cp.getZy()))
            {
               this.upstate = 1;
               param1.changeCurRoomByZou(_loc2_.nname);
            }
         }
      }
      
      private function isover() : Boolean
      {
         if(this.overnum == 0)
         {
            return this.objectisover(this.oneFlag);
         }
         return this.objectisover(this.twoFlag);
      }
      
      private function otherisover() : Boolean
      {
         if(this.overnum == 0)
         {
            return this.othersisover(this.oneFlag);
         }
         return this.othersisover(this.twoFlag);
      }
      
      protected function overHandle(param1:CLevel) : void
      {
         var _loc2_:CNextRoom = null;
         var _loc3_:String = null;
         var _loc4_:Point = null;
         var _loc5_:Class = null;
         var _loc6_:MovieClip = null;
         if(this.type == GS.a2)
         {
            FlowInterface.isGkOk(param1.name);
         }
         for each(_loc2_ in this.nexroom)
         {
            _loc3_ = "";
            switch(_loc2_.f)
            {
               case 1:
                  _loc4_ = new Point(50,300);
                  _loc3_ = "tishihou";
                  break;
               case 2:
                  _loc4_ = new Point(850,300);
                  _loc3_ = "tishiqian";
                  break;
               case 3:
                  _loc4_ = new Point(500,100);
                  _loc3_ = "tishishang";
                  break;
               case 4:
                  _loc4_ = new Point(500,500);
                  _loc3_ = "tishixia";
                  break;
               case 5:
                  _loc4_ = new Point(500,500);
                  _loc3_ = "tishikong";
                  break;
               default:
                  throw new Error("default error");
            }
            _loc5_ = LoaderManager.getSwfClass(_loc3_) as Class;
            _loc6_ = new _loc5_() as MovieClip;
            _loc6_.x = _loc4_.x;
            _loc6_.y = _loc4_.y;
            param1.getvs().addForthMc(_loc6_);
         }
         this.clsmpm.clearAll();
         GM.levelm.killAllM();
         this.curstate = 1;
         ++this.overnum;
         param1.curscene.updateDoorEnterScene(param1);
      }
      
      private function othersisover(param1:Object) : Boolean
      {
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc2_:String = param1.tj;
         var _loc3_:Boolean = false;
         switch(_loc2_)
         {
            case "boss":
               if(this.killBossNum >= param1.sl)
               {
                  _loc3_ = true;
               }
               break;
            case "cg":
               _loc4_ = Number(GM.cp.getZx());
               _loc5_ = Number(GM.cp.getZy());
               if(_loc4_ > param1.lx && _loc4_ < param1.rx && _loc5_ > param1.ly && _loc5_ < param1.ry)
               {
                  _loc3_ = true;
               }
         }
         return _loc3_;
      }
      
      private function objectisover(param1:Object) : Boolean
      {
         var _loc2_:String = param1.tj;
         var _loc3_:Boolean = false;
         switch(_loc2_)
         {
            case "qg":
               if(GM.levelm.getMonsterNum() == 0)
               {
                  _loc3_ = true;
               }
         }
         return _loc3_;
      }
      
      private function clsmpInit(param1:Array) : void
      {
         var _loc2_:String = null;
         var _loc3_:Object = null;
         this.clsmpm.clearAll();
         for each(_loc2_ in param1)
         {
            _loc3_ = LevelDataManager.getMBO(_loc2_ + this.lstar);
            switch(_loc3_.tj.tj)
            {
               case "null":
                  if(_loc3_.tj.bo == 1)
                  {
                     this.clsmpm.addBo(new CLSMP(_loc3_.bo));
                  }
                  else if(_loc3_.tj.bo == 2)
                  {
                     this.clsmpm.addother(new CLSMP(_loc3_.bo));
                  }
                  break;
               case "sj":
                  if(_loc3_.tj.jl > Math.random() * GS.a100)
                  {
                     if(_loc3_.tj.bo == 1)
                     {
                        this.clsmpm.addBo(new CLSMP(_loc3_.bo));
                     }
                     else if(_loc3_.tj.bo == 2)
                     {
                        this.clsmpm.addother(new CLSMP(_loc3_.bo));
                     }
                  }
                  break;
               case "lv":
                  break;
               case "rw":
                  if(FlowInterface.isTaskIngById(_loc3_.tj.id))
                  {
                     if(_loc3_.tj.bo == 1)
                     {
                        this.clsmpm.addBo(new CLSMP(_loc3_.bo));
                     }
                     else if(_loc3_.tj.bo == 2)
                     {
                        this.clsmpm.addother(new CLSMP(_loc3_.bo));
                     }
                  }
            }
         }
      }
      
      public function enterRoom(param1:CLevel) : void
      {
         var _loc2_:Array = null;
         var _loc3_:int = 0;
         if(this.zhangaiwuarr.length > 0)
         {
            _loc3_ = 0;
            while(_loc3_ < this.zhangaiwuarr.length)
            {
               ZtDFFactory.createZShiTou(this.zhangaiwuarr[_loc3_][2],this.zhangaiwuarr[_loc3_][0],this.zhangaiwuarr[_loc3_][1]);
               _loc3_++;
            }
         }
         Main.sg.focus = Main.self;
         SoundManager.playSenceSound(this.mapSound);
         this.enterT = GM.frameTime;
         this.killBossNum = 0;
         this.killNum = 0;
         ++this.enternum;
         this.shuamFlag = 0;
         this.upstate = 0;
         for each(_loc2_ in this.mapgood)
         {
            GM.levelm.addDiaoLougood(FlowInterface.getGoodsById((_loc2_[0] as VT).getValue()),(_loc2_[1] as VT).getValue(),(_loc2_[2] as VT).getValue());
         }
         if(this.enterlimit < this.enternum)
         {
            this.shuamFlag = 1;
            this.curstate = 1;
            this.clsmpm.clearAll();
         }
         else if(this.overnum == 0)
         {
            this.curstate = 0;
            this.clsmpInit(this.oneMonser);
         }
         else
         {
            if(this.resetFlag == 1)
            {
               this.curstate = 0;
            }
            else
            {
               this.curstate = 1;
            }
            this.clsmpInit(this.twoMonser);
         }
         Czhujiemian.self.hideTQ();
      }
      
      public function exitRoom() : void
      {
         GM.levelm.clearDiaoLouGood();
         GM.levelm.clearZtdfShiTou();
         this.clsmpm.clearAll();
      }
      
      public function exitLevelClear() : void
      {
         this.oneMonser = null;
         this.twoMonser = null;
         this.oneFlag = null;
         this.twoFlag = null;
         this.mapgood = null;
         this.zhangaiwuarr = null;
         GM.levelm.clearDiaoLouGood();
         GM.levelm.clearZtdfShiTou();
         this.nexroom.length = 0;
         this.clsmpm.clearAll();
         this.rtoup = null;
         this.rlp = null;
         this.rlm = null;
      }
      
      public function getrtoup() : Array
      {
         if(this.beffect == 0)
         {
            if(this.curstate == 0)
            {
               return this.rtoup;
            }
            return this.rtoupb;
         }
         if(this.curstate == 0)
         {
            return this.pTools(this.rtoup);
         }
         return this.pTools(this.rtoupb);
      }
      
      public function getrlp() : Array
      {
         if(this.beffect == 0)
         {
            if(this.curstate == 0)
            {
               return this.rlp;
            }
            return this.rlpb;
         }
         if(this.curstate == 0)
         {
            return this.pTools(this.rlp);
         }
         return this.pTools(this.rlpb);
      }
      
      private function pTools(param1:Array) : Array
      {
         var _loc2_:Array = new Array();
         var _loc3_:Point = GM.levelm.gPointChangeLevel(new Point(0,0));
         var _loc4_:Point = GM.levelm.gPointChangeLevel(new Point(GM.vw,GM.vh));
         if(param1[0] == "p")
         {
            _loc2_[_loc2_.length] = _loc3_.x;
         }
         else
         {
            _loc2_[_loc2_.length] = param1[0];
         }
         if(param1[1] == "p")
         {
            _loc2_[_loc2_.length] = _loc4_.x;
         }
         else
         {
            _loc2_[_loc2_.length] = param1[1];
         }
         if(param1[2] == "p")
         {
            _loc2_[_loc2_.length] = _loc3_.y;
         }
         else
         {
            _loc2_[_loc2_.length] = param1[2];
         }
         if(param1[3] == "p")
         {
            _loc2_[_loc2_.length] = _loc4_.y;
         }
         else
         {
            _loc2_[_loc2_.length] = param1[3];
         }
         return _loc2_;
      }
      
      public function getrlm() : Array
      {
         return this.rlm;
      }
      
      public function addKillNum(param1:int) : void
      {
         if(this.curstate == 0)
         {
            ++this.killNum;
            GM.levelm.curLevel.addLevelKillMNum();
            if(param1 == GS.a10)
            {
               ++this.killBossNum;
            }
         }
      }
      
      public function get curstate() : int
      {
         return this._curstate.getValue();
      }
      
      public function set curstate(param1:int) : void
      {
         this._curstate.setValue(param1);
      }
      
      public function get shuamFlag() : int
      {
         return this._shuamFlag.getValue();
      }
      
      public function set shuamFlag(param1:int) : void
      {
         this._shuamFlag.setValue(param1);
      }
      
      public function get overnum() : int
      {
         return this._overnum.getValue();
      }
      
      public function set overnum(param1:int) : void
      {
         this._overnum.setValue(param1);
      }
      
      public function get upstate() : int
      {
         return this._upstate.getValue();
      }
      
      public function set upstate(param1:int) : void
      {
         this._upstate.setValue(param1);
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      public function set name(param1:String) : void
      {
         this._name = param1;
      }
      
      public function get type() : int
      {
         return this._type.getValue();
      }
      
      public function set type(param1:int) : void
      {
         this._type.setValue(param1);
      }
      
      public function get pFoot() : Number
      {
         return this._pFoot;
      }
      
      public function set pFoot(param1:Number) : void
      {
         this._pFoot = param1;
      }
      
      public function get enterlimit() : int
      {
         return this._enterlimit.getValue();
      }
      
      public function set enterlimit(param1:int) : void
      {
         this._enterlimit.setValue(param1);
      }
      
      public function get enternum() : int
      {
         return this._enternum.getValue();
      }
      
      public function set enternum(param1:int) : void
      {
         this._enternum.setValue(param1);
      }
      
      public function get killBossNum() : int
      {
         return this._killBossNum.getValue();
      }
      
      public function set killBossNum(param1:int) : void
      {
         this._killBossNum.setValue(param1);
      }
      
      public function get killNum() : int
      {
         return this._killNum.getValue();
      }
      
      public function set killNum(param1:int) : void
      {
         this._killNum.setValue(param1);
      }
      
      public function get lstar() : int
      {
         return this._lstar.getValue();
      }
      
      public function set lstar(param1:int) : void
      {
         this._lstar.setValue(param1);
      }
   }
}

