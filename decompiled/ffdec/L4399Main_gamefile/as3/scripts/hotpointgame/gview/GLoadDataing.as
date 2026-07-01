package hotpointgame.gview
{
   import flash.display.*;
   import flash.events.*;
   import flash.utils.*;
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   import hotpointgame.utils.*;
   
   public class GLoadDataing
   {
      
      private static var self:GLoadDataing = new GLoadDataing();
      
      private static var _curs:VT = VT.createVT(0);
      
      private static var _ocFlag:VT = VT.createVT(0);
      
      private var mc:MovieClip;
      
      public function GLoadDataing()
      {
         super();
         var _loc1_:Class = ClassGet.getClassByName("chushihua");
         this.mc = new _loc1_() as MovieClip;
         this.mc.stop();
      }
      
      public static function open() : void
      {
         if(curs == 0)
         {
            self.reset();
         }
      }
      
      public static function close() : void
      {
         self.leave();
      }
      
      public static function get curs() : int
      {
         return _curs.getValue();
      }
      
      public static function set curs(param1:int) : void
      {
         _curs.setValue(param1);
      }
      
      public static function get ocFlag() : int
      {
         return _ocFlag.getValue();
      }
      
      public static function set ocFlag(param1:int) : void
      {
         _ocFlag.setValue(param1);
      }
      
      public function reset() : void
      {
         if(this.mc == null)
         {
            GM.aSaveData.checkfm.addFlag(GS.a50,0);
            GM.testapi.saveDataBeforeNoState();
            return;
         }
         ocFlag = 0;
         curs = GS.a1;
         this.mc.x = 0;
         this.mc.y = 0;
         this.mc.addEventListener(Event.ENTER_FRAME,this.FrameH);
         GM.fone.addChild(this.mc);
      }
      
      public function leave() : void
      {
         if(curs == GS.a1)
         {
            curs = 0;
            this.mc.x = 19563;
            this.mc.y = 29563;
            this.mc.removeEventListener(Event.ENTER_FRAME,this.FrameH);
            GM.fone.removeChild(this.mc);
            this.mc = null;
         }
      }
      
      private function FrameH(param1:Event = null) : void
      {
         var _loc2_:uint = uint(getTimer());
         ++ocFlag;
         switch(ocFlag)
         {
            case GS.a14:
               GameDataInit.xmlDataInit();
               break;
            case GS.a24:
               GameDataInit.xmlDataInitByMskill();
               break;
            case GS.a28:
               GameDataInit.xmlDataInitByBullet();
               break;
            case GS.a32:
               this.leave();
               GM.baseDatainit();
         }
      }
   }
}

