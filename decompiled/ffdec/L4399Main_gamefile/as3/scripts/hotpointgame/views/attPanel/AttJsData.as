package hotpointgame.views.attPanel
{
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   import hotpointgame.models.bag.*;
   
   public class AttJsData
   {
      
      private var myData:AttCyData;
      
      private var cyDataList:Array = [];
      
      private var currCyDataList:Array = [];
      
      private var zdl:VT = VT.createVT(GS.a0);
      
      public function AttJsData()
      {
         super();
      }
      
      public static function read() : AttJsData
      {
         var _loc1_:AttJsData = new AttJsData();
         _loc1_.myData = null;
         _loc1_.cyDataList.length = 0;
         _loc1_.currCyDataList.length = 0;
         _loc1_.zdl = VT.createVT(GS.a0);
         return _loc1_;
      }
      
      public function jsZdl() : void
      {
         BagFactory.equipSlot.JsZdl();
         this.zdl.setValue(Math.floor(BagFactory.equipSlot.getZdl() + GM.aSaveData.petm.getFightgAtt()));
      }
      
      public function getZdl() : Number
      {
         return this.zdl.getValue();
      }
      
      public function getMyData() : AttCyData
      {
         return this.myData;
      }
      
      public function setMyData(param1:Object) : void
      {
         if(param1 != null)
         {
            this.myData = AttCyData.crateAttCyData(param1);
         }
      }
      
      public function getCyList() : Array
      {
         return this.cyDataList;
      }
      
      public function setCyList(param1:Array) : void
      {
         var _loc2_:uint = 0;
         this.cyDataList.length = 0;
         if(param1.length != 0)
         {
            _loc2_ = 0;
            while(_loc2_ < param1.length)
            {
               this.cyDataList[_loc2_] = AttCyData.crateAttCyData(param1[_loc2_]);
               _loc2_++;
            }
         }
      }
      
      public function getCurrCyList(param1:Number, param2:Number = 10) : Array
      {
         this.currCyDataList.length = 0;
         var _loc3_:uint = 0;
         while(_loc3_ < param2)
         {
            if(this.cyDataList[(param1 - 1) * param2 + _loc3_] != null)
            {
               this.currCyDataList.push(this.cyDataList[(param1 - 1) * param2 + _loc3_]);
            }
            _loc3_++;
         }
         return this.currCyDataList;
      }
      
      public function getDataByKey(param1:Number) : AttCyData
      {
         return this.currCyDataList[param1];
      }
      
      public function getAllYeCy() : Number
      {
         var _loc1_:Number = Number(this.cyDataList.length);
         var _loc2_:Number = int(_loc1_ / 10);
         if(_loc1_ % 10 > 0)
         {
            _loc2_ += 1;
         }
         return _loc2_;
      }
   }
}

