package
{
	import Entrance.MissionDataCreatorST;
	import Entrance.XmlJsonTool;
	
	import classes.Creater.CreaterBase;
	import classes.Creater.DramaXMLCreater;
	import classes.Creater.INIDataCreater;
	import classes.Creater.MissionDataCreater;
	import classes.tools.analysers.RoleFileAnalyserNew;
	
	import flash.display.Sprite;
	import flash.xml.XMLNode;
	
	import ww599.Tools.FileDealer;
	import ww599.Tools.StringTool;
	
	public class CodeLib extends Sprite
	{
		public function CodeLib()
		{
			work();
		}
		
		public function work():void
		{
			
//			var xml:XmlJsonTool;
//			xml=new XmlJsonTool;
			
//			var missionData:MissionDataCreatorST;
//			missionData=new MissionDataCreatorST();
			
//			var tt:XML;
//			var kk:XMLNode;
//			kk.localName
			
//			var iniCreater:INIDataCreater;
//			iniCreater=new INIDataCreater;
//			iniCreater.work();
			
//			testFun();
			
//			var dramaCreater:DramaXMLCreater;
//			dramaCreater=new DramaXMLCreater();
//			dramaCreater.work();
			
			
//			var roleAnalyser:RoleFileAnalyserNew;
//			roleAnalyser=new RoleFileAnalyserNew();
//			roleAnalyser.loadTargetFile("/res/data/人物属性.ini");
//			roleAnalyser.parseWork();
			
			var dataCreater:CreaterBase;
			dataCreater=new MissionDataCreater();
			dataCreater.work();
			
			
//			createTempStunt();
			
//			rewriteMissionTxt();

//			fileListText();
		}
		public function fileListText():void
		{
			var fileList:Array;
			fileList=FileDealer.getInstance().getFileList("/res/stand");
			
			var tName:String;
			var oPath:String;
			var dPath:String;
			var i:int;
			var len:int;
			len=fileList.length;
			
			for(i=0;i<len;i++)
			{
				
				tName=fileList[i];
				
				
				
				oPath="/res/stand/"+tName;
				
				FileDealer.getInstance().copyFile(oPath,"/dramaAvatar/"+StringTool.getReplaceOne(tName,".swf","Drama.swf"));
				
			}
		}
		public function rewriteMissionTxt():void
		{
			var missList:Object={"济南府(5)":62,"长鸣殿(3)":49,"皂角林(2)":26,"总兵府(5)":67,"凉善阁(4)":36,"擂台(4)":16,"二贤庄(3)":11,"汝南庄(1)":73,"郊外(3)":3,"汝南庄(7)":79,"杏花林(6)":24,"长鸣殿(1)":47,"北平府(5)":32,"擂台(2)":14,"郊外(2)":2,"汝南庄(8)":80,"总兵府(3)":65,"汝南庄(2)":74,"皂角林(3)":27,"小孤山(4)":84,"军营(1)":37,"北平府(2)":29,"杏花林(2)":20,"皂角林(1)":25,"济南府(4)":61,"汝南庄(5)":77,"花灯街(5)":55,"凉善阁(1)":33,"擂台(6)":18,"楂树岗(3)":6,"花灯街(3)":53,"花灯街(4)":54,"小孤山(3)":83,"小孤山(5)":85,"越王府(4)":46,"凉善阁(2)":34,"金叶坡(2)":96,"济南府(2)":59,"金叶坡(7)":101,"赤水湾(3)":90,"擂台(5)":17,"花灯街(2)":52,"军营(2)":38,"擂台(1)":13,"汝南庄(6)":78,"汝南庄(3)":75,"总兵府(4)":66,"金叶坡(6)":100,"济南府(1)":58,"历城(1)":68,"花灯街(7)":57,"历城(2)":69,"金叶坡(3)":97,"金叶坡(4)":98,"军营(5)":41,"花灯街(1)":51,"赤水湾(2)":89,"济南府(3)":60,"杏花林(3)":21,"小孤山(6)":86,"二贤庄(2)":10,"杏花林(1)":19,"花灯街(6)":56,"赤水湾(4)":91,"杏花林(4)":22,"长鸣殿(2)":48,"二贤庄(4)":12,"汝南庄(4)":76,"小孤山(2)":82,"楂树岗(2)":5,"历城(3)":70,"赤水湾(5)":92,"擂台(3)":15,"赤水湾(6)":93,"郊外(1)":1,"军营(6)":42,"北平府(3)":30,"凉善阁(3)":35,"楂树岗(4)":7,"越王府(3)":45,"金叶坡(8)":102,"军营(3)":39,"长鸣殿(4)":50,"历城(5)":72,"楂树岗(1)":4,"北平府(1)":28,"越王府(1)":43,"小孤山(7)":87,"金叶坡(5)":99,"总兵府(1)":63,"杏花林(5)":23,"军营(4)":40,"赤水湾(7)":94,"小孤山(1)":81,"北平府(4)":31,"赤水湾(1)":88,"二贤庄(1)":9,"历城(4)":71,"越王府(2)":44,"楂树岗(5)":8,"金叶坡(1)":95,"总兵府(2)":64};
			var missSign:Object={"济南府(5)":"JiNanFu","长鸣殿(3)":"ChangMingDian","皂角林(2)":"ZaoJiaoLin","总兵府(5)":"ZongBingFu","凉善阁(4)":"LiangShanGe","擂台(4)":"LeiTai","二贤庄(3)":"ErXianZhuang","汝南庄(1)":"NuNanZhuang","郊外(3)":"JiaoWai","汝南庄(7)":"NuNanZhuang","杏花林(6)":"XingHuaLin","长鸣殿(1)":"ChangMingDian","北平府(5)":"BeiPingFu","擂台(2)":"LeiTai","郊外(2)":"JiaoWai","汝南庄(8)":"NuNanZhuang","总兵府(3)":"ZongBingFu","汝南庄(2)":"NuNanZhuang","皂角林(3)":"ZaoJiaoLin","小孤山(4)":"XiaoGuShan","军营(1)":"JunYing","北平府(2)":"BeiPingFu","杏花林(2)":"XingHuaLin","皂角林(1)":"ZaoJiaoLin","济南府(4)":"JiNanFu","汝南庄(5)":"NuNanZhuang","花灯街(5)":"HuaDengJie","凉善阁(1)":"LiangShanGe","擂台(6)":"LeiTai","楂树岗(3)":"ZhaShuGang","花灯街(3)":"HuaDengJie","花灯街(4)":"HuaDengJie","小孤山(3)":"XiaoGuShan","小孤山(5)":"XiaoGuShan","越王府(4)":"YueWangFu","凉善阁(2)":"LiangShanGe","金叶坡(2)":"JinYePo","济南府(2)":"JiNanFu","金叶坡(7)":"JinYePo","赤水湾(3)":"ChiShuiWan","擂台(5)":"LeiTai","花灯街(2)":"HuaDengJie","军营(2)":"JunYing","擂台(1)":"LeiTai","汝南庄(6)":"NuNanZhuang","汝南庄(3)":"NuNanZhuang","总兵府(4)":"ZongBingFu","金叶坡(6)":"JinYePo","济南府(1)":"JiNanFu","历城(1)":"LiCheng","花灯街(7)":"HuaDengJie","历城(2)":"LiCheng","金叶坡(3)":"JinYePo","金叶坡(4)":"JinYePo","军营(5)":"JunYing","花灯街(1)":"HuaDengJie","赤水湾(2)":"ChiShuiWan","济南府(3)":"JiNanFu","杏花林(3)":"XingHuaLin","小孤山(6)":"XiaoGuShan","二贤庄(2)":"ErXianZhuang","杏花林(1)":"XingHuaLin","花灯街(6)":"HuaDengJie","赤水湾(4)":"ChiShuiWan","杏花林(4)":"XingHuaLin","长鸣殿(2)":"ChangMingDian","二贤庄(4)":"ErXianZhuang","汝南庄(4)":"NuNanZhuang","小孤山(2)":"XiaoGuShan","楂树岗(2)":"ZhaShuGang","历城(3)":"LiCheng","赤水湾(5)":"ChiShuiWan","擂台(3)":"LeiTai","赤水湾(6)":"ChiShuiWan","郊外(1)":"JiaoWai","军营(6)":"JunYing","北平府(3)":"BeiPingFu","凉善阁(3)":"LiangShanGe","楂树岗(4)":"ZhaShuGang","越王府(3)":"YueWangFu","金叶坡(8)":"JinYePo","军营(3)":"JunYing","长鸣殿(4)":"ChangMingDian","历城(5)":"LiCheng","楂树岗(1)":"ZhaShuGang","北平府(1)":"BeiPingFu","越王府(1)":"YueWangFu","小孤山(7)":"XiaoGuShan","金叶坡(5)":"JinYePo","总兵府(1)":"ZongBingFu","杏花林(5)":"XingHuaLin","军营(4)":"JunYing","赤水湾(7)":"ChiShuiWan","小孤山(1)":"XiaoGuShan","北平府(4)":"BeiPingFu","赤水湾(1)":"ChiShuiWan","二贤庄(1)":"ErXianZhuang","历城(4)":"LiCheng","越王府(2)":"YueWangFu","楂树岗(5)":"ZhaShuGang","金叶坡(1)":"JinYePo","总兵府(2)":"ZongBingFu"};
			
			var tName:String;
			var oPath:String;
			var dPath:String;
			for(tName in missList)
			{

				
				oPath="/res/main/"+tName+".txt";

			    FileDealer.getInstance().copyFile(oPath,"/numMissionData/"+missSign[tName]+missList[tName]+".txt");
				
			}
		}
		public function createTempStunt():void
		{
			var stuntList:Array=["TianLingXuanJian","HuaYunGaiDing","ZhanYuanShen","YaZhi","FenZhan","WeiXie","PaoXiao","XiePo","HuiFeng","BengLie","LeiYing","TianZhao","GuiLing","KuangBao","YuanDao","FangTianLuanWu","FanSha","YongGong","HeiYunYaJing","LieHuoHongLei","JinLvFeiQue","LuoYingJian","XuanFengZhan","XuanHuaLing","LiHuaSa","FeiLianTaLang","TianLeiPo","BaiBuChuanYang","LiHunZhang","WuShuangJian","FeiQuanLuo","SaShouJian","XiaGanYiDan","LiuYunFeiYu","SanHunDuan","FeiShaCiGu","ShuangLongRuHai","TianJueDiMie","JingTaoHaiLang","DuanHouShu","NuShiZhan","JianChuPengLai","KaoShanYiJi","HongChenXiao","HuiMaQiang","XingChenLie","ZhenCangQiong","YiSheZhan","ChuanYunLieShi","LieHuoGongXin","FengJuanCanYun","GuiShiShenChai","PoFuChenZhou","WeiZhenBaFang","HuiShouQinLong","SanBanFu"];
			
			var i:int;
			var len:int;
			
			var oPath:String;
			var dPath:String;
			
			oPath="/res/avater/TianMei.swf";
			len=stuntList.length;
			for(i=0;i<len;i++)
			{
				FileDealer.getInstance().copyFile(oPath,"/tempAvater/stunt/"+stuntList[i]+".swf");
			}
		}
		private function testFun():void
		{
			trace(kkFun.length);
		}
		private function kkFun(i:int,kk:Function):void
		{
			
		}
	}
}