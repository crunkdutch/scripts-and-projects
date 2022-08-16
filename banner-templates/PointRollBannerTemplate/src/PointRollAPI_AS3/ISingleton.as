

package PointRollAPI_AS3{
/**
* @private
* This interface is used to get around a bizarre CS4 issue.  When using the Private Constructor 
* Singleton Pattern, CS4 will complain that any interface implemented by the class is not implemented correctly.
* The only solution we have found to date is to add a second interface to the class.
* 
* This interface is to serve as that additional interface where needed.
* @author Tim O'Hare & Chris Deely
*/
	public interface ISingleton  {
		
	}
	
}