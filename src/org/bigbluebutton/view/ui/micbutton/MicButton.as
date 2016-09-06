package org.bigbluebutton.view.ui.micbutton {
	
	import flash.events.MouseEvent;
	import mx.events.FlexEvent;
	import mx.states.SetStyle;
	import mx.states.State;
	import spark.components.Button;
	
	public class MicButton extends Button implements IMicButton {
		public function MicButton() {
			super();
		}
		
		override protected function childrenCreated():void {
			super.childrenCreated();
			//修改:去掉静音及样式处理 三个按钮
//			var muted:State = new State({name: "muted"});
//			var unmuted:State = new State({name: "unmuted"});
//			muted.overrides = [new SetStyle(this, "gradientColorTop", this.getStyle('selectedGradientColorTop')),
//							   new SetStyle(this, "gradientColorBottom", this.getStyle('selectedGradientColorBottom')),
//							   new SetStyle(this, "backgroundImage", this.getStyle('mutedBackgroundImage'))];
//			this.states.push(muted);
//			this.states.push(unmuted);
		}
		
		public function dispose():void {
		}
		
		public function setVisibility(val:Boolean):void {
			this.visible = val;
			this.includeInLayout = val;
		}
		
		protected var _muted:Boolean = false;
		
		public function set muted(b:Boolean):void {
			//修改:去掉静音处理 三个按钮
//			_muted = b;
//			if (_muted) {
//				currentState = "muted";
//			} else
//				currentState = "unmuted";
		}
		
		public function get muted():Boolean {
			return _muted;
		}
	}
}
