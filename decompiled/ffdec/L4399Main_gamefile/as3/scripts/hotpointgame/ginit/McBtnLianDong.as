package hotpointgame.ginit
{
   public class McBtnLianDong
   {
      
      private var btnOL:Object = new Object();
      
      private var btnON:Object = new Object();
      
      private var curbtn:String = "";
      
      public function McBtnLianDong()
      {
         super();
      }
      
      public function addBtnLianDong(param1:McBtn) : void
      {
         this.btnOL[param1.bname] = param1;
         this.btnON[param1.bname] = param1;
      }
      
      public function addBtnNoLian(param1:McBtn) : void
      {
         this.btnON[param1.bname] = param1;
      }
      
      public function isFlase(param1:String) : Boolean
      {
         return this.btnON.hasOwnProperty(param1);
      }
      
      public function btnByClick(param1:String) : void
      {
         (this.btnON[param1] as McBtn).clickBy();
         if(this.curbtn != "" && this.curbtn != param1 && this.btnOL[param1] != null)
         {
            (this.btnOL[this.curbtn] as McBtn).clickCancel();
            this.curbtn = param1;
         }
         this.curbtn = param1;
      }
      
      public function getMcBtnByName(param1:String) : McBtn
      {
         return this.btnON[param1] as McBtn;
      }
      
      public function remove() : void
      {
         var _loc1_:McBtn = null;
         for each(_loc1_ in this.btnON)
         {
            _loc1_.remove();
         }
         this.btnOL = null;
         this.btnON = null;
      }
   }
}

