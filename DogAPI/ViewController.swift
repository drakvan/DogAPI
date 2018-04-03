//
//  ViewController.swift
//  DogAPI
//
//  Created by Ivan Cabrer on 4/2/18.
//  Copyright © 2018 drakvan. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var breeds: Breeds!
    var breedsArr: [String]! = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        downloadJSON {
            print(self.breeds.message.count)
            
            self.breedsArr = self.breeds.message
            self.tableView.reloadData()
        }
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        
        return breedsArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = breedsArr[indexPath.row].localizedCapitalized
        
        //Image Downloading
        //Review Operations for resources efficiency
        //Closure for random image
        
//        let sUrl = "https://dog.ceo/api/breed/"+breedsArr[indexPath.row]+"/images"
//        let nsurl = NSURL(string: sUrl)
//        let imgData = NSData(contentsOfURL: nsurl!)
//        cell.oImagen.image = UIImage(data: imgData!)
        
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func downloadJSON(completed: @escaping () -> ()){
        
        let url = URL(string: "https://dog.ceo/api/breeds/list")
        
        URLSession.shared.dataTask(with: url!) { (data, responde, error) in
            
            if error == nil{
                do{
                    self.breeds = try JSONDecoder().decode(Breeds.self, from: data!)
//                    print(self.breeds.message)
                    
                    DispatchQueue.main.async{
                        completed()
                    }
                }catch{
                    print("JSON Error")
                }
            }
        }.resume()
    }
}

