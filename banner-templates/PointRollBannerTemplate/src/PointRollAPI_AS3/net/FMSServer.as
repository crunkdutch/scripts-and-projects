package PointRollAPI_AS3.net 
{
	
	/**
	* Houses all configuration data related to the various FMS servers employed in streaming video delivery.
	* @author Chris Deely - PointRoll
	*/
	public class FMSServer 
	{
		public static const DEFAULT:uint = 0;
		public static const SPEEDERA:uint = 1;
		//2 appears unused
		public static const MII:uint = 3;
		public static const LLNWD:uint = 5;
		public static const FMS25:uint = 6;
		public static const FMS3:uint = 4;

		
		private const c_sURI:Array             = new Array("",    "fms2.pointroll.speedera.net",                      "cp17171.edgefcs.net", "flv.world.mii-streaming.net", "cp30559.edgefcs.net", "pointroll.fcod.llnwd.net", "cp47883.edgefcs.net");
		private const c_sURI2:Array            = new Array("",    "fms2.pointroll.speedera.net.staging.speedera.net", "cp17171.edgefcs.net", "flv.world.mii-streaming.net", "cp30559.edgefcs.net", "pointroll.fcod.llnwd.net", "cp47883.edgefcs.net");
		private const c_sBasePath:Array        = new Array("",    "/ondemand",                                        "/ondemand",           "/pointroll",                  "/ondemand",           "/a976/o10",               "/ondemand");
		private const c_sPathOnConnect:Array   = new Array(false, false,                                              false,                 true,                          false,                 true,                      false);
		private const c_sFixedFolderPath:Array = new Array("",    "/fms2.pointroll/",                                 "/fms2.pointroll/",    "/",                           "/fms2.pointroll/",    "/",                       "/fms2.pointroll/");
		private const c_sIPLookup:Array 	   = new Array(false, 	true, 											true, 					false, 							true,                  false,                     true);

		public var serverIndex:uint;
		public var uri:String;
		public var uri2:String;
		public var basePath:String;
		public var pathOnConnect:Boolean;
		public var fixedFolderPath:String;
		public var ipLookup:Boolean;
		public var fcs:String;
		public var ipLookupComplete:Boolean = false;
		
		public function FMSServer(index:uint) 
		{
			if (index == DEFAULT)
			{
				index = FMS3;
			}
			serverIndex = index;
			uri = c_sURI[index];
			uri2 = c_sURI2[index];
			basePath = c_sBasePath[index];
			pathOnConnect = c_sPathOnConnect[index];
			fixedFolderPath = c_sFixedFolderPath[index];
			ipLookup = c_sIPLookup[index];
			fcs = ipLookup ? "?_fcs_vhost=" + uri : "";
		}
		
	}
	
}