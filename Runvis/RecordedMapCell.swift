//
//  RecordedMapCell.swift
//  Runvis
//
//  Created by 吳政緯 on 2017/5/25.
//  Copyright © 2017年 吳政緯. All rights reserved.
//

import UIKit
import CoreData
import MapKit

class RecordedMapCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var runningDistance: UILabel!
    
    var delegate: EachRunningRecordDelegate!
    var runPath = [RunningLocations]()
    var mapImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 300, height: 190))
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupMap()
    }
    
    override func layoutSubviews() {
        loadMap()
        takeSnapShot(mapView: self.mapView)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    fileprivate func setupMap() {
        
        mapView.delegate = self
        mapView.isZoomEnabled = false
        mapView.isRotateEnabled = false
        mapView.isScrollEnabled = false
        mapView.mapType = MKMapType.standard
    }
}

extension RecordedMapCell: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        if overlay is MKTileOverlay{
            guard let tileOverlay = overlay as? MKTileOverlay else {
                return MKOverlayRenderer()
            }
            
            return MKTileOverlayRenderer(tileOverlay: tileOverlay)
        }
        
        if overlay is MulticolorPolylineSegment {
            let polyline = overlay as! MulticolorPolylineSegment
            let renderer = MKPolylineRenderer(polyline: polyline)
            renderer.strokeColor = polyline.color
            renderer.lineWidth = 3
            return renderer
        }
        return MKOverlayRenderer()
    }
    
    fileprivate func loadMap() {
        
        if runPath.count > 0 {
            mapView.isHidden = false
            
            // Set the map bounds
            mapView.region = mapRegion(runPath)
            
            // Make the line(s!) on the map
            let colorSegments = MulticolorPolylineSegment.colorSegments(forLocations: runPath)
            mapView.addOverlays(colorSegments)
        }
    }
    
    fileprivate func polyline() -> MKPolyline {
        
        var coords = [CLLocationCoordinate2D]()
        
        let locations = runPath
        for location in locations {
            coords.append(CLLocationCoordinate2D(latitude: location.latitude.doubleValue,
                                                 longitude: location.longitude.doubleValue))
        }
        
        return MKPolyline(coordinates: &coords, count: runPath.count)
    }
    
    fileprivate func mapRegion(_ runPath: [RunningLocations]) -> MKCoordinateRegion {
        
        let initialLoc = runPath.first!
        
        var minLat = initialLoc.latitude.doubleValue
        var minLng = initialLoc.longitude.doubleValue
        var maxLat = minLat
        var maxLng = minLng
        
        let locations = runPath
        
        for location in locations {
            minLat = min(minLat, location.latitude.doubleValue)
            minLng = min(minLng, location.longitude.doubleValue)
            maxLat = max(maxLat, location.latitude.doubleValue)
            maxLng = max(maxLng, location.longitude.doubleValue)
        }
        
        return MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: (minLat + maxLat)/2,
                                           longitude: (minLng + maxLng)/2),
            span: MKCoordinateSpan(latitudeDelta: (maxLat - minLat)*1.5,
                                   longitudeDelta: (maxLng - minLng)*1.5))
    }
}

extension RecordedMapCell {
    
    func takeSnapShot(mapView: MKMapView) {
        if runPath.count == 0 {
            return
        }
        
        let mapSnapshotOptions = MKMapSnapshotOptions()
        let polyLine = polyline()
        var region = MKCoordinateRegionForMapRect(polyLine.boundingMapRect)
        
        region.span = MKCoordinateSpan(latitudeDelta: region.span.latitudeDelta * 2, longitudeDelta: region.span.longitudeDelta * 2)
        mapSnapshotOptions.region = region
        
        mapSnapshotOptions.scale = UIScreen.main.scale
        
        mapSnapshotOptions.size = mapView.frame.size
        
        mapSnapshotOptions.showsBuildings = true
        mapSnapshotOptions.showsPointsOfInterest = true
        
        let snapShotter = MKMapSnapshotter(options: mapSnapshotOptions)
        
        snapShotter.start() { snapshot, error in
            guard let snapshot = snapshot else { return }
            self.mapImage.image = self.drawLineOnImage(snapshot: snapshot)
            self.delegate.tranformImageToData(self.mapImage.image!)
        }
    }
    
    fileprivate func drawLineOnImage(snapshot: MKMapSnapshot) -> UIImage {
        
        //        let image = snapshot.image
        let image = UIImage()
        
        // for Retina screen
        UIGraphicsBeginImageContextWithOptions(self.mapImage.frame.size, true, 0)
        
        // draw original image into the context
        image.draw(at: CGPoint.zero)
        
        // get the context for CoreGraphics
        let context = UIGraphicsGetCurrentContext()
        let rect = CGRect(x: 0, y: 0, width: mapImage.frame.size.width, height: mapImage.frame.size.height)
        
        UIColor.darkGray.setFill()
        UIRectFill(rect)
        
        // set stroking width and color of the context
        context!.setLineWidth(8.0)
        context!.setStrokeColor(UIColor.orange.cgColor)
        
        var coords = [CLLocationCoordinate2D]()
        let locations = runPath
        for location in locations {
            coords.append(CLLocationCoordinate2D(latitude: location.latitude.doubleValue,
                                                 longitude: location.longitude.doubleValue))
        }
        
        context!.move(to: snapshot.point(for: coords[0]))
        
        for i in 0...coords.count-1 {
            context!.addLine(to: snapshot.point(for: coords[i]))
            context!.move(to: snapshot.point(for: coords[i]))
        }
        
        // apply the stroke to the context
        context!.strokePath()
        
        // get the image from the graphics context
        let resultImage = UIGraphicsGetImageFromCurrentImageContext()
        
        // end the graphics context
        UIGraphicsEndImageContext()
        
        return resultImage!
    }
}

extension RecordedMapCell {
    
    internal func setupValue(by runningInfo:RunInformation){
        //再問問設計師
        //        var myString:NSString = "I AM KIRIT MODI"
        //        var myMutableString = NSMutableAttributedString()
        //        myMutableString = NSMutableAttributedString(string: myString as String, attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 18.0)!])
        //        myMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.red, range: NSRange(location:2,length:4))
        //        // set label Attribute
        //        titleLabel.attributedText = myMutableString
        
        if let title = runningInfo.title {
            
            if title != "" {
                titleLabel.text = title
            } else {
                titleLabel.text = nil
            }
            
        } else {
            titleLabel.text = nil
        }
        
        let distance:String = runningInfo.distance.doubleValue.toKmDisplay()
        print(runningInfo.distance,"distance")
        print(runningInfo.distance.doubleValue,"double")
        print(runningInfo.distance.doubleValue.toKmDisplay(),"km")
        runningDistance.text = distance
    }
}
