package classes.Creater
{
	import classes.tools.analysers.MissionMapDataAnalyser;

	public class INIDataCreater extends CreaterBase
	{
		public function INIDataCreater()
		{
			super();
		}
		override public function work():void
		{
			trace("begin work");
			create();
		}
		var tAnalyser:MissionMapDataAnalyser;
		public function create():void
		{
			tAnalyser=new MissionMapDataAnalyser;
			tAnalyser.loadTargetFile("/res/data/ZhuxianFuBen.ini");
//			tAnalyser.loadTargetFile("/res/data/maintask.ini");
			tAnalyser.parseWork();
		}
	}
}