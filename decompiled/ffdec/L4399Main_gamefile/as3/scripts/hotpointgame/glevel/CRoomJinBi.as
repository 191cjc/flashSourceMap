package hotpointgame.glevel
{
   import flash.display.MovieClip;
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   import hotpointgame.utils.gameloader.*;
   import hotpointgame.utils.gsound.*;
   
   public class CRoomJinBi extends CRoom
   {
      
      private var allJBMc:Array = new Array();
      
      public function CRoomJinBi(param1:Object)
      {
         super(param1);
      }
      
      override public function gmUpdate(param1:CLevel) : void
      {
         var _loc4_:MovieClip = null;
         var _loc2_:int = int(this.allJBMc.length);
         var _loc3_:* = int(_loc2_ - 1);
         while(_loc3_ >= 0)
         {
            _loc4_ = this.allJBMc[_loc3_];
            if(GM.cp.getCPlayByHit().hitTestObject(_loc4_))
            {
               SoundManager.addOnlySound("mp_jianjinbi");
               if(name == "神农遗迹福利房间1")
               {
                  GM.cp.addGodByRoleByVip(GS.a10);
               }
               else if(name == "梦魇之境神农遗迹福利房间1")
               {
                  GM.cp.addGodByRoleByVip(GS.a20);
               }
               else if(name == "梦魇之境神农祭坛福利房间1")
               {
                  GM.cp.addGodByRoleByVip(GS.a60);
               }
               else if(name == "神农祭坛福利房间1")
               {
                  GM.cp.addGodByRoleByVip(GS.a30);
               }
               else if(name == "暗黑之海金币房间")
               {
                  GM.cp.addGodByRoleByVip(GS.a26);
               }
               else if(name == "暗黑之海金币房间1")
               {
                  GM.cp.addGodByRoleByVip(GS.a34);
               }
               else if(name == "梦魇之境暗黑之海金币房间1")
               {
                  GM.cp.addGodByRoleByVip(GS.a40);
               }
               this.allJBMc.splice(_loc3_,1);
               if(_loc4_.parent)
               {
                  _loc4_.parent.removeChild(_loc4_);
               }
            }
            _loc3_--;
         }
         super.gmUpdate(param1);
      }
      
      override public function enterRoom(param1:CLevel) : void
      {
         var _loc2_:String = "jinbi_jingbi1";
         if(param1.id == 9 || param1.id == 3008)
         {
            _loc2_ = "jinbi_jingbi2";
         }
         var _loc3_:Class = LoaderManager.getSwfClass(_loc2_) as Class;
         this.allJBMc = param1.getvs().getAllJingBiMc(_loc3_);
         super.enterRoom(param1);
      }
      
      override public function exitRoom() : void
      {
         this.jibiremove();
         super.exitRoom();
      }
      
      override public function exitLevelClear() : void
      {
         this.jibiremove();
         super.exitLevelClear();
      }
      
      private function jibiremove() : void
      {
         this.allJBMc.length = 0;
      }
   }
}

