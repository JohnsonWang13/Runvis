
import UIKit
import MapKit
import CoreLocation

protocol HandleMapSearch: class {
    func dropPinZoomIn(_ placemark:MKPlacemark)
}

class SportLocationVC: UIViewController {
    
    fileprivate var locationManager: CLLocationManager!
    fileprivate var resultSearchController: UISearchController!
    fileprivate var selectedPin: MKPlacemark?
    
    var sportLocations = [SportLocation]()
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        pinSportLocations(sportLocations)
        locationInfo()
        locationSearch()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        locationManager.stopUpdatingLocation()
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
    
    fileprivate func locationSearch() {
        
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTable") as! LocationSearchTable
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController.searchResultsUpdater = locationSearchTable
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search for places"
        navigationItem.titleView = resultSearchController.searchBar
        
        definesPresentationContext = true
        resultSearchController.hidesNavigationBarDuringPresentation = false
        resultSearchController.dimsBackgroundDuringPresentation = true
        
        locationSearchTable.mapView = mapView
        locationSearchTable.handleMapSearchDelegate = self
    }
    
    fileprivate func pinSportLocations(_ locations: [SportLocation]) {
        
        if locations.count != 0 {
            for location in locations {
                let coordinate = CLLocationCoordinate2DMake(location.latitude, location.longitude)
                let pin = PinAnnotation(title: location.name, subtitle: location.address, coordinate: coordinate)
                mapView.addAnnotation(pin)
            }
        }
    }
    
    @IBAction func backToRun(_ sender: UIButton) {
        
        dismiss(animated: false, completion: nil)
    }
    
    @IBAction func reLocationBtn(_ sender: UIButton) {
        
        mapView.setRegion(MKCoordinateRegionMake(self.mapView.userLocation.coordinate, MKCoordinateSpanMake(0.01, 0.01)), animated: true)
    }
}


extension SportLocationVC: HandleMapSearch {
    
    func dropPinZoomIn(_ placemark: MKPlacemark){
        // cache the pin
        selectedPin = placemark
        // clear existing pins
        mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        
        if let city = placemark.locality,
            let state = placemark.administrativeArea {
            annotation.subtitle = "\(city) \(state)"
        }
        
        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegionMake(placemark.coordinate, span)
        mapView.setRegion(region, animated: true)
    }
}

extension SportLocationVC: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard !(annotation is MKUserLocation) else { return nil }
        let reuseId = "pin"
        //        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        var pinView: MKAnnotationView?
        
        if pinView == nil {
            
            pinView?.frame.size = CGSize(width: 35, height: 44)
            pinView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.image = UIImage(named:"sportLocation")
            pinView?.canShowCallout = true
        } else {
            
            pinView?.annotation = annotation
        }
        
        return pinView
    }
}

extension SportLocationVC: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations[0] as CLLocation
        let nowLocation = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        
        let span: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        mapView.setRegion(MKCoordinateRegion(center: nowLocation, span: span), animated: true)
    }
}
