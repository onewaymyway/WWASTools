package Entrance
{
	import classes.Creater.CreaterBase;
	import classes.Creater.MissionDataCreater;
	import classes.Creater.RoleDataCreater;
	import classes.dataStruct.MapData;
	import classes.tools.Base.FileAnalyserBase;
	import classes.tools.FileDealer;
	import classes.tools.StringTool;
	
	import flash.display.Sprite;
	
	public class MissionDataCreatorST extends Sprite
	{
		public function MissionDataCreatorST()
		{
			
			work();
			
//			createTempAvater();
//			createTempMissionMap();
//			createTempMissionIcon();
			
		}
        private var dataCreater:CreaterBase;
		
		public function work():void
		{
			
			dataCreater=new MissionDataCreater();
			
//			dataCreater=new RoleDataCreater();
			
			dataCreater.work();
		}
		
		public function createTempMissionMap():void
		{
			var mapList:Array=["XingHuaLin","ZaoJiaoLin","BeiPingFu","LiangShanGe","JunYing","YueWangFu","ChangMingDian","HuaDengJie","JiNanFu","ZongBingFu","LiCheng","NuNanZhuang","XiaoGuShan","ChiShuiWan","JinYePo"];
			
			var i:int;
			var len:int;
			
			var oPath:String;
			var dPath:String;
			
			oPath="/res/missionMap/JiaoWai";
			len=mapList.length;
			for(i=0;i<len;i++)
			{
				FileDealer.getInstance().copyFile(oPath,"/tempMap/"+mapList[i]);
			}
			
            function saveMap(mapSign:String):void
			{
				
			}
		}
		public function createTempMissionIcon():void
		{
			var mapList:Array=["ErXianZhuang","LeiTai","XingHuaLin","ZaoJiaoLin","BeiPingFu","LiangShanGe","JunYing","YueWangFu","ChangMingDian","HuaDengJie","JiNanFu","ZongBingFu","LiCheng","NuNanZhuang","XiaoGuShan","ChiShuiWan","JinYePo"];;
			
			var i:int;
			var len:int;
			
			var oPath:String;
			var dPath:String;
			
			oPath="/res/entranceIcon/JiaoWai.png";
			len=mapList.length;
			for(i=0;i<len;i++)
			{
				FileDealer.getInstance().copyFile(oPath,"/tempMissionIcon/"+mapList[i]+".png");
			}
			
			function saveMap(mapSign:String):void
			{
				
			}
		}
		public function  createTempAvater():void
		{
			
			var roleList:Array=["QiangBingLan","JianShiHong","QiangBingLan","DaoBingLan","ShiNvHong","JianShiLan","QiangBingHuang","DaoBingHuang","ShiNvLan","JianShiLv","QiangBingLv","DaoBingLv","ShiNvLv","XMQZi","XMQHong","XMQLan","XMDZi","XMDHong","XMDLan","QiangBingLan","QiangBingHuang","DaoBingHuang","QiangBingLv","DaoBingLv","QiangBingLan","DaoBingLan","QiangBingLv","DaoBingLv","HeiYiRenQiang","HeiYiRenDao","HeiYiRenDao","XMQLan","XMDZi","XMQHong","JianShiLv","XMQHong","XMDHong","ShiNvLv","QiangBingHuang","DaoBingLv","XMQLan","XMDZi","JianShiLv","ShiNvLan","XMQZi","XMQLan","XMDZi","XMDLan","QiangBingLan","DaoBingLan","QiangBingLv","DaoBingLv","QiangBingLan","DaoBingLan","QiangBingLan","DaoBingLan","QiangBingLv","DaoBingLv","YangGuang","AnLuShan","TuJueShangRen","NvPu1","NvPu2","NvPu3","LiRongRong","ShanYingYing","ShiDaNai","XuanHuaFuRen","RuYiGongZhu","ZhangLiHua","ShanXiongXin","WangBoDang","PingYangGongZhu","YangYuEr","YuChiGong","QinQiong","ChaiShao","PeiCuiYun","LaiHuEr","XinYueE","CaoYanPing","XinWenLi","MaSaiFei","ShangShiTu","WeiWenTong","DouXianNiang","YangLin","HongFuNv","LuoCheng","XuMaoGong","WuTianXi","WuYunZhao","FanLiHua","XiongKuoHai","PeiYuanQing","XiaoMeiNiang","YuWenChengDu","LiYuanBa","LiShiMin","ChengYaoJin"];
			
		    var i:int;
			var len:int;
			
			var oPath:String;
			var dPath:String;
			
			oPath="/res/avater/run.swf";
			len=roleList.length;
			for(i=0;i<len;i++)
			{
				FileDealer.getInstance().copyFile(oPath,"/tempAvater/run/"+roleList[i]+".swf");
			}
			
			oPath="/res/avater/ShenWuNan.swf";
			len=roleList.length;
			for(i=0;i<len;i++)
			{
				FileDealer.getInstance().copyFile(oPath,"/tempAvater/stand/"+roleList[i]+".swf");
			}
			
			oPath="/res/avater/PiaoQiNan.swf";
			len=roleList.length;
			for(i=0;i<len;i++)
			{
				FileDealer.getInstance().copyFile(oPath,"/tempAvater/war/"+roleList[i]+".swf");
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
	}
}