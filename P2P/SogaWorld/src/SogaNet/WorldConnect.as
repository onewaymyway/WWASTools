package SogaNet
{
	import SogaDis.Player;
	
	import com.reyco1.multiuser.MultiUserSession;
	import com.reyco1.multiuser.data.UserObject;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class WorldConnect extends Sprite
	{
		public function WorldConnect()
		{
		}
		
		private const SERVER		:String   = "rtmfp://p2p.rtmfp.net/";
		private const DEVKEY		:String   = "d8a803bfdc1b74f34e087709-7f1d117981bf"; // TODO: add your Cirrus key here. You can get a key from here : http://labs.adobe.com/technologies/cirrus/
		private const SERV_KEY		:String = SERVER + DEVKEY;
		
		public static const WorldAdd:String="SogaWolrd";
		
		private const OP_ROTATION 	:String = "R";
		private const OP_SHOT 		:String = "S";
		private const OP_DIE 		:String = "D";
		private const OP_POSITION 	:String = "P";
		
		private var mConnection		:MultiUserSession;
		
		private var mMyName			:String;
		private var mMyColor		:uint;
		
		public function initialize(addr:String):void 
		{
			mConnection = new MultiUserSession(SERV_KEY, addr); 		// create a new instance of MultiUserSession
			
			mConnection.onConnect 		= handleConnect;						// set the method to be executed when connected
			mConnection.onUserAdded 	= handleUserAdded;						// set the method to be executed once a user has connected
			mConnection.onUserRemoved 	= handleUserRemoved;					// set the method to be executed once a user has disconnected
			mConnection.onObjectRecieve = handleGetObject;						// set the method to be executed when we recieve data from a user
			mConnection.onChatMessage=handleChatMessage;
			mMyName  = "User_" + Math.round(Math.random()*100);
			mMyColor = 0x888888 + Math.random() * 0x888888;
			
			var aStartX :Number = 20 + 200*Math.random();
			var aStartY :Number = 20 +200*Math.random();
			
			mConnection.connect(mMyName, { color: mMyColor, x: aStartX, y: aStartY, name: mMyName } );
			
		}

		private var me:Player;
		private var playerDic			:Object = {};
		protected function handleConnect(theUser:UserObject) :void 
		{
            
			me=new Player();
			me.color=mMyColor;
			me.nameStr=mMyName+"{me}";
			me.create();
			me.x=theUser.details.x;
			me.y=theUser.details.y;
			
			this.addChild(me);
			
			playerDic[theUser.id]=me;
			this.stage.addEventListener(MouseEvent.CLICK,mouseClick);
		}
		
		private function addUserByObj(theUser:UserObject):void
		{
			
		}
		protected function handleUserAdded(theUser:UserObject) :void 
		{
			
			if(playerDic[theUser.id]) return;
			var tP:Player;
			tP=new Player();
			tP.color=theUser.details.color;
			tP.nameStr=theUser.details.name;
			tP.create();
			tP.x=theUser.details.x;
			tP.y=theUser.details.y;
			
			this.addChild(tP);
			playerDic[theUser.id]=tP;
			
			mConnection.sendChatMessage("hello i am "+mMyName,theUser);
		}
		
		protected function handleChatMessage(data:Object):void
		{
			trace("receive chat:"+data);
		}
		protected function handleUserRemoved(theUser:UserObject) :void 
		{
			if(playerDic[theUser.id])
			{
				var tP:Player;
				tP=playerDic[theUser.id];
				if(tP&&tP.parent)
				{
					tP.parent.removeChild(tP);
				}
				delete playerDic[theUser.id];
			}
		}
		
		
		protected function handleGetObject(theUserId :String, theData :Object) :void 
		{
			var aOpCode :String = theData.op;
			
			switch(aOpCode) {
				case OP_POSITION:
					syncPosition(theUserId, theData);
					break;

			}
		}
		public function sendPosition(tp :Player) :void	{
			mConnection.sendObject({op: OP_POSITION, x: tp.x, y: tp.y});
		}
		private function mouseClick(evt:MouseEvent):void
		{
			var tX:Number;
			var tY:Number;
			tX=this.mouseX;
			tY=this.mouseY;
			me.moveTo(tX,tY);
			mConnection.sendObject({op: OP_POSITION, x: tX, y: tY});
		}
		private function syncPosition(theUserId :String, theData :Object) :void {
			var tP:Player;
			tP=playerDic[theUserId];
			if(tP&&tP.parent)
			{
				tP.moveTo(theData.x,theData.y);
			}
		}
	}
}