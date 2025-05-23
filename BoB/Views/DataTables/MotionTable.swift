//
//  MotionTable.swift
//  BoB
//
//  Created by Kim Martini on 5/7/25.
//

import SwiftUI

struct MotionTable: View {
    let motionData: [MotionData]
    
    var body: some View {
        NavigationStack {
            Table(motionData) {
                TableColumn("Timestamp [ISO8601], Acceleration [m/s], Angular Velocity [rad/s], Magnetic Field [uT]") { motion in
                    VStack(alignment: .leading) {
                        Text(motion.timestamp)
                            .font(.subheadline)
                        
                        HStack {
                            
                            VStack(alignment: .leading) {
                                Text("Acceleration [m/s]:")
                                Text("Angular Velocity [rad/s]:")
                                Text("Magnetic Field [uT]:")
                            }
                            .frame(minWidth: 140)

                            
                            VStack(alignment: .trailing) {
                                Text( String(format: "%0.6f", motion.accelerationX ?? Double.nan))
                                Text( String(format: "%0.6f", motion.angularVelocityY ?? Double.nan))
                                Text( String(format: "%0.4f", motion.magneticFieldX ?? Double.nan))
                            }
                            .frame(minWidth: 65)
                            
                            VStack(alignment: .trailing) {
                                Text( String(format: "%0.6f", motion.accelerationY ?? Double.nan))
                                Text( String(format: "%0.6f", motion.angularVelocityY ?? Double.nan))
                                Text( String(format: "%0.4f", motion.magneticFieldY ?? Double.nan))
                            }
                            .frame(minWidth: 65)
                            
                            VStack(alignment: .trailing) {
                                Text( String(format: "%0.6f", motion.accelerationZ ?? Double.nan))
                                Text( String(format: "%0.6f", motion.angularVelocityZ ?? Double.nan))
                                Text( String(format: "%0.4f", motion.magneticFieldZ ?? Double.nan))
                            }
                            .frame(width: 65)
                        }
                        .font(.caption)
                        .foregroundColor(.gray)
                    }
                }
            }
            .navigationTitle("Motion Data")
        }
        .padding(.leading, 5)
        .padding(.trailing, 10)
    }
}

#Preview {
    let sampleMotionData = [
        MotionData(timestamp: "2025-05-05T23:25:51.015Z", accelerationX:  -0.008499, accelerationY: -0.531052 , accelerationZ: -0.824951 , angularVelocityX: 0 , angularVelocityY: 0 , angularVelocityZ: 0, magneticFieldX: 0, magneticFieldY: 0, magneticFieldZ: 0 ),
        MotionData(timestamp: "2025-05-05T23:25:51.209Z", accelerationX:  0.004532, accelerationY: -0.537399 , accelerationZ: -0.850937 , angularVelocityX: 0.007171 , angularVelocityY: -0.003339 , angularVelocityZ: 0.000917, magneticFieldX: -10.309, magneticFieldY: -24.996, magneticFieldZ: -17.08 ),
        MotionData(timestamp: "2025-05-05T23:25:51.410Z", accelerationX:  -0.009842, accelerationY: -0.535126 , accelerationZ: -0.832413 , angularVelocityX: -0.018896 , angularVelocityY: 0.016209 , angularVelocityZ: -0.003137, magneticFieldX: -10.579, magneticFieldY: -25.273, magneticFieldZ: -16.473 ),
        MotionData(timestamp: "2025-05-05T23:25:51.610Z", accelerationX:  -0.004601, accelerationY: -0.537521 , accelerationZ: -0.843903 , angularVelocityX: 0 , angularVelocityY: 0.003899 , angularVelocityZ: 0.002769, magneticFieldX: -10.656, magneticFieldY: -25.29, magneticFieldZ: -16.579 )
    ]
    MotionTable(motionData: sampleMotionData)
}
