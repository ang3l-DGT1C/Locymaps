//
//  ViewController.swift
//  Locymaps
//
//  Created by Ángel González on 18/02/23.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    var locationManager:CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = CLLocationManager()
        // la precisión determina la frecuencia con que se van a estar obteniendo lecturas, y por lo tanto el gasto de la batería
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Verificamos si la geolocalización está activada en el dispositivo
         if CLLocationManager.locationServicesEnabled() {
             // Verificar permisos para mi aplicación
             if locationManager.authorizationStatus == .authorizedAlways ||
                    locationManager.authorizationStatus == .authorizedWhenInUse {
                 // si tengo permiso de usar el gps, entonces iniciamos la detección
                 locationManager.startUpdatingLocation()
             }
             else {
                 // no tenemos permisos, hay que volver a solicitarlos
                 locationManager.requestAlwaysAuthorization()
             }
         }
         else {
             let ac = UIAlertController(title:"Error", message:"Lo sentimos, pero al parecer no hay geolocalización. Deseas habilitarla?", preferredStyle: .alert)
             let action = UIAlertAction(title: "SI", style: .default) {
                 action1 in
                 // abrimos los setting del dispositivo para que habilite la localizacion
                 let settingsURL = URL(string: UIApplication.openSettingsURLString)!
                 if UIApplication.shared.canOpenURL(settingsURL) {
                     UIApplication.shared.open(settingsURL, options: [:])
                 }
             }
             ac.addAction(action)
             let action2 = UIAlertAction(title: "NO", style: .default) {
                 action2 in
                 // Si necesitamos terminar una app. El código indica el tipo de error
                 exit(666)
             }
             ac.addAction(action2)
             self.present(ac, animated: true)
         }
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let permiso = manager.authorizationStatus
        if permiso == .authorizedAlways || permiso == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
        else {
            print ("no autoriza a usar el GPS... que hacemos?")
            exit(666)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let loc = locations.first else { return }
        print ("parece que estas en: \(loc.coordinate)")
        let ad = UIApplication.shared.delegate as! AppDelegate
        ad.elCentro = loc.coordinate
        NotificationCenter.default.post(name:NSNotification.Name("ubicacion_actualizada"), object:nil, userInfo: ["lat":loc.coordinate.latitude, "lon":loc.coordinate.longitude])
        CLGeocoder().reverseGeocodeLocation(loc) { lugares, error in
            if error != nil {
                print ("ocurrio un error en la geolocalizacion \(String(describing: error))")
            }
            else {
                guard let lugar = lugares?.first else { return }
                let thoroughfare = (lugar.thoroughfare ?? "")
                let subThoroughfare = (lugar.subThoroughfare ?? "")
                let locality = (lugar.locality ?? "")
                let subLocality = (lugar.subLocality ?? "")
                let administrativeArea = (lugar.administrativeArea ?? "")
                let subAdministrativeArea = (lugar.subAdministrativeArea ?? "")
                let postalCode = (lugar.postalCode ?? "")
                let country = (lugar.country ?? "")
                let direccion = "Dirección: \(thoroughfare) \(subThoroughfare) \(locality) \(subLocality) \(administrativeArea) \(subAdministrativeArea) \(postalCode) \(country)"
                let textView = UITextView()
                textView.frame = self.view.bounds.insetBy(dx: 150, dy: 150)
                DispatchQueue.main.async {
                    self.view.addSubview(textView)
                    textView.text = direccion
                }
                //self.locationManager.stopUpdatingLocation()
            }
        }
    }
        
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print ("ocurrió un error \(String(describing: error))")
    }
}

