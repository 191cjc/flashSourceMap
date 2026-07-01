package hotpointgame.savedatal
{
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   
   public class CheckFlagM
   {
      
      private var cfm:Vector.<CheckFlag> = new Vector.<CheckFlag>();
      
      private var _idandindex:VT = VT.createVT(0);
      
      private var _checkRValue:VT = VT.createVT(0);
      
      private var dangerM:Vector.<CheckFlag> = new Vector.<CheckFlag>();
      
      public function CheckFlagM()
      {
         super();
      }
      
      public static function readData(param1:Object = null) : CheckFlagM
      {
         var _loc3_:Array = null;
         var _loc4_:Object = null;
         var _loc5_:Array = null;
         var _loc6_:Object = null;
         var _loc2_:CheckFlagM = new CheckFlagM();
         if(param1 != null)
         {
            _loc3_ = param1.fa;
            for each(_loc4_ in _loc3_)
            {
               _loc2_.cfm.push(CheckFlag.readData(_loc4_));
            }
            _loc2_.idandindex = param1.idai;
            if(param1.co != null)
            {
               _loc2_.checkRValue = param1.co;
            }
            if(param1.dm != null)
            {
               _loc5_ = param1.dm;
               for each(_loc6_ in _loc5_)
               {
                  _loc2_.dangerM.push(CheckFlag.readData(_loc6_));
               }
            }
         }
         return _loc2_;
      }
      
      public function save() : Object
      {
         var _loc3_:CheckFlag = null;
         var _loc4_:Array = null;
         var _loc5_:CheckFlag = null;
         var _loc1_:Object = new Object();
         var _loc2_:Array = new Array();
         for each(_loc3_ in this.cfm)
         {
            _loc2_.push(_loc3_.save());
         }
         _loc1_.fa = _loc2_;
         _loc4_ = new Array();
         for each(_loc5_ in this.dangerM)
         {
            _loc4_.push(_loc5_.save());
         }
         _loc1_.dm = _loc4_;
         if(this.idandindex != 0)
         {
            _loc1_.idai = this.idandindex;
         }
         else
         {
            _loc1_.idai = GM.testapi.userId * (GM.testapi.dataIndex + GS.a1);
         }
         this.checkRValue = Math.random() * GS.a511097 + GS.a1;
         _loc1_.co = this.checkRValue;
         return _loc1_;
      }
      
      public function isHasZoubi() : Boolean
      {
         var _loc1_:CheckFlag = null;
         if(this.cfm.length == 0)
         {
            return false;
         }
         for each(_loc1_ in this.cfm)
         {
            if(_loc1_.cflag == GS.a9)
            {
               if(!isNaN(_loc1_.cvalue))
               {
                  return true;
               }
            }
            else
            {
               if(_loc1_.cflag != GS.a3)
               {
                  return true;
               }
               if(_loc1_.cvalue * (GS.a07 + GS.a05 * GS.a01) > GM.testapi.allChongGod)
               {
                  return true;
               }
            }
         }
         this.cfm.length = 0;
         return false;
      }
      
      public function isHasZouBiInDm() : Boolean
      {
         if(this.isHasZoubi() == false && this.dangerM.length == 0)
         {
            return false;
         }
         return true;
      }
      
      public function addFlag(param1:Number, param2:Number) : void
      {
         var _loc3_:CheckFlag = null;
         var _loc4_:CheckFlag = null;
         for each(_loc3_ in this.cfm)
         {
            if(_loc3_.cflag == param1)
            {
               _loc3_.cvalue = param2;
               _loc3_.cnum += GS.a1;
               _loc3_.cDate = Number("" + (GM.serverDateC.sMonth + GS.a1) + "0" + GM.serverDateC.sDate + "0" + GM.serverDateC.sHours);
               return;
            }
         }
         _loc4_ = new CheckFlag();
         _loc4_.cflag = param1;
         _loc4_.cvalue = param2;
         _loc4_.cnum = GS.a1;
         _loc4_.cDate = Number("" + (GM.serverDateC.sMonth + GS.a1) + "0" + GM.serverDateC.sDate + "0" + GM.serverDateC.sHours);
         this.cfm.push(_loc4_);
      }
      
      public function addFlagB(param1:Number, param2:Number, param3:Number) : void
      {
         var _loc4_:CheckFlag = null;
         var _loc5_:CheckFlag = null;
         for each(_loc4_ in this.cfm)
         {
            if(_loc4_.cflag == param1)
            {
               _loc4_.cvalue = param2;
               _loc4_.cnum = param3;
               _loc4_.cDate = Number("" + (GM.serverDateC.sMonth + GS.a1) + "0" + GM.serverDateC.sDate + "0" + GM.serverDateC.sHours);
               return;
            }
         }
         _loc5_ = new CheckFlag();
         _loc5_.cflag = param1;
         _loc5_.cvalue = param2;
         _loc5_.cnum = param3;
         _loc5_.cDate = Number("" + (GM.serverDateC.sMonth + GS.a1) + "0" + GM.serverDateC.sDate + "0" + GM.serverDateC.sHours);
         this.cfm.push(_loc5_);
      }
      
      public function addDanagerFlag(param1:Number, param2:Number) : void
      {
         var _loc3_:CheckFlag = null;
         var _loc4_:CheckFlag = null;
         for each(_loc3_ in this.dangerM)
         {
            if(_loc3_.cflag == param1)
            {
               _loc3_.cvalue = param2;
               _loc3_.cnum += GS.a1;
               _loc3_.cDate = Number("" + (GM.serverDateC.sMonth + GS.a1) + "0" + GM.serverDateC.sDate + "0" + GM.serverDateC.sHours);
               return;
            }
         }
         _loc4_ = new CheckFlag();
         _loc4_.cflag = param1;
         _loc4_.cvalue = param2;
         _loc4_.cnum = GS.a1;
         _loc4_.cDate = Number("" + (GM.serverDateC.sMonth + GS.a1) + "0" + GM.serverDateC.sDate + "0" + GM.serverDateC.sHours);
         this.dangerM.push(_loc4_);
      }
      
      public function clearAllCheck() : void
      {
         this.cfm.length = 0;
      }
      
      public function clearDMCheck() : void
      {
         this.dangerM.length = 0;
      }
      
      public function getseccion() : String
      {
         var _loc2_:CheckFlag = null;
         var _loc1_:String = "";
         for each(_loc2_ in this.cfm)
         {
            switch(_loc2_.cflag)
            {
               case GS.a1:
                  _loc1_ += "*id不同" + _loc2_.cvalue + "|" + _loc2_.cnum + "时间:" + _loc2_.cDate;
                  break;
               case GS.a2:
                  _loc1_ += "*存档位不同" + _loc2_.cvalue + "|" + _loc2_.cnum + "时间:" + _loc2_.cDate;
                  break;
               case GS.a3:
                  _loc1_ += "*物品价格超过" + _loc2_.cvalue + "|" + _loc2_.cnum + "时间:" + _loc2_.cDate;
                  break;
               case GS.a4:
                  _loc1_ += "*物品数量超过" + _loc2_.cvalue + "|" + _loc2_.cnum + "时间:" + _loc2_.cDate;
                  break;
               case GS.a5:
                  _loc1_ += "*直接改了存档" + _loc2_.cvalue + "|" + _loc2_.cnum + "时间:" + _loc2_.cDate;
                  break;
               case GS.a6:
                  _loc1_ += "*掉落了不可能掉的" + _loc2_.cvalue + "|" + _loc2_.cnum + "时间:" + _loc2_.cDate;
                  break;
               case GS.a7:
                  _loc1_ += "*职业标识有问题" + _loc2_.cvalue + "|" + _loc2_.cnum + "时间:" + _loc2_.cDate;
                  break;
               case GS.a8:
                  _loc1_ += "*基础数据修改" + _loc2_.cvalue + "|" + _loc2_.cnum + "时间:" + _loc2_.cDate;
                  break;
               case GS.a9:
                  _loc1_ += "*不存在些物品id:" + _loc2_.cvalue + "|" + _loc2_.cnum + "时间:" + _loc2_.cDate;
                  break;
               default:
                  _loc1_ += "*忘了记的:" + _loc2_.cflag + "|" + _loc2_.cvalue + "|" + _loc2_.cnum + "时间:" + _loc2_.cDate;
            }
         }
         return _loc1_;
      }
      
      public function getseccionDM() : String
      {
         var _loc2_:CheckFlag = null;
         var _loc1_:String = "";
         for each(_loc2_ in this.dangerM)
         {
            switch(_loc2_.cflag)
            {
               case GS.a1:
                  _loc1_ += "*id不同" + _loc2_.cvalue + "|" + _loc2_.cnum + "时间:" + _loc2_.cDate;
                  break;
               case GS.a2:
                  _loc1_ += "*存档位不同" + _loc2_.cvalue + "|" + _loc2_.cnum + "时间:" + _loc2_.cDate;
                  break;
               case GS.a3:
                  _loc1_ += "*物品价格超过" + _loc2_.cvalue + "|" + _loc2_.cnum + "时间:" + _loc2_.cDate;
                  break;
               case GS.a4:
                  _loc1_ += "*物品数量超过" + _loc2_.cvalue + "|" + _loc2_.cnum + "时间:" + _loc2_.cDate;
                  break;
               case GS.a5:
                  _loc1_ += "*直接改了存档" + _loc2_.cvalue + "|" + _loc2_.cnum + "时间:" + _loc2_.cDate;
                  break;
               case GS.a6:
                  _loc1_ += "*掉落了不可能掉的" + _loc2_.cvalue + "|" + _loc2_.cnum + "时间:" + _loc2_.cDate;
                  break;
               case GS.a7:
                  _loc1_ += "*职业标识有问题" + _loc2_.cvalue + "|" + _loc2_.cnum + "时间:" + _loc2_.cDate;
                  break;
               case GS.a8:
                  _loc1_ += "*基础数据修改" + _loc2_.cvalue + "|" + _loc2_.cnum + "时间:" + _loc2_.cDate;
                  break;
               case GS.a9:
                  _loc1_ += "*不存在些物品id:" + _loc2_.cvalue + "|" + _loc2_.cnum + "时间:" + _loc2_.cDate;
                  break;
               default:
                  _loc1_ += "*忘了记的:" + _loc2_.cflag + "|" + _loc2_.cvalue + "|" + _loc2_.cnum + "时间:" + _loc2_.cDate;
            }
         }
         if(_loc1_ != "")
         {
            _loc1_ = "*----test----:" + _loc1_;
         }
         return _loc1_;
      }
      
      public function get idandindex() : Number
      {
         return this._idandindex.getValue();
      }
      
      public function set idandindex(param1:Number) : void
      {
         this._idandindex.setValue(param1);
      }
      
      public function get checkRValue() : uint
      {
         return this._checkRValue.getValue();
      }
      
      public function set checkRValue(param1:uint) : void
      {
         this._checkRValue.setValue(param1);
      }
   }
}

