package wg.timer
{
	
	
	import flash.utils.getTimer;

	/**
	 *这个类用来作运行时间开消的计算 
	 */
	public class Calter
	{
		
		private static var time1:Date;
		
		private static var time2:Date;
		
		private static var temp:Number;
		
		private static var info:String = "";;
		
		public function Calter()
		{
		}
		
		public static function begin(inf:String):void{	
			info = "";
			if(inf != "" || inf)
				info = inf;
			temp = getTimer()
		}
		
		public static function end():String{
			var result:Number = getTimer() - temp;
			if(result > 30)
				trace("抓住了");
			if(info && info.length > 0)
				trace(info,"此次运行耗时",result ,"毫秒");
			else
				trace("此次运行耗时:" ,result ,"毫秒");
			temp = getTimer();
			return info +"此次运行耗时" + result  + "毫秒"
		}
	}
}