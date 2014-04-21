package
{
	import SogaNet.WorldConnect;
	
	import flash.display.Sprite;
	
	public class SogaWorld extends Sprite
	{
		public function SogaWorld()
		{
			world=new WorldConnect();
			this.addChild(world);
			enterWorld();
		}
		private var world:WorldConnect;
		public function enterWorld():void
		{
			world.initialize(WorldConnect.WorldAdd);
		}
		
		public function enterRoom(roomID:String):void
		{
			
		}
	}
}