package PointRollAPI_AS3.activities{
/**
* Reminder Activities
* @author Chris Deely - PointRoll
* @version 1.0
* @see PointRoll#activity()
* @includeExample ../../examples/PointRoll/PointRoll_GameActivity.txt -noswf
*/

public class ReminderActivities{
	/** Activity to be tracked when a user accesses an Outlook reminder*/
	public static const OUTLOOK:Number = 8960
	/** Activity to be tracked when a user accesses an iCal reminder*/
	public static const ICAL:Number = 8961 
	/** Activity to be tracked when a user signs up for an SMS text message reminder*/
	public static const SMS:Number = 8962 
	/** Activity to be tracked when a user signs up to receive an email reminder*/
	public static const EMAIL:Number= 8963 
}
}