package com.choomba.utils
{
	public class DateUtils
	{
		public function DateUtils()
		{
		}
		
		public static function getDayString(date:Date):String
		{
			var days:Array = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
			
			return days[date.day];
		}
		
		public static function getMonthString(date:Date):String
		{
			var months:Array = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", 
				"Aug", "Sep", "Oct", "Nov", "Dec"];
			
			return months[date.month];
		}
		
		public static function timeStamp(today:Date):String
		{
			// convert to 12 hour time
			var hour:Number = today.hours;
			if (hour > 12)
				hour -= 12;
			
			var cycle:String = 'am';
			
			if (today.hours > 11 && today.hours < 24)
				cycle = 'pm';
			
			return DateUtils.getDayString(today) + ' ' + DateUtils.getMonthString(today)
				+ ' ' + today.date + ' ' + hour + ':' + today.minutes + ' ' + cycle + ' A.F. 17';
		}
	}
}