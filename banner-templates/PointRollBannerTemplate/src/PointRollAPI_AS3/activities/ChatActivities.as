package PointRollAPI_AS3.activities
{
	
/**
* Activities for Chat functionality.  These constants should be used to track the corresponding user activities.  
* The example at the end of this section illustrates the use of the standardized activities.
* @author Chris Deely - PointRoll
* @version 1.0
* @see PointRoll#activity()
* @includeExample ../../examples/PointRoll/PointRoll_GameActivity.txt -noswf
*/


	public class ChatActivities {
		/**
		 * Reserved activity number for the beginning of a chat session
		 */
		public static const BEGIN:Number = 8900;
		/**
		 *  Reserved activity number for sending a chat message
		 */
		public static const SEND:Number = 8901;
	}
}