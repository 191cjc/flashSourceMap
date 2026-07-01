package hotpointgame.savedatal
{
   import hotpointgame.common.*;
   
   public class ShengxiaoDouHunList
   {
      
      private var levelArr:Array = new Array();
      
      public function ShengxiaoDouHunList()
      {
         super();
      }
      
      public static function readData(param1:Object = null) : ShengxiaoDouHunList
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:ShengxiaoDouHun = null;
         var _loc2_:ShengxiaoDouHunList = new ShengxiaoDouHunList();
         if(param1 != null)
         {
            _loc3_ = int(GS.a1);
            while(_loc3_ < GS.a13)
            {
               _loc2_.levelArr[_loc3_] = ShengxiaoDouHun.readData(param1[_loc3_]);
               _loc3_++;
            }
         }
         else
         {
            _loc4_ = int(GS.a1);
            while(_loc4_ < GS.a13)
            {
               _loc5_ = new ShengxiaoDouHun();
               _loc5_.id = _loc4_;
               _loc2_.levelArr[_loc4_] = _loc5_;
               _loc4_++;
            }
         }
         return _loc2_;
      }
      
      public function save() : Object
      {
         var _loc1_:Object = new Object();
         var _loc2_:int = int(GS.a1);
         while(_loc2_ < GS.a13)
         {
            _loc1_[_loc2_] = (this.levelArr[_loc2_] as ShengxiaoDouHun).save();
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function getsxDataByid(param1:int) : ShengxiaoDouHun
      {
         return this.levelArr[param1];
      }
      
      public function changeDHLevel(param1:int, param2:int) : void
      {
         var _loc3_:ShengxiaoDouHun = this.getsxDataByid(param1);
         if(_loc3_ != null)
         {
            _loc3_.curlevel = param2;
         }
      }
      
      public function getAddA() : Number
      {
         return (this.levelArr[GS.a1] as ShengxiaoDouHun).getAddatt();
      }
      
      public function getAddAB() : Number
      {
         return (this.levelArr[GS.a11] as ShengxiaoDouHun).getAddatt();
      }
      
      public function getAddD() : Number
      {
         return (this.levelArr[GS.a2] as ShengxiaoDouHun).getAddatt();
      }
      
      public function getAddMu() : Number
      {
         return (this.levelArr[GS.a3] as ShengxiaoDouHun).getAddatt();
      }
      
      public function getAddNL() : Number
      {
         return (this.levelArr[GS.a4] as ShengxiaoDouHun).getAddatt();
      }
      
      public function getAddTu() : Number
      {
         return (this.levelArr[GS.a5] as ShengxiaoDouHun).getAddatt();
      }
      
      public function getAddHp() : Number
      {
         return (this.levelArr[GS.a6] as ShengxiaoDouHun).getAddatt();
      }
      
      public function getAddShui() : Number
      {
         return 0;
      }
      
      public function getAddHuo() : Number
      {
         return (this.levelArr[GS.a7] as ShengxiaoDouHun).getAddatt();
      }
      
      public function getAddJin() : Number
      {
         return 0;
      }
      
      public function getAddHD() : Number
      {
         return (this.levelArr[GS.a10] as ShengxiaoDouHun).getAddatt();
      }
      
      public function getAddHDB() : Number
      {
         return (this.levelArr[GS.a12] as ShengxiaoDouHun).getAddatt();
      }
      
      public function getAddBJ() : Number
      {
         return (this.levelArr[GS.a8] as ShengxiaoDouHun).getAddatt() / GS.a10000;
      }
      
      public function getAddHpB() : Number
      {
         return (this.levelArr[GS.a9] as ShengxiaoDouHun).getAddatt();
      }
   }
}

