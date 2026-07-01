package hotpointgame.ginit
{
   import flash.display.*;
   import flash.events.*;
   
   public class McBtnArrow
   {
      
      private var mc:MovieClip;
      
      private var maxlevel:int = 4;
      
      private var maxl:int = 0;
      
      private var mccur:int = 1;
      
      private var lB:McBtn;
      
      private var rB:McBtn;
      
      public function McBtnArrow(param1:MovieClip, param2:int = 0, param3:int = 4)
      {
         super();
         this.mc = param1;
         this.maxlevel = param3;
         this.maxl = param2;
         if(this.maxlevel == 4)
         {
            if(this.maxl >= 3)
            {
               this.lB = new McBtn(this.mc["xuannandub"]);
            }
            else
            {
               this.lB = new McBtn(this.mc["xuannandub"],4);
            }
            if(this.maxl >= 1)
            {
               this.rB = new McBtn(this.mc["xuannanduc"]);
            }
            else
            {
               this.rB = new McBtn(this.mc["xuannanduc"],4);
            }
         }
         else if(this.maxlevel == 2)
         {
            if(this.maxl >= 1)
            {
               this.lB = new McBtn(this.mc["xuannandub"]);
            }
            else
            {
               this.lB = new McBtn(this.mc["xuannandub"],4);
            }
            if(this.maxl >= 1)
            {
               this.rB = new McBtn(this.mc["xuannanduc"]);
            }
            else
            {
               this.rB = new McBtn(this.mc["xuannanduc"],4);
            }
         }
         (this.mc["xuannandud"] as MovieClip).gotoAndStop(this.mccur);
         this.mc.addEventListener(MouseEvent.CLICK,this.clickH);
      }
      
      public function remove() : void
      {
         this.mc.removeEventListener(MouseEvent.CLICK,this.clickH);
         this.lB.remove();
         this.lB = null;
         this.rB.remove();
         this.rB = null;
         this.mc = null;
      }
      
      public function changeCur(param1:int) : void
      {
         this.mccur = param1;
         (this.mc["xuannandud"] as MovieClip).gotoAndStop(this.mccur);
         this.changeLR();
      }
      
      private function clickH(param1:MouseEvent) : void
      {
         if(param1.target.name != null)
         {
            if(this.maxlevel == 4)
            {
               if(param1.target.name == "xuannandub")
               {
                  if(this.lB.getcurstate() != 4)
                  {
                     if(this.mccur == 1)
                     {
                        this.mccur = 4;
                     }
                     else
                     {
                        --this.mccur;
                     }
                     (this.mc["xuannandud"] as MovieClip).gotoAndStop(this.mccur);
                     this.changeLR();
                  }
               }
               if(param1.target.name == "xuannanduc")
               {
                  if(this.rB.getcurstate() != 4)
                  {
                     if(this.mccur == 4)
                     {
                        this.mccur = 1;
                     }
                     else
                     {
                        ++this.mccur;
                     }
                     (this.mc["xuannandud"] as MovieClip).gotoAndStop(this.mccur);
                     this.changeLR();
                  }
               }
            }
            else if(this.maxlevel == 2)
            {
               if(param1.target.name == "xuannandub")
               {
                  if(this.lB.getcurstate() != 4)
                  {
                     if(this.mccur == 1)
                     {
                        this.mccur = 2;
                     }
                     else
                     {
                        --this.mccur;
                     }
                     (this.mc["xuannandud"] as MovieClip).gotoAndStop(this.mccur);
                     this.changeLR();
                  }
               }
               if(param1.target.name == "xuannanduc")
               {
                  if(this.rB.getcurstate() != 4)
                  {
                     if(this.mccur == 2)
                     {
                        this.mccur = 1;
                     }
                     else
                     {
                        ++this.mccur;
                     }
                     (this.mc["xuannandud"] as MovieClip).gotoAndStop(this.mccur);
                     this.changeLR();
                  }
               }
            }
         }
      }
      
      private function changeLR() : void
      {
         if(this.maxlevel == 4)
         {
            switch(this.mccur)
            {
               case 1:
                  if(this.maxl >= 3)
                  {
                     this.lB.clickCancel();
                  }
                  else
                  {
                     this.lB.clickDisable();
                  }
                  if(this.maxl >= 1)
                  {
                     this.rB.clickCancel();
                  }
                  else
                  {
                     this.rB.clickDisable();
                  }
                  break;
               case 2:
                  this.lB.clickCancel();
                  if(this.maxl >= 2)
                  {
                     this.rB.clickCancel();
                  }
                  else
                  {
                     this.rB.clickDisable();
                  }
                  break;
               case 3:
                  this.lB.clickCancel();
                  if(this.maxl >= 3)
                  {
                     this.rB.clickCancel();
                  }
                  else
                  {
                     this.rB.clickDisable();
                  }
                  break;
               case 4:
                  this.lB.clickCancel();
                  this.rB.clickCancel();
            }
         }
         else if(this.maxlevel == 2)
         {
            switch(this.mccur)
            {
               case 1:
                  if(this.maxl >= 1)
                  {
                     this.lB.clickCancel();
                  }
                  else
                  {
                     this.lB.clickDisable();
                  }
                  if(this.maxl >= 1)
                  {
                     this.rB.clickCancel();
                  }
                  else
                  {
                     this.rB.clickDisable();
                  }
                  break;
               case 2:
                  this.lB.clickCancel();
                  this.rB.clickCancel();
            }
         }
      }
      
      public function getCur() : int
      {
         return this.mccur;
      }
   }
}

