//
//  DailyWeatherView.swift
//  CWK2Template
//
//  Created by girish lukka on 02/11/2023.
//

import SwiftUI

struct DailyWeatherView: View {
    @EnvironmentObject var weatherMapViewModel: WeatherMapViewModel
    var day: Daily
    var body: some View {
        
        let formattedDate = DateFormatterUtils.formattedDateWithWeekdayAndDay(from: TimeInterval(day.dt))
        VStack{
            HStack{
                
                if let iconCode = weatherMapViewModel.weatherDataModel?.current.weather.first?.icon {
                    AsyncImage(url: URL(string: "\(weatherMapViewModel.URLStringForIcon(for: iconCode))")) { image in
                        image.resizable()
                            .frame(width: 100, height: 100)
                    } placeholder: {
                        // a view for placeholder
                        ProgressView()
                    }
                }
                
                Spacer().frame(width: 10)
                
                VStack{
                    Text("\((String)(day.weather.first?.weatherDescription.rawValue ?? "Unknown"))")
                        .frame(width: 130)
                    
                    
                    Text(formattedDate)
                        .frame(width: 120)
                        .font(.body) // Customize the font if needed
                    
                }
                
                
                Text("\((Int)(day.temp.max)) ˚C / \((Int)(day.temp.min)) ˚C")
                    .frame(width: 115)
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal)
                
            }
            
        }
    }
}
