package hotpointgame.common.event
{
   import flash.events.Event;
   
   public class UnEvent extends Event
   {
      
      public static const MY_UNION:String = "myUnion";
      
      public static const CH_UNION:String = "changeUnion";
      
      public static const LIST_UNION:String = "unionlist";
      
      public static const LIST_UNION_CY:String = "unionlistcy";
      
      public static const OUT_UNION_CY:String = "tcunction";
      
      public static const OUT_UNION_MY:String = "outmy";
      
      public static const OUT_UNION_ALL:String = "outunionall";
      
      public static const GONGAO_TX:String = "gongaotx";
      
      public static const WJXX_TX:String = "wanjiaXX";
      
      public static const SQ_LIST:String = "sqlist";
      
      public static const SH_CY:String = "shcy";
      
      public static const SY_ING:String = "sqing";
      
      public static const TASK_OVER:String = "overtask";
      
      public static const JC_API:String = "jcapi";
      
      public static const GET_GG_BL:String = "getggbl";
      
      public static const SET_GG_BL:String = "setggbl";
      
      public static const DUI_HUANG:String = "duihuang";
      
      public static const ERROR_UNION:String = "errorUnion";
      
      private var _obj:*;
      
      public function UnEvent(param1:String, param2:* = null, param3:Boolean = true, param4:Boolean = false)
      {
         super(param1,param3,param4);
         this._obj = param2;
      }
      
      public function get obj() : Object
      {
         return this._obj;
      }
      
      override public function clone() : Event
      {
         return new UnEvent(type,this._obj,bubbles,cancelable);
      }
      
      override public function toString() : String
      {
         return formatToString("UnEvent","type","_obj","bubbles","cancelable","eventPhase");
      }
   }
}

