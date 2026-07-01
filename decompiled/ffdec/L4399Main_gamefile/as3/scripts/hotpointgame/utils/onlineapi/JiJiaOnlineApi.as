package hotpointgame.utils.onlineapi
{
   import com.adobeadobe.crypto.*;
   import flash.events.*;
   import flash.net.*;
   import flash.utils.*;
   import hotpointgame.Control.*;
   
   public class JiJiaOnlineApi extends EventDispatcher
   {
      
      public static var packT:int = 17;
      
      public static var addMi:int = 126;
      
      protected var sock:Socket = new Socket();
      
      protected var responseData:ByteArray = new ByteArray();
      
      protected var requestData:ByteArray = new ByteArray();
      
      public var subjishi:Number = 0;
      
      public function JiJiaOnlineApi()
      {
         super();
         this.responseData.endian = Endian.LITTLE_ENDIAN;
         this.requestData.endian = Endian.LITTLE_ENDIAN;
         this.sock.addEventListener(Event.CONNECT,this.connectSucess,false,0,true);
         this.sock.addEventListener(Event.CLOSE,this.connectClose,false,0,true);
         this.sock.addEventListener(IOErrorEvent.IO_ERROR,this.connectIoError,false,0,true);
         this.sock.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.connectSecurityError,false,0,true);
         this.sock.addEventListener(ProgressEvent.SOCKET_DATA,this.connectDataB,false,0,true);
      }
      
      public static function getNewBytes() : ByteArray
      {
         var _loc1_:ByteArray = new ByteArray();
         _loc1_.endian = Endian.LITTLE_ENDIAN;
         return _loc1_;
      }
      
      public function connect(param1:String, param2:int) : void
      {
         if(this.sock.connected)
         {
            this.sock.close();
         }
         this.responseData.length = this.responseData.position = this.requestData.length = this.requestData.position = 0;
         this.sock.connect(param1,param2);
      }
      
      private function submit() : void
      {
         var _loc1_:int = int(this.requestData.length);
         var _loc2_:ByteArray = getNewBytes();
         this.requestData.position = 0;
         while(this.requestData.position < _loc1_)
         {
            _loc2_.writeByte(this.requestData.readByte() ^ addMi);
         }
         this.sock.writeBytes(_loc2_);
         this.sock.flush();
         this.requestData.length = this.requestData.position = 0;
         this.subjishi = GM.frameTime;
      }
      
      private function addData(param1:int, param2:ByteArray) : void
      {
         this.requestData.writeUTFBytes("|");
         this.requestData.writeShort(0);
         this.requestData.writeShort(0);
         this.requestData.writeInt(0);
         this.requestData.writeInt(param2.length);
         this.requestData.writeInt(param1);
         this.requestData.writeBytes(param2);
      }
      
      private function addDataAndSubmit(param1:int, param2:ByteArray) : void
      {
         this.addData(param1,param2);
         this.submit();
      }
      
      public function sLogin(param1:int) : void
      {
         var _loc2_:ByteArray = getNewBytes();
         _loc2_.writeInt(param1);
         _loc2_.writeUTFBytes(MD5.hash("" + param1 + "jjxz"));
         this.addDataAndSubmit(ResponseEvent.S_Login,_loc2_);
      }
      
      public function sGetChannelList() : void
      {
         var _loc1_:ByteArray = getNewBytes();
         this.addDataAndSubmit(ResponseEvent.S_ChannelList,_loc1_);
      }
      
      public function sEnterChannel(param1:int, param2:String, param3:int = 1) : void
      {
         var _loc4_:ByteArray = getNewBytes();
         _loc4_.writeUTFBytes(param2);
         var _loc5_:ByteArray = getNewBytes();
         _loc5_.writeInt(param1);
         _loc5_.writeInt(param3);
         _loc5_.writeShort(_loc4_.length);
         _loc5_.writeBytes(_loc4_);
         this.addDataAndSubmit(ResponseEvent.S_EnterChannel,_loc5_);
      }
      
      public function sRoleEnter(param1:int, param2:int, param3:String) : void
      {
         var _loc4_:ByteArray = getNewBytes();
         _loc4_.writeUTFBytes(param3);
         var _loc5_:ByteArray = getNewBytes();
         _loc5_.writeShort(param1);
         _loc5_.writeShort(param2);
         _loc5_.writeShort(_loc4_.length);
         _loc5_.writeBytes(_loc4_);
         this.addDataAndSubmit(ResponseEvent.S_RoleEnter,_loc5_);
      }
      
      public function sHealt() : void
      {
         this.addDataAndSubmit(ResponseEvent.S_Healt,new ByteArray());
      }
      
      public function sRoleList() : void
      {
         this.addDataAndSubmit(ResponseEvent.S_RoleList,new ByteArray());
      }
      
      public function sRoleMove(param1:int, param2:int, param3:int, param4:int) : void
      {
         var _loc5_:ByteArray = getNewBytes();
         _loc5_.writeShort(param1);
         _loc5_.writeShort(param2);
         _loc5_.writeShort(param3);
         _loc5_.writeShort(param4);
         this.addDataAndSubmit(ResponseEvent.S_RoleMove,_loc5_);
      }
      
      public function sRoleAttUp(param1:String, param2:String) : void
      {
         var _loc3_:ByteArray = getNewBytes();
         _loc3_.writeUTFBytes(param1);
         var _loc4_:ByteArray = getNewBytes();
         _loc4_.writeUTFBytes(param2);
         var _loc5_:ByteArray = getNewBytes();
         _loc5_.writeShort(_loc3_.length);
         _loc5_.writeBytes(_loc3_);
         _loc5_.writeShort(_loc4_.length);
         _loc5_.writeBytes(_loc4_);
         this.addDataAndSubmit(ResponseEvent.S_RoleAttUp,_loc5_);
      }
      
      public function sRoleAllAtt(param1:int) : void
      {
         var _loc2_:ByteArray = getNewBytes();
         _loc2_.writeInt(param1);
         this.addDataAndSubmit(ResponseEvent.S_RoleAllAtt,_loc2_);
      }
      
      public function sChat(param1:String) : void
      {
         var _loc2_:ByteArray = getNewBytes();
         _loc2_.writeUTFBytes(param1);
         var _loc3_:ByteArray = getNewBytes();
         _loc3_.writeInt(_loc2_.length);
         _loc3_.writeBytes(_loc2_);
         this.addDataAndSubmit(ResponseEvent.S_Chat,_loc3_);
      }
      
      public function sChLine(param1:int) : void
      {
         var _loc2_:ByteArray = getNewBytes();
         _loc2_.writeInt(param1);
         this.addDataAndSubmit(ResponseEvent.S_ChLine,_loc2_);
      }
      
      private function connectSucess(param1:Event) : void
      {
         this.dispDefaulEvent(ResponseEvent.S_Session.toString(),1);
      }
      
      private function connectClose(param1:Event) : void
      {
         this.dispDefaulEvent(ResponseEvent.S_Session.toString(),2);
      }
      
      private function connectIoError(param1:IOErrorEvent) : void
      {
         this.dispDefaulEvent(ResponseEvent.S_Session.toString(),3);
      }
      
      private function connectSecurityError(param1:SecurityErrorEvent) : void
      {
         this.dispDefaulEvent(ResponseEvent.S_Session.toString(),4);
      }
      
      private function connectData(param1:ProgressEvent) : void
      {
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:ByteArray = null;
         var _loc9_:ResponseEvent = null;
         var _loc10_:ByteArray = null;
         var _loc2_:ByteArray = getNewBytes();
         var _loc3_:ByteArray = getNewBytes();
         this.sock.readBytes(_loc2_,_loc2_.length);
         _loc2_.position = 0;
         var _loc4_:int = int(_loc2_.length);
         while(_loc2_.position < _loc4_)
         {
            _loc3_.writeByte(_loc2_.readByte() ^ addMi);
         }
         _loc3_.position = 0;
         _loc3_.readBytes(this.responseData,this.responseData.length);
         var _loc5_:int = 0;
         while(true)
         {
            _loc5_ = int(this.responseData.bytesAvailable);
            if(!_loc5_)
            {
               break;
            }
            if(_loc5_ < packT)
            {
               break;
            }
            this.responseData.position += 9;
            _loc6_ = this.responseData.readInt();
            if(_loc5_ < _loc6_ + packT)
            {
               this.responseData.position -= 13;
               break;
            }
            _loc7_ = this.responseData.readInt();
            _loc8_ = getNewBytes();
            this.responseData.readBytes(_loc8_,0,_loc6_);
            if(hasEventListener(_loc7_.toString()))
            {
               _loc9_ = new ResponseEvent(_loc7_.toString());
               _loc8_.position = 0;
               _loc9_.data = _loc8_;
               dispatchEvent(_loc9_);
            }
            else
            {
               this.dispDefaulEvent(ResponseEvent.S_Session.toString(),5,_loc7_);
            }
         }
         if(this.responseData.bytesAvailable == 0)
         {
            this.responseData.length = this.responseData.position = 0;
         }
         else if(this.responseData.position != 0)
         {
            _loc10_ = getNewBytes();
            this.responseData.readBytes(_loc10_);
            this.responseData.length = this.responseData.position = 0;
            this.responseData.writeBytes(_loc10_);
            this.responseData.position = 0;
         }
      }
      
      private function connectDataB(param1:ProgressEvent) : void
      {
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:ByteArray = null;
         var _loc12_:ResponseEvent = null;
         var _loc13_:ByteArray = null;
         var _loc2_:ByteArray = getNewBytes();
         var _loc3_:ByteArray = getNewBytes();
         this.sock.readBytes(_loc2_,_loc2_.length);
         _loc2_.position = 0;
         var _loc4_:int = int(_loc2_.length);
         while(_loc2_.position < _loc4_)
         {
            _loc3_.writeByte(_loc2_.readByte() ^ addMi);
         }
         _loc3_.position = 0;
         _loc3_.readBytes(this.responseData,this.responseData.length);
         var _loc5_:int = int(this.responseData.bytesAvailable);
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         while(_loc7_ < _loc5_)
         {
            if(this.responseData.readUTFBytes(1) == "|")
            {
               --this.responseData.position;
               _loc6_ = 1;
               break;
            }
            if(_loc7_ != 0)
            {
               this.dispDefaulEvent(ResponseEvent.S_Session.toString(),6);
            }
            _loc7_++;
         }
         if(_loc5_ != 0 && _loc6_ == 0)
         {
            this.dispDefaulEvent(ResponseEvent.S_Session.toString(),7);
            this.responseData.length = this.responseData.position = 0;
            return;
         }
         var _loc8_:int = 0;
         while(true)
         {
            _loc8_ = int(this.responseData.bytesAvailable);
            if(!_loc8_)
            {
               break;
            }
            if(_loc8_ < packT)
            {
               break;
            }
            this.responseData.position += 9;
            _loc9_ = this.responseData.readInt();
            if(_loc8_ < _loc9_ + packT)
            {
               this.responseData.position -= 13;
               break;
            }
            _loc10_ = this.responseData.readInt();
            _loc11_ = getNewBytes();
            this.responseData.readBytes(_loc11_,0,_loc9_);
            if(hasEventListener(_loc10_.toString()))
            {
               _loc12_ = new ResponseEvent(_loc10_.toString());
               _loc11_.position = 0;
               _loc12_.data = _loc11_;
               dispatchEvent(_loc12_);
            }
            else
            {
               this.dispDefaulEvent(ResponseEvent.S_Session.toString(),5,_loc10_);
            }
         }
         if(this.responseData.bytesAvailable == 0)
         {
            this.responseData.length = this.responseData.position = 0;
         }
         else if(this.responseData.position != 0)
         {
            _loc13_ = getNewBytes();
            this.responseData.readBytes(_loc13_);
            this.responseData.length = this.responseData.position = 0;
            this.responseData.writeBytes(_loc13_);
            this.responseData.position = 0;
         }
      }
      
      public function isConnect() : Boolean
      {
         return this.sock.connected;
      }
      
      public function closeLine() : void
      {
         if(this.sock.connected)
         {
            this.sock.close();
         }
      }
      
      public function dispDefaulEvent(param1:String, ... rest) : void
      {
         var _loc3_:ResponseEvent = new ResponseEvent(param1);
         var _loc4_:ByteArray = getNewBytes();
         var _loc5_:int = 0;
         while(_loc5_ < rest.length)
         {
            _loc4_.writeInt(rest[_loc5_]);
            _loc5_++;
         }
         _loc4_.position = 0;
         _loc3_.data = _loc4_;
         dispatchEvent(_loc3_);
      }
   }
}

