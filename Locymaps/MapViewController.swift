//
//  MapViewController.swift
//  Locymaps
//
//  Created by Ángel González on 18/02/23.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    var elMapa:MKMapView!
    var estadioAzul = CLLocationCoordinate2D(latitude: 19.3834381, longitude: -99.1804635)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        elMapa = MKMapView()
        elMapa.frame = self.view.bounds
        elMapa.delegate = self
        self.view.addSubview(elMapa)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let ad = UIApplication.shared.delegate as! AppDelegate
        if let centro = ad.elCentro {
            elMapa.setRegion(MKCoordinateRegion(center:centro, latitudinalMeters:500, longitudinalMeters:500), animated: true)
            let elPin = MKPointAnnotation()
            elPin.coordinate = centro
            elPin.title = "Usted está aqui"
            elMapa.addAnnotation(elPin)
            destino()
        }
        else {
            elMapa.setRegion(MKCoordinateRegion(center:CLLocationCoordinate2D(latitude: 19.433926, longitude: -99.142832), latitudinalMeters:500, longitudinalMeters:500), animated: true)
            NotificationCenter.default.addObserver(self, selector:#selector(ubicacionActualizada(_ :)), name:NSNotification.Name("ubicacion_actualizada"), object: nil)
        }
    }

    func destino () {
        let elPin = MKPointAnnotation()
        elPin.coordinate = estadioAzul
        elPin.title = "META"
        elMapa.addAnnotation(elPin)
    }
    
    @objc func ubicacionActualizada (_ notificacion:Notification) {
        if let userInfo = notificacion.userInfo {
            let latitud = userInfo["lat"] as? Double ?? 0
            let longitud = userInfo["lon"] as? Double ?? 0
            let nuevaCoordenada = CLLocationCoordinate2D(latitude:latitud, longitude:longitud)
            elMapa.setRegion(MKCoordinateRegion(center:nuevaCoordenada, latitudinalMeters:500, longitudinalMeters:500), animated: true)
            let elPin = MKPointAnnotation()
            elPin.coordinate = nuevaCoordenada
            elPin.title = "Usted está aqui"
            elMapa.addAnnotation(elPin)
            destino()
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // se implementa para cambiar la "anotación" o sea la imagen que se muestra
        let anotacion =  MKMarkerAnnotationView(annotation:annotation, reuseIdentifier:"reuseIdentifier")
        if annotation.title == "META" {
            anotacion.glyphImage = UIImage(systemName: "figure.soccer")
            anotacion.markerTintColor = .blue
        }
        else {
            anotacion.glyphImage = UIImage(systemName: "person.circle")
        }
        return anotacion
    }
}
