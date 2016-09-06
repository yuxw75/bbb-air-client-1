package wg.caller.command
{
	import flash.errors.IllegalOperationError;
	import flash.utils.Dictionary;
	
	import wg.caller.command.ICommand;
	
	public class CommandController
	{
		public function CommandController()
		{
			if(this["constructor"] == CommandController){
				if(_instance != null)
					throw new IllegalOperationError("本类实例已存在，使用_instance属性获取");
			}
		}
		
		static public function get instance(): CommandController
		{
			if (_instance == null)
				_instance = new CommandController();
			return _instance;
		}
		
		public function execCommand(notify:String, param: Object): void
		{
			var arr:Array;
			if(_cmdMap[notify] != null){
				arr = _cmdMap[notify];
			}
			if (arr != null)
			{
				for each (var cmdClass: Class  in arr) 
				{
					var cmd: ICommand = new cmdClass() as ICommand;
					
//					CONFIG::debug{_execCmdStack.push(cmdClass);}
					
//					CONFIG::debug{checkCmdStack();}
					
					cmd.exec(param);
					
//					CONFIG::debug{_execCmdStack.pop();}
				}
			}
		}
		
		/** 
		 *     注册命令
		 * */
		public static function regist(notify:String,cls:Class): void
		{
			if(instance._cmdMap[notify] == null){
				instance._cmdMap[notify] = new Array;
			}
			if((instance._cmdMap[notify] as Array).indexOf(cls) == -1){
				(instance._cmdMap[notify] as Array).push(cls);
			}
		}
		
		/** 
		 *     移除命令
		 * */
		public static function remove(notify:String,cls:Class): void
		{
			var arr:Array;
			if(instance._cmdMap[notify] != null){
				arr = instance._cmdMap[notify];
			}
			if (arr != null)
			{
				arr.splice((instance._cmdMap[notify] as Array).indexOf(cls),1);
			}
		}
		
		/** 
		 *     检察是否注册有命令
		 * */
		public function checkCommand(notify:String):Boolean
		{
			return _cmdMap[notify] != null;
		}
		
//		CONFIG::debug
//		private function checkCmdStack(): void
//		{
//			var curCmd: Class = null;
//			for (var i: int = 0; i < _execCmdStack.length; i++)
//			{
//				curCmd = _execCmdStack[i];
//				for (var j: int = i + 1; j < _execCmdStack.length; j++){
////					assert(curCmd == _execCmdStack[j], "命令栈有嵌套！:" + curCmd);
//				}
//			}
//		}
		
		private var _cmdMap: Dictionary = new Dictionary();
		
		static private var _instance: CommandController;
		
//		CONFIG::debug
//		private var _execCmdStack: Vector.<Class> = new Vector.<Class>();
	}
}