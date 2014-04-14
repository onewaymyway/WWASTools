package classes.tools.analysers
{
	import classes.consts.CommonConsts;
	import classes.dataStruct.XMLObject;
	import classes.tools.Base.FileAnalyserBase;
	import classes.tools.DebugTools;
	import classes.tools.FileDealer;
	import classes.tools.parser.ParserEngine;

	public class RoleFileAnalyserNew  extends FileAnalyserBase
	{
		public function RoleFileAnalyserNew()
		{
			super();
			parserEngine=new ParserEngine;
			//			parserEngine.loadDesFile("/res/parseDes/MissionDataDesS.txt");
			parserEngine.loadDesFile("/res/parseDes/RoleDataDesNow.txt");
		}
		public var MissionDataList:Array=[];
		public var parserEngine:ParserEngine;
		override public function parseWork():void
		{
			var i:int;
			var len:int;
			var tType:String;
			var tStr:String;
			var tMissionData:Object={};
			len=this.getLineCount();
			for(i=0;i<len;i++)
			{
				tStr=this.getLineTxt(i);
				tType=parserEngine.getLineType(tStr);
				switch(tType)
				{
					case CommonConsts.TYPE_BEGIN:
						tMissionData=new Object;
						tMissionData.name=parserEngine.getSectionName(tStr);
						MissionDataList.push(tMissionData);
						break;
					case CommonConsts.TYPE_COMMENT:
					case CommonConsts.TYPE_EMPTY:
						continue;
						break;
					default:
						parserEngine.parseLine(tStr,tType,tMissionData);
				}
			}
			
			DebugTools.traceObj(MissionDataList,"resultdd");
			saveData();
		}
		private function saveData():void
		{
			var dataO:Object;
			var tRole:Object;
			var i:String;
			dataO=MissionDataList[0];
			var restO:Object;
			var adtRole:Object;
			restO={};
			var skillList:Array=[];
			restO.skill=skillList;
			for(i in dataO)
			{
				if(i=="name") continue;
				tRole=dataO[i];
				adtRole=new Object;
				adtRole.roleName=tRole.name;
				adtRole.id=tRole.id;
				adtRole.stuntType="近攻|远攻";
				adtRole.skillName="绝技名";
				adtRole.attackEffect=getAttackObj();
				adtRole.attackedEffect=getAttackedObj();
				adtRole.actionEffect=getActionEffecttObj();
				adtRole.des=getSkillDesObj();
//				restO["skill"+adtRole.id]=adtRole;
				skillList.push(adtRole);
			}
			FileDealer.getInstance().saveObjectToXmlFile("/output/xml/roleSkilldata.xml",restO,"skill");
		}
		private function getSkillDesObj():Object
		{
			var rst:Object;
			rst={};
			rst.des="特效效果具体描述";
			return rst;
		}
		private function getActionEffecttObj():Object
		{
			var rst:Object;
			rst={};
			rst.des="动作特效效果具体描述";
			return rst;
		}
		private function getAttackObj():Object
		{
			var rst:Object;
			rst={};
			rst.sign="攻击者特效动画";
			rst.type="与动作同时播放|动作完成后播放";
			rst.des="特效效果具体描述";
			return rst;
		}
		
		private function getAttackedObj():Object
		{
			var rst:Object;
			rst={};
			rst.sign="被攻击者特效动画";
			rst.type="与动作同时播放|动作完成后播放";
			rst.des="特效效果具体描述";
			return rst;
		}
	}
}