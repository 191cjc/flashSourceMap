package hotpointgame.views.taskPanel
{
   import flash.display.MovieClip;
   import flash.text.*;
   import hotpointgame.Control.*;
   import hotpointgame.utils.gameloader.*;
   
   public class TaskMcPanel extends MovieClip
   {
      
      public static var _instance:TaskMcPanel;
      
      public static var taskMc:MovieClip;
      
      public var currJd:Number = 0;
      
      public var currData:Array = [];
      
      public function TaskMcPanel()
      {
         super();
      }
      
      public static function createTaskMcpanel() : TaskMcPanel
      {
         var _loc1_:Object = null;
         var _loc2_:MovieClip = null;
         if(_instance == null)
         {
            _loc1_ = LoaderManager.getSwfClass("Task_mc") as Class;
            _loc2_ = new _loc1_();
            taskMc = _loc2_;
            _instance = new TaskMcPanel();
            _instance.addChild(taskMc);
            GM.dtop.addChild(_instance);
            (taskMc.t_tx as TextField).mouseEnabled = false;
         }
         taskMc.visible = false;
         taskMc.npc_mc.gotoAndStop(1);
         _instance.currJd = 0;
         _instance.currData.length = 0;
         return _instance;
      }
      
      public function open(param1:Array) : void
      {
         this.currData = param1;
         this.currJd = 0;
         taskMc.visible = true;
         taskMc.npc_mc.gotoAndStop(this.currData[0][this.currJd]);
         (taskMc.t_tx as TextField).htmlText = this.currData[1][this.currJd];
         (taskMc.t_tx as TextField).embedFonts = true;
         (taskMc.t_tx as TextField).setTextFormat(new TextFormat(GM.fzfont.fontName,15));
         FlowInterface.gamePause();
         taskMc.x = 0;
      }
      
      public function mcGoto() : Boolean
      {
         if(this.currData.length != 0 && this.currJd < (this.currData[0] as Array).length - 1)
         {
            ++this.currJd;
            taskMc.npc_mc.gotoAndStop(this.currData[0][this.currJd]);
            (taskMc.t_tx as TextField).htmlText = this.currData[1][this.currJd];
            (taskMc.t_tx as TextField).embedFonts = true;
            (taskMc.t_tx as TextField).setTextFormat(new TextFormat(GM.fzfont.fontName,15));
            return false;
         }
         this.close();
         return true;
      }
      
      public function close() : void
      {
         taskMc.visible = false;
         taskMc.npc_mc.gotoAndStop(1);
         this.currData = [];
         this.currJd = 0;
         FlowInterface.gameContinue();
         taskMc.x = 5000;
      }
   }
}

