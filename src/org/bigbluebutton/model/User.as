package org.bigbluebutton.model {
	
	import org.bigbluebutton.model.chat.ChatMessages;
	import org.osflash.signals.ISignal;
	
	public class User {
		public static const MODERATOR:String = "MODERATOR";
		
		public static const VIEWER:String = "VIEWER";
		
		public static const PRESENTER:String = "PRESENTER";
		
		public static const UNKNOWN_USER:String = "UNKNOWN USER";
		
		public static const NO_STATUS:String = "NO_STATUS";
		
		public static const AGREE:String = "AGREE";
		
		public static const RAISE_HAND:String = "RAISE_HAND";
		
		public static const DISAGREE:String = "DISAGREE";
		
		public static const SPEAK_LOUDER:String = "SPEAK_LOUDER";
		
		public static const SPEAK_LOWER:String = "SPEAK_LOWER";
		
		public static const SPEAK_FASTER:String = "SPEAK_FASTER";
		
		public static const SPEAK_SLOWER:String = "SPEAK_SLOWER";
		
		public static const BE_RIGHT_BACK:String = "BE_RIGHT_BACK";
		
		public static const LAUGHTER:String = "LAUGHTER";
		
		public static const SAD:String = "SAD";
		
		/**
		 * Flag to tell that user is in the process of leaving the meeting.
		 */
		public var isLeavingFlag:Boolean = false;
		
		private var _userID:String = UNKNOWN_USER;
		
		public function get userID():String {
			return _userID;
		}
		
		public function set userID(value:String):void {
			_userID = value;
		}
		
		private var _name:String;
		
		public function get name():String {
			return _name;
		}
		
		public function set name(value:String):void {
			_name = value;
		}
		
		private var _phoneUser:Boolean = false;
		
		public function get phoneUser():Boolean {
			return _phoneUser;
		}
		
		public function set phoneUser(value:Boolean):void {
			_phoneUser = value;
		}
		
		private var _me:Boolean = false;
		
		public function get me():Boolean {
			return _me;
		}
		
		public function set me(value:Boolean):void {
			_me = value;
		}
		
		private var _presenter:Boolean = false;
		
		public function get presenter():Boolean {
			return _presenter;
		}
		
		public function set presenter(value:Boolean):void {
			_presenter = value;
		}
		
		private var _role:String = VIEWER;
		
		public function get role():String {
			return _role;
		}
		
		public function set role(role:String):void {
			_role = role;
			verifyUserStatus();
		}
		
		private var _status:String = User.NO_STATUS;
		
		public function get status():String {
			return _status;
		}
		
		public function set status(s:String):void {
			_status = s;
			verifyUserStatus();
		}
		
		private var _hasStream:Boolean = false;
		
		[Bindable]
		public function get hasStream():Boolean {
			return _hasStream;
		}
		
		public function set hasStream(s:Boolean):void {
			_hasStream = s;
			verifyMedia();
		}
		
		private var _voiceUserId:String;
		
		public function get voiceUserId():String {
			return _voiceUserId;
		}
		
		public function set voiceUserId(value:String):void {
			_voiceUserId = value;
		}
		
		private var _voiceJoined:Boolean;
		
		[Bindable]
		public function get voiceJoined():Boolean {
			return _voiceJoined;
		}
		
		public function set voiceJoined(value:Boolean):void {
			_voiceJoined = value;
			verifyUserStatus();
		}
		
		private var _muted:Boolean;
		
		[Bindable]
		public function get muted():Boolean {
			return _muted;
		}
		
		public function set muted(value:Boolean):void {
			_muted = value;
			verifyUserStatus();
		}
		
		private var _talking:Boolean;
		
		[Bindable]
		public function get talking():Boolean {
			return _talking;
		}
		
		public function set talking(value:Boolean):void {
			_talking = value;
			verifyUserStatus();
		}
		
		private var _locked:Boolean;
		
		[Bindable]
		public function get locked():Boolean {
			return _locked;
			verifyUserStatus();
		}
		
		public function set locked(value:Boolean):void {
			_locked = value;
		}
		
		public var streamName:String = "";
		
		// This used to only be used for accessibility and doesn't need to be filled in yet. - Chad
		private function verifyUserStatus():void {
		}
		
		// This used to only be used for accessibility and doesn't need to be filled in yet. - Chad
		private function verifyMedia():void {
		}
		
		public function isModerator():Boolean {
			return role == MODERATOR;
		}
		
		private var _listenOnly:Boolean;
		
		public function get listenOnly():Boolean {
			return _listenOnly;
		}
		
		public function set listenOnly(value:Boolean):void {
			_listenOnly = value;
		}
		
		private var _guest:Boolean;
		
		public function get guest():Boolean {
			return _guest;
		}
		
		public function set guest(value:Boolean):void {
			_guest = value;
		}
		
		private var _waitingForAcceptance:Boolean;
		
		public function get waitingForAcceptance():Boolean {
			return _waitingForAcceptance;
		}
		
		public function set waitingForAcceptance(value:Boolean):void {
			_waitingForAcceptance = value;
		}
	}
}
