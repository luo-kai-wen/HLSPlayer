package com.fenhongxiang.cue
{
	import com.fenhongxiang.util.LogUtil;

	public class CueUtil
	{
		public function CueUtil()
		{
			// String -> Json objet
			// Json根据时间排序
			// 绘制时间点
			// 鼠标移到时间点上 会显示内容
		}
		
		public static const testJson:String = 	"["+
			
			"{"+
			"\"pos\": 0.03,"+
			"\"text\": \"即将遭遇猎杀\""+
			"},"+
			"{"+
				"\"pos\": 0.2,"+
				"\"text\": \"遇见受伤的小龙\""+
			"},"+
			"{"+
				"\"pos\": 0.56,"+
				"\"text\": \"找到洞穴，准备进去一探究竟\""+
			"}"+
		"]";
		
		public static function jsonToVector(json:String):Vector.<CueData>
		{
			try
			{
				var cueArr:* = JSON.parse(json);
			}
			catch(e:Error)
			{
				
			}
			
			if (cueArr != null && cueArr is Array)
			{
				var result:Vector.<CueData> = new Vector.<CueData>();
				
				for each(var obj:Object in cueArr)
				{
					var cueData:CueData = new CueData();
					cueData.pos = obj['pos'];
					cueData.text = obj['text'];
					
					LogUtil.debug(cueData.pos + ":" + cueData.text);
					result.push(cueData);
				}
				
				return result;
			}
			else
			{
				return null;
			}
		}
		
	}
}