package hotpointgame.views.shipPanel
{
   import hotpointgame.common.*;
   
   public class ShipData
   {
      
      public static var tl:VT = VT.createVT(GS.a100);
      
      public static var nj:VT = VT.createVT(GS.a100);
      
      public static var opBo:Boolean = false;
      
      public static var level:VT = VT.createVT(GS.a1);
      
      public static var xlLevel:VT = VT.createVT(GS.a1);
      
      public static var gsArr:Array = [VT.createVT(GS.a331144 + GS.a3),VT.createVT(GS.a331144 + GS.a4)];
      
      public static var gsNum:Array = [VT.createVT(GS.a3),VT.createVT(GS.a3)];
      
      public static var levelMax:VT = VT.createVT(GS.a43);
      
      public static var xlMx:VT = VT.createVT(GS.a18);
      
      public function ShipData()
      {
         super();
      }
      
      public static function initData() : void
      {
         tl.setValue(GS.a100);
         nj.setValue(GS.a100);
         level.setValue(GS.a1);
         xlLevel.setValue(GS.a1);
         opBo = false;
      }
      
      public static function save() : Object
      {
         var _loc1_:Object = new Object();
         _loc1_["tl"] = tl.getValue();
         _loc1_["nj"] = nj.getValue();
         _loc1_["lv"] = level.getValue();
         _loc1_["xl"] = xlLevel.getValue();
         _loc1_["op"] = opBo;
         return _loc1_;
      }
      
      public static function read(param1:Object) : void
      {
         tl.setValue(param1["tl"]);
         nj.setValue(param1["nj"]);
         level.setValue(param1["lv"]);
         xlLevel.setValue(param1["xl"]);
         opBo = param1["op"];
      }
      
      public static function deleteTl(param1:Number) : void
      {
         if(param1 < tl.getValue())
         {
            tl.setValue(tl.getValue() - param1);
         }
         else
         {
            tl.setValue(GS.a0);
         }
      }
      
      public static function addTl(param1:Number) : void
      {
         if(tl.getValue() + param1 < GS.a100)
         {
            tl.setValue(tl.getValue() + param1);
         }
         else
         {
            tl.setValue(GS.a100);
         }
      }
      
      public static function deleteNj(param1:Number) : void
      {
         if(param1 < nj.getValue())
         {
            nj.setValue(nj.getValue() - param1);
         }
         else
         {
            nj.setValue(GS.a0);
         }
      }
      
      public static function addNj() : void
      {
         nj.setValue(GS.a100);
      }
      
      public static function addLv() : void
      {
         if(level.getValue() < levelMax.getValue())
         {
            level.setValue(level.getValue() + GS.a1);
         }
      }
      
      public static function addXl() : void
      {
         xlLevel.setValue(xlLevel.getValue() + GS.a1);
      }
   }
}

