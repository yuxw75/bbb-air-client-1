package wg.caller.call
{
	
	import flash.events.TimerEvent;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	import wg.caller.ICall.ICallBack;
	import wg.caller.command.CommandController;
	
	/**
	 *这个类的功能跟EventDispatcher是完全一样的，但是实现原理不同， EventDispatcher的原理是事件机制
	 * 此类的原理是回调机制，通常回调的性能会比事件机制要高
	 * 使用addCallBack后，如不需要再监听就要使用removeCallback移除掉
	 * 被回调的方法必须有一个类型为object的参数，否则报错
	 */
	public class CallBack implements ICallBack
	{
		public function CallBack()
		{
			funcDic = new Dictionary(); 
			foDic = new Dictionary();
			queue = [];
			callList = [];
		}
		
		private var funcDic:Dictionary;
		private var foDic:Dictionary;
		//类型是全局共享记录的
		private static var allType:Vector.<String>;
		private static var funcCount:int = 0;
		private static var counter:Dictionary = new Dictionary();
		
		private var queue:Array;
		private var callList:Array;
		private var waitNum:int;
		public var errorFunc:Function;
		
		/**
		 *增加回调方法 
		 * @param type 回调类型
		 * @param func 回调方法
		 * @param priority监听器的优先级，默认为0，值越大优先级就越高
		 * 
		 */		
		public function addCallback(type:String, func:Function,priority:int=0):void
		{
			if (!funcDic[type])
			{
				funcDic[type] = new Vector.<FunctionObj>();
			}
			if(!foDic[type]){
				foDic[type] = new Dictionary();
			}
			if (!allType)
			{
				allType = new Vector.<String>;
			}
			
			if (!counter[type])
			{
				counter[type] = new Object();
				counter[type].num = 0;
				allType.push(type);
			}
			removeFromQueue(type,func);
			if (!foDic[type][func])
			{
				var fo:FunctionObj = new FunctionObj();
				fo.func = func;
				fo.priority = priority;
				counter[type].num += 1;		
				funcCount += 1;
				foDic[type][func] = fo;
				if(foDic[type].hasOwnProperty("num")){
					++foDic[type].num;
				}else{
					foDic[type].num = 1;
				}
				funcDic[type].push(fo);
				if(priority > 0){
					funcDic[type].sort(
						function (x:FunctionObj,y:FunctionObj):Number{
							return y.priority - x.priority;
						}
					);
				}
			}
		}
		
		/**
		 *调用深度 
		 */		
		private var depthCall:int = 0;
		public function dispatch(type:String, data:*=null):void
		{
			if(CommandController.instance.checkCommand(type))
			{
				try
				{
					CommandController.instance.execCommand(type,data);
				}catch (e: Error)
				{
				}
			}
			
			if(funcDic[type])
			{
				depthCall += 1;				
				var time:int = getTimer();
				for each(var func:FunctionObj in funcDic[type])
				{
					func.func(data);
				}
				time = getTimer() - time;
				if(time > 30){
					trace(type + "  ->消息执行时间过长 时间："+time+"ms");
				}
				depthCall -= 1;
				runEnd();
			}			
		}
		
		/**
		 *移除回调方法 
		 * @param type 回调类型
		 * @param func 回调方法
		 * 
		 */		
		public function removeCallback(type:String, func:Function,removeNow:Boolean=false):void
		{
			if (depthCall > 0 && !removeNow)
			{
				queue.push({type:type,fun:func});
			}
			else
			{
				if(funcDic[type] && foDic[type])
				{
					var idx:int;
					//var fo:FunctionObj = getFO(type,func);
					var fo:FunctionObj = foDic[type][func];
					idx = (funcDic[type] as Vector.<FunctionObj>).indexOf(fo);
					//如果在数组里能找到相应的方法，就把它从数组中删除
					if(idx >= 0){
						(funcDic[type] as Vector.<FunctionObj>).splice(idx,1);
						delete foDic[type][func];
						--foDic[type].num;
						if(foDic[type].num <= 0)
							delete foDic[type];
						funcCount -= 1;
					}
					//如果相应类型的回调已经删除干净，把相应的键也删了
					if(funcDic[type].length == 0){
						delete funcDic[type];
					}
					
					//如果相应的类型数量还大于0的，就把相应的数量减掉1
					if(counter[type] != null && counter[type].num > 0){
						counter[type].num -= 1;
						//如果相应类型的数量已经等于0的，就删除那个类型的计数.
						if(counter[type].num == 0){
							delete counter[type];
							idx = allType.indexOf(type);        
							if(idx >= 0){
								allType.splice(idx,1);
							}
						}
					}			
				}
			}
		}
		
		private function runEnd():void
		{
			if (depthCall == 0)
			{
				for each(var obj:Object in queue)
					removeCallback(obj.type, obj.fun);
				queue.length = 0;
			}
		}
		/**
		 *得到所有已经被注册的回调类型 
		 * @return 
		 */		
		public static function getTypes():Vector.<String>
		{
			return allType;
		}
		
		/**
		 *得到所有已经被注册的回调方法数量 
		 * @return 
		 * 
		 */		
		public static function getFunctionCount():int
		{
			return funcCount;
		}
		
		/**
		 *得到注册的回调明细信息 
		 */		
		public static function getDetail(num:int=1):String
		{
			if(allType){
				var str:String = "";
				for each(var obj:String in allType){
					trace(obj+":"+counter[obj].num);
					if(counter[obj].num >= num)
						str += obj+":"+counter[obj].num + "<br>";
				}
				trace("------------------------------------------------");
				if(allType.length == 0){
					trace("啥都没");
				}
			}else{
				trace("啥都没");
			}
			return str;
		}
		
		/**
		 *  功能:把一个监听从删除队列里拿出来
		 *  参数:
		 **/
		private function removeFromQueue(type:String,func:Function):void
		{
			for each(var item:Object in queue){
				if(item.type == type && item.fun == func){
					var idx:int = queue.indexOf(item);
					if(idx >= 0){
						queue.splice(idx,1);
					}
				}
			}
		}
		
		public function getTypeLength(type: String):int
		{
			return funcDic[type].length;
		}
		
		/**
		 *判断有没有注册某类回调 
		 * @param type
		 * @param func
		 * @return 
		 * 
		 */		
		public function hasCallbackType(type:String):Boolean
		{
			if(foDic[type]){
				return true;
			}
			return false;
		}
		
		/**
		 *判断有没有注册某个回调 
		 * @param type
		 * @param func
		 * @return 
		 * 
		 */		
		public function hasCallback(type:String,func:Function):Boolean
		{			
			if(foDic[type])
			{
				return foDic[type][func] != null;
			}
			return false;
		}
		
		/**
		 *这个方法会在调用过后自动把这个类型的监听全部删掉
		 *因为有一些消息确实是只需要发一次的，省掉移除的麻烦
		 * @param type
		 * @param data
		 * 
		 */		
		public function callOnce(type:String, data:*=null):void
		{
			dispatch(type,data);
			for each(var func:FunctionObj in funcDic[type])
			{
				removeCallback(type,func.func);
			}
		}
		
		public function dispatchT(type:String, data:*=null):void
		{
			callList.push({type:type,data:data});
			waitNum += 1;
		}
		
		private function onCall(evt:TimerEvent):void
		{
			if(waitNum > 0){
				var callObj:Object = callList.shift();
				var type:String = callObj.type;
				waitNum -= 1; 
				if(funcDic[callObj.type]){
					for each(var func:Function in funcDic[type]){
						func(callObj.data);
					}
				}
			}
		}
		/**
		 *其实这个东西也出过问题，并且存在隐患，使用的时候要按照一定的规则
		 * 如果消息发来发去的话，调用的栈会变得很深，就会有可能出现当前类的
		 * 状态被改掉，本来是一个正确的判断，进来之后就变成错误的了。 
		 * 
		 * 为了把交叉调用的影响降低到最小，所以通常最好最把发出消息的代码放
		 * 在逻辑的最后
		 * 
		 * 在同一个调用堆栈里头如果删除了监听再添加的话，会被丢到队列里，添加
		 * 完再删除，这样就惨了，所以添加的时候还要再检查一下垃圾队列里有没有
		 * 那个要删除的监听，有的话就把它T掉不让删
		 */		
	}
}