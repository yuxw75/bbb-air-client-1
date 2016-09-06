package wg.timer
{


	public class FuncPack
	{
		public function FuncPack()
		{
		}
		public var func:Function;
		public var delay:int;
		public var frameRate:int;
		public var msMeta:int; 
		public var repeat:int;
		public var desc:String;
		public var callTime:int;
		public var params:Array;
		public var preTime:int;
		public var opFlag:Boolean;//get是true,return是false
		//锁，标识这个对象是不是安全可用，带锁的对象禁止返回池当中,要保证池中的所有对象都是无锁安全的。
		public var lock:Boolean;
		
		public function clear():void{
			func = null;
			delay = 0;
			frameRate = 0;
			repeat = 0;
			desc = "";
			callTime = 0;
			preTime = 0;
			params = null;
		}
	}
}