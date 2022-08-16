package PointRollAPI_AS3.activities{
/**
* Activities for use with games in ad units
* @author Chris Deely - PointRoll
* @version 1.0
* @see PointRoll#activity()
* @includeExample ../../examples/PointRoll/PointRoll_GameActivity.txt -noswf
*/

public class GameActivities{
	/** Activity to be tracked when a user begins a game*/
	public static const BEGIN:Number = 8890 
	/** Activity to be tracked when a user restarts a game*/
	public static const RESTART:Number = 8891
	/** Activity to be tracked when a game ends*/
	public static const OVER:Number = 8892 
	/** Activity to be tracked when a user submits their high score*/
	public static const HIGHSCORE:Number= 8893 
}
}