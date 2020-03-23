

import UIKit
import CoreLocation

class WeatherViewController: UIViewController{
    
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    var weatherManager = WeatherManger()
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        weatherManager.delegate = self
        searchTextField.delegate = self
        
    }
    
    @IBAction func locationPressed(_ sender: UIButton) {
        
        locationManager.requestLocation()
    }
}

//MARK: - UITextFieldDelegate

extension WeatherViewController: UITextFieldDelegate {
    // to trigger the search button
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
        
    }
    
    // to activate the enter button
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
        
    }
    
    //To Clear Text after searching
    func textFieldDidEndEditing(_ textField: UITextField) {
        //This is the best place to get what the user typed
        if let city = searchTextField.text {
            weatherManager.fetchWeather(cityName:city)
        }
        searchTextField.text = ""
    }
    
    
    // For verification
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if(textField.text != ""){
            return true
        }else{
            textField.placeholder = "Type something"
            return false
        }
    }
    
}

//MARK: - WeatherManagerDelegate

extension WeatherViewController:WeatherManagerDelegate{
    
    
    func didUpdateWeather(_ weatherManager:WeatherManger, weather: WeatherModel) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString
            self.cityLabel.text = weather.cityName
            self.conditionImageView.image = UIImage(systemName: weather.conditionname)
        }
        
        
    }
    func didFailWithError(error : Error) {
        print(error)
    }
}

//MARK: - CLLocationManagerDeligate

extension WeatherViewController:CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeather(latitude: lat, longitude: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}






























//
//
//
//import UIKit
//
//class WeatherViewController: UIViewController,UITextFieldDelegate, WeatherManagerDelegate {
//
//
//    @IBOutlet weak var conditionImageView: UIImageView!
//    @IBOutlet weak var temperatureLabel: UILabel!
//    @IBOutlet weak var cityLabel: UILabel!
//    @IBOutlet weak var searchTextField: UITextField!
//    var weatherManager = WeatherManger()
//
//
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        weatherManager.delegate = self
//        searchTextField.delegate = self
//    }
//
//    // to trigger the search button
//    @IBAction func searchPressed(_ sender: UIButton) {
//        searchTextField.endEditing(true)
//
//    }
//
//    // to activate the enter button
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        searchTextField.endEditing(true)
//        return true
//
//    }
//
//    //To Clear Text after searching
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        //This is the best place to get what the user typed
//       if let city = searchTextField.text {
//        weatherManager.fetchWeather(cityName:city)
//        }
//        searchTextField.text = ""
//    }
//
//
//    // For verification
//    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
//        if(textField.text != ""){
//            return true
//        }else{
//            textField.placeholder = "Type something"
//            return false
//        }
//    }
//
//
//    func didUpdateWeather(_ weatherManager:WeatherManger, weather: WeatherModel) {
//        DispatchQueue.main.async {
//            self.temperatureLabel.text = weather.temperatureString
//            self.cityLabel.text = weather.cityName
//            self.conditionImageView.image = UIImage(systemName: weather.conditionname)
//        }
//
//
//       }
//    func didFailWithError(error : Error) {
//        print(error)
//    }
//}
