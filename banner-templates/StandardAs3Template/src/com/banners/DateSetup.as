package com.banners
{
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.text.TextField;

	/**
	 * @author crunkdutch
	 */
	public class DateSetup extends Sprite
	{
		public var date1 : MovieClip;
		public var date2 : MovieClip;
		public var date3 : MovieClip;
		public var date4 : MovieClip;
		public var date5 : MovieClip;
		public var targetDay : TextField;
		public var targetMonth : TextField;
		public var targetYear : TextField;
		public var finalDay : TextField;
		public var finalMonth : TextField;
		private var year : Number;
		private var month : Number;
		private var day : Number;
		private var today : Date = new Date();
		private var targetDate : Date;
		private var daysRemaining : Number;
		private var last_year : Number;
		private var last_month : Number;
		private var last_day : Number;
		private var lastDate : Date;
		private var last_daysRemaining : Number;

		public function DateSetup()
		{
			initDates();
			date1.visible = false;
			date2.visible = false;
			date3.visible = false;
			date4.visible = false;
			date5.visible = false;
			showDate();
		}

		private function initDates() : void
		{
			targetYear.visible = false;
			targetMonth.visible = false;
			targetDay.visible = false;
			finalMonth.visible = false;
			finalDay.visible = false;

			year = Number(targetYear.text);
			month = Number(targetMonth.text)-1; // subtract one because designers dont know that january is 0
			day = Number(targetDay.text);
			targetDate = new Date(year, month, day);
			daysRemaining = Math.ceil((targetDate.getTime() - today.getTime()) / 86400000);

			// extra date - like for a special case that happens after the target date
			last_year = Number(targetYear.text);
			last_month = Number(finalMonth.text)-1;
			last_day = Number(finalDay.text);
			lastDate = new Date(last_year, last_month, last_day);
			last_daysRemaining = Math.ceil((lastDate.getTime() - today.getTime()) / 86400000);
		}

		private function showDate() : void
		{
			if (daysRemaining > 6)
			{
				date1.visible = true;
			}
			else if (daysRemaining > 1 && daysRemaining < 6)
			{
				date2.visible = true;
			}
			else if (daysRemaining == 1)
			{
				date3.visible = true;
			}
			else if (daysRemaining == 0)
			{
				//est hack
				if ( (today.getUTCDate() == day + 1) && (today.getUTCHours() >= 1))
				{
					date4.visible = true;
				}
				else
				{
					date3.visible = true;
				}
			}
			else
			{
				if (last_daysRemaining <= 0) // the day or after - negative number is LESS than zero
				{
					date5.visible = true;
				}
				else
				{
					trace('are we here? else - else');
					date4.visible = true;
				}
			}
		}
	}
}