package org.bigbluebutton.core {
	
	import flash.events.AsyncErrorEvent;
	import flash.events.Event;
	import flash.events.NetDataEvent;
	import flash.events.NetStatusEvent;
	import flash.events.StatusEvent;
	import flash.events.TimerEvent;
	import flash.media.Microphone;
	import flash.media.MicrophoneEnhancedMode;
	import flash.media.MicrophoneEnhancedOptions;
	import flash.media.SoundCodec;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.utils.Timer;
	import mx.binding.utils.BindingUtils;
	import mx.utils.ObjectUtil;
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;
	
	public class VoiceStreamManager {
		protected var _incomingStream:NetStream = null;
		
		protected var _outgoingStream:NetStream = null;
		
		protected var _connection:NetConnection = null;
		
		protected var _mic:Microphone = null;
		
		protected var _defaultMicGain = 50;
		
		protected var _heartbeat:Timer = new Timer(2000);
		
		public function setDefaultMicGain(value:Number) {
			_defaultMicGain = value
		}
		
		public function get mic():Microphone {
			return _mic;
		}
		
		public function VoiceStreamManager() {
			_heartbeat.addEventListener(TimerEvent.TIMER, onHeartbeat);
		}
		
		protected function onHeartbeat(event:TimerEvent):void {
			trace("+++ heartbeat +++");
			trace(ObjectUtil.toString(_incomingStream.audioCodec));
		}
		
		public function muteMicGain(value:Boolean):void {
			if (_mic) {
				_mic.gain = value ? 0 : _defaultMicGain;
			}
		}
		
		public function play(connection:NetConnection, streamName:String):void {
			_incomingStream = new NetStream(connection);
			_incomingStream.client = this;
			_incomingStream.addEventListener(NetDataEvent.MEDIA_TYPE_DATA, onNetDataEvent);
			_incomingStream.addEventListener(NetStatusEvent.NET_STATUS, onNetStatusEvent);
			_incomingStream.addEventListener(AsyncErrorEvent.ASYNC_ERROR, onAsyncErrorEvent);
			/*
			 * Set the bufferTime to 0 (zero) for live stream as suggested in the doc.
			 * http://help.adobe.com/en_US/FlashPlatform/beta/reference/actionscript/3/flash/net/NetStream.html#bufferTime
			 * If we don't, we'll have a long audio delay when a momentary network congestion occurs. When the congestion
			 * disappears, a flood of audio packets will arrive at the client and Flash will buffer them all and play them.
			 * http://stackoverflow.com/questions/1079935/actionscript-netstream-stutters-after-buffering
			 * ralam (Dec 13, 2010)
			 */
			_incomingStream.bufferTime = 0;
			_incomingStream.receiveAudio(true);
			_incomingStream.receiveVideo(false);
			_incomingStream.play(streamName);
			//			_heartbeat.start();
		}
		
		protected function onNetDataEvent(event:NetDataEvent):void {
			//			trace(ObjectUtil.toString(event));
		}
		
		public function publish(connection:NetConnection, streamName:String, codec:String, pushToTalk:Boolean):void {
			_outgoingStream = new NetStream(connection);
			_outgoingStream.client = this;
			_outgoingStream.addEventListener(NetStatusEvent.NET_STATUS, onNetStatusEvent);
			_outgoingStream.addEventListener(AsyncErrorEvent.ASYNC_ERROR, onAsyncErrorEvent);
			setupMicrophone(codec, pushToTalk);
			if (_mic) {
				_outgoingStream.attachAudio(_mic);
				_outgoingStream.publish(streamName, "live");
			}
		}
		
		private function noMicrophone():Boolean {
			return ((Microphone.getMicrophone() == null) || (Microphone.names.length == 0)
				|| ((Microphone.names.length == 1) && (Microphone.names[0] == "Unknown Microphone")));
		}
		
		private function setupMicrophone(codec:String, pushToTalk:Boolean):void {
			if (noMicrophone()) {
				_mic = null;
				return;
			}
			_mic = getMicrophone(codec);
			//修改:回音消除处理 AEC 2016.8.31
			_mic.gain = pushToTalk ? 0 : _defaultMicGain;
		}
		
		/**
		 * first try to use the enhanced microphone
		 * if it doesn't work, get the regular one
		 */
		private function getMicrophone(codec:String):Microphone {
			//修改:回音消除处理 AEC 2016.8.31
			var mic:Microphone = null;
			mic = Microphone.getEnhancedMicrophone();
			if (mic) {
				var options:MicrophoneEnhancedOptions = new MicrophoneEnhancedOptions();
				options.mode = MicrophoneEnhancedMode.FULL_DUPLEX;
				options.autoGain = false;
				options.echoPath = 128;
				options.nonLinearProcessing = true;
				mic['enhancedOptions'] = options;
				mic.setUseEchoSuppression(true);
			} else {
				mic = Microphone.getMicrophone();
			}
			if (mic == null) {
				trace("No microphone! <o>");
			} else {
				mic.addEventListener(StatusEvent.STATUS, onMicStatusEvent);
				mic.setLoopBack(false);
				mic.setSilenceLevel(0, 20000);
				mic.gain = 60;
				if (codec == "SPEEX") {
					mic.encodeQuality = 6;
					mic.codec = SoundCodec.SPEEX;
					mic.framesPerPacket = 1;
					mic.rate = 16;
					trace("Using SPEEX wideband codec");
				} else {
					mic.codec = SoundCodec.NELLYMOSER;
					mic.rate = 8;
					trace("Using Nellymoser codec");
				}
			}
			return mic;
			
			//官方文档
//			mic = Microphone.getEnhancedMicrophone();
//			mic.gain=60;
//			mic.rate =22;
//			return mic;

			
			
//			
//			var _microphone:Microphone;				
//			try
//			{
//				_microphone =Microphone.getEnhancedMicrophone();
//			}
//			catch(e:Error)
//			{
//				_microphone= null;			
//			}			
//			if(_microphone == null)
//			{				
//				try
//				{
//					_microphone =Microphone.getMicrophone();
//				}
//				catch(e:Error)
//				{
//					_microphone= null;
//				}				
//			}			
//			if(_microphone == null)
//			{
//				return null;
//			}			
//			_microphone.codec = SoundCodec.PCMA;	
//			_microphone.gain = 50;
//			//_microphone.setUseEchoSuppression(true);
//			_microphone.setLoopBack(false);
//			
//			
//			var options:MicrophoneEnhancedOptions = new MicrophoneEnhancedOptions();
//			//模式，默认使用全双工模式
//			options.mode = MicrophoneEnhancedMode.FULL_DUPLEX;
//			//是否启用自动增益控制
//			//options.autoGain = true;
//			//回声路径,值越大，回声抑制效果越好，但声音的延迟会越大，消耗的资源会越多，值取128或256
//			options.echoPath = 128;
//			//非线性处理，处理乐音时最好关闭
//			options.nonLinearProcessing = true;
//			_microphone.enhancedOptions=options;
//			
//			return _microphone;	
			
			
		}
		
		protected function onMicStatusEvent(event:StatusEvent):void {
			trace("New microphone status event");
			//trace(ObjectUtil.toString(event));
			switch (event.code) {
				case "Microphone.Muted":
					break;
				case "Microphone.Unmuted":
					break;
				default:
					break;
			}
		}
		
		public function close():void {
			if (_incomingStream) {
				_incomingStream.removeEventListener(NetDataEvent.MEDIA_TYPE_DATA, onNetDataEvent);
				_incomingStream.removeEventListener(NetStatusEvent.NET_STATUS, onNetStatusEvent);
				_incomingStream.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, onAsyncErrorEvent);
				_incomingStream.close();
				_incomingStream = null;
			}
			if (_outgoingStream) {
				_outgoingStream.removeEventListener(NetStatusEvent.NET_STATUS, onNetStatusEvent);
				_outgoingStream.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, onAsyncErrorEvent);
				_outgoingStream.attachAudio(null);
				_outgoingStream.close();
				_outgoingStream = null;
			}
		}
		
		protected function onNetStatusEvent(event:NetStatusEvent):void {
			trace("VoiceStreamManager: onNetStatusEvent - " + event.info.code);
			switch (event.info.code) {
				case "NetStream.Play.Reset":
					break;
				case "NetStream.Play.StreamNotFound":
					break;
				case "NetStream.Play.Failed":
					break;
				case "NetStream.Play.Start":
					break;
				case "NetStream.Play.Stop":
					break;
				case "NetStream.Publish.Start":
					break;
				case "NetStream.Buffer.Full":
					break;
				default:
					break;
			}
		}
		
		protected function onAsyncErrorEvent(event:AsyncErrorEvent):void {
			trace(ObjectUtil.toString(event));
		}
		
		public function onPlayStatus(... rest):void {
			trace("onPlayStatus() " + ObjectUtil.toString(rest));
		}
		
		public function onMetaData(... rest):void {
			trace("onMetaData() " + ObjectUtil.toString(rest));
		}
		
		public function onHeaderData(... rest):void {
			trace("onHeaderData() " + ObjectUtil.toString(rest));
		}
	}
}
