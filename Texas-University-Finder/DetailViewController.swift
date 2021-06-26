//
//  DetailViewController.swift
//  Spr21-Universities
//
//  Created by AV on 4/11/21.
//  Copyright © 2021 AV. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class DetailViewController: UIViewController {

    @IBOutlet weak var detailDescriptionLabel: UILabel!
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var forwardButton: UIButton!
    @IBOutlet weak var backwardButton: UIButton!
    @IBOutlet weak var addressLabel: UILabel!
    
    var PlaceMark: CLPlacemark!
    var Addr: String = " "
    var MemberName: String = " "
    var Uni: [String:String] = [:]
    var UName: [String] = []
    var OriginalUName: String = ""
    var currIndex: Int = -1
    
    func setNewAddr(Member: String, formap address: String) {
        Addr = address
        MemberName = Member
    }

    func configureView() {
        // Update the user interface for the detail item.
        if let detail = detailItem {
            if let label = detailDescriptionLabel {
                label.text = detail.description
                addressLabel.text = Uni[detail.description]
            }
        }
        
    }
    
    func configMap() {
        CLGeocoder().geocodeAddressString(Addr, completionHandler: {(placemarks, error) in
            if error != nil {
                print("ERROR: Geocode failed")
            } else if (placemarks?.count)! > 0 {
                self.PlaceMark = placemarks![0]
                let MKplacemark: MKPlacemark = MKPlacemark(placemark: self.PlaceMark)
                let circularRegion: CLCircularRegion = (self.PlaceMark.region as! CLCircularRegion)
                var region: MKCoordinateRegion
                region = MKCoordinateRegion(center: circularRegion.center, latitudinalMeters: circularRegion.radius * 20, longitudinalMeters: circularRegion.radius * 20)
                self.map.setRegion(region, animated: true)
                self.map.addAnnotation(MKplacemark)
            }
        })
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureView()
        self.configMap()
        currIndex = UName.firstIndex(of: OriginalUName)!
    }

    var detailItem: String? {
        didSet {
            // Update the view.
            configureView()
        }
    }

    @IBAction func previousUni(_ sender: Any) {
        currIndex -= 1
        if currIndex < 0 {
            currIndex = UName.count - 1
        }
        setMap()
    }
    
    @IBAction func nextUni(_ sender: Any) {
        currIndex += 1
        if currIndex == UName.count {
            currIndex = 0
        }
        setMap()
    }
    
    func setMap() {
        let newAddr: String = Uni[UName[currIndex]]!
        setNewAddr(Member: newAddr, formap: newAddr)
        detailDescriptionLabel.text = UName[currIndex]
        addressLabel.text = Uni[UName[currIndex]]
        self.configMap()
    }
    
}

