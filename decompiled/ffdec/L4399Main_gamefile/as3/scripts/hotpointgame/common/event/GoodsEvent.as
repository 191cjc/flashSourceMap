package hotpointgame.common.event
{
   import flash.events.Event;
   import hotpointgame.models.goods.Goods;
   
   public class GoodsEvent extends Event
   {
      
      public static const DO_BACK:String = "doBack";
      
      public static const DO_BACK_SLOT:String = "doBackSlot";
      
      public static const DO_WEAR:String = "doWear";
      
      public static const DO_DISPLAY:String = "donDisplay";
      
      public static const DO_INSERT:String = "insert";
      
      public static const DO_STRENGTH:String = "strength";
      
      public static const DO_COM:String = "com";
      
      public static const DO_ROOM:String = "room";
      
      public static const DO_WM:String = "wmd";
      
      public static const DO_PETWEAR:String = "pet";
      
      public static const DO_ZENWEAR:String = "zf";
      
      private var _goods:Goods;
      
      private var _goodsNum:Number;
      
      private var _id:Number;
      
      private var _typeb:Number;
      
      private var _bo:Boolean;
      
      private var _cwId:Number;
      
      public function GoodsEvent(param1:String, param2:Goods, param3:Number = 0, param4:Number = 0, param5:Number = 1, param6:Boolean = true, param7:Number = 0, param8:Boolean = true, param9:Boolean = false)
      {
         super(param1,param8,param9);
         this._goods = param2;
         this._id = param3;
         this._typeb = param4;
         this._goodsNum = param5;
         this._bo = param6;
         this._cwId = param7;
      }
      
      public function get goods() : Goods
      {
         return this._goods;
      }
      
      public function get id() : Number
      {
         return this._id;
      }
      
      public function get typeb() : Number
      {
         return this._typeb;
      }
      
      public function get goodsNum() : Number
      {
         return this._goodsNum;
      }
      
      public function get bo() : Boolean
      {
         return this._bo;
      }
      
      public function get cwId() : Number
      {
         return this._cwId;
      }
      
      override public function clone() : Event
      {
         return new GoodsEvent(type,this._goods,this._id,this._typeb,this._goodsNum,this._bo,this._cwId,bubbles,cancelable);
      }
      
      override public function toString() : String
      {
         return formatToString("GoodsEvent","typeb","_goods","_id","_typeb","_goodsNum","bo","_cwId","bubbles","cancelable","eventPhase");
      }
   }
}

