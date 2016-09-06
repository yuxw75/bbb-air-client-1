package wg.utils
{
	import flash.display.Sprite;
	import flash.geom.Point;

	/**
	 *这个类是用来生成点与点之间的一条路径 
	 * @author wetouns
	 * 
	 */	
	public class WalkUtil
	{
		public function WalkUtil()
		{
		}
		private var _degree:int;
		
		private static var _ins:WalkUtil;
		
		public static function get instance():WalkUtil{
			if(!_ins){
				_ins = new WalkUtil();
			}
			return _ins;
		}
		
		private static var stp:Point = new Point();
		
		private static var enp:Point = new Point();
		
		private static var rds:Number;
		
		private static var Sin:Number;
		
		private static var Cos:Number;
		
		private static var testData:Array = [];
		
		/**
		 *使target向目标点的x,y移动 
		 * @param target
		 * @param desX
		 * @param desY
		 * @param stepLen
		 * @return 
		 * 
		 */		
		public static function updatePos(target:*,desX:Number,desY:Number,stepLen:int=6):Boolean{
			var dx:int = desX - target.x;
			var dy:int = desY - target.y;
			if(dx == 0 && dy == 0){
				return false;
			}
			if(target.x == desX && target.y == desY){
				return false;
			}
			//这个方法有个问题，当dx和dy都=0的时候，sin值会算出来是1，要小心
			rds = Math.atan2(dy, dx);	
			Sin = Math.sin(rds);
			Cos = Math.cos(rds);	
			target.x = Math.round(target.x + stepLen * Cos);
			target.y = Math.round(target.y + stepLen * Sin);
			return true;
		}
		
		public static function updatePosByRot(target:*,rotation:Number,len:int):void{
			rds = (rotation * Math.PI)/180;
			Sin = Math.sin(rds);
			Cos = Math.cos(rds);	
			target.x = Math.round(target.x + len * Cos);
			target.y = Math.round(target.y + len * Sin);
		}
		
		/**
		 *把p2的值赋给p1 
		 * @param p1
		 * @param p2
		 * 
		 */		
		public static function copyPoint(p1:*,p2:*):Boolean{
			if(p1 == null || p2 == null)
				return false;
			p1.x = p2.x;
			p1.y = p2.y;
			return true;
		}
		
		/**
		 *  功能:判断两点是否相等
		 *  参数:
		 **/
		public static function equals(p1:Object,p2:Object):Boolean
		{
			if(p1.x == p2.x && p1.y == p2.y){
				return true;
			}
			return false;
		}
		
		public static function contactArray(arr1:Array,arr2:Array):void{
			while(arr2.length > 0){
				arr1.push(arr2.shift());
			}
		}
		
		private static var dp1:Point = new Point();
		
		private static var dp2:Point = new Point();
		
		private static var dis:Number;
		
		public static function distance(p1:*,p2:*):Number{
			var len:int = p2.x - p1.x;
			var wid:int = p2.y - p1.y;
			dis = Math.sqrt(len*len+wid*wid);
			return dis;
		}
		
		public static function setMouseEnable(dio:Sprite):void{
			dio.mouseEnabled = false;
			dio.mouseChildren = false;
		}
		
		/**
		 *给出两点的坐标，返回一个0~359度的值 
		 * @param x1  
		 * @param y1                            90°
		 *                                       0°    中点    180°
		 * @param x2                           270°
		 * @param y2
		 * @return 
		 * 
		 */		
		public static function getDegree360(x1:int, y1:int, x2:int, y2:int):int{
			var dg:int = MathUtil.getMoveDegrees(x1,y1,x2,y2);
			if(dg < 0){
				dg = dg + 360;
			}
			return dg;
		}
	}
}