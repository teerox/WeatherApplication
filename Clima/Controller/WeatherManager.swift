//

import Foundation
import CoreLocation


//like an interface, always try creating it with a delegate
protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager:WeatherManger, weather: WeatherModel)
    func didFailWithError(error:Error)
}




struct WeatherManger {
    //always use https when making network call
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=2ccddf8e618a18c1cebf5b8b2bbae55f&units=metric"
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName:String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
    }
    
    func fetchWeather(latitude: CLLocationDegrees , longitude: CLLocationDegrees){
        
        let urlstring = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlstring)
        
    }
    

    //perform Network Request
    func performRequest(with urlString:String){
        //1. create a URL
        if let url = URL(string: urlString){
            //2 create a URL SESSION
            let session = URLSession(configuration: .default)
            //3 Give the session a Task
            //a completionHamndler is like an ASYNC function
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                        return
                    }
                    if let safeData = data {
                        if let weather = self.parseJSON(safeData){
                            self.delegate?.didUpdateWeather(self, weather:weather)
                        }
                    }
            }
            //4 start the task
            task.resume()
            
        }
        
    }
    
    
    
    
    func parseJSON(_ weatherData:Data)-> WeatherModel?  {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            
            let weather = WeatherModel(conditionID: id, cityName: name, temperature: temp)
            return weather
           
        } catch  {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    

 
}
            
            //Either This
//            let task = session.dataTask(with: url, completionHandler: handle(data:response:error:))
            
                //this is a method to help handle my task like my asyn func which is my oncompletion Handler
                // return is used to exit out of a funtion
                
            //    func handle(data:Data?, response:URLResponse?, error:Error?){
            //        if error != nil {
            //            print(error!)
            //            return
            //        }
            //
            //        if let safeData = data {
            //            let dataString = String(data: safeData, encoding: .utf8)
            //            print(dataString)
            //        }
            //    }
