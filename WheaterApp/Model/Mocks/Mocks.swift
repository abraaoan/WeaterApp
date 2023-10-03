//
//  MockCity.swift
//  CocusTuiChallenge
//
//  Created by Abraao Nascimento on 09/09/2023.
//

import Foundation

enum Mock {
    static let city = City(name: "Porto",
                           lat: 41.1494512,
                           lon: -8.6107884,
                           country: "PT",
                           state: nil)
    
    static let section = RSection(date: "Sunday, Sep 10",
                                  weather: [
                                    RWeather(time: "19",
                                             icon: "02d",
                                             temp: "36º",
                                             max: "36º",
                                             min: "17º")
                                  ])
    static let response = Response(cod: "0",
                                   list: [
                                      ListResult(date: Date(timeIntervalSince1970: 1694131200),
                                                 main: Main(temp: 18,
                                                            feelsLike: 18,
                                                            tempMin: 12,
                                                            tempMax: 25),
                                                 weather: [Weather(id: 0,
                                                                   main: "",
                                                                   description: "not Clean",
                                                                   icon: "02d")]),
                                      ListResult(date: Date(timeIntervalSince1970: 1694131200),
                                                 main: Main(temp: 18,
                                                            feelsLike: 18,
                                                            tempMin: 12,
                                                            tempMax: 25),
                                                 weather: [Weather(id: 0,
                                                                   main: "",
                                                                   description: "not Clean",
                                                                   icon: "02d")]),
                                      ListResult(date: Date(timeIntervalSince1970: 1694131200),
                                                 main: Main(temp: 18,
                                                            feelsLike: 18,
                                                            tempMin: 12,
                                                            tempMax: 25),
                                                 weather: [Weather(id: 0,
                                                                   main: "",
                                                                   description: "not Clean",
                                                                   icon: "02d")]),
                                      ListResult(date: Date(timeIntervalSince1970: 1694131200),
                                                 main: Main(temp: 18,
                                                            feelsLike: 18,
                                                            tempMin: 12,
                                                            tempMax: 25),
                                                 weather: [Weather(id: 0,
                                                                   main: "",
                                                                   description: "not Clean",
                                                                   icon: "02d")])
                                   ],
                                   city: RCity(id: 0,
                                              coord: Coord(lat: 41.1494512, lon: -8.6107884),
                                              country: "PT",
                                              name: "Porto"))
    static let coord = Coord(lat: 41.1494512,
                             lon: -8.6107884)
    
    static let weather = RWeather(time: "12",
                                  icon: "02d",
                                  temp: "18º",
                                  max: "25º",
                                  min: "12º")
}
