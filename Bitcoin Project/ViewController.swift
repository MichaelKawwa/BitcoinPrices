//
//  ViewController.swift
//  Bitcoin Project
//
//  Created by Michael Kawwa on 3/25/20.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet var currencyPickerView: UIPickerView!
    @IBOutlet var bitcoinValueLabel: UILabel!
  
    // insert your api key her.
    let apiKey = "ZTZkYmY1ODBjMGVhNGUzZTlhOGQ2NDEwZTRkZDg4ZGM"
    
    // contains a list of curruncies.
    let curruncies = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    // we start off with this url, the currency is AUD.
    let baseUrl = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTCAUD"

    override func viewDidLoad() {
        super.viewDidLoad()
        currencyPickerView.delegate = self
        currencyPickerView.dataSource = self
        //starting value
        fetchData(url: baseUrl)
    }

     func numberOfComponents(in pickerView: UIPickerView) -> Int {
          return 1
       }
       
     func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
           // return the number of curruncies, from the curruncy array
          return curruncies.count
       }
    
     func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        // return the title from the curruencies array to the appropriate row
        return curruncies[row]
     }
       
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // called when a row is selected.
        // change the url according to the row selected.
        var url = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC\(curruncies[row])"
        fetchData(url: url)
    }
    
    func fetchData(url: String) {
        //fetch data from the url, using URLSession
        
        let url = URL(string: url)!
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue(apiKey, forHTTPHeaderField: "x-ba-key")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let data = data {
                let dataString = String(data: data, encoding: .utf8)
             // send json to be parsed
                self.parseJSON(json: data)
            } else {
                //data was not fetched correctly
                print("error")
            }
        }
        task.resume()
        
    }
    
    func parseJSON(json: Data) {
        // parse the json using JSONSerialization
        do {
            // this method parses the json.
            if let json = try JSONSerialization.jsonObject(with: json, options: .mutableContainers) as? [String: Any] {
                // this is where we get the "ask" value from the JSON
                print(json)
                if let askValue = json["ask"] as? NSNumber {
                    print(askValue)
                    //convert tp string
                    let askvalueString = "\(askValue)"
                    DispatchQueue.main.async {
                        //must update ui over main thread
                        self.bitcoinValueLabel.text = askvalueString
                    }
                    print("success")
                } else {
                    print("error")
                }
            }
        } catch {
            // check for any errors when parsing the JSON
            print("error parsing json: \(error)")
        }
    }

}

