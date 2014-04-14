package classes.DataClasses
{
	public class MapMissionTaskData
	{
		public function MapMissionTaskData()
		{
		}
		
		public static const missionNameMapDic:Object={"花灯街(1)":"HuaDengJie","花灯街(3)":"HuaDengJie","总兵府(3)":"ZongBingFu","凉善阁(1)":"LiangShanGe","二贤庄(3)":"ErXianZhuang","长鸣殿(2)":"ChangMingDian","汝南庄(5)":"NuNanZhuang","历城(2)":"LiCheng","赤水湾(7)":"ChiShuiWan","凉善阁(2)":"LiangShanGe","历城(4)":"LiCheng","汝南庄(6)":"NuNanZhuang","杏花林(5)":"XingHuaLin","擂台(1)":"LeiTai","楂树岗(3)":"ZhaShuGang","济南府(3)":"JiNanFu","小孤山(5)":"XiaoGuShan","小孤山(7)":"XiaoGuShan","金叶坡(1)":"JinYePo","越王府(2)":"YueWangFu","北平府(1)":"BeiPingFu","小孤山(1)":"XiaoGuShan","北平府(2)":"BeiPingFu","花灯街(4)":"HuaDengJie","二贤庄(4)":"ErXianZhuang","军营(3)":"JunYing","郊外(2)":"JiaoWai","军营(4)":"JunYing","越王府(3)":"YueWangFu","济南府(4)":"JiNanFu","楂树岗(5)":"ZhaShuGang","总兵府(5)":"ZongBingFu","长鸣殿(3)":"ChangMingDian","凉善阁(3)":"LiangShanGe","总兵府(4)":"ZongBingFu","金叶坡(2)":"JinYePo","汝南庄(7)":"NuNanZhuang","花灯街(5)":"HuaDengJie","楂树岗(4)":"ZhaShuGang","杏花林(1)":"XingHuaLin","金叶坡(8)":"JinYePo","历城(5)":"LiCheng","金叶坡(7)":"JinYePo","二贤庄(1)":"ErXianZhuang","杏花林(6)":"XingHuaLin","擂台(5)":"LeiTai","凉善阁(4)":"LiangShanGe","历城(1)":"LiCheng","汝南庄(1)":"NuNanZhuang","赤水湾(3)":"ChiShuiWan","长鸣殿(4)":"ChangMingDian","郊外(3)":"JiaoWai","济南府(5)":"JiNanFu","军营(5)":"JunYing","赤水湾(2)":"ChiShuiWan","楂树岗(2)":"ZhaShuGang","北平府(3)":"BeiPingFu","越王府(4)":"YueWangFu","花灯街(6)":"HuaDengJie","金叶坡(5)":"JinYePo","皂角林(1)":"ZaoJiaoLin","军营(1)":"JunYing","赤水湾(1)":"ChiShuiWan","金叶坡(3)":"JinYePo","擂台(2)":"LeiTai","军营(6)":"JunYing","赤水湾(4)":"ChiShuiWan","花灯街(7)":"HuaDengJie","小孤山(6)":"XiaoGuShan","擂台(3)":"LeiTai","楂树岗(1)":"JiaoWai","汝南庄(2)":"NuNanZhuang","总兵府(2)":"ZongBingFu","总兵府(1)":"ZongBingFu","金叶坡(4)":"JinYePo","汝南庄(3)":"NuNanZhuang","军营(2)":"JunYing","杏花林(2)":"XingHuaLin","济南府(1)":"JiNanFu","花灯街(2)":"HuaDengJie","小孤山(4)":"XiaoGuShan","皂角林(2)":"ZaoJiaoLin","汝南庄(8)":"NuNanZhuang","济南府(2)":"JiNanFu","长鸣殿(1)":"ChangMingDian","擂台(4)":"LeiTai","越王府(1)":"YueWangFu","赤水湾(5)":"ChiShuiWan","北平府(5)":"BeiPingFu","二贤庄(2)":"ErXianZhuang","金叶坡(6)":"JinYePo","杏花林(3)":"XingHuaLin","历城(3)":"LiCheng","北平府(4)":"BeiPingFu","小孤山(3)":"XiaoGuShan","汝南庄(4)":"NuNanZhuang","擂台(6)":"LeiTai","赤水湾(6)":"ChiShuiWan","郊外(1)":"JiaoWai","杏花林(4)":"XingHuaLin","皂角林(3)":"ZaoJiaoLin","小孤山(2)":"XiaoGuShan"};
		public static function getMissionMapByMissionName(missionName:String):String
		{
			return missionNameMapDic[missionName];
		}
	}
}