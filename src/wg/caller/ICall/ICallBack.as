package wg.caller.ICall
{
	public interface ICallBack
	{
		function addCallback(type:String,func:Function,priority:int=0):void;
		function removeCallback(type:String,func:Function,removeNow:Boolean=false):void;
		function dispatch(type:String,data:*=null):void;
		function getTypeLength(type:String):int;
	}
}