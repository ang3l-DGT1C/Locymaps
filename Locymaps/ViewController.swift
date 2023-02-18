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
    }
        
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print ("ocurrió un error \(String(describing: error))")
    }
}

