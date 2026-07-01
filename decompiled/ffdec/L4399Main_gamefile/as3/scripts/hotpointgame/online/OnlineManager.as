package hotpointgame.online
{
   import hotpointgame.Control.*;
   import hotpointgame.common.*;
   import hotpointgame.gameobj.*;
   import hotpointgame.gview.*;
   import hotpointgame.utils.onlineapi.*;
   
   public class OnlineManager
   {
      
      public static var sMaxNum:int = 450;
      
      private var roleArr:Vector.<CplayerLine> = new Vector.<CplayerLine>();
      
      private var oapiLogin:JiJiaOnlineApi = new JiJiaOnlineApi();
      
      private var oapiGame:JiJiaOnlineApi = new JiJiaOnlineApi();
      
      private var _curServer:VT = VT.createVT(0);
      
      private var _tepServer:VT = VT.createVT(0);
      
      private var _curLine:VT = VT.createVT(0);
      
      private var _isHasRoomCun:VT = VT.createVT(GS.a1);
      
      public var cList:Array = new Array();
      
      private var actionMap:RoleActionMap = new RoleActionMap();
      
      public function OnlineManager()
      {
         super();
         this.oapiLogin.addEventListener(ResponseEvent.R_Login.toString(),this.rLogSucess);
         this.oapiLogin.addEventListener(ResponseEvent.R_ChannelList.toString(),this.rGetChannelList);
         this.oapiLogin.addEventListener(ResponseEvent.R_Error.toString(),this.rError);
         this.oapiLogin.addEventListener(ResponseEvent.S_Session.toString(),this.sSessionLogin);
         this.oapiGame.addEventListener(ResponseEvent.R_EnterChannel.toString(),this.rEnterChannel);
         this.oapiGame.addEventListener(ResponseEvent.R_RoleEnter.toString(),this.rRoleEnter);
         this.oapiGame.addEventListener(ResponseEvent.R_RoleList.toString(),this.rRoleList);
         this.oapiGame.addEventListener(ResponseEvent.R_RoleMove.toString(),this.rRoleMove);
         this.oapiGame.addEventListener(ResponseEvent.R_RoleAttUp.toString(),this.rRoleAttUp);
         this.oapiGame.addEventListener(ResponseEvent.R_RoleAllAtt.toString(),this.rRoleAllAtt);
         this.oapiGame.addEventListener(ResponseEvent.R_RoleLeave.toString(),this.rRoleLeave);
         this.oapiGame.addEventListener(ResponseEvent.R_Chat.toString(),this.rChat);
         this.oapiGame.addEventListener(ResponseEvent.R_ChLine.toString(),this.rChLine);
         this.oapiGame.addEventListener(ResponseEvent.R_Error.toString(),this.rError);
         this.oapiGame.addEventListener(ResponseEvent.S_Session.toString(),this.sSession);
      }
      
      public function gmUpdate() : void
      {
         var _loc1_:int = 0;
         var _loc2_:* = 0;
         if(GM.onlineM.isConnectLine())
         {
            GChatC.open();
         }
         else
         {
            GChatC.close();
         }
         if(this.isHasRoomCun == 0)
         {
            _loc1_ = int(this.roleArr.length);
            _loc2_ = int(_loc1_ - 1);
            while(_loc2_ >= 0)
            {
               this.roleArr[_loc2_].gmUpdate(new Vector.<ZhangDouT>());
               _loc2_--;
            }
         }
      }
      
      public function removeAllR() : void
      {
         var _loc1_:CplayerLine = null;
         for each(_loc1_ in this.roleArr)
         {
            _loc1_.remove();
         }
         this.roleArr.length = 0;
      }
      
      public function removeRById(param1:uint) : void
      {
         var _loc2_:int = int(this.roleArr.length);
         var _loc3_:* = int(_loc2_ - 1);
         while(_loc3_ >= 0)
         {
            if(this.roleArr[_loc3_].getId() == param1)
            {
               this.roleArr[_loc3_].remove();
               this.roleArr.splice(_loc3_,1);
            }
            _loc3_--;
         }
      }
      
      public function removeRByLimit() : void
      {
         var _loc1_:int = 0;
         var _loc2_:* = 0;
         var _loc3_:int = 0;
         if(this.isConnectLine())
         {
            _loc1_ = int(this.roleArr.length);
            if(_loc1_ <= GOnlineServerC.self.rShowNum)
            {
               return;
            }
            _loc2_ = int(_loc1_ - 1);
            while(_loc2_ >= 0)
            {
               this.roleArr[_loc2_].remove();
               this.roleArr.splice(_loc2_,1);
               _loc3_ = int(this.roleArr.length);
               if(_loc3_ <= GOnlineServerC.self.rShowNum)
               {
                  return;
               }
               _loc2_--;
            }
         }
      }
      
      public function upAddRole(param1:Array) : void
      {
         var _loc2_:Array = null;
         var _loc3_:OnlineData = null;
         var _loc4_:Boolean = false;
         var _loc5_:CplayerLine = null;
         var _loc6_:CplayerLine = null;
         if(this.isHasRoomCun == 0)
         {
            for each(_loc2_ in param1)
            {
               if(this.roleArr.length >= GOnlineServerC.self.rShowNum)
               {
                  break;
               }
               _loc3_ = OnlineData.createTemp(_loc2_[2]);
               if(_loc3_.userid != GM.testapi.userId)
               {
                  if(_loc3_.cunFlag == 0)
                  {
                     _loc4_ = false;
                     for each(_loc5_ in this.roleArr)
                     {
                        if(_loc3_.userid == _loc5_.getId())
                        {
                           _loc4_ = true;
                           break;
                        }
                     }
                     if(!_loc4_)
                     {
                        if(_loc3_.rjob == 1)
                        {
                           _loc6_ = new CplayerLineMan(_loc3_);
                        }
                        else
                        {
                           _loc6_ = new CplayerLineWom(_loc3_);
                        }
                        _loc6_.setZx(_loc2_[0]);
                        _loc6_.setZy(_loc2_[1]);
                        this.roleArr.push(_loc6_);
                        GM.levelm.curLevel.getvs().addMonsterMc(_loc6_.getZmc());
                     }
                  }
               }
            }
         }
      }
      
      public function upRoleAction(param1:Array) : void
      {
         var _loc2_:Array = null;
         var _loc3_:CplayerLine = null;
         var _loc4_:Array = null;
         if(this.isHasRoomCun == 0)
         {
            for each(_loc2_ in param1)
            {
               for each(_loc3_ in this.roleArr)
               {
                  if(uint(_loc2_[0]) == _loc3_.getId())
                  {
                     _loc4_ = this.actionMap.getForthAndAction(_loc2_[3]);
                     if(_loc4_ != null)
                     {
                        _loc3_.rAction(_loc2_[1],_loc2_[2],_loc4_[0],_loc4_[1],_loc2_[4]);
                     }
                     break;
                  }
               }
            }
         }
      }
      
      public function setCurStatie(param1:int, param2:int) : void
      {
         this.curServer = param1;
         this.curLine = param2;
      }
      
      public function isConnectLine() : Boolean
      {
         if(this.curServer != 0 && this.curLine != 0)
         {
            return true;
         }
         return false;
      }
      
      public function exitLine() : void
      {
         this.oapiLogin.closeLine();
         this.oapiGame.closeLine();
         this.removeAllR();
         this.setCurStatie(0,0);
      }
      
      public function exitGame() : void
      {
         this.exitLine();
         this.cList.length = 0;
         GOnlineServerC.close();
      }
      
      public function fHealt() : void
      {
         if(this.isConnectLine())
         {
            if(GM.frameTime - this.oapiGame.subjishi > 3600)
            {
               this.oapiGame.sHealt();
            }
         }
      }
      
      public function connectLoninServer() : void
      {
         this.oapiLogin.connect("jjxz.aiwan4399.com",8000);
      }
      
      public function fLogin() : void
      {
         this.oapiLogin.sLogin(GM.testapi.userId);
      }
      
      public function fGetChannelList() : void
      {
         this.oapiLogin.sGetChannelList();
      }
      
      public function connectChannelServer(param1:int) : void
      {
         var _loc2_:Object = this.cList[param1 - 1];
         this.tepServer = param1;
         this.oapiGame.connect(_loc2_.ip,_loc2_.port);
      }
      
      public function fEnterChannel() : void
      {
         this.oapiGame.sEnterChannel(GM.testapi.userId,OnlineData.getonlineObj());
      }
      
      public function fRoleEnter() : void
      {
         if(this.isConnectLine() && this.isHasRoomCun == 0)
         {
            this.oapiGame.sRoleEnter(GM.cp.getZx(),GM.cp.getZy(),OnlineData.getonlineObj());
         }
      }
      
      public function fRoleList() : void
      {
         if(this.isConnectLine() && this.isHasRoomCun == 0)
         {
            this.oapiGame.sRoleList();
         }
      }
      
      public function fRoleMove(param1:Number, param2:Number, param3:int, param4:String, param5:Number) : void
      {
         var _loc6_:int = 0;
         if(this.isConnectLine() && this.isHasRoomCun == 0)
         {
            if(GM.levelm.curLevel != null && GM.levelm.curLevel.id != GS.a9999)
            {
               return;
            }
            _loc6_ = int(this.actionMap.getIntByfa(param3,param4));
            if(_loc6_ == 0)
            {
               this.output("发送了不存在的动作: " + param3 + "" + param4);
            }
            else
            {
               this.oapiGame.sRoleMove(param1,param2,this.actionMap.getIntByfa(param3,param4),param5);
            }
         }
      }
      
      public function fRoleAttUpLeaveCun() : void
      {
         if(this.isConnectLine())
         {
            this.oapiGame.sRoleAttUp(OnlineData.getonlineObj(),OnlineData.getonlineObj(GS.a1));
         }
      }
      
      public function fRoleAttUpEnterCun() : void
      {
         if(this.isConnectLine())
         {
            this.oapiGame.sRoleAttUp(OnlineData.getonlineObj(),OnlineData.getonlineObj());
         }
      }
      
      public function fChat(param1:String) : void
      {
         if(this.isConnectLine())
         {
            this.oapiGame.sChat(param1);
         }
      }
      
      public function fChLine(param1:int) : void
      {
         if(this.isConnectLine())
         {
            this.oapiGame.sChLine(param1);
         }
      }
      
      private function rLogSucess(param1:ResponseEvent) : void
      {
         if(param1.data.readInt() == 1)
         {
            this.fGetChannelList();
         }
         else
         {
            GoodsManger.cwTs("登录失败");
         }
      }
      
      private function rGetChannelList(param1:ResponseEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         var _loc5_:int = 0;
         var _loc2_:int = param1.data.readInt();
         if(_loc2_ > 0)
         {
            this.cList.length = 0;
            _loc3_ = 0;
            while(_loc3_ < _loc2_)
            {
               _loc4_ = new Object();
               _loc4_.id = param1.data.readInt();
               _loc4_.num = param1.data.readInt();
               _loc4_.port = param1.data.readInt();
               _loc5_ = param1.data.readShort();
               _loc4_.ip = param1.data.readUTFBytes(_loc5_);
               this.cList.push(_loc4_);
               _loc3_++;
            }
            GOnlineServerC.self.initServerListData();
         }
         else
         {
            GoodsManger.cwTs("服务器维护中，列表为空!");
         }
      }
      
      private function rEnterChannel(param1:ResponseEvent) : void
      {
         var _loc2_:int = param1.data.readInt();
         var _loc3_:int = param1.data.readInt();
         if(_loc3_ != 0)
         {
            this.setCurStatie(this.tepServer,_loc3_);
            GOnlineServerC.self.initState(this.curServer,this.curLine);
            GoodsManger.cwTs("进入服务器成功了!");
            GOnlineServerC.close();
            this.fRoleEnter();
            this.fRoleList();
         }
         else
         {
            GoodsManger.cwTs("进入服务器失败了!");
            this.setCurStatie(0,0);
            GOnlineServerC.self.fjishi = 0;
            GOnlineServerC.self.initState(0,0);
         }
      }
      
      private function rRoleEnter(param1:ResponseEvent) : void
      {
         var _loc5_:Array = null;
         var _loc6_:int = 0;
         var _loc2_:int = param1.data.readInt();
         var _loc3_:Array = new Array();
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_)
         {
            _loc5_ = new Array();
            _loc5_.push(param1.data.readShort());
            _loc5_.push(param1.data.readShort());
            _loc6_ = param1.data.readShort();
            _loc5_.push(param1.data.readUTFBytes(_loc6_));
            if(_loc6_ != 0)
            {
               _loc3_.push(_loc5_);
            }
            _loc4_++;
         }
         this.upAddRole(_loc3_);
      }
      
      private function rRoleList(param1:ResponseEvent) : void
      {
         var _loc5_:Array = null;
         var _loc6_:int = 0;
         var _loc2_:int = param1.data.readInt();
         var _loc3_:Array = new Array();
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_)
         {
            _loc5_ = new Array();
            _loc5_.push(param1.data.readShort());
            _loc5_.push(param1.data.readShort());
            _loc6_ = param1.data.readShort();
            _loc5_.push(param1.data.readUTFBytes(_loc6_));
            if(_loc6_ != 0)
            {
               _loc3_.push(_loc5_);
            }
            _loc4_++;
         }
         this.upAddRole(_loc3_);
      }
      
      private function rRoleMove(param1:ResponseEvent) : void
      {
         var _loc5_:Array = null;
         var _loc2_:int = param1.data.readInt();
         var _loc3_:Array = new Array();
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_)
         {
            _loc5_ = new Array();
            _loc5_[0] = param1.data.readInt();
            _loc5_[1] = param1.data.readShort();
            _loc5_[2] = param1.data.readShort();
            _loc5_[3] = param1.data.readShort();
            _loc5_[4] = param1.data.readShort();
            _loc3_.push(_loc5_);
            _loc4_++;
         }
         this.upRoleAction(_loc3_);
      }
      
      private function rRoleAttUp(param1:ResponseEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:String = null;
         var _loc6_:OnlineData = null;
         var _loc7_:Boolean = false;
         var _loc8_:CplayerLine = null;
         var _loc9_:CplayerLine = null;
         if(this.isHasRoomCun == 0)
         {
            _loc2_ = param1.data.readInt();
            _loc3_ = 0;
            for(; _loc3_ < _loc2_; _loc3_++)
            {
               _loc4_ = param1.data.readShort();
               _loc5_ = param1.data.readUTFBytes(_loc4_);
               _loc6_ = OnlineData.createTemp(_loc5_);
               if(_loc6_.userid != GM.testapi.userId)
               {
                  if(_loc6_.cunFlag == 0)
                  {
                     if(_loc6_.verFlag == GS.a1)
                     {
                        if(this.roleArr.length >= GOnlineServerC.self.rShowNum)
                        {
                           continue;
                        }
                        _loc7_ = false;
                        for each(_loc8_ in this.roleArr)
                        {
                           if(_loc6_.userid == _loc8_.getId())
                           {
                              _loc7_ = true;
                              break;
                           }
                        }
                        if(_loc7_)
                        {
                           continue;
                        }
                        if(_loc6_.rjob == 1)
                        {
                           _loc9_ = new CplayerLineMan(_loc6_);
                        }
                        else
                        {
                           _loc9_ = new CplayerLineWom(_loc6_);
                        }
                        _loc9_.setZx(_loc6_.curx);
                        _loc9_.setZy(_loc6_.cury);
                        this.roleArr.push(_loc9_);
                        GM.levelm.curLevel.getvs().addMonsterMc(_loc9_.getZmc());
                     }
                  }
                  else
                  {
                     this.removeRById(_loc6_.userid);
                  }
               }
            }
         }
      }
      
      private function rRoleAllAtt(param1:ResponseEvent) : void
      {
         if(this.isHasRoomCun == 0)
         {
         }
         var _loc2_:int = param1.data.readShort();
         this.output("rRoleAllAtt","完整数据:" + param1.data.readUTFBytes(_loc2_));
      }
      
      private function rRoleLeave(param1:ResponseEvent) : void
      {
         var _loc2_:int = param1.data.readInt();
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            this.removeRById(param1.data.readInt());
            _loc3_++;
         }
      }
      
      private function rChat(param1:ResponseEvent) : void
      {
         var _loc4_:int = 0;
         var _loc2_:int = param1.data.readInt();
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = param1.data.readInt();
            GChatC.self.addChat(param1.data.readUTFBytes(_loc4_));
            _loc3_++;
         }
      }
      
      private function rChLine(param1:ResponseEvent) : void
      {
         var _loc2_:int = param1.data.readInt();
         if(_loc2_ == 0)
         {
            GoodsManger.cwTs("换频道失败了!");
            GOnlineServerC.self.initState(this.curServer,this.curLine);
         }
         else
         {
            GoodsManger.cwTs("换频道成功了!");
            this.setCurStatie(this.curServer,_loc2_);
            GOnlineServerC.self.initState(this.curServer,_loc2_);
            this.removeAllR();
            this.fRoleEnter();
            this.fRoleList();
         }
      }
      
      private function rError(param1:ResponseEvent) : void
      {
         var _loc2_:int = param1.data.readInt();
         this.output("rError 收到错误 码:",_loc2_);
         switch(_loc2_)
         {
            case 0:
            case 1:
            case 2:
               GoodsManger.cwTs("登录失败，可能是帐号已在其它地方登录!");
               break;
            case 1005:
               GoodsManger.cwTs("!           这个服务器人数已满了!");
               break;
            case 1006:
               GoodsManger.cwTs("!             这个频道人数已满了!");
         }
      }
      
      private function sSessionLogin(param1:ResponseEvent) : void
      {
         var _loc2_:int = param1.data.readInt();
         switch(_loc2_)
         {
            case 1:
               this.output("连接成功了a");
               this.fLogin();
               break;
            case 2:
               this.output("连接关闭了a");
               break;
            case 3:
               this.output("连接io 错误a");
               break;
            case 4:
               this.output("连接安全错误a");
               break;
            case 5:
               this.output("收到未处理的指令a",param1.data.readInt());
               break;
            case 6:
               this.output("有丢弃数据aa");
               break;
            case 7:
               this.output("有丢弃数据ba");
         }
      }
      
      private function sSession(param1:ResponseEvent) : void
      {
         var _loc2_:int = param1.data.readInt();
         switch(_loc2_)
         {
            case 1:
               this.output("连接成功了b");
               this.fEnterChannel();
               break;
            case 2:
               GoodsManger.cwTs("从服务器掉线了!");
               this.exitGame();
               break;
            case 3:
               this.output("连接io 错误b");
               break;
            case 4:
               this.output("连接安全错误b");
               break;
            case 5:
               this.output("收到未处理的指令b",param1.data.readInt());
               break;
            case 6:
               this.output("有丢弃数据ab");
               break;
            case 7:
               this.output("有丢弃数据bb");
         }
      }
      
      public function output(... rest) : void
      {
         var _loc2_:String = "";
         var _loc3_:int = 0;
         while(_loc3_ < rest.length)
         {
            _loc2_ = _loc2_ + (rest[_loc3_] + "  ");
            _loc3_++;
         }
         DebugOutPut.self.apptext(_loc2_);
      }
      
      public function get curServer() : int
      {
         return this._curServer.getValue();
      }
      
      public function set curServer(param1:int) : void
      {
         this._curServer.setValue(param1);
      }
      
      public function get curLine() : int
      {
         return this._curLine.getValue();
      }
      
      public function set curLine(param1:int) : void
      {
         this._curLine.setValue(param1);
      }
      
      public function get tepServer() : int
      {
         return this._tepServer.getValue();
      }
      
      public function set tepServer(param1:int) : void
      {
         this._tepServer.setValue(param1);
      }
      
      public function get isHasRoomCun() : int
      {
         return this._isHasRoomCun.getValue();
      }
      
      public function set isHasRoomCun(param1:int) : void
      {
         this._isHasRoomCun.setValue(param1);
      }
   }
}

