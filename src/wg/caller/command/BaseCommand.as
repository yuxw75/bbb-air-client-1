package wg.caller.command
{
	

	/**
	 *  @author:Gaara
	 *  2011-7-18
	 *     
	 *   基础命令类，提供代理操作基本方法
	 * 
	 **/
	public class BaseCommand implements ICommand
	{

		/**
		 *  功能: 执行方法，  子类中重写
		 *  参数:
		 **/
		public function exec(param:Object):void
		{
		}
//		
//		/**
//		 *  功能: 获取代理
//		 *  参数:
//		 **/
//		public function getProxy(name:String):BaseProxy
//		{
//			return NetProxy.instance.getProxy(name);
//		}
//		
//		public function addCallBack(type: String, func: Function): void
//		{
//			EventsManager.getInstance().addCallback(type, func);
//		}
//		
//		public function removeCallback(type:String,func:Function,removeNow:Boolean=false):void
//		{
//			EventsManager.getInstance().removeCallback(type,func,removeNow);
//		}
//		
//		public function dispatch(type:String,data:*=null):void
//		{
//			EventsManager.getInstance().dispatch(type,data);
//		}
	}
}