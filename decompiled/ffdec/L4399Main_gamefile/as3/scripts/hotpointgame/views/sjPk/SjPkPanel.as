package hotpointgame.views.sjPk
{
   import flash.display.MovieClip;
   import flash.text.*;
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   import hotpointgame.common.basicBtn.*;
   import hotpointgame.common.event.*;
   import hotpointgame.common.newBasicBtn.*;
   import hotpointgame.utils.*;
   import hotpointgame.utils.gameloader.*;
   import hotpointgame.views.playerPanel.*;
   
   public class SjPkPanel extends MovieClip
   {
      
      private static var _instance:SjPkPanel;
      
      private static var objSx:Object;
      
      private static var cbx:Number = -1;
      
      private var _playerChangeMc:PlayerChange;
      
      private var sjmc:MovieClip;
      
      private var _state:Number = GS.a0;
      
      private var tbBoxArr:Array = [];
      
      private var currnetRoleMc:MovieClip;
      
      private var typeBtn:SameChangeBtnX;
      
      private var smTypeBtn:SameChangeBtnX;
      
      private var posStrArr:Array = ["武器","铠甲","腰带","机甲兽型","吊坠","护腕","指环","机甲人型","时装","肩膀","武器时装","炫光","机甲挂饰","浮游机炮","暂未开放","暂未开放"];
      
      public function SjPkPanel()
      {
         super();
      }
      
      public static function open(param1:Object) : void
      {
         var _loc2_:Array = null;
         objSx = param1;
         if(_instance == null)
         {
            if(GM.loaderM.keYiUse())
            {
               cbx = -1;
               _loc2_ = new Array();
               _loc2_.push("sjpkpanel");
               _loc2_.push("t_box");
               _loc2_.push("pmodes1");
               _loc2_.push("pmodes2");
               GM.loaderM.setLoadData(_loc2_);
               GM.loaderM.completeF = loadSjOver;
               GM.loaderM.startLoadDataJieM();
               return;
            }
            return;
         }
         _instance.initPanel();
      }
      
      public static function close() : void
      {
         cbx = 0;
         if(_instance != null && Boolean(_instance.visible))
         {
            _instance._playerChangeMc.close();
            _instance.removeEvent();
            _instance.visible = false;
         }
      }
      
      public static function loadSjOver() : void
      {
         var _loc1_:Object = null;
         var _loc2_:Object = null;
         var _loc3_:uint = 0;
         var _loc4_:CloseBtnX = null;
         var _loc5_:MovieClip = null;
         var _loc6_:GoodsBtnX = null;
         if(cbx == -1)
         {
            _instance = new SjPkPanel();
            _loc1_ = LoaderManager.getSwfClass("EquipPk") as Class;
            _instance.sjmc = new _loc1_();
            _instance.addChild(_instance.sjmc);
            _instance._playerChangeMc = PlayerChange.createPlayerChange();
            _loc2_ = LoaderManager.getSwfClass("T_Box") as Class;
            _loc3_ = 0;
            for(; _loc3_ < 17; _instance.tbBoxArr.push(_loc6_),_instance.sjmc.addChild(_loc6_),_loc3_++)
            {
               _loc5_ = new _loc2_();
               _loc5_.name = "e_" + _loc3_;
               if(_loc3_ < 8)
               {
                  _loc6_ = new GoodsBtnX(_loc5_,_instance.sjmc["d_" + _loc3_].x,_instance.sjmc["d_" + _loc3_].y);
                  continue;
               }
               switch(_loc3_)
               {
                  case 8:
                     _loc6_ = new GoodsBtnX(_loc5_,_instance.sjmc["d_" + 0].x,_instance.sjmc["d_" + 0].y);
                     break;
                  case 9:
                     _loc6_ = new GoodsBtnX(_loc5_,_instance.sjmc["d_" + 4].x,_instance.sjmc["d_" + 4].y);
                     break;
                  case 10:
                     _loc6_ = new GoodsBtnX(_loc5_,_instance.sjmc["d_" + 1].x,_instance.sjmc["d_" + 1].y);
                     break;
                  case 11:
                     _loc6_ = new GoodsBtnX(_loc5_,_instance.sjmc["d_" + 2].x,_instance.sjmc["d_" + 2].y);
                     break;
                  case 12:
                     _loc6_ = new GoodsBtnX(_loc5_,_instance.sjmc["d_" + 3].x,_instance.sjmc["d_" + 3].y);
                     break;
                  case 13:
                     _loc6_ = new GoodsBtnX(_loc5_,_instance.sjmc["d_" + 6].x,_instance.sjmc["d_" + 6].y);
                     break;
                  case 14:
                     _loc6_ = new GoodsBtnX(_loc5_,_instance.sjmc["d_" + 5].x,_instance.sjmc["d_" + 5].y);
                     break;
                  case 15:
                     _loc6_ = new GoodsBtnX(_loc5_,_instance.sjmc["d_" + 7].x,_instance.sjmc["d_" + 7].y);
                     break;
                  case 16:
                     _loc6_ = new GoodsBtnX(_loc5_,_instance.sjmc["d_" + 16].x,_instance.sjmc["d_" + 16].y);
               }
            }
            _instance.smTypeBtn = SameChangeBtnX.createSameChangeBtn([_instance.sjmc["sb_" + 0],_instance.sjmc["sb_" + 1]]);
            _instance.sjmc.addChild(_instance.smTypeBtn);
            _instance.typeBtn = SameChangeBtnX.createSameChangeBtn([_instance.sjmc["t_" + 0],_instance.sjmc["t_" + 1]]);
            _instance.sjmc.addChild(_instance.typeBtn);
            _loc4_ = new CloseBtnX(_instance.sjmc.close_0,_instance.sjmc.close_0.x,_instance.sjmc.close_0.y);
            _instance.sjmc.addChild(_loc4_);
            _loc3_ = 0;
            while(_loc3_ < 9)
            {
               (_instance.sjmc["txt_" + _loc3_] as TextField).embedFonts = true;
               (_instance.sjmc["txt_" + _loc3_] as TextField).defaultTextFormat = new TextFormat(GM.fzfont.fontName,15);
               _loc3_++;
            }
            _loc3_ = 0;
            while(_loc3_ < 6)
            {
               (_instance.sjmc["text_" + _loc3_] as TextField).embedFonts = true;
               (_instance.sjmc["text_" + _loc3_] as TextField).defaultTextFormat = new TextFormat(GM.fzfont.fontName,16);
               _loc3_++;
            }
            GM.bagJm.addChild(_instance);
            _instance.initPanel();
         }
      }
      
      private function initPanel() : void
      {
         this.visible = true;
         this._state = GS.a0;
         this.typeBtn.btnOk(this._state);
         this.smTypeBtn.btnOk(0);
         this.addEvent();
         this.initFrame();
         this.initText(GS.a0);
         addChild(this._playerChangeMc);
         this._playerChangeMc.initChange(463,173,objSx);
      }
      
      private function initText(param1:Number) : void
      {
         var _loc2_:String = null;
         var _loc3_:uint = 0;
         if(objSx["newne"] != null)
         {
            this.sjmc.name_tx.text = DeepCopyUtil.decode(objSx["newne"]);
         }
         else
         {
            this.sjmc.name_tx.text = objSx["ne"];
         }
         if(objSx["jo"] == 1)
         {
            _loc2_ = "绝影枪手";
         }
         else if(objSx["jo"] == 2)
         {
            _loc2_ = "炎蓝炮手";
         }
         this.sjmc.job_tx.text = _loc2_;
         this.sjmc.level_tx.text = "Lv." + objSx["lv"];
         this.sjmc.type_mc.gotoAndStop(param1 + 1);
         if(objSx["ca"] != -1)
         {
            this.sjmc.cwmx.gotoAndStop(objSx["ca"]);
            this.sjmc.cwmx.cw.gotoAndStop(objSx["cb"]);
         }
         else
         {
            this.sjmc.cwmx.gotoAndStop(1);
         }
         if(param1 == 0)
         {
            _loc3_ = 0;
            while(_loc3_ < 6)
            {
               this.sjmc["text_" + _loc3_].text = String(objSx["tx"][0][_loc3_]);
               _loc3_++;
            }
         }
         else if(param1 == 1)
         {
            _loc3_ = 0;
            while(_loc3_ < 6)
            {
               this.sjmc["text_" + _loc3_].text = String(objSx["tx"][1][_loc3_]);
               _loc3_++;
            }
         }
      }
      
      private function initFrame() : void
      {
         var _loc1_:uint = 0;
         if(this._state == 0)
         {
            _loc1_ = 0;
            while(_loc1_ < 16)
            {
               (this.tbBoxArr[_loc1_] as GoodsBtnX).getSmMc().t_txt.text = "";
               (this.tbBoxArr[_loc1_] as GoodsBtnX).getSmMc().mask_mc.gotoAndStop(1);
               (this.tbBoxArr[_loc1_] as GoodsBtnX).getSmMc().gx_mc.visible = false;
               (this.tbBoxArr[_loc1_] as GoodsBtnX).getSmMc().gotoAndStop(1);
               if(_loc1_ < 8)
               {
                  this.sjmc["txt_" + _loc1_].text = this.posStrArr[_loc1_];
                  if(objSx["fe"][_loc1_] != -1)
                  {
                     (this.tbBoxArr[_loc1_] as GoodsBtnX).visible = true;
                     (this.tbBoxArr[_loc1_] as GoodsBtnX).getSmMc().gotoAndStop(objSx["fe"][_loc1_]);
                  }
                  else
                  {
                     this.sjmc["txt_" + _loc1_].text = this.posStrArr[_loc1_];
                  }
               }
               else
               {
                  (this.tbBoxArr[_loc1_] as GoodsBtnX).visible = false;
                  (this.tbBoxArr[_loc1_] as GoodsBtnX).getSmMc().gotoAndStop(1);
               }
               _loc1_++;
            }
         }
         else if(this._state == 1)
         {
            _loc1_ = 0;
            while(_loc1_ < 16)
            {
               (this.tbBoxArr[_loc1_] as GoodsBtnX).getSmMc().t_txt.text = "";
               (this.tbBoxArr[_loc1_] as GoodsBtnX).getSmMc().mask_mc.gotoAndStop(1);
               (this.tbBoxArr[_loc1_] as GoodsBtnX).getSmMc().gx_mc.visible = false;
               (this.tbBoxArr[_loc1_] as GoodsBtnX).getSmMc().gotoAndStop(1);
               if(_loc1_ < 8)
               {
                  (this.tbBoxArr[_loc1_] as GoodsBtnX).visible = false;
                  (this.tbBoxArr[_loc1_] as GoodsBtnX).getSmMc().gotoAndStop(1);
               }
               else
               {
                  this.sjmc["txt_" + (_loc1_ - 8)].text = this.posStrArr[_loc1_];
                  if(objSx["fe"][_loc1_] != -1)
                  {
                     (this.tbBoxArr[_loc1_] as GoodsBtnX).visible = true;
                     (this.tbBoxArr[_loc1_] as GoodsBtnX).getSmMc().gotoAndStop(objSx["fe"][_loc1_]);
                  }
               }
               _loc1_++;
            }
         }
         (this.tbBoxArr[16] as GoodsBtnX).getSmMc().t_txt.text = "";
         (this.tbBoxArr[16] as GoodsBtnX).getSmMc().mask_mc.gotoAndStop(1);
         (this.tbBoxArr[16] as GoodsBtnX).getSmMc().gx_mc.visible = false;
         this.sjmc["txt_" + 8].text = "称号";
         if(objSx["fe"][16] != -1)
         {
            (this.tbBoxArr[16] as GoodsBtnX).visible = true;
            (this.tbBoxArr[16] as GoodsBtnX).getSmMc().gotoAndStop(objSx["fe"][16]);
         }
         else
         {
            (this.tbBoxArr[16] as GoodsBtnX).visible = false;
            (this.tbBoxArr[16] as GoodsBtnX).getSmMc().gotoAndStop(1);
         }
      }
      
      private function closeHandle(param1:BtnEvent) : void
      {
         close();
      }
      
      private function addEvent() : void
      {
         addEventListener(BtnEvent.DO_CLOSE,this.closeHandle);
         addEventListener(BtnEvent.DO_SAME_CHANGE,this.changeHandle);
      }
      
      private function changeHandle(param1:BtnEvent) : void
      {
         if(param1.name == "t")
         {
            this._state = param1.id;
            this.initFrame();
         }
         else if(param1.name == "sb")
         {
            this.initText(param1.id);
         }
      }
      
      private function removeEvent() : void
      {
         removeEventListener(BtnEvent.DO_CLOSE,this.closeHandle);
         removeEventListener(BtnEvent.DO_SAME_CHANGE,this.changeHandle);
      }
   }
}

