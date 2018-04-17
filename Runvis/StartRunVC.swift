
import UIKit
import CoreData
import CoreLocation
import HealthKit
import AVFoundation
import AudioToolbox

class StartRunVC: UIViewController {
    
    fileprivate let appDelegate = UIApplication.shared.delegate as! AppDelegate
    fileprivate var managedObjectContext: NSManagedObjectContext?
    
    fileprivate var run: RunInformation!
    fileprivate var seconds: Int        = 0
    fileprivate var distance: Double    = 0.0
    fileprivate var instantPace: Double = 0.0
    fileprivate var locationManager: CLLocationManager!
    fileprivate var (speedMin, speedSec): (Int, Int) = (0, 0)
    fileprivate var countdownTime = 0
    
    var adviceTime    = 0
    
    var needSoundWarning: Bool = true
    
    lazy fileprivate var locations = [CLLocation]()
    lazy fileprivate var timer = Timer()
    
    @IBOutlet weak fileprivate var timeLabel: UILabel!
    @IBOutlet weak fileprivate var distanceLabel: UILabel!
    @IBOutlet weak var instantPaceLabel: UILabel!
    @IBOutlet weak var countDownView: UIView!
    @IBOutlet weak var countDownCircle: CountDownView!
    @IBOutlet weak var countdownLabel: UILabel!
    @IBOutlet weak var adviceTimeLabel: UILabel!
    @IBOutlet weak var soundWarningImage: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupTimes()
        setupLocationManager()
        startLocationUpdates()
        startRun()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        managedObjectContext = appDelegate.persistentContainer.viewContext
        
        self.view.backgroundColor = UIColor.runPageBackground
        countDownCircle.backgroundColor = UIColor.runPageBackground
        
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func setupTimes() {
        
        countdownTime = adviceTime
        countdownLabel.text = countdownTime.timeDisplay()
        adviceTimeLabel.text = adviceTime.timeDisplay()
        
        if needSoundWarning {
            soundWarningImage.setImage(UIImage(named: "sound"), for: .normal)
        } else {
            soundWarningImage.setImage(UIImage(named: "mute"), for: .normal)
        }
    }
    
    @IBAction func stopPressed(_ sender: AnyObject) {
        
        pauseAnimation()
        
        let alert = UIAlertController(title: "請問你是否要完成這次跑步", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "是的我已經完成", style: .default, handler: self.saveRun))
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: self.resumeAnimation))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func soundWarningBtn(_ sender: UIButton) {
        
        needSoundWarning = !needSoundWarning
        
        if needSoundWarning {
            soundWarningImage.setImage(UIImage(named: "sound"), for: .normal)
        } else {
            soundWarningImage.setImage(UIImage(named: "mute"), for: .normal)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        timer.invalidate()
    }
    
    fileprivate func setupLocationManager() {
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.allowsBackgroundLocationUpdates = true
        //locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.activityType = .fitness
        locationManager.distanceFilter = 1
        locationManager.requestAlwaysAuthorization()
    }
    
    
    fileprivate func startRun() {
        
        seconds     = 0
        distance    = 0
        locations.removeAll(keepingCapacity: false)
        timer = Timer.scheduledTimer(timeInterval: 1,
                                     target: self,
                                     selector: #selector(eachSecond(_:)),
                                     userInfo: nil,
                                     repeats: true)
        startLocationUpdates()
        
        countdown(time: adviceTime)
    }
    
    
    ////---------------------------------------------
    func eachSecond(_ timer: Timer) {
        
        if countdownTime > 0 {
            countdownTime -= 1
            if countdownTime == 0 {
                countdownTimeUp(needSoundWarning)
            }
        }
        countdownLabel.text = countdownTime.timeDisplay()
        
        seconds += 1
        
        timeLabel.text = seconds.timeDisplay()
        
        distanceLabel.text = distance.toKmDisplay()
        
        //km/h
        instantPaceLabel.text = instantPace.timePerKmDisplay()
        //"Pace: "+String((distance/seconds*3.6*10).rounded()/10)+" km/h"
    }
    
    fileprivate func startLocationUpdates() {
        
        locationManager.startUpdatingLocation()
        print("start location update")
    }
    
    fileprivate func saveRun(alert: UIAlertAction) {
        
        locationManager.stopUpdatingLocation()
        // 1
        let savedRun = NSEntityDescription.insertNewObject(forEntityName: "RunInformation",
                                                           into: managedObjectContext!) as! RunInformation
        
        savedRun.distance  = NSNumber(value: distance)
        savedRun.duration  = (NSNumber(value: seconds))
        savedRun.timestamp = NSDate() as Date
        
        // 2
        var savedLocations = [RunningLocations]()
        for location in locations {
            let savedLocation = NSEntityDescription.insertNewObject(forEntityName: "RunningLocations",
                                                                    into: managedObjectContext!) as! RunningLocations
            savedLocation.timestamp = location.timestamp
            savedLocation.latitude  = NSNumber(value: location.coordinate.latitude)
            savedLocation.longitude = NSNumber(value: location.coordinate.longitude)
            savedLocations.append(savedLocation)
        }
        
        savedRun.ownLocations = NSOrderedSet(array: savedLocations)
        run = savedRun
        print(run)
        
        do{
            try managedObjectContext!.save()
        } catch {
            print("Could not save the run!")
        }
        
        let runInfoStoryboard = UIStoryboard(name: "EachRunningRecord", bundle: nil)
        let runInfo = runInfoStoryboard.instantiateViewController(withIdentifier: "runInfo") as! EachRunningRecordViewController
        runInfo.runningInformation = savedRun
        runInfo.isFromStartRun = true
        
        self.navigationController?.pushViewController(runInfo, animated: true)
    }
    
    fileprivate func countdown(time countdownTime: Int) {
        
        if countdownTime != 0 {
            
            //advice time (sec)
            let duration: TimeInterval = TimeInterval(countdownTime)
            
            countDownCircle.animateCircleTo(duration: duration, fromValue: 1.0, toValue: 0)
        }
    }
    
    fileprivate func pauseAnimation() {
        
        timer.invalidate()
        
        let pausedTime = countDownCircle.layer.convertTime(CACurrentMediaTime(), from: nil)
        countDownCircle.layer.speed = 0.0
        countDownCircle.layer.timeOffset = pausedTime
    }
    
    fileprivate func resumeAnimation(alert: UIAlertAction) {
        
        timer = Timer.scheduledTimer(timeInterval: 1,
                                     target: self,
                                     selector: #selector(eachSecond(_:)),
                                     userInfo: nil,
                                     repeats: true)
        
        let pausedTime = countDownCircle.layer.timeOffset
        countDownCircle.layer.speed = 1.0
        countDownCircle.layer.timeOffset = 0.0
        countDownCircle.layer.beginTime = 0.0
        let timeSincePause = countDownCircle.layer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        countDownCircle.layer.beginTime = timeSincePause
    }
    
    fileprivate func countdownTimeUp(_ soundWarning: Bool) {
        
        let alert = UIAlertController(title: "提醒", message: "今天的適當的跑步量已經到達了噢！快點回家休息吧～", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "確定", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
        if soundWarning {
            AudioServicesPlaySystemSound(SystemSoundID(1304))
        } else {
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
        }
    }
}

extension StartRunVC: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        for location in locations {
            
            let howRecent = location.timestamp.timeIntervalSinceNow
            
            if abs(howRecent) < 10 && location.horizontalAccuracy < 20 {
                
                //update distance
                if self.locations.count > 0 {
                    distance += location.distance(from: self.locations.last!)
                    
                    var coords = [CLLocationCoordinate2D]()
                    coords.append(self.locations.last!.coordinate)
                    coords.append(location.coordinate)
                    
                    //current speed  m/sec
                    instantPace = location.distance(from: self.locations.last!)/(location.timestamp.timeIntervalSince(self.locations.last!.timestamp))
                    instantPace = (instantPace*3.6*100).rounded()/100
                }
                
                //save location
                self.locations.append(location)
            }
        }
    }
}

