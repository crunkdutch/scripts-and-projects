package PointRollAPI_AS3.activities{
/**
* General standard activities
* @author Chris Deely - PointRoll
* @version 1.0
* @see PointRoll#activity()
* @includeExample ../../examples/PointRoll/PointRoll_GameActivity.txt -noswf
*/

public class GeneralActivities{
	/** Activity to be tracked when a user prints any ad content*/
	public static const PRINT:Number = 8970
	/** Activity to be tracked when a user unmutes an ad. <strong>Not for use with the PrVideo or PrAudio classes, as they already track this functionality.</strong>*/
	public static const UNMUTE:Number= 8971 
	/** Activity to be tracked when a user mutes an ad. <strong>Not for use with the PrVideo or PrAudio classes, as they already track this functionality.</strong>*/
	public static const MUTE:Number= 8972 
	/** Activity to be tracked when a user expands an ad area (Generally reserved for use with faux panels)*/
	public static const EXPAND:Number = 8980 
	/** Activity to be tracked when a user collapses an ad area (Generally reserved for use with faux panels)*/
	public static const COLLAPSE:Number = 8981 
}
}