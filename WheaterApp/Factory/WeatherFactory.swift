//
//  WeatherFactory.swift
//  CocusTuiChallenge
//
//  Created by Abraao Nascimento on 08/09/2023.
//

import Foundation

enum WeatherFactory {
    static func createWeathers(response: Response) -> [RSection] {
        let calendar = Calendar.current
        let formatter = DateFormatter()
        let result = Dictionary(grouping: response.list) { element in
            let components = calendar.dateComponents([.day], from: element.date)
            return Calendar.current.date(from: components) ?? element.date
        }
        let days: [Date] = result.keys.sorted()
        
        func getDateKey(date: Date) -> Date {
            let component = calendar.dateComponents([.day], from: date)
            let keyDate = calendar.date(from: component) ?? date
            return keyDate
        }
        
        func getDateByDays(_ days: [Date]) -> [Date] {
            let dates = response.list.map { $0.date }
            return days.map { dDate in
                return dates.first { date in
                    let component = calendar.dateComponents([.day], from: date)
                    let newDate = calendar.date(from: component) ?? date
                    return dDate == newDate
                } ?? dDate
            }
        }
        
        func formatDate(date: Date) -> String {
            formatter.dateFormat = "EEEE, MMM d"
            return formatter.string(from: date)
        }
        
        func formatTime(date: Date) -> String {
            formatter.dateFormat = "HH"
            return formatter.string(from: date)
        }
        
        func handleListWeather(values: [ListResult]) -> [RWeather] {
            let results: [RWeather] = values.compactMap { value in
                guard let icon = value.weather.first?.icon else { return nil }
                return RWeather(time: formatTime(date: value.date),
                                icon: icon,
                                temp: "\(Int(value.main.temp))º",
                                max: "\(Int(value.main.tempMax))º",
                                min: "\(Int(value.main.tempMin))º")
                
            }
            
            return results
        }
        
        return getDateByDays(days).compactMap {
            let key = getDateKey(date: $0)
            guard let values = result[key]?.sorted(by: { $0.date < $1.date }) else { return nil }
            return RSection(date: formatDate(date: $0), weather: handleListWeather(values: values))
        }
    }
}
