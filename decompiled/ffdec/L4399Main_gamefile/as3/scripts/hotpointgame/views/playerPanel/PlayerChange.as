package hotpointgame.views.playerPanel
{
   import flash.display.MovieClip;
   import hotpointgame.Control.*;
   import hotpointgame.models.bag.*;
   import hotpointgame.utils.gameloader.*;
   
   public class PlayerChange extends MovieClip
   {
      
      private static var _instance:PlayerChange;
      
      private var changePanel:MovieClip;
      
      private var _slot:EquipSlot;
      
      public function PlayerChange()
      {
         super();
      }
      
      public static function createPlayerChange() : PlayerChange
      {
         if(_instance == null)
         {
            _instance = new PlayerChange();
            _instance._slot = BagFactory.equipSlot;
         }
         return _instance;
      }
      
      public function initChange(param1:Number, param2:Number, param3:Object = null) : void
      {
         var _loc4_:Object = null;
         this.x = param1;
         this.y = param2;
         if(param3 == null)
         {
            _loc4_ = LoaderManager.getSwfClass("P_" + FlowInterface.getJobByRole()) as Class;
            this.changePanel = new _loc4_();
            addChild(this.changePanel);
            this.init();
            this.changeRoleMc();
         }
         else
         {
            _loc4_ = LoaderManager.getSwfClass("P_" + param3["jo"]) as Class;
            this.changePanel = new _loc4_();
            addChild(this.changePanel);
            this.init();
            this.changeRoleMcXX(param3);
         }
      }
      
      public function close() : void
      {
         removeChild(this.changePanel);
      }
      
      private function init() : void
      {
         var _loc1_:uint = 0;
         while(_loc1_ < 16)
         {
            if(this.changePanel["bh_" + _loc1_])
            {
               this.changePanel["bh_" + _loc1_].gotoAndStop(1);
               if(_loc1_ == 8)
               {
                  this.changePanel["bh_" + 17].gotoAndStop(1);
               }
               else if(_loc1_ == 10)
               {
                  this.changePanel["bh_" + 18].gotoAndStop(1);
               }
               else if(_loc1_ == 12)
               {
                  this.changePanel["bh_" + 19].gotoAndStop(1);
               }
            }
            _loc1_++;
         }
      }
      
      public function changeRoleMc() : void
      {
         var _loc1_:uint = 0;
         while(_loc1_ < 16)
         {
            if(_loc1_ == 0 || _loc1_ == 1 || _loc1_ == 2 || _loc1_ == 5 || _loc1_ == 8 || _loc1_ == 10 || _loc1_ == 11 || _loc1_ == 12)
            {
               this.changePanel["bh_" + _loc1_]["playerhuwan"].gotoAndPlay(1);
               if(_loc1_ == 8)
               {
                  this.changePanel["bh_" + 17]["playerhuwan"].gotoAndPlay(1);
               }
               else if(_loc1_ == 10)
               {
                  this.changePanel["bh_" + 18]["playerhuwan"].gotoAndPlay(1);
               }
               else if(_loc1_ == 12)
               {
                  this.changePanel["bh_" + 19]["playerhuwan"].gotoAndPlay(1);
               }
               this.changePanel["bh_" + _loc1_].visible = true;
               if(this._slot.getGoods(_loc1_) != null)
               {
                  this.changePanel["bh_" + _loc1_].gotoAndStop(this._slot.getGoods(_loc1_).getFrame());
                  if(_loc1_ == 8)
                  {
                     if(this._slot.getYc(_loc1_))
                     {
                        this.changePanel["bh_" + 17].gotoAndStop(this._slot.getGoods(_loc1_).getFrame());
                        this.changePanel["bh_" + 1].gotoAndStop(1);
                        this.changePanel["bh_" + 2].gotoAndStop(1);
                        this.changePanel["bh_" + 5].gotoAndStop(1);
                        this.changePanel["bh_" + 1].visible = false;
                        this.changePanel["bh_" + 2].visible = false;
                        this.changePanel["bh_" + 5].visible = false;
                     }
                     else
                     {
                        this.changePanel["bh_" + _loc1_].gotoAndStop(1);
                        this.changePanel["bh_" + 17].gotoAndStop(1);
                     }
                  }
                  else if(_loc1_ == 10)
                  {
                     if(this._slot.getYc(_loc1_))
                     {
                        this.changePanel["bh_" + 18].gotoAndStop(this._slot.getGoods(_loc1_).getFrame());
                     }
                     else
                     {
                        this.changePanel["bh_" + 18].gotoAndStop(1);
                        this.changePanel["bh_" + 10].gotoAndStop(1);
                     }
                  }
                  else if(_loc1_ == 11)
                  {
                     if(this._slot.getYc(_loc1_))
                     {
                        this.changePanel["bh_" + 0].gotoAndStop(1);
                        this.changePanel["bh_" + 0].visible = false;
                     }
                     else
                     {
                        this.changePanel["bh_" + 11].gotoAndStop(1);
                     }
                  }
                  else if(_loc1_ == 12)
                  {
                     if(!this._slot.getYc(_loc1_))
                     {
                        this.changePanel["bh_" + 12].gotoAndStop(1);
                        this.changePanel["bh_" + 19].gotoAndStop(1);
                     }
                     else
                     {
                        this.changePanel["bh_" + 19].gotoAndStop(this._slot.getGoods(_loc1_).getFrame());
                     }
                  }
               }
               else
               {
                  this.changePanel["bh_" + _loc1_].gotoAndStop(1);
                  if(_loc1_ == 8)
                  {
                     this.changePanel["bh_" + 17].gotoAndStop(1);
                  }
                  else if(_loc1_ == 10)
                  {
                     this.changePanel["bh_" + 18].gotoAndStop(1);
                  }
                  else if(_loc1_ == 12)
                  {
                     this.changePanel["bh_" + 19].gotoAndStop(1);
                  }
               }
            }
            _loc1_++;
         }
      }
      
      private function changeRoleMcXX(param1:Object) : void
      {
         var _loc2_:uint = 0;
         while(_loc2_ < 16)
         {
            if(_loc2_ == 0 || _loc2_ == 1 || _loc2_ == 2 || _loc2_ == 5 || _loc2_ == 8 || _loc2_ == 10 || _loc2_ == 11 || _loc2_ == 12)
            {
               this.changePanel["bh_" + _loc2_]["playerhuwan"].gotoAndPlay(1);
               if(_loc2_ == 8)
               {
                  this.changePanel["bh_" + 17]["playerhuwan"].gotoAndPlay(1);
               }
               else if(_loc2_ == 10)
               {
                  this.changePanel["bh_" + 18]["playerhuwan"].gotoAndPlay(1);
               }
               else if(_loc2_ == 12)
               {
                  this.changePanel["bh_" + 19]["playerhuwan"].gotoAndPlay(1);
               }
               this.changePanel["bh_" + _loc2_].visible = true;
               if(param1["fe"][_loc2_] != -1)
               {
                  this.changePanel["bh_" + _loc2_].gotoAndStop(param1["fe"][_loc2_]);
                  if(_loc2_ == 8)
                  {
                     this.changePanel["bh_" + 17].gotoAndStop(param1["fe"][_loc2_]);
                     this.changePanel["bh_" + 1].gotoAndStop(1);
                     this.changePanel["bh_" + 2].gotoAndStop(1);
                     this.changePanel["bh_" + 5].gotoAndStop(1);
                     this.changePanel["bh_" + 1].visible = false;
                     this.changePanel["bh_" + 2].visible = false;
                     this.changePanel["bh_" + 5].visible = false;
                  }
                  else if(_loc2_ == 10)
                  {
                     this.changePanel["bh_" + 18].gotoAndStop(param1["fe"][_loc2_]);
                  }
                  else if(_loc2_ == 11)
                  {
                     this.changePanel["bh_" + 0].gotoAndStop(1);
                     this.changePanel["bh_" + 0].visible = false;
                  }
                  else if(_loc2_ == 12)
                  {
                     this.changePanel["bh_" + 19].gotoAndStop(param1["fe"][_loc2_]);
                  }
               }
               else
               {
                  this.changePanel["bh_" + _loc2_].gotoAndStop(1);
                  if(_loc2_ == 8)
                  {
                     this.changePanel["bh_" + 17].gotoAndStop(1);
                  }
                  else if(_loc2_ == 10)
                  {
                     this.changePanel["bh_" + 18].gotoAndStop(1);
                  }
                  else if(_loc2_ == 12)
                  {
                     this.changePanel["bh_" + 19].gotoAndStop(1);
                  }
               }
            }
            _loc2_++;
         }
      }
   }
}

