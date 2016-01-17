package com.fenhongxiang.util
{
	public final class ObjectUtil
	{
		public function ObjectUtil()
		{
		}
		
		public static function available(obj:Object, ...args):Boolean
		{
			if(obj == null) return false;
			
			for each(var prop:* in args)
			{
				if (!obj.hasOwnProperty(prop) || obj[prop] == null )
				{
					return false;
					break;
				}
			}
			
			return true;
		}
	}
}