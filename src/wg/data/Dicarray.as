package wg.data
{
	import flash.utils.Dictionary;

	/**
	 *它是一个包含了字典和数组的一个类 
	 * @author wetouns
	 * 
	 */	
	public class Dicarray
	{
		public function Dicarray()
		{
			array = [];
			keyArray = [];
			dic = new Dictionary();
		}
		
		private var array:Array;
		private var keyArray:Array;
		private var dic:Dictionary;
		
		public function push(elm:*,key:*):void{	
			if(!dic[key]){			
				array.push(elm);
				keyArray.push(key);
				dic[key] = elm;
			}
		}
		
		public function unshift(elm:*,key:*):void{
			if(!dic[key]){
				array.unshift(elm);
				keyArray.unshift(key);
				dic[key] = elm;
			}
		}
		
		/**
		 *移除一个对象 
		 * @param elm
		 * 
		 */		
		public function remove(key:*):*{			
			var elm:*;
			if(dic[key] != null){
				var idx:int = array.indexOf(dic[key]);
				keyArray.splice(idx,1);
				array.splice(idx,1);
				elm = dic[key]; 
				delete dic[key]; 
				return elm;
			}
			return elm;
		}
		
		/**
		 *移除所有东西
		 * 
		 */		
		public function removeAll():void{
			for each(var key:* in keyArray){
				delete dic[key];
			}
			keyArray.length = 0;
			array.length = 0;
		}
		
		/**
		 *获取一个元素 
		 * @param id
		 * @return 
		 * 
		 */		
		public function getElm(key:*):*{
			return dic[key];
		}
		
		public function hasElm(key:*):Boolean{
			return dic[key] != null;
		}
		
		/**
		 *得到循环对象 
		 * @return 
		 * 
		 */		
		public function getArray():Array{
			return array;
		}
		
		public function getKeys():Array{
			return keyArray;
		}
		
		/**
		 *得到它的长度 
		 * @return 
		 * 
		 */		
		public function get length():int{
			return array.length;
		}
		
		/**
		 *通过下标来获取某个元素 
		 * @param idx
		 * @return 
		 * 
		 */		
		public function getByIdx(idx:int):*{
			return array[idx];
		}
		
		/**
		 *  功能:删除第一个元素
		 *  参数:
		 **/
		public function shift():*
		{
			var obj:* = array.shift();
			var key:* = keyArray.shift()
			delete dic[key];
			return obj;
		}
		
		public function pop():*{
			var obj:* = array.pop();
			var key:* = keyArray.pop()
			delete dic[key];
			return obj;
		}
		
		/**
		 *  功能:查找元素
		 *  参数:
		 **/
		public function indexOf(searchElement:*, fromIndex:*=0):int
		{
			return array.indexOf(searchElement,fromIndex);
		}
		
		/**
		 *  功能:更新元素
		 *  参数:
		 **/
		public function update(elm:*,key:*):void
		{
			var idx:int = array.indexOf(dic[key]);
			array[idx] = elm;
			dic[key] = elm;
		}
	}
}