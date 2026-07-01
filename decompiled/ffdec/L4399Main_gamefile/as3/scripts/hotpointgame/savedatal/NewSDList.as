package hotpointgame.savedatal
{
   import hotpointgame.common.*;
   import hotpointgame.pet.*;
   
   public class NewSDList
   {
      
      private static var _onewVF:VT = VT.createVT(GS.a46);
      
      public var flagNewDay:EveryDataR;
      
      public var sxiaodata:ShengxiaoData;
      
      public var sxiaolevel:ShengxiaoDouHunList;
      
      public var petm:PetManager;
      
      public var pkDrList:PkEnemy;
      
      public var pksd:DataPk;
      
      public var tztR:TiaoZhanTa;
      
      public var checkfm:CheckFlagM;
      
      public var nlevel:NewLevelData;
      
      public var jieshas:JieShaSdata;
      
      public var surmd:SurMSData;
      
      public var summervd:SummerVRecord;
      
      private var _gamev:VT = VT.createVT(0);
      
      public function NewSDList()
      {
         super();
      }
      
      public static function readData(param1:Object = null) : NewSDList
      {
         var _loc2_:NewSDList = new NewSDList();
         if(param1 == null)
         {
            _loc2_.flagNewDay = EveryDataR.readData();
            _loc2_.sxiaodata = ShengxiaoData.readData(null);
            _loc2_.sxiaolevel = ShengxiaoDouHunList.readData(null);
            _loc2_.petm = PetManager.readData(null);
            _loc2_.gamev = onewVF;
            _loc2_.pkDrList = PkEnemy.readData();
            _loc2_.pksd = DataPk.readData();
            _loc2_.tztR = TiaoZhanTa.readData();
            _loc2_.checkfm = CheckFlagM.readData();
            _loc2_.nlevel = NewLevelData.readData();
            _loc2_.jieshas = JieShaSdata.readData();
            _loc2_.surmd = SurMSData.readData();
            _loc2_.summervd = SummerVRecord.readData();
         }
         else
         {
            _loc2_.flagNewDay = EveryDataR.readData(param1.ndf);
            _loc2_.sxiaodata = ShengxiaoData.readData(param1.sxd);
            _loc2_.sxiaolevel = ShengxiaoDouHunList.readData(param1.sxlv);
            _loc2_.petm = PetManager.readData(param1.pm);
            if(param1.gv != null)
            {
               _loc2_.gamev = param1.gv;
            }
            else
            {
               _loc2_.gamev = onewVF;
            }
            _loc2_.pkDrList = PkEnemy.readData(param1.pkl);
            _loc2_.pksd = DataPk.readData(param1.pks);
            _loc2_.tztR = TiaoZhanTa.readData(param1.tr);
            _loc2_.checkfm = CheckFlagM.readData(param1.cm);
            _loc2_.nlevel = NewLevelData.readData(param1.nlel);
            _loc2_.jieshas = JieShaSdata.readData(param1.jsha);
            _loc2_.surmd = SurMSData.readData(param1.sum);
            _loc2_.summervd = SummerVRecord.readData(param1.summr);
         }
         if(_loc2_.flagNewDay.isNewDay())
         {
            _loc2_.tztR.everyDayUpdata();
            _loc2_.jieshas.dataUpdate();
            _loc2_.surmd.dataUpdate();
            _loc2_.flagNewDay.updateNewDay();
         }
         return _loc2_;
      }
      
      public static function get onewVF() : int
      {
         return _onewVF.getValue();
      }
      
      public static function set onewVF(param1:int) : void
      {
         _onewVF.setValue(param1);
      }
      
      public function save() : Object
      {
         var _loc1_:Object = new Object();
         _loc1_.ndf = this.flagNewDay.save();
         _loc1_.sxd = this.sxiaodata.save();
         _loc1_.sxlv = this.sxiaolevel.save();
         _loc1_.pm = this.petm.save();
         _loc1_.gv = onewVF;
         _loc1_.pkl = this.pkDrList.save();
         _loc1_.pks = this.pksd.save();
         _loc1_.tr = this.tztR.save();
         _loc1_.cm = this.checkfm.save();
         _loc1_.nlel = this.nlevel.save();
         _loc1_.jsha = this.jieshas.save();
         _loc1_.sum = this.surmd.save();
         _loc1_.summr = this.summervd.save();
         return _loc1_;
      }
      
      public function isMaxNewV() : Boolean
      {
         return true;
      }
      
      public function get gamev() : int
      {
         return this._gamev.getValue();
      }
      
      public function set gamev(param1:int) : void
      {
         this._gamev.setValue(param1);
      }
   }
}

