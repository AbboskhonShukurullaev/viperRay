import Foundation
import MapKit
import Combine

class TripMapViewPresenter: ObservableObject {
    @Published var pins: [MKAnnotation] = []
    @Published var routes: [MKRoute] = []
    
    let interactor: TripDetailInteractor
    private var cancellabels = Set<AnyCancellable>()
    
    init(interactor: TripDetailInteractor) {
        self.interactor = interactor
        
        interactor.$waypoints
            .map {
                $0.map {
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = $0.location
                    return annotation
                }
            }
            .assign(to: \.pins, on: self)
            .store(in: &cancellabels)
        
        interactor.$directions
            .assign(to: \.routes, on: self)
            .store(in: &cancellabels)
    }
}
