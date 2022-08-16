package PointRollAPI_AS3.activities{
/**
* Activities for use with Form submissions
* @author Chris Deely - PointRoll
* @version 1.0
* @see PointRoll#activity()
* @includeExample ../../examples/PointRoll/PointRoll_GameActivity.txt -noswf
*/

public class FormActivities{
	/** Activity to be tracked when a user begins a form submission */
	public static const BEGIN:Number = 8930;
	/** Activity to be tracked when a user submits an email address*/
	public static const SUBMIT_EMAIL:Number = 8931;
	/** Activity to be tracked when a user submits more personal data than just an email address. For example, their name, location or birth date.*/
	public static const SUBMIT_PERSONAL:Number= 8932 
}
}