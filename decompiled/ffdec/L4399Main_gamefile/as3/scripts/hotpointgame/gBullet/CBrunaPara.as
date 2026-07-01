package hotpointgame.gBullet
{
   import flash.display.MovieClip;
   import flash.geom.Point;
   import hotpointgame.Control.*;
   import hotpointgame.gameobj.ZhangDouT;
   import hotpointgame.utils.*;
   
   public class CBrunaPara extends CBruna
   {
      
      private var benjix:int = 0;
      
      private var benjiy:int = 0;
      
      private var changa:Number = 0;
      
      private var angleA:Number = 0;
      
      private var yunx:Number = 0;
      
      private var yuny:Number = 0;
      
      private var forthA:int = 0;
      
      private var jiaduan:int = 0;
      
      private var obspeed:Number = 0;
      
      private var obcos:Number = 0;
      
      private var obsin:Number = 0;
      
      public function CBrunaPara(param1:MovieClip, param2:ZhangDouT, param3:Object, param4:int = 0)
      {
         super(param1,param2,param3,param4);
      }
      
      override protected function dataInit(param1:Object) : void
      {
         this.benjix = param1.others.benjix;
         this.benjiy = param1.others.benjiy;
         this.changa = param1.others.changa;
         super.dataInit(param1);
      }
      
      override protected function mcInit() : void
      {
         mc.rotation = Math.round(mc.rotation);
         var _loc1_:Point = Pos.l_To_G(mc);
         _loc1_ = GM.levelm.gPointChangeLevel(_loc1_);
         mc.x = _loc1_.x;
         mc.y = _loc1_.y;
         if(fz.getZTType() == 1)
         {
            mc.rotation = fz.getXforth() == 1 ? mc.rotation : 180 + mc.rotation * -1;
            zhenAnagle = mc.rotation;
         }
         if(fz.getZTType() == 2)
         {
            mc.rotation = fz.getXforth() == -1 ? mc.rotation + 180 : mc.rotation * -1;
            zhenAnagle = mc.rotation;
            mc.rotation = 180 + zhenAnagle;
         }
         bSin = Math.sin(zhenAnagle * Math.PI / 180);
         bCos = Math.cos(zhenAnagle * Math.PI / 180);
         _forth = zhenAnagle > -90 && zhenAnagle <= 90 ? 1 : -1;
         if(mc.rotation > 90 || mc.rotation <= -90)
         {
            mc.scaleY *= -1;
         }
         if(zhenAnagle > -90 && zhenAnagle <= 90)
         {
            this.angleA = zhenAnagle - 90;
            this.forthA = 1;
         }
         else
         {
            this.angleA = zhenAnagle + 90;
            this.forthA = -1;
         }
         this.obspeed = bSpeed;
         this.obsin = bSin;
         this.obcos = bCos;
         this.yunx = _loc1_.x - Math.cos(this.angleA * Math.PI / 180) * this.benjix;
         this.yuny = _loc1_.y - Math.sin(this.angleA * Math.PI / 180) * this.benjiy;
         mc.alpha = 1;
         mc.gotoAndPlay(1);
      }
      
      override protected function beforeUpdate(param1:Vector.<ZhangDouT>) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         if(this.jiaduan == 0 && bSpeed != 0)
         {
            this.angleA += this.forthA * this.changa;
            zhenAnagle += this.forthA * this.changa;
            if(this.forthA == 1 && zhenAnagle > 90)
            {
               zhenAnagle = 90;
               this.jiaduan = 1;
            }
            if(this.forthA == -1 && zhenAnagle < -270)
            {
               zhenAnagle = 90;
               this.jiaduan = 1;
            }
            if(fz.getZTType() == 1)
            {
               mc.rotation = zhenAnagle;
            }
            if(fz.getZTType() == 2)
            {
               mc.rotation = 180 + zhenAnagle;
            }
            if(this.jiaduan == 1)
            {
               bSpeed = this.obspeed;
               bSin = 1;
               bCos = 0;
               return;
            }
            _loc2_ = this.yunx + Math.cos(this.angleA * Math.PI / 180) * this.benjix;
            _loc3_ = this.yuny + Math.sin(this.angleA * Math.PI / 180) * this.benjiy;
            _loc4_ = _loc2_ - mc.x;
            _loc5_ = _loc3_ - mc.y;
            bSpeed = Math.sqrt(_loc4_ * _loc4_ + _loc5_ * _loc5_);
            bCos = _loc4_ / bSpeed;
            bSin = _loc5_ / bSpeed;
         }
      }
   }
}

