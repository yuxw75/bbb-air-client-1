package org.bigbluebutton.view.ui.videobutton {
	
	import flash.events.MouseEvent;
	import flash.media.Camera;
	import flash.media.CameraPosition;
	
	import org.bigbluebutton.command.ShareCameraSignal;
	import org.bigbluebutton.core.ISaveData;
	import org.bigbluebutton.model.IUserSession;
	import org.bigbluebutton.model.User;
	import org.bigbluebutton.model.UserList;
	
	import robotlegs.bender.bundles.mvcs.Mediator;
	
	import wg.caller.Call;
	import wg.caller.notify.Notify;
	
	public class VideoButtonMediator extends Mediator {
		
		[Inject]
		public var userSession:IUserSession;
		
		[Inject]
		public var shareCameraSignal:ShareCameraSignal;
		
		[Inject]
		public var view:IVideoButton;
		
		[Inject]
		public var saveData:ISaveData;
		
		/**
		 * Initialize listeners and Mediator initial state
		 */
		override public function initialize():void {
			(view as VideoButton).addEventListener(MouseEvent.CLICK, mouseEventClickHandler);
			userSession.userList.userChangeSignal.add(userChangeHandler);
			//修改:注掉显示处理2016.9.6
			//view.setVisibility(userSession.userList.me.hasStream);		
			//修改:切换摄像头 2016.9.6
			Call.addCallback(Notify.SWAP_CAMERA,onSwapCamra);
		}
		
		//修改:切换摄像头 2016.9.6
		private function onSwapCamra(data:Object):void
		{
			if (Camera.names.length > 1) {
				if (!userSession.userList.me.hasStream) {
					if (String(userSession.videoConnection.cameraPosition) == CameraPosition.FRONT) {
						userSession.videoConnection.cameraPosition = CameraPosition.BACK;
					} else {
						userSession.videoConnection.cameraPosition = CameraPosition.FRONT;
					}
				} else {
					if (String(userSession.videoConnection.cameraPosition) == CameraPosition.FRONT) {
						shareCameraSignal.dispatch(!userSession.userList.me.hasStream, CameraPosition.FRONT);
						shareCameraSignal.dispatch(userSession.userList.me.hasStream, CameraPosition.BACK);
					} else {
						shareCameraSignal.dispatch(!userSession.userList.me.hasStream, CameraPosition.BACK);
						shareCameraSignal.dispatch(userSession.userList.me.hasStream, CameraPosition.FRONT);
					}
				}
				saveData.save("cameraPosition", userSession.videoConnection.cameraPosition);
			}
		}
		
		
		/**
		 * Destroy view and listeners
		 */
		override public function destroy():void {
			(view as VideoButton).removeEventListener(MouseEvent.CLICK, mouseEventClickHandler);
			userSession.userList.userChangeSignal.remove(userChangeHandler);
			super.destroy();
			view.dispose();
			view = null;
		}
		
		/**
		 * Handle events to turnOn microphone
		 */
		private function mouseEventClickHandler(e:MouseEvent):void {
			if(userSession.userList.me.hasStream)
			{
				(view as VideoButton).setStyle("styleName","openCamButtonStyle topButtonStyle");
			}
			else
			{
				(view as VideoButton).setStyle("styleName","closeCamButtonStyle topButtonStyle");
			}
			shareCameraSignal.dispatch(!userSession.userList.me.hasStream, userSession.videoConnection.cameraPosition);
			//修改:添加三个按钮
			//shareCameraSignal.dispatch(false, null);
		}
		
		/**
		 * Update the view when there is a chenge in the model
		 */
		private function userChangeHandler(user:User, type:int):void {
			//修改:添加三个按钮 注掉显示处理2016.9.6
//			if (user && user.me) {
//				view.setVisibility(userSession.userList.me.hasStream);
//			}
		}
	}
}
