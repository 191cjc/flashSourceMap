package hotpointgame.glevel
{
   import flash.geom.*;
   import hotpointgame.Control.*;
   
   public class ShakeM
   {
      
      private var speedy:Number = 0;
      
      private var sleng:int = 0;
      
      private var curleng:int = 0;
      
      private var pointA:Vector.<Point> = new Vector.<Point>();
      
      private var fixnum:Number = 0.017453292519943295;
      
      public function ShakeM()
      {
         super();
      }
      
      public function gmUpdate() : void
      {
         if(this.sleng < 0)
         {
            return;
         }
         if(this.sleng == 0)
         {
            GM.blevel.x = 0;
            GM.blevel.y = 0;
         }
         else
         {
            GM.blevel.y = this.sleng % 2 == 0 ? Number(this.speedy) : -this.speedy;
         }
         --this.sleng;
      }
      
      public function setShakeBySkillAndBullet(param1:int, param2:int, param3:int) : void
      {
         var _loc5_:Point = null;
         if(this.sleng - this.curleng > param3)
         {
            return;
         }
         this.pointA.length = 0;
         var _loc4_:int = 0;
         while(_loc4_ < param3)
         {
            _loc5_ = new Point();
            _loc5_.y = param1 * Math.sin(-_loc4_ * param2 * this.fixnum);
            this.pointA[this.pointA.length] = _loc5_;
            _loc4_++;
         }
         this.curleng = 0;
         this.sleng = this.pointA.length;
      }
      
      public function setShakeByCircle() : void
      {
         var _loc2_:Point = null;
         this.pointA.length = 0;
         var _loc1_:int = 0;
         while(_loc1_ < 120)
         {
            _loc2_ = new Point();
            _loc2_.x = 70 * Math.cos(-_loc1_ * 7 * this.fixnum);
            _loc2_.y = 70 * Math.sin(-_loc1_ * 7 * this.fixnum);
            this.pointA[this.pointA.length] = _loc2_;
            _loc1_++;
         }
         this.curleng = 0;
         this.sleng = this.pointA.length;
      }
      
      public function setShake(param1:Number, param2:int) : void
      {
         if(this.sleng > param2)
         {
            return;
         }
         this.speedy = param1;
         this.sleng = param2;
      }
   }
}

