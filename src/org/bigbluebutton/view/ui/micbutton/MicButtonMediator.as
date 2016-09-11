package org.bigbluebutton.view.ui.micbutton {
	
	
	import flash.events.MouseEvent;
	import flash.system.Capabilities;
	
	import org.bigbluebutton.command.MicrophoneMuteSignal;
	import org.bigbluebutton.command.ShareMicrophoneSignal;
	import org.bigbluebutton.model.IUserSession;
	import org.bigbluebutton.model.User;
	import org.bigbluebutton.model.UserList;
	import org.bigbluebutton.view.ui.videobutton.VideoButton;
	
	import robotlegs.bender.bundles.mvcs.Mediator;
	
	public class MicButtonMediator extends Mediator {
		
		
		[Inject]
		public var microphoneMuteSignal:MicrophoneMuteSignal;
		
		[Inject]
		public var view:IMicButton;
		
		
		//修改: 添加shareMicrophoneSignal
		[Inject]
		public var shareMicrophoneSignal:ShareMicrophoneSignal;
		[Inject]
		public var userSession:IUserSession;
		
		/**
		 * Initialize listeners and Mediator initial state
		 */
		override public function initialize():void {
			(view as MicButton).addEventListener(MouseEvent.CLICK, mouseEventClickHandler);
			userSession.userList.userChangeSignal.add(userChangeHandler);
			//修改:去掉隐藏  三个按钮
//			view.setVisibility(userSession.userList.me.voiceJoined);
//			view.muted = userSession.userList.me.muted;
		}
		
		/**
		 * Destroy view and listeners
		 */
		override public function destroy():void {
			(view as MicButton).removeEventListener(MouseEvent.CLICK, mouseEventClickHandler);
			userSession.userList.userChangeSignal.remove(userChangeHandler);
			super.destroy();
			view.dispose();
			view = null;
		}
		
		/**
		 * Handle events to turnOn microphone
		 */
		private function mouseEventClickHandler(e:MouseEvent):void {
			//修改:去掉隐藏 原始代码 三个按钮
			//microphoneMuteSignal.dispatch(userSession.userList.me);
			
			//修改:添加打开关闭音频  三个按钮
			
			var isjoin = userSession.userList.me.voiceJoined;
			if(userSession.userList.me.voiceJoined)
			{
				(view as MicButton).setStyle("styleName","openMicButtonStyle topButtonStyle");
				
			}
			else
			{
				(view as MicButton).setStyle("styleName","closeMicButtonStyle topButtonStyle");
			}
			var audioOptions:Object = new Object();
			audioOptions.shareMic = userSession.userList.me.voiceJoined = !isjoin;
			audioOptions.listenOnly = userSession.userList.me.listenOnly = isjoin;
			shareMicrophoneSignal.dispatch(audioOptions);
			
		}
		
		/**
		 * Update the view when there is a chenge in the model
		 */
		private function userChangeHandler(user:User, type:int):void {
			//修改:去掉隐藏及静音处理  三个按钮
//			if (user && UserList && user.me) {
//				if (type == UserList.JOIN_AUDIO) {
//					view.setVisibility(user.voiceJoined);
//				} else if (type == UserList.MUTE) {
//					view.muted = user.muted;
//				}
//			}
		}
	}
}
