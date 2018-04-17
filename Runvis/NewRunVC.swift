
import UIKit
import MapKit
import CoreData
import CoreLocation

protocol NewRunDelegate {
    
    func aqi()
}

class NewRunViewController: UIViewController, MKMapViewDelegate, NewRunDelegate {
    
    fileprivate var locationManager: CLLocationManager!
    fileprivate var sportLocations = [SportLocation]()
    fileprivate var adviceTime = 0
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var sportAdviceView: SportAdviceView!
    @IBOutlet weak var airLevelColorView: AirLevelColor!
    @IBOutlet weak var airLevelColorView2: AriLevelColorSmall!
    @IBOutlet weak var startBtn: UIButton!
    @IBOutlet weak var airLevelLabel: UILabel!
    @IBOutlet weak var adviceImage: UIImageView!
    @IBOutlet weak var airQuality: UILabel!
    @IBOutlet weak var airQualityChinese: UILabel!
    @IBOutlet weak var sportSuggest: UILabel!
    @IBOutlet weak var timeSuggest: UILabel!
    @IBOutlet weak var warningSwitch: UISwitch!
    @IBOutlet weak var noAdviceImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AppDelegate.app.delegate = self
        
        mapViewSetup()
        _ = Authorization.check.Gps{self.present($0, animated: true, completion: nil)}
        
        locationInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let regionRadius: CLLocationDistance = 1000
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(mapView.userLocation.coordinate,regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
        startBtn.layer.roundCorner([.bottomLeft, .bottomRight], radius: 4)
        
        airPollution()
        
        aqi()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        locationManager.stopUpdatingLocation()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destination = segue.destination as? UINavigationController {
            if let startRunVC = destination.viewControllers.first as? StartRunVC {
                
                startRunVC.needSoundWarning = warningSwitch.isOn
                startRunVC.adviceTime = adviceTime
            }
        }
        
        if let destination = segue.destination as? UINavigationController {
            if let sportLocationVC = destination.viewControllers.first as? SportLocationVC {
                sportLocationVC.sportLocations = sportLocations
            }
        }
    }
    
    fileprivate func mapViewSetup() {
        
        mapView.delegate                 = self
        mapView.showsUserLocation        = true
        mapView.userTrackingMode         = .follow
        
        mapView.isScrollEnabled          = false
        mapView.isZoomEnabled            = false
        mapView.isUserInteractionEnabled = false
    }
    
    fileprivate func locationInfo() {
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.allowsBackgroundLocationUpdates = true
        //locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.activityType = .fitness
        locationManager.distanceFilter = 10.0
        locationManager.requestAlwaysAuthorization()
        
        locationManager.startUpdatingLocation()
    }
    
    func aqi() {
        
        if let currentArea = AppDelegate.app.nearAreaAirQuality {
            
            airQuality.text = "AQI \(currentArea.aQI)"
            airQualityChinese.text = "空氣品質 \(AirPollutant.aQI(currentArea.aQI).airQuality)"
            noAdviceImage.isHidden = true
            
            switch AirPollutant.aQI(currentArea.aQI).airQuality {
            case "良好":
                airLevelLabel.text = "GREAT"
            case "不錯":
                airLevelLabel.text = "GOOD"
            case "普通":
                airLevelLabel.text = "SOSO"
            case "差":
                airLevelLabel.text = "BAD"
            case "很差":
                airLevelLabel.text = "WORSE"
            case "危害":
                airLevelLabel.text = "AWFUL"
            default:
                noAdviceImage.isHidden = false
            }
            
            adviceImage.image = AirPollutant.aQI(currentArea.aQI).aQIImage
            airLevelColorView.backgroundColor = AirPollutant.aQI(currentArea.aQI).correspodingColor
            airLevelColorView2.backgroundColor = AirPollutant.aQI(currentArea.aQI).correspodingColor
            sportSuggest.text = AirPollutant.aQI(currentArea.aQI).runningSuggestion
            
            if let advice = AirPollutant.aQI(currentArea.aQI).suggestRunningTime {
                adviceTime = advice
                timeSuggest.text = adviceTime.timeDisplay()
            }
        }
    }
    
    fileprivate func airPollution() {
        
        airLevelLabel.text                 = "----"
        airLevelColorView.backgroundColor  = UIColor.purpleyGrey
        airLevelColorView2.backgroundColor = UIColor.purpleyGrey
        airQuality.text                    = "AQI --"
        airQualityChinese.text             = "空氣品質 --"
        sportSuggest.text                  = ""
        timeSuggest.text                   = "0:00"
    }
    
    fileprivate func getSportLocation(nowLocation: CLLocationCoordinate2D) {
        
        var location:[String:Double] = [:]
        location["lon"] = nowLocation.longitude
        location["lat"] = nowLocation.latitude
        Request.getData.sportPlace(location: location) { data in
            if let data = data {
                if let locations = Transform.data.toSportPlaceCoordinate(from: data) {
                    
                    self.sportLocations = locations
                }
            }
        }
    }
    
    @IBAction func reLocationBtn(_ sender: UIButton) {
        
        mapView.setRegion(MKCoordinateRegionMake(self.mapView.userLocation.coordinate, MKCoordinateSpanMake(0.01, 0.01)), animated: true)
        locationManager.startUpdatingLocation()
    }
}

extension NewRunViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations[0] as CLLocation
        let nowLocation  = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        
        let span: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        mapView.setRegion(MKCoordinateRegion(center: nowLocation, span: span), animated: true)
        
        getSportLocation(nowLocation: nowLocation)
        locationManager.stopUpdatingHeading()
    }
}
