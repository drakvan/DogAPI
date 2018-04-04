//
//  ViewController.swift
//  DogAPI
//
//  Created by Ivan Cabrer on 4/2/18.
//  Copyright © 2018 drakvan. All rights reserved.
//

import UIKit

extension UIImageView {
    func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
            }.resume()
    }
    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url, contentMode: mode)
    }
}

class DogBreed{
    var name: String!
    var arrPhotos: [String]!
    var randomN: Int
    
    init(nm: String, ph: [String], n: Int){
        name = nm
        arrPhotos = ph
        randomN = n
    }
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var breeds: Breeds!
    var arrPhotos: [String]! = []
    
    var breedsArr: [DogBreed]! = []
    
    func randomNumber(size: Int)->Int{
        let n = Int(arc4random_uniform(UInt32(size)))
        
        return Int(n)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        downloadJSON {
//            self.breedsArr = self.breeds.message
            for breed in self.breeds.message{
                self.breedsArr.append(DogBreed(nm: breed, ph: [], n: 0))
            }
            
            for db in self.breedsArr{
                self.downloadJSONPhotos(db: db)
            }
            
            self.tableView.reloadData()
        }
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return breedsArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        
        cell.tlBreed.text = breedsArr[indexPath.row].name.localizedCapitalized
        
        
        //Check if the arrPhotos is already downloaded
        if(breedsArr[indexPath.row].arrPhotos.count>0){
            
            let n = breedsArr[indexPath.row].randomN
            let urlString = URL(string: breedsArr[indexPath.row].arrPhotos[n])
            
            cell.imagePhoto.downloadedFrom(url: urlString!)
        }
        
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
                    
                    DispatchQueue.main.async{
                        completed()
                    }
                }catch{
                    print("JSON Error")
                }
            }
        }.resume()
    }
    
    func downloadJSONPhotos(db: DogBreed){
        
        let url = URL(string: "https://dog.ceo/api/breed/" + db.name + "/images")
        
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            
            if error == nil{
                do{
                    let photosMess = try JSONDecoder().decode(Photos.self, from: data!)
                    self.arrPhotos = photosMess.message
                    db.arrPhotos = photosMess.message
                    
                    db.randomN = self.randomNumber(size: photosMess.message.count)
                }catch{
                    print("JSON Error")
                }
            }else {print("If Error")}
        }.resume()
    }
}

