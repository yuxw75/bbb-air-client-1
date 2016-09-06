package wg.utils
{
	import flash.utils.Dictionary;
	

	public class ArrayUtil
	{
		public function ArrayUtil()
		{
		}
		
		/**
		 *把第二个数组里的元素追加到第一个数组里,第二个数组会变为空 
		 * @param arr1
		 * @param arr2
		 * @param unique判断是否唯一
		 * 
		 */		
		public static function contact(arr1:Array,arr2:Array,unique:Boolean=false):void{
			if(arr1 == arr2)
				throw new Error("两个对象不能相等");
			while(arr2.length > 0){
				if(unique){//如果唯一，就判断
					pushSingle(arr2.shift(),arr1);
				}
				else{
					arr1.push(arr2.shift());
				}
			}
		}
		
		public static function pushSingle(res:*,arr:Array,idx:int=-1):void{
			if(arr.indexOf(res) < 0){
				if(idx < 0){
					arr.push(res);
				}
				else{
					arr[arr.length] = arr[idx];
					arr[idx] = res;
				}
			}
		}
		
		public static function deleteElm(res:*,arr:Array):Boolean{
			var idx:int = arr.indexOf(res);
			if(idx >= 0){
				arr.splice(idx,1);
				return true;
			}
			return false;
		}
		
		/**
		 *  功能: 判断一个数组里是不是存在某个元素
		 * 如果没有field，就直接对比value对象，如果有，就对比字段
		 *  参数:
		 **/
		public static function hasElm(arr:Array,value:Object,field:String=null):int
		{
			var idx:int;
			for each(var item:Object in arr){
				if(field == null && item== value){//如果不指定字段就对比对象本身
					return idx;
				}
				else if(field != null && item[field] == value){// 否则就对比字段
					return idx;
				}
				++idx;
			}
			return -1;
		}
		
		/**
		 *把一个元素从数组1转移到数组2上 
		 * @param res
		 * @param arr1
		 * @param arr2
		 * 
		 */		
		public static function changeElm(res:*,arr1:Array,arr2:Array):void{
			var idx:int = arr1.indexOf(res);
			if(idx >= 0){
				arr1.splice(idx,1);
			}
			arr2.push(res);
		}
		
		/**
		 *URL对象优先级排序用的一个方法 
		 * @param arr
		 * 
		 */		
		public static function sortPriority(arr:Array):void{
			if(arr.length > 1)
				arr.sort(
					function (x:Object,y:Object):Number{
						return x.pri - y.pri;
					}
					);
		}
		
		/**
		 *  功能:清空一个字典
		 *  参数:
		 **/
		public static function clearDictionary(dic:Dictionary):void
		{
			for(var key:String in dic){
				delete dic[key];
			}
		}
		
		/**
		 *  功能:随机在数组拿出一个元素，但不删除
		 *  参数:
		 **/
		public static function getRandomElm(arr:Array):*
		{
			var len:int = arr.length;
			var idx:int = (Math.random()*1000000) % len;
			return arr[idx];
		}
		
		/**
		 *  功能:通过字段来得到一个数组里边的元素
		 *  参数:
		 **/
		public static function getItemByField(field:String,value:Object,arr:*):Object
		{
			for each (var elm:Object in arr) 
			{
				if(elm[field] == value){
					return elm;
				}
			}
			return null;
		}
		
		
		/**
		 *  功能:通过字段来得到一个数组里边的元素
		 *  参数:
		 **/
		public static function deleteItemByField(field:String,value:Object,arr:Array):Object
		{
			var idx:int;
			var delObj:Object;
			for each (var elm:Object in arr) 
			{
				if(elm[field] == value){
					delObj = arr.splice(idx,1);
					break;
				}
				++idx;
			}
			if(delObj)
				return delObj[0];
			else
				return null;
		}
	}
}