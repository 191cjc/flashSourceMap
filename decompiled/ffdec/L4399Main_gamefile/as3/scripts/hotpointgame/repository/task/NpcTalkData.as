package hotpointgame.repository.task
{
   import hotpointgame.common.*;
   
   public class NpcTalkData
   {
      
      private var _id:VT;
      
      private var _taskId:VT;
      
      private var _npca:Array = [];
      
      private var _talka:Array = [];
      
      private var _npcb:Array = [];
      
      private var _talkb:Array = [];
      
      private var _npcc:Array = [];
      
      private var _talkc:Array = [];
      
      public function NpcTalkData()
      {
         super();
      }
      
      public static function createNpcTalk(param1:Number, param2:Number, param3:String, param4:String, param5:String, param6:String, param7:String, param8:String) : NpcTalkData
      {
         var _loc9_:NpcTalkData = new NpcTalkData();
         _loc9_._id = VT.createVT(param1);
         _loc9_._taskId = VT.createVT(param2);
         _loc9_._npca = strToArr(param3);
         _loc9_._talka = strToArr(param4);
         _loc9_._npcb = strToArr(param5);
         _loc9_._talkb = strToArr(param6);
         _loc9_._npcc = strToArr(param7);
         _loc9_._talkc = strToArr(param8);
         return _loc9_;
      }
      
      private static function strToArr(param1:String) : Array
      {
         var _loc2_:Array = param1.split("*");
         var _loc3_:Array = [];
         var _loc4_:uint = 0;
         while(_loc4_ < _loc2_.length)
         {
            if(Boolean(Number(_loc2_[_loc4_])) || _loc2_[_loc4_] == 0)
            {
               _loc3_.push(_loc2_[_loc4_]);
            }
            else
            {
               _loc3_.push(String(_loc2_[_loc4_]).replace(/^\s*/g,""));
            }
            _loc4_++;
         }
         return _loc3_;
      }
      
      public function getId() : Number
      {
         return this._id.getValue();
      }
      
      public function getTaskId() : Number
      {
         return this._taskId.getValue();
      }
      
      public function getNpca() : Array
      {
         return this._npca;
      }
      
      public function getTalka() : Array
      {
         return this._talka;
      }
      
      public function getNpcb() : Array
      {
         return this._npcb;
      }
      
      public function getTalkb() : Array
      {
         return this._talkb;
      }
      
      public function getNpcc() : Array
      {
         return this._npcc;
      }
      
      public function getTalkc() : Array
      {
         return this._talkc;
      }
   }
}

