//
//  WeatherForcastView.swift
//  CWK2Template
//
//  Created by Fareed Khan on 29/10/2023.
//

import SwiftUI

struct WeatherForecastView: View {
    @EnvironmentObject var weatherMapViewModel: WeatherMapViewModel
    var body: some View {
        NavigationView {
            ScrollView{
                VStack(alignment: .leading, spacing: 16) {
                    if let hourlyData = weatherMapViewModel.weatherDataModel?.hourly {
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            
                            HStack(spacing: 10) {
                                
                                ForEach(hourlyData) { hour in
                                    HourWeatherView(current: hour)
                                    
                                }
                            }
                            .padding(.horizontal, 16)
                        }
                        .frame(height: 180)
                    }
                    Divider()
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                    VStack {
                        List {
                            ForEach(weatherMapViewModel.weatherDataModel?.daily ?? []) { day in
                                DailyWeatherView(day: day)
                                    .background(
                                        Image("background")
                                            .aspectRatio(contentMode: /*@START_MENU_TOKEN@*/.fill/*@END_MENU_TOKEN@*/)
                                            .scaledToFill()
                                            .opacity(0.1)
                                    )
                            }
                        }
                        .listStyle(GroupedListStyle())
                        .frame(height: 500)
                        // .opacity(0.2)
                    }
                }
                .padding(.horizontal, 16)
                
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        HStack {
                            Image(systemName: "sun.min.fill")
                            VStack{
                                Text("Weather Forecast for \(weatherMapViewModel.city)").font(.title3)
                                    .fontWeight(.bold)
                            }
                        }
                    }
                }
                
            }
            .background(
                Image("appBackground")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .edgesIgnoringSafeArea(.top)
            )
        }
        .ignoresSafeArea(edges: .all)
        .navigationBarTitleDisplayMode(.inline)
    }
}


