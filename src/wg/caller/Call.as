package wg.caller
{
	import wg.caller.call.CallBack;
	
	/**
	 * 消息处理类 用于模块之间传递数据及通知使用
	 * @author xuanweizi
	 */
	public class Call
	{
		public function Call()
		{
			callBack = new CallBack();
		}
		
		private static var _ins:Call;
		
		private var callBack:CallBack;
		
		private static function get instance():Call
		{
			if(!_ins){
				_ins = new Call;
			}
			return _ins;
		}
		
		public static function addCallback(type:String, func:Function,priority:int=0):void
		{
			instance.callBack.addCallback(type,func,priority);
		}
		
		public static function removeCallback(type:String, func:Function,removeNow:Boolean=false):void
		{
			instance.callBack.removeCallback(type,func,removeNow);
		}
		
		public static function dispatch(type:String, data:*=null):void
		{
			instance.callBack.dispatch(type,data);
		}
		
		public static function callOnce(type:String, data:*=null):void
		{
			instance.callBack.callOnce(type,data);
		}
		
		public static function hasCallbackType(type:String):Boolean
		{
			return instance.callBack.hasCallbackType(type);
		}
		
		public static function hasCallback(type:String,func:Function):Boolean
		{
			return instance.callBack.hasCallback(type,func);
		}
		
		public static function getCallback():CallBack
		{
			return instance.callBack;
		}
	}
}