package
{
	import starling.events.Event;
	import starling.display.Sprite;
	import starling.core.Starling;
		
	import feathers.controls.Screen;
	import feathers.controls.Button;
	import feathers.layout.VerticalLayout;
	import feathers.layout.VerticalLayoutData;
	import feathers.layout.HorizontalLayout;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	import feathers.themes.MetalWorksMobileTheme;
	import feathers.events.FeathersEventType;
	import starling.utils.AssetManager;
	
	import flash.filesystem.File;
	import starling.display.Button;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.media.Video;
	import flash.text.engine.EastAsianJustifier;
	
	public class Main extends Screen
	{
		private var assetMgr:AssetManager;
		private var controlButton:Button;
		private var pauseButton:Button;
		private var videoStream:NetStream;
		
		private var video:Video;
		private var videoPlaying:Boolean;
		private var portraitMode:Boolean;
		
		public function Main()
		{
			// constructor code
			super();
			
			this.addEventListener(FeathersEventType.INITIALIZE, initializeHandler);
		}
		
		private function initializeHandler(e:Event):void
		{
			this.removeEventListener(FeathersEventType.INITIALIZE, initializeHandler);
			
			this.stage.addEventListener(Event.RESIZE, stageResized);
			
			assetMgr = new AssetManager();
			assetMgr.verbose = true;
			
			var appDir:File = File.applicationDirectory;
			
			assetMgr.enqueue(appDir.resolvePath("assets"));
			assetMgr.loadQueue(handleAssetsLoading);
			
		}
		
		private function handleAssetsLoading(ratioLoaded:Number):void
		{
			trace("handleAssetsLoading: " + ratioLoaded);
			
			if (ratioLoaded == 1)
			{
				startApp();
			}
		}
		
		private function startApp()
		{
			new MetalWorksMobileTheme();
			
			this.layout = new AnchorLayout();
			
			this.height = this.stage.stageHeight;
			this.width = this.stage.stageWidth;
			
			portraitMode = true;
			
			setupVideo();
			
			setupButton();
			
			pauseButton();
		}
		
		private function setupVideo()
		{
			var nc:NetConnection = new NetConnection();
			
			nc.connect(null);
			
			videoStream = new NetStream(nc);
			
			videoStream.client = this;
			
			video = new Video();
			Starling.current.nativeStage.addChild(video);
			
			video.attachNetStream(videoStream);
			
			videoPlaying = false;
			
			positionVideo();
		}
		private function setupButton()
		{
			controlButton = new Button();
			controlButton.label = "Play";
			
			var controlButtonLayout:AnchorLayoutData = new AnchorLayoutData();
			controlButtonLayout.left = 5;
			controlButtonLayout.right = 5;
			controlButtonLayout.bottom = 1;
			
			controlButton.layoutData = controlButtonLayout;
			
			controlButton.addEventListener(Event.TRIGGERED, handleControlButtonClick);
			this.addChild(controlButton);
								
		}
		
		private function pauseButton():void
		{
			pauseButton = new Button();
			pauseButton.label = "Pause";
			
			var pauseButtonLayout:AnchorLayoutData = new AnchorLayoutData();
			pauseButtonLayout.left = 5;
			pauseButtonLayout.right = 5;
			pauseButtonLayout.bottom = 30;
			
			pauseButton.layoutData = controlButtonLayout;
			
			pauseButton.addEventListener(Event.TRIGGERED, handlePauseButtonClick);
			this.addChild(pauseButton);
								
		}
		
		private function handleControlButtonClick(e:Event):void
		{
			if (! videoPlaying)
			{
				videoStream.play("videos/here.mp4");
				controlButton.label = "Stop";
				videoPlaying = true;
			}
			else
			{
				videoStream.close();
				videoPlaying = false;
				controlButton.label = "Play";
			}
		}
		
		private function handlePauseButtonClick(e:Event):void
		{
			videoStream.togglePause();
		}
		
		protected function stageResized(e:EastAsianJustifier):void
		{
			this.height = this.stage.stageHeight;
			this.width = this.stage.stageWidth;
			
			if (this.height > this.width)
			{
				this.portraitMode = true;
			}
			else
			{
				this.portraitMode = false;
			}
			
			positionVideo();
		}
		
		private function positionVideo()
		{
			if (video != null)
			{
				if (! portraitMode)
				{
					video.height = this.height - controlButton.height - 5 - 10;
					video.scaleX = video.scaleY;
					
					video.x = (this.width - video.width)/2;
					video.y = 5;
				}
				else
				{
					video.width = this.width - 10;
					video.scaleY = video.scaleX;
					
					video.x = 5;
					video.y = 5;
					
				}
			}
		}
		public function onMetaData(infoObject:Object)
		{
			trace("onMeta invoked...")
		}
		public function onXMPData(infoObject:Object)
		{
			trace("onMeta invoked...")
		}
		public function onCuePoint(infoObject:Object)
		{
			trace("onMeta invoked...")
		}
	}

}