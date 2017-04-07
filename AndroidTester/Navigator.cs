//Euzübillahimineşşeytanirracim Bismillahirrahmanirrahim
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class NavigatorDouble : MonoBehaviour {
	//navigation here
	public Vector3d targetCoordinates;
	public Vector3d NewExpCoordinates;
	public Vector3d OldExpCoordinates;
	public Vector3d DeltaCross;
	public Vector3d toTargetCross;
	public double angleInBetween;
	public double Radius;
	public double distanceToTarget;
	public double distanceTraveledBetw;
	public float throttle;
	//gps here
	private bool GPStry;
	public GameObject logLabel;
	public GameObject gpsLabel;
	public GameObject cursor;
	public GameObject angleText;
	public GameObject throttleBar;
	private string log;
	private string gpstext;

	public double latitude;
	public double longtitude;
	public double horizontalAcc;
	public double altitude;
	public double timeStamp;
	private bool updateLocationTry;
	private bool locationChanged;

	//test
	public double tester;
	// Use this for initialization
	void Start () {
		log = "App Started";
		Radius=6371000.0d;
		//iT iS A SiLLY THiNG TO DO BUT THE CODE REQUiRES a non zero Ro(radius) value and I gave 10 over 8 to get countable results
		targetCoordinates.x = 100000000.0d;
		NewExpCoordinates.x = 100000000.0d;
		OldExpCoordinates.x = 100000000.0d;
	}

	// Update is called once per frame
	void Update () {
		if(updateLocationTry == false){
			StartCoroutine(UpdateLocation());}

		//text onscreen
		logLabel.GetComponent<Text>().text = log;
		gpstext = "Lat: " + latitude.ToString() + "\n" + "Lon: " + longtitude.ToString() + "\n" + "Acc: " + horizontalAcc.ToString() + "\n" + "Alt: " + altitude.ToString() + "\n" + "Time: " + timeStamp.ToString() + "\n" +"DistBtw: " + distanceTraveledBetw.ToString() + "\n" + "Angle: " + angleInBetween.ToString() + "\n" + "DistTarget: " + distanceToTarget.ToString() + "\n" + "Throttle: " + throttle.ToString();
		gpsLabel.GetComponent<Text> ().text = gpstext;
		//rotating cursor for navigation
		cursor.GetComponent<RectTransform>().localRotation = Quaternion.Euler(0.0F,0.0F,-1.0F*(float)angleInBetween + 180.0F);
		//showing big angle
		angleText.GetComponent<Text> ().text = Mathd.RoundToInt(Mathd.Abs (angleInBetween)).ToString();
		//throttlebar
		throttleBar.GetComponent<Image>().fillAmount=throttle;
	}




	//Polar to cartesian transform function
	private Vector3d Polar2Cartesian (Vector3d polarvector)
	{
		//this is for transforming the polar vector in spherical coordinate system to cartesian coordinate system
		Vector3d cartvector;
		cartvector.x = polarvector.x * Mathd.Cos (polarvector.y * Mathd.PI / 180) * Mathd.Cos (polarvector.z * Mathd.PI / 180);
		cartvector.y = polarvector.x * Mathd.Cos (polarvector.y * Mathd.PI / 180) * Mathd.Sin (polarvector.z * Mathd.PI / 180);
		cartvector.z = polarvector.x * Mathd.Sin (polarvector.y * Mathd.PI / 180);
		return cartvector;
	}


	private void navigationCalculator() {
		//assigning variables
	NewExpCoordinates = new Vector3d (100000000.0d,latitude,longtitude);
	targetCoordinates= new Vector3d (100000000.0d,41.104686d, 29.022858d);
		//navigation code here
		DeltaCross = Vector3d.Cross (Polar2Cartesian (NewExpCoordinates), Polar2Cartesian (OldExpCoordinates));
		distanceToTarget = Vector3d.Angle(Polar2Cartesian (NewExpCoordinates),Polar2Cartesian (targetCoordinates))*2.0d*Mathd.PI*Radius/360;
		distanceTraveledBetw= Vector3d.Angle(Polar2Cartesian (NewExpCoordinates),Polar2Cartesian (OldExpCoordinates))*2.0d*Mathd.PI*Radius/360;
		toTargetCross = Vector3d.Cross (Polar2Cartesian(targetCoordinates), Polar2Cartesian (NewExpCoordinates)); 
		//calculate further only if you have moved enough for fair calculations
		if(distanceTraveledBetw>horizontalAcc){   
		angleInBetween = Vector3d.Angle (DeltaCross, toTargetCross) * Mathd.Sign (Vector3d.Dot (Vector3d.Cross (toTargetCross, DeltaCross),NewExpCoordinates));
		OldExpCoordinates = NewExpCoordinates;
		}

			//throttling code here it gives full throttle when it is more then 15m away. 
		//It decreases its speed between 15-4 meters and it stops when it reaches 4 meters up close.
		if(distanceToTarget>horizontalAcc & distanceToTarget>15.0d){throttle=1.0F;}else if(distanceToTarget<horizontalAcc){throttle=0.0F;}else{throttle=(float)distanceToTarget/15;}
	
	}


	private IEnumerator UpdateLocation() {updateLocationTry = true;
		//this is used to wait between calculations
		yield return new WaitForSeconds(1);


		//gps code here
		if (GPStry == false) {
			StartCoroutine (GPS ());
		}
		updateLocationTry = false;
		StartCoroutine(UpdateLocation());
	}



	//retrieving GPS data
	private IEnumerator GPS()
	{
		GPStry = true;
		// First, check if user has location service enabled
		if (!Input.location.isEnabledByUser)
		{log = "Enable GPS";
			yield break;
		}

		// Start service before querying location parameters:acc,updatedistance
		Input.location.Start(5.0f,5.0f);

		// Wait until service initializes
		int maxWait = 20;
		while (Input.location.status == LocationServiceStatus.Initializing && maxWait > 0)
		{
			log = "Initializing";
			yield return new WaitForSeconds(1);
			maxWait--;
		}

		// Service didn't initialize in 20 seconds
		if (maxWait < 1)
		{
			log = "Timed out";
			yield break;
		}

		// Connection has failed
		if (Input.location.status == LocationServiceStatus.Failed)
		{
			log = "Unable to determine device location";
			yield break;
		}
		else
		{
			log = "Success";
			// Access granted and location value could be retrieved

			latitude = Input.location.lastData.latitude;
			longtitude = Input.location.lastData.longitude;
			altitude = Input.location.lastData.altitude;
			horizontalAcc=Input.location.lastData.horizontalAccuracy;
			timeStamp = Input.location.lastData.timestamp;


			//calling nav calculator after acquiring gps data
				navigationCalculator ();

		}


		GPStry = false;
	}
}
