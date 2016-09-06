package wg.utils
{
	import flash.geom.Point;
	
	public class MathUtil
	{
		public function MathUtil()
		{
		}
		//以水平为基础得到两点之间的弧度值,xy不为负数
		public static function getMoveRadians(startPoint:Point, endPoint:Point):Number
		{
			if(startPoint.equals(endPoint)) return 0;
			return Math.atan(Math.abs(endPoint.y - startPoint.y)/Math.abs(endPoint.x - startPoint.x));	
		}
		//以水平为基础得到两点之间的弧度值,xy可为负数
		public static function getMoveRadiansInit(startPoint:Point, endPoint:Point):Number
		{
			if(startPoint.equals(endPoint)) return 0;
			return Math.atan2(endPoint.y - startPoint.y, endPoint.x - startPoint.x);	
		}
		//以水平为基础得到两点之间的角度值(-180至180)
		public static function getMoveDegrees(x1:Number,y1:Number,x2:Number,y2:Number):int
		{
			var rad:Number = Math.atan2(y1-y2,x1-x2);
			return rad * 180 /Math.PI;
		}
	}
}