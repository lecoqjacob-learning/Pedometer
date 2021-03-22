//
//  ContentView.swift
//  Pedometer
//
//  Created by Jacob LeCoq on 3/21/21.
//

import SwiftUI
import CoreMotion

struct ContentView: View {
    @AppStorage("stepCount", store: UserDefaults(suiteName: "group.com.lecoqjacob.justwalking"))
    var stepCount: Int = 0
    
    @AppStorage("distanceCount", store: UserDefaults(suiteName: "group.com.lecoqjacob.justwalking"))
    var distanceCount: Double = 0
    
    
    @State private var steps: Int?
    @State private var distance: Double?
    
    private var pedometer: CMPedometer = CMPedometer()
    
    private var isPedometerAvailable: Bool{
        return CMPedometer.isPedometerEventTrackingAvailable() &&
            CMPedometer.isDistanceAvailable() && CMPedometer.isStepCountingAvailable()
    }
    
    private func updateUI(data: CMPedometerData) {
        self.stepCount = data.numberOfSteps.intValue
        self.steps = data.numberOfSteps.intValue
        
        guard let pedometerDistance = data.distance else { return }
        let distanceInMeters = Measurement(value: pedometerDistance.doubleValue, unit: UnitLength.meters)
        
        self.distance = distanceInMeters.converted(to: .miles).value
        self.distanceCount = distanceInMeters.converted(to: .miles).value
    }
    
    private func initializePedometer(){
        if isPedometerAvailable {
            
            guard let startDate = Calendar.current.date(byAdding: .day, value: -7, to: Date()) else {
                return
            }
            
            pedometer.queryPedometerData(from: startDate, to: Date()){ (data, error) in
                guard let data = data, error == nil else { return }
                
                updateUI(data: data)
            }
        }
    }
    
    var body: some View {
        VStack {
            Text(steps != nil ? "\(steps!) steps" : "No Steps")
                .padding()
            
            Text(distance != nil ? String(format: "%.2f miles", distance!) : "No Distance")
                .padding()
            
            Button("Update steps"){
                self.stepCount = Int.random(in: 5000...9000)
            }
        }
        .onAppear{
            initializePedometer()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
