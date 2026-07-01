package hotpointgame.utils.onlineapi
{
   import flash.events.Event;
   import flash.utils.ByteArray;
   
   public class ResponseEvent extends Event
   {
      
      public static const S_Healt:int = 1000;
      
      public static const S_Login:int = 1001;
      
      public static const R_Login:int = 1002;
      
      public static const S_ChannelList:int = 1010;
      
      public static const R_ChannelList:int = 1012;
      
      public static const S_EnterChannel:int = 10001;
      
      public static const R_EnterChannel:int = 10002;
      
      public static const S_RoleEnter:int = 10050;
      
      public static const R_RoleEnter:int = 10051;
      
      public static const S_RoleList:int = 10010;
      
      public static const R_RoleList:int = 10011;
      
      public static const S_RoleMove:int = 10020;
      
      public static const R_RoleMove:int = 10021;
      
      public static const S_RoleAttUp:int = 10040;
      
      public static const R_RoleAttUp:int = 10041;
      
      public static const S_RoleAllAtt:int = 10060;
      
      public static const R_RoleAllAtt:int = 10061;
      
      public static const S_Chat:int = 10070;
      
      public static const R_Chat:int = 10071;
      
      public static const S_ChLine:int = 10080;
      
      public static const R_ChLine:int = 10081;
      
      public static const R_RoleLeave:int = 10030;
      
      public static const R_Error:int = 500000;
      
      public static const S_Session:int = 1;
      
      public var data:ByteArray;
      
      public function ResponseEvent(param1:String, param2:Boolean = false, param3:Boolean = false)
      {
         super(param1,param2,param3);
      }
   }
}

