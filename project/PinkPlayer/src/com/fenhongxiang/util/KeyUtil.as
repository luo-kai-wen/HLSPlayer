package com.fenhongxiang.util
{
	import flash.utils.ByteArray;

	public class KeyUtil
	{
		public function KeyUtil()
		{
		}
		
		public static function getKeyBytesByID(id:String):ByteArray
		{
			var keyData:ByteArray = new ByteArray();
				keyData.position = 0;
				
			var keyString:String = "";
			
			switch(id)
			{
				case "1":
				{
					keyString = "51338x999y837479";
					break;
				}
				case "2":
				{
					keyString = "51338x999y837479";
					break;
				}
				case "3":
				{
					keyString = "51338x999y837479";
					break;
				}
				case "4":
				{
					keyString = "51338x999y837479";
					break;
				}
				case "5":
				{
					keyString = "51338x999y837479";
					break;
				}
					
				default:
				{
					break;
				}
			}
			
			keyData.writeUTFBytes(keyString);
			
			return keyData;
		}
	}
}