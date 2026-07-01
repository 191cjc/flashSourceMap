package hotpointgame.Control
{
   import hotpointgame.views.attPanel.*;
   import hotpointgame.views.chHdPanel.*;
   import hotpointgame.views.dljlPanel.*;
   import hotpointgame.views.everyDayPanel.*;
   import hotpointgame.views.onLineJl.*;
   import hotpointgame.views.signPanel.*;
   import hotpointgame.views.threePanel.*;
   import hotpointgame.views.unionPanel.*;
   import hotpointgame.views.unionVip.*;
   import hotpointgame.views.zenfuPanel.*;
   
   public class DataList
   {
      
      public var unionData:UnionPanelData;
      
      public var uVipData:UnVipData;
      
      public var hdData:CzHdData;
      
      public var unShop:UnPanelShopData;
      
      public var onLData:OnLinePanelData;
      
      public var attZdl:AttJsData;
      
      public var pzfBag:PlayerZfBag;
      
      public var cwZfBag:PetZfBag;
      
      public var three:ThData;
      
      public var evData:EveryDayData;
      
      public var sgnData:SignData;
      
      public var dljl:DljlData;
      
      public function DataList()
      {
         super();
      }
      
      public static function read(param1:Object = null) : DataList
      {
         var _loc2_:DataList = new DataList();
         if(param1 != null)
         {
            _loc2_.unionData = UnionPanelData.read(param1["un"]);
            _loc2_.uVipData = UnVipData.read(param1["uvp"]);
            _loc2_.hdData = CzHdData.read(param1["hd"]);
            _loc2_.unShop = UnPanelShopData.read(param1["us"]);
            _loc2_.onLData = OnLinePanelData.read(param1["ol"]);
            _loc2_.pzfBag = PlayerZfBag.read(param1["pb"]);
            _loc2_.cwZfBag = PetZfBag.read(param1["cb"]);
            _loc2_.three = ThData.read(param1["th"]);
            _loc2_.evData = EveryDayData.read(param1["ev"]);
            _loc2_.sgnData = SignData.read(param1["sg"]);
            _loc2_.dljl = DljlData.read(param1["dl"]);
         }
         else
         {
            _loc2_.unionData = UnionPanelData.read();
            _loc2_.uVipData = UnVipData.read();
            _loc2_.hdData = CzHdData.read();
            _loc2_.unShop = UnPanelShopData.read();
            _loc2_.onLData = OnLinePanelData.read();
            _loc2_.pzfBag = PlayerZfBag.read();
            _loc2_.cwZfBag = PetZfBag.read();
            _loc2_.three = ThData.read();
            _loc2_.evData = EveryDayData.read();
            _loc2_.sgnData = SignData.read();
            _loc2_.dljl = DljlData.read();
         }
         _loc2_.attZdl = AttJsData.read();
         return _loc2_;
      }
      
      public function save() : Object
      {
         var _loc1_:Object = new Object();
         _loc1_["un"] = this.unionData.save();
         _loc1_["uvp"] = this.uVipData.save();
         _loc1_["hd"] = this.hdData.save();
         _loc1_["us"] = this.unShop.save();
         _loc1_["ol"] = this.onLData.save();
         _loc1_["pb"] = this.pzfBag.save();
         _loc1_["cb"] = this.cwZfBag.save();
         _loc1_["th"] = this.three.save();
         _loc1_["ev"] = this.evData.save();
         _loc1_["sg"] = this.sgnData.save();
         _loc1_["dl"] = this.dljl.save();
         return _loc1_;
      }
   }
}

