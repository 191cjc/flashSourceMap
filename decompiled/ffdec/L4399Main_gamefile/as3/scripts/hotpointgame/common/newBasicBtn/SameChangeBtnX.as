package hotpointgame.common.newBasicBtn
{
   import flash.display.MovieClip;
   import hotpointgame.common.event.*;
   
   public class SameChangeBtnX extends MovieClip
   {
      
      private var _state:Boolean;
      
      private var _type:Number = 0;
      
      private var _btnArr:Array = [];
      
      private var _clickArr:Array = [];
      
      private var _clickNum:Number = 0;
      
      public function SameChangeBtnX()
      {
         super();
      }
      
      public static function createSameChangeBtn(param1:Array) : SameChangeBtnX
      {
         var _loc2_:SameChangeBtnX = new SameChangeBtnX();
         _loc2_.initBtn(param1);
         return _loc2_;
      }
      
      public function set state(param1:Boolean) : void
      {
         this._state = param1;
      }
      
      public function set type(param1:Number) : void
      {
         this._type = param1;
      }
      
      public function set clickNum(param1:Number) : void
      {
         this._clickNum = param1;
      }
      
      private function initBtn(param1:Array) : void
      {
         var _loc3_:BasicBtnX = null;
         var _loc2_:uint = 0;
         while(_loc2_ < param1.length)
         {
            _loc3_ = new ChangeBtnX(param1[_loc2_],param1[_loc2_].x,param1[_loc2_].y);
            this._btnArr.push(_loc3_);
            this._clickArr.push(_loc3_.getIsClick());
            param1[_loc2_].addEventListener(BtnEvent.DO_CHANGE,this.changeHandle);
            addChild(_loc3_);
            _loc2_++;
         }
      }
      
      private function changeHandle(param1:BtnEvent) : void
      {
         this.btnOk(param1.id);
         dispatchEvent(new BtnEvent(BtnEvent.DO_SAME_CHANGE,param1.id,param1.name));
      }
      
      public function btnOk(param1:Number) : void
      {
         var _loc2_:uint = 0;
         if(this._type == 0)
         {
            _loc2_ = 0;
            while(_loc2_ < this._btnArr.length)
            {
               if(param1 == _loc2_)
               {
                  if(!this._state)
                  {
                     (this._btnArr[_loc2_] as ChangeBtnX).isClick = true;
                     this._clickArr[_loc2_] = true;
                  }
                  else if((this._btnArr[_loc2_] as ChangeBtnX).getIsClick() == true)
                  {
                     (this._btnArr[_loc2_] as ChangeBtnX).isClick = false;
                     this._clickArr[_loc2_] = false;
                  }
                  else
                  {
                     (this._btnArr[_loc2_] as ChangeBtnX).isClick = true;
                     this._clickArr[_loc2_] = true;
                  }
               }
               else
               {
                  (this._btnArr[_loc2_] as ChangeBtnX).isClick = false;
                  this._clickArr[_loc2_] = false;
               }
               _loc2_++;
            }
         }
         else if(this._type == 1)
         {
            if((this._btnArr[param1] as ChangeBtnX).getIsClick() == true)
            {
               (this._btnArr[param1] as ChangeBtnX).isClick = false;
               this._clickArr[param1] = false;
            }
            else
            {
               (this._btnArr[param1] as ChangeBtnX).isClick = true;
               this._clickArr[param1] = true;
            }
         }
      }
      
      public function getClickArr() : Array
      {
         return this._clickArr;
      }
      
      public function czArr() : void
      {
         var _loc1_:uint = 0;
         while(_loc1_ < this._clickArr.length)
         {
            this._btnArr[_loc1_].isClick = false;
            this._clickArr[_loc1_] = false;
            _loc1_++;
         }
      }
      
      public function setClick(param1:Number, param2:Boolean) : void
      {
         this._btnArr[param1].isClick = param2;
         this._clickArr[param1] = param2;
      }
      
      public function getClick(param1:Number) : Boolean
      {
         return this._clickArr[param1];
      }
      
      public function closeOrOpenBtnById(param1:Number, param2:Number) : void
      {
         var _loc3_:uint = 0;
         while(_loc3_ < this._btnArr.length)
         {
            if(param1 == _loc3_)
            {
               if(param2 == 0)
               {
                  (this._btnArr[_loc3_] as ChangeBtnX).okBtn = false;
                  break;
               }
               if(param2 == 1)
               {
                  (this._btnArr[_loc3_] as ChangeBtnX).okBtn = true;
                  break;
               }
            }
            _loc3_++;
         }
      }
   }
}

