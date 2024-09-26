//
//  WeatherNowView.swift
//  CWK2Template
//
//  Created by girish lukka on 29/10/2023.
//

import SwiftUI

struct WeatherNowView: View {
    @EnvironmentObject var weatherMapViewModel: WeatherMapViewModel
    @State var isLoading = false
    @State private var temporaryCity = ""
    
    var body: some View {
        ZStack{
            Image("sky")
                .resizable()
                .edgesIgnoringSafeArea(.top)
                .opacity(0.3)
            
            
            VStack{
                
                HStack{
                    Text("Change Location")
                    
                    TextField("Enter New Location", text: $temporaryCity)
                        .onSubmit {
                            Task {
                                isLoading = true
                                do {
                                    // write code to process user change of location
                                    weatherMapViewModel.city = temporaryCity
                                    try await weatherMapViewModel.getCoordinatesForCity()
                                    try await weatherMapViewModel.weatherDataModel = weatherMapViewModel.loadData(lat: weatherMapViewModel.coordinates?.latitude ?? 0.0, lon: weatherMapViewModel.coordinates?.longitude ?? 0.0)
                                    
                                    temporaryCity = ""
                                    
                                } catch {
                                    print("Error: \(error)")
                                    isLoading = false
                                }
                                
                            }
                            
                            
                        }
                }
                .bold()
                .font(.system(size: 20))
                .padding(10)
                .shadow(color: .blue, radius: 10)
                .cornerRadius(10)
                .fixedSize()
                .font(.custom("Arial", size: 26))
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .cornerRadius(15)
                
                VStack{
                    HStack{
                        Text("Current Location: \(weatherMapViewModel.city)")
                    }
                    .bold()
                    .font(.system(size: 20))
                    .padding(10)
                    .shadow(color: .blue, radius: 10)
                    .cornerRadius(10)
                    .fixedSize()
                    .font(.custom("Arial", size: 26))
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .cornerRadius(15)
                    
                    
                    
                    let timestamp = TimeInterval(weatherMapViewModel.weatherDataModel?.current.dt ?? 0)
                    let formattedDate = DateFormatterUtils.formattedDateTime(from: timestamp)
                    Text(formattedDate)
                        .padding()
                        .font(.title)
                        .foregroundColor(.black)
                        .shadow(color: .black, radius: 1)
                    
                    VStack{
                        
                        HStack {
                            
                            //Weather Icon
                            if let iconCode = weatherMapViewModel.weatherDataModel?.current.weather.first?.icon {
                                AsyncImage(url: URL(string: "\(weatherMapViewModel.URLStringForIcon(for: iconCode))")) { image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(height: 50)
                                        .padding(.leading, 45)
                                } placeholder: {
                                    // a view for placeholder
                                    ProgressView()
                                }
                            }
                            
                            Spacer().frame(width: 20)
                            
                            // Weather description
                            if let forecast = weatherMapViewModel.weatherDataModel {
                                Text("\((String)(forecast.current.weather.first?.weatherDescription.rawValue ?? "Unknown"))")
                                    .font(.system(size: 25, weight: .medium))
                            } else {
                                Text("N/A")
                                    .font(.system(size: 25, weight: .medium))
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        
                        
                        HStack {
                            // Weather Temperature Value
                            if let forecast = weatherMapViewModel.weatherDataModel {
                                Image("temperature")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(height: 50)
                                    .padding(.leading, 45)
                                
                                Spacer().frame(width: 20)
                                
                                Text("Temp: \((Double)(forecast.current.temp), specifier: "%.0f") ºC")
                                    .font(.system(size: 25, weight: .medium))
                            } else {
                                Text("Temp: N/A")
                                    .font(.system(size: 25, weight: .medium))
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        HStack {
                            
                            //Weather humidity Value
                            if let forecast = weatherMapViewModel.weatherDataModel {
                                Image("humidity")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(height: 50)
                                    .padding(.leading, 45)
                                
                                Spacer().frame(width: 20)
                                
                                
                                Text("Humidity: \((Double)(forecast.current.humidity), specifier: "%.0f") %")
                                    .font(.system(size: 25, weight: .medium))
                            } else {
                                Text("Humidity: N/A")
                                    .font(.system(size: 25, weight: .medium))
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        HStack {
                            //Weather Pressure Value
                            if let forecast = weatherMapViewModel.weatherDataModel {
                                Image("pressure")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(height: 50)
                                    .padding(.leading, 45)
                                
                                Spacer().frame(width: 20)
                                
                                Text("Pressure: \((Double)(forecast.current.pressure), specifier: "%.0f") hPa")
                                    .font(.system(size: 25, weight: .medium))
                            } else {
                                Text("Pressure: N/A")
                                    .font(.system(size: 25, weight: .medium))
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        HStack {
                            //Weather Windspeed Value
                            if let forecast = weatherMapViewModel.weatherDataModel {
                                Image("windSpeed")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(height: 50)
                                    .padding(.leading, 45)
                                
                                Spacer().frame(width: 20)
                                
                                Text("Windspeed: \((Double)(forecast.current.windSpeed), specifier: "%.0f") mph")
                                    .font(.system(size: 25, weight: .medium))
                            } else {
                                Text("Windspeed: N/A")
                                    .font(.system(size: 25, weight: .medium))
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }//VS2
            }// VS1
        }
    }
}

