package hotpointgame.views.petGj
{
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   import hotpointgame.models.bag.*;
   import hotpointgame.pet.*;
   import hotpointgame.repository.goods.*;
   import hotpointgame.repository.petGj.*;
   import hotpointgame.views.shipPanel.*;
   
   public class PetGjData
   {
      
      public static var eatArr:Array = [VT.createVT(GS.a331155 + GS.a17),VT.createVT(GS.a331155 + GS.a18),VT.createVT(GS.a331155 + GS.a19)];
      
      public static var gdTime:VT = VT.createVT(GS.a30);
      
      public static var pxPetId:VT = VT.createVT(-GS.a1);
      
      public static var pxLsId:VT = VT.createVT(GS.a2);
      
      public static var pxLsNum:VT = VT.createVT(GS.a1);
      
      public static var zxTime:VT = VT.createVT(GS.a0);
      
      public static var noTime:VT = VT.createVT(GS.a0);
      
      public static var isBo:VT = VT.createVT(GS.a0);
      
      public static var gjTime:VT = VT.createVT(GS.a0);
      
      public static var expLv:VT = VT.createVT(GS.a1);
      
      public static var hosLv:VT = VT.createVT(GS.a1);
      
      public static var expMax:VT = VT.createVT(GS.a20);
      
      public static var hosMax:VT = VT.createVT(GS.a60);
      
      public static var opBo:Boolean = false;
      
      public static var eatBo:Boolean = false;
      
      public function PetGjData()
      {
         super();
      }
      
      public static function initData() : void
      {
         closePanelData();
         hosLv.setValue(GS.a1);
         expLv.setValue(GS.a1);
         opBo = false;
      }
      
      public static function closePanelData() : void
      {
         pxPetId.setValue(-1);
         pxLsId.setValue(GS.a2);
         pxLsNum.setValue(GS.a1);
         zxTime.setValue(GS.a0);
         noTime.setValue(GS.a0);
         isBo.setValue(GS.a0);
         gjTime.setValue(GS.a0);
         eatBo = false;
      }
      
      public static function save() : Object
      {
         var _loc1_:Object = new Object();
         _loc1_["pp"] = pxPetId.getValue();
         _loc1_["pl"] = pxLsId.getValue();
         _loc1_["pn"] = pxLsNum.getValue();
         _loc1_["zx"] = zxTime.getValue();
         _loc1_["no"] = noTime.getValue();
         _loc1_["bo"] = isBo.getValue();
         _loc1_["gj"] = gjTime.getValue();
         _loc1_["ev"] = expLv.getValue();
         _loc1_["hv"] = hosLv.getValue();
         _loc1_["opb"] = opBo;
         _loc1_["eb"] = eatBo;
         return _loc1_;
      }
      
      public static function read(param1:Object) : void
      {
         var _loc2_:VT = null;
         pxPetId.setValue(param1["pp"]);
         pxLsId.setValue(param1["pl"]);
         pxLsNum.setValue(param1["pn"]);
         zxTime.setValue(param1["zx"]);
         noTime.setValue(param1["no"]);
         isBo.setValue(param1["bo"]);
         gjTime.setValue(param1["gj"]);
         expLv.setValue(param1["ev"]);
         hosLv.setValue(param1["hv"]);
         opBo = param1["opb"];
         if(param1["eb"] != null)
         {
            eatBo = param1["eb"];
         }
         if(isBo.getValue() == GS.a1)
         {
            if(gjTime.getValue() > GS.a0)
            {
               _loc2_ = VT.createVT(GS.a0);
               if(gjTime.getValue() > FlowInterface.getLxTime() / GS.a1000)
               {
                  _loc2_.setValue(int(FlowInterface.getLxTime() / GS.a1000));
               }
               else
               {
                  _loc2_.setValue(gjTime.getValue());
               }
               gjTime.setValue(int(gjTime.getValue() - _loc2_.getValue()));
               addLxTime(int(_loc2_.getValue() / GS.a60 / gdTime.getValue()));
               ShipData.deleteNj(getLxTime());
            }
         }
      }
      
      public static function getPetHosLv() : Number
      {
         return hosLv.getValue();
      }
      
      public static function addPetHosLv() : void
      {
         hosLv.setValue(hosLv.getValue() + GS.a1);
      }
      
      public static function getExpLv() : Number
      {
         return expLv.getValue();
      }
      
      public static function addExpLv() : void
      {
         expLv.setValue(expLv.getValue() + GS.a1);
      }
      
      public static function addExp() : void
      {
         var _loc1_:VT = null;
         if(getCurrPetId() != -1 && GM.aSaveData.petm.getPetById(getCurrPetId()) != null)
         {
            _loc1_ = VT.createVT(getZxExp() + getLxExp());
            GM.aSaveData.petm.getPetById(getCurrPetId()).addExp(_loc1_.getValue());
         }
      }
      
      public static function getZxExp() : Number
      {
         return int(GoodsFactory.getGoodsById(eatArr[getLsId()].getValue()).getOtherValue() * getZxTime() * getExpBs());
      }
      
      public static function getLxExp() : Number
      {
         return int(GoodsFactory.getGoodsById(eatArr[getLsId()].getValue()).getLwId()[0] * getLxTime() * getExpBs());
      }
      
      public static function deleteGs() : void
      {
         var _loc1_:VT = VT.createVT(getZxTime() + getLxTime());
         if(_loc1_.getValue() > GS.a0)
         {
            BagFactory.deteleGoods(eatArr[getLsId()].getValue(),_loc1_.getValue());
         }
      }
      
      public static function getExpBs() : Number
      {
         return PetGjFactory.getExpDataByLv(getExpLv()).getXg();
      }
      
      public static function getZxTime() : Number
      {
         return zxTime.getValue();
      }
      
      public static function addZxTime() : void
      {
         zxTime.setValue(zxTime.getValue() + GS.a1);
      }
      
      public static function getLxTime() : Number
      {
         return noTime.getValue();
      }
      
      public static function addLxTime(param1:Number) : void
      {
         noTime.setValue(noTime.getValue() + param1);
      }
      
      public static function getIsBo() : Number
      {
         return isBo.getValue();
      }
      
      public static function getGjTimeZ() : Number
      {
         return getPxLsNum() * gdTime.getValue() * GS.a60;
      }
      
      public static function setIsBo(param1:Number) : void
      {
         isBo.setValue(param1);
      }
      
      public static function getGjTime() : Number
      {
         return gjTime.getValue();
      }
      
      public static function setGjTime(param1:Number) : void
      {
         gjTime.setValue(param1);
      }
      
      public static function getCurrPetId() : Number
      {
         return pxPetId.getValue();
      }
      
      public static function setCurrPetId(param1:Number) : void
      {
         pxPetId.setValue(param1);
      }
      
      public static function getLsId() : Number
      {
         return pxLsId.getValue();
      }
      
      public static function setLsId(param1:Number) : void
      {
         pxLsId.setValue(param1);
      }
      
      public static function getPxLsNum() : Number
      {
         return pxLsNum.getValue();
      }
      
      public static function setPxLsNum(param1:Number) : void
      {
         pxLsNum.setValue(param1);
      }
   }
}

