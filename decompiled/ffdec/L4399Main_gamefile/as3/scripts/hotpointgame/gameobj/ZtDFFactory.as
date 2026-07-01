package hotpointgame.gameobj
{
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   import hotpointgame.utils.*;
   import hotpointgame.utils.gameloader.*;
   
   public class ZtDFFactory
   {
      
      private static var ballData:Object = new Object();
      
      private static var shitouData:Object = new Object();
      
      public function ZtDFFactory()
      {
         super();
      }
      
      public static function createYbBall(param1:String, param2:Number, param3:Number) : void
      {
         var _loc4_:Object = null;
         var _loc5_:Class = null;
         if(param1 == "历练关球一")
         {
            _loc4_ = new Object();
            _loc4_.classname = "wuxingqiuaa";
            _loc4_.attvalue = VT.createVT(GM.cp.getAttackValue() * GS.a30);
            _loc5_ = YbBallLiLianGuan;
         }
         else if(param1 == "历练关球二")
         {
            _loc4_ = new Object();
            _loc4_.classname = "wuxingqiuaa";
            _loc4_.attvalue = VT.createVT(GM.cp.getAttackValue() * GS.a30);
            _loc5_ = YbBallLiLianTwo;
         }
         else
         {
            _loc4_ = ballData[param1];
            _loc5_ = YbBall;
         }
         var _loc6_:Class = LoaderManager.getSwfClass(_loc4_.classname) as Class;
         var _loc7_:YbBall = new _loc5_(new _loc6_(),param2,param3,(_loc4_.attvalue as VT).getValue()) as YbBall;
         GM.levelm.addZtDF(_loc7_);
      }
      
      public static function createZShiTou(param1:String, param2:Number, param3:Number) : void
      {
         var _loc4_:Object = shitouData[param1];
         var _loc5_:Class = LoaderManager.getSwfClass(_loc4_.mcclassname) as Class;
         var _loc6_:Class = ClassGet.getClassByNameAndAlias(_loc4_.classname) as Class;
         var _loc7_:ZShiTou = new _loc6_(new _loc5_(),param2,param3,_loc4_);
         GM.levelm.addGfShiTou(_loc7_);
      }
      
      public static function shitouDataInit(param1:XML) : void
      {
         var _loc2_:XML = null;
         var _loc3_:Object = null;
         for each(_loc2_ in param1.障碍物)
         {
            _loc3_ = new Object();
            _loc3_.yiname = String(_loc2_.名字);
            _loc3_.ername = String(_loc2_.二名);
            _loc3_.hurtnum = VT.createVT(Number(_loc2_.被击数上限));
            _loc3_.mcclassname = String(_loc2_.元件链接名);
            _loc3_.classname = String(_loc2_.类名);
            shitouData["" + _loc3_.yiname + _loc3_.ername] = _loc3_;
         }
      }
      
      public static function ballDataInit() : void
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc4_:int = 0;
         var _loc5_:String = null;
         var _loc6_:VT = null;
         var _loc7_:Object = null;
         var _loc1_:int = int(GS.a1);
         while(_loc1_ < GS.a6)
         {
            _loc2_ = "";
            _loc3_ = "";
            switch(_loc1_)
            {
               case GS.a1:
                  _loc2_ = "金";
                  _loc3_ = "wuxingqiua";
                  break;
               case GS.a2:
                  _loc2_ = "木";
                  _loc3_ = "wuxingqiub";
                  break;
               case GS.a3:
                  _loc2_ = "水";
                  _loc3_ = "wuxingqiuc";
                  break;
               case GS.a4:
                  _loc2_ = "火";
                  _loc3_ = "wuxingqiud";
                  break;
               case GS.a5:
                  _loc2_ = "土";
                  _loc3_ = "wuxingqiue";
            }
            _loc4_ = int(GS.a1);
            while(_loc4_ < GS.a5)
            {
               _loc5_ = "";
               _loc6_ = VT.createVT(0);
               switch(_loc4_)
               {
                  case GS.a1:
                     _loc5_ = "";
                     _loc6_.setValue(GS.a30 * GS.a10);
                     break;
                  case GS.a2:
                     _loc5_ = "普通_";
                     _loc6_.setValue(GS.a35 * GS.a10);
                     break;
                  case GS.a3:
                     _loc5_ = "困难_";
                     _loc6_.setValue(GS.a50 * GS.a10);
                     break;
                  case GS.a4:
                     _loc5_ = "噩梦_";
                     _loc6_.setValue(GS.a50 * GS.a10);
               }
               _loc7_ = new Object();
               _loc7_.classname = _loc3_;
               _loc7_.attvalue = VT.createVT(_loc6_.getValue());
               ballData[_loc5_ + _loc2_ + "球"] = _loc7_;
               _loc4_++;
            }
            _loc1_++;
         }
      }
   }
}

