//
//  ThreeHourForecastView.swift
//  WeatherCodingChallenge
//
//  Created by iMac Pro on 7/4/23.
//

import SwiftUI

struct ThreeHourForecastView: View {
    
    //MARK: - Properties
    var threeHourForecast: ThreeHourForecast
    
    var body: some View {
        HStack(spacing: 20) {
            HStack {
                Text(threeHourForecast.time)
                Spacer()
                
                HStack {
                    Text("\((threeHourForecast.chances * 100).asRoundedString())%")
                        .padding(.trailing, 20)
                    
                    Image(systemName: threeHourForecast.conditionsID.createCurrentConditions())
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                        .symbolRenderingMode(.multicolor)
                }
            }
            
            HStack {
                Text("L: \(threeHourForecast.tempLow.asRoundedString())°F")
                    .padding(.trailing, 12)
                
                Text("H: \(threeHourForecast.tempHigh.asRoundedString())°F")
            }
        }
        .font(.subheadline)
        .foregroundColor(.white)
        .padding(.vertical, 2)
    }
}

//struct ThreeHourForecast_Previews: PreviewProvider {
//    static let mockDailyForecast = ThreeHourForecast(time: "3:00 pm", chances: 0.1, conditionsID: 800, tempLow: 80, tempHigh: 100)
//
//    static var previews: some View {
//        ZStack {
//            Color.cyan
//            ThreeHourForecastView(threeHourForecast: mockDailyForecast)
//                .padding(.horizontal)
//        }
//        .frame(height: 40)
//        .previewLayout(.sizeThatFits)
//    }
//}
