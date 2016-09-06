package wg.timer
{
	import com.data.Dicarray;
	import com.global.put;
	import com.proxy.addListener;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	/**
	 *此类是帧事件管理器，在人为的表现动画的时候不需要自行去增加enterFrame监听器，只要调
	 * push方法就行了，这是一个单例类 
	 * @author wetouns
	 * 
	 */
	public class FrameEvent
	{
		private static var _ins:FrameEvent;
		public static var frameNum:uint;
		public static var preTime:uint;
		public static var runTime:uint;
		public var funcNum:int;
		public static var realFPS:int = 30;
		
		private static var ins:FrameEvent;
		public static var FRAMERATE:int = 30;
		/**默认1倍速**/
		public static var speed:int = 1;
		private var funcDic:Dicarray;
		private var funcMap:Dictionary = new Dictionary();
		private var keys:Array;
		private var isProcessing:Boolean;
		private var id:int;
		private var arrPool:Array = [];
		private var fpPool:Array = [];
		/**帧运行数据记录**/
		private var frameDic:Dictionary = new Dictionary();

		public function FrameEvent()
		{		
			funcDic = new Dicarray();
			keys = funcDic.getKeys();
			fpPool.num = 0;
			initFrameDic();
		}
		
		public static function init(stage:DisplayObjectContainer,frameRate:int):void{
			addListener(stage,Event.ENTER_FRAME,getInstance().run);
			FRAMERATE = frameRate;
		}
		
		/**
		 *  功能:初始化数据
		 *  参数:
		 **/
		private function initFrameDic():void
		{
			for (var i:int = 0; i < 30; i++) 
			{
				frameDic[i+1] = uint(0);
			}
		}
		/**
		 *
		 * @return 
		 * 
		 */		
		public static function getInstance(id:int=1):FrameEvent{
			//目前测试，只使用一个FRAME
//			id=1;
			if(ins == null){
				ins = new FrameEvent();
			}
			return ins;
		}
		
		public static function shift(spd:int):void{
			if(spd > 0 && spd <= 15)
				FrameEvent.speed = spd;
		}
		
		public static function stopWorld(stage:Sprite):void{
			stage.removeEventListener(Event.ENTER_FRAME,FrameEvent.getInstance(1).run);
		}
		
		public static function showHandle():void{
			ins.showHandler();
			//			insDic['2'].showHandler();
			//			insDic['3'].showHandler();
		}
		
		private var metaFlag:int;
		private var fpsTest:int = 0;
		private var fpsTime:Number = 0;
		/**
		 *在主程序进入帧的时候开始执行。 
		 * 
		 */		
		public function run(evt:Event):void{
			runTime = getTimer();
			fpsTime += runTime - preTime;
			fpsTest += 1;
			if(fpsTest >= 5){
				//算出跑满帧所需要的时间
				var st:int = (FRAMERATE/5)*fpsTime;
				realFPS = Math.round((FRAMERATE*1000)/st);
				fpsTest = fpsTime = 0;
			}
			
			if(speed == 1){
				exec();
			}
			else if(speed > 1){
				for(var i:int = 0;i<speed;i++){
					exec();
				}
			}
			preTime = runTime;
		}
		
		private function exec():void{
			frameNum += 1;
			var runNum:uint;
			
			for each(var meta:int in keys){
				if(meta != 30){
					runNum = runTime*meta/1000;//总运行时间除以一次需要多少时间决定是否进行下一次调用
				}
				if(runNum > frameDic[meta] || meta == 30){
					//如果已经达成条件，即调用
					frameDic[meta] = runNum;
					var funcs:Dicarray = funcDic.getElm(meta);
					var arr:Array = funcs.getArray();
					for each(var fp:FuncPack in arr){
						try{
							fp.func(runTime-fp.preTime,runTime - preTime);
							fp.preTime = runTime;
						}catch(e:Error){
							fp.preTime = runTime;
							put(e.getStackTrace(),"sysErr");							
						}
					}
				}
			}
		}
		/**
		 *
		 * @param func 需要执行的方法
		 *  (这个方法要求有两个参数，参数类型均为整型，第一个参数为上次调用的getTimer的值，
		 * 第二个参数为上一帧到当前帧花了多少时间，单位是ms）
		 * @param frameRate 此方法每秒被调用多少次？也就是此方法的帧率
		 * 
		 */		
		public static function push(func:Function,frameRate:int=30,desc:String="function"):void{
			getInstance().push(func,frameRate,desc);
		}
		
		/**
		 *当不需要的时候把方法传入，它会帮把方法移除掉 
		 * @param func
		 */		
		public static function remove(func:Function):void{
			getInstance().remove(func);
		}
		
		/**
		 *返回是否存在某个正在运行的方法 
		 * @param func
		 * @return 
		 */		
		public static function hasFunction(func:Function):Boolean{
			return getInstance().hasFunction(func);
		}
		
		private function push(func:Function,frameRate:int=30,desc:String="function"):void{
			if(func!=null){
				remove(func);
				if(!funcMap[func]){
					var arr:Dicarray = funcDic.getElm(frameRate);
					if(!arr){
						arr = getArr();
						funcDic.push(arr,frameRate);
					}				
					
					var fp:FuncPack = getFP();
					fp.frameRate = frameRate;
					fp.func = func;
					fp.desc = desc;
					arr.push(fp,func);
					funcMap[func] = fp;
					funcNum += 1;
				}else{//如果已经有了就更新一下参数
					var fp2:FuncPack = funcMap[func];
					var arr2:Dicarray = funcDic.getElm(fp2.frameRate);//拿出原来他保存的位置
					arr2.remove(func);//删除
					arr2 = funcDic.getElm(frameRate);//得到新的位置
					fp2.frameRate = frameRate;
					fp2.desc = desc;
					arr2.push(fp2,func);//设置完参数后保存
				}
			}else{
				//给出的是空参数
			}
		}

		private function remove(func:Function):void{
			if(funcMap[func]){
				var fp:FuncPack = funcMap[func];
				delete funcMap[func];
				var arr:Dicarray = funcDic.getElm(fp.frameRate);
				arr.remove(fp.func);
				
				if(arr.length == 0){
					funcDic.remove(fp.frameRate);
					arrPool.push(arr);
				}
				returnFP(fp);
				funcNum -= 1;
			}
		}

		private function hasFunction(func:Function):Boolean{
			return (funcMap[func] != null);
		}
		
		private var delayFuncs:Array = [];
		private var delayProcessArr:Array = [];
		
		/**
		 * 自产delayCall，作用跟tweenlite的一样，因为用tweenlite的出过问题，所以决定自产
		 *延迟调用 ,最高精度为100ms
		 * @param time 以秒为单位，例，2秒后调用就输入2，100ms后调用就输入0.1
		 * @param func 将要调用的方法
		 * @param ...args调用完成之后的参数
		 * 
		 */		
		public static function delayCall(time:Number,func:Function,...args):void{
			var fe:FrameEvent = FrameEvent.getInstance();
			if(fe.isProcessing){//当调用处于堆栈中的话，就延迟处理
				fe.delayProcessArr.push({type:0,tm:time,fun:func,arg:args});
			}
			else{
				var fp:FuncPack = fe.getFP();
				fp.func = func;
				fp.callTime = time*1000+getTimer();
				fp.params = args;
				fe.delayFuncs.push(fp);
				if(fe.delayFuncs.length > 0){
					fe.push(fe.checkDelay,30,"delayCall");
				}
			}
		}
		
		/**
		 * 当delayCall处于堆栈中的话，就延迟调用delayCall
		 */		
		private function delayProcess():void{
			var dpObj:Object;
			var fun:Function = delayCall;
			while(delayProcessArr.length > 0){
				dpObj = delayProcessArr.pop();
				if(dpObj.type == 0){
					dpObj.arg.unshift(dpObj.fun);
					dpObj.arg.unshift(dpObj.tm);
					fun.apply(null,dpObj.arg);
				}
				else if(dpObj.type == 1){
					
				}
			}
		}
		
		public static function cancleDelay(func:Function):void{
			var fe:FrameEvent = getInstance();
			for each(var fp:FuncPack in fe.delayFuncs){
				if(fp.func == func){
					var idx:int = fe.delayFuncs.indexOf(fp);
					fe.delayFuncs.splice(idx,1);
					//					Debug.put("cancelDelay:"+fp.delayNum,"cdy");
					getInstance().returnFP(fp);
				}
			}
		}
		
		private function checkDelay(ct:int,dis:int):void{
			var fp:FuncPack;
			var idx:int;
			for(var i:int=0;i<delayFuncs.length;i++){
				fp = delayFuncs[i] as FuncPack;
				if(getTimer() >= fp.callTime){
					isProcessing = true;
					//二度返还，非常有问题，在这里的call已经返还了这个fp，然后调完了这个又返还一次
					//二度返还之后还带来的一个问题就是i的值已经不准了
					//一定要考虑到在call这个function之后可能会发生长度变化！
					//这个for循环是一个完整的流程，它所操作的元素不能被影响，所以把要操作的元素加上锁，
					//加了锁的对象在流程结束前不允许做任何销毁或者其他的操作
					fp.lock = true;
					fp.func.apply(null,fp.params);
					idx = delayFuncs.indexOf(fp);
					if(idx >= 0){
						delayFuncs.splice(idx,1);
						i -= 1;
					}
					isProcessing = false;
					fp.lock = false;
					returnFP(fp);
				}
			}
			delayProcess();
			if(delayFuncs.length <= 0){
				remove(checkDelay);
			}
		}
		
		public function showHandler():void{
			put("fpPool数量：" + String(fpPool.num) + "  监听数量:" + funcNum);
			for each(var ar:Dicarray in funcDic.getArray()){
				for each(var fp:FuncPack in ar.getArray()){ 
					put(fp.desc + " - fps:" + fp.frameRate);
				}		
			}
		}
		
		private function getArr():Dicarray{
			return arrPool.length>0?arrPool.pop():new Dicarray();
		}
		
		private function getFP():FuncPack{
			var fp:FuncPack
			//要大于1才可以Pop,时刻保持有1个FP以用于交替
			if(fpPool.length > 1){
				fp = fpPool.pop();
			}
			else{
				fpPool.num += 1;
				fp = new FuncPack();
			}
			fp.opFlag = true;
			fp.preTime = runTime;
			return fp;
		}
		
		private function returnFP(fp:FuncPack):void{
			if(fp.lock){
				//				throw new Error("当前FP为锁定状态，禁止操作!");
				return;
			}
			if(fp.opFlag){
				fp.clear();
				fp.opFlag = false;
				fpPool.unshift(fp);
				//				fpPool.push(fp);
			}
		}
		
		public static function isTick(space:int):Boolean{
			return frameNum%space==0;
		}
	}
}