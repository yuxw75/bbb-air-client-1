package wg.timer
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.utils.getTimer;
	
	public class FrameRateTest
	{
		public static const MYWIDTH:int = 50;
		private var content:TextField;
		private var lastTimer:Number;
		private var frame:Number;
		public function FrameRateTest()
		{

		}
		public function run(stage:Stage):void
		{
			stage.addEventListener(Event.ENTER_FRAME,enterFrameHandler);
			initData();
		}
		public static var Rate:int;
		
		public static var lowTime:int;
		
		public var shiftLastTime:int;
		private function initData():void 
		{
			lastTimer = getTimer();
			frame = 0;
		}
		private function enterFrameHandler(evt:Event):void
		{
			var now:Number = getTimer() - lastTimer;
			frame ++;
			if(now >= 1000){
				Rate = Math.floor(frame / (now /1000));
				initData();
			}
			shift();
		}
		
		private function shift():void
		{
			var now:int = getTimer() - shiftLastTime;
			shiftLastTime = getTimer();
			if(now >= 90)//实时帧频降到10帧以下每降一次就记录一次
				lowTime += 1;
			else//如果帧频一提高，就取消前面的计数，重头开始
				lowTime = 0;
			
			if(lowTime > 10)//如果连续降10次都没有升过就代表真的休眠了
				FrameEvent.shift(4);
			else 
				FrameEvent.shift(1);
		}
		
		private function clickHandler(evt:Event):void
		{
			initData();
		}
	}
}