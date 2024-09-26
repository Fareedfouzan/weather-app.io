//
//  HourWeatherView.swift
//  CWK2Template
//
//  Created by girish lukka on 02/11/2023.
//

import SwiftUI

struct HourWeatherView: View {
    @EnvironmentObject var weatherMapViewModel: WeatherMapViewModel
    var current: Current
    

    var body: some View {
        let formattedDate = DateFormatterUtils.formattedDateWithDay(from: TimeInterval(current.dt))
        VStack(alignment: .leading, spacing: 5) {
            Text(formattedDate)
                .frame(width: 125)
                .font(.body)
                .multilineTextAlignment(.leading)
                .lineLimit(nil)
                .padding(.horizontal)
                .foregroundColor(.black)
            
            //Weather Icon
            if let iconCode = current.weather.first?.icon {
                AsyncImage(url: URL(string: "\(weatherMapViewModel.URLStringForIcon(for: iconCode))")) { image in
                    image.resizable()
                        .frame(width: 100, height: 100)
                } placeholder: {
                    // a view for placeholder
                    ProgressView()
                }
                .frame(width: 125)
                .multilineTextAlignment(.leading)
                .lineLimit(nil)
                .padding(.horizontal)
            }
            
            Text("\((Double)(current.temp), specifier: "%.0f") ºC")
                .frame(width: 125)
                .font(.body)
                .multilineTextAlignment(.leading)
                .lineLimit(nil)
                .padding(.horizontal)
                .foregroundColor(.black)

            Text("\((String)(current.weather.first?.weatherDescription.rawValue ?? "Unknown"))")
                .frame(width: 125)
                .font(.body)
                .multilineTextAlignment(.leading)
                .lineLimit(nil) 
                .padding(.horizontal)
                .foregroundColor(.black)
        }
        .frame(height: 200)
        .background(Color.teal)
        .cornerRadius(20)
        
    }
}




