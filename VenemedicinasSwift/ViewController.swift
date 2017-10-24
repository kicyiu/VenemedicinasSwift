//
//  ViewController.swift
//  VenemedicinasSwift
//
//  Created by Alberto Tsang on 10/19/17.
//  Copyright © 2017 kicyiusoft. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource {
    

    let activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView();
    var url = URL(string: "")
    private var medicines = [Medicine]()
    
    @IBOutlet weak var searchBar: UISearchBar!
    

    @IBOutlet var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        searchBar.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        startLoading()
        print("Search Bar Clicked")
        tableView.reloadData()
        
        url = URL(string: "https://silkefischer.000webhostapp.com/getMedicin.php?name="+searchBar.text!)
        
        //Oculto el teclado
        searchBar.resignFirstResponder()
        
        downLoadJson()
        
        //paro la ejecucion del programa por un instante para que de chance de saber hub o no resultado
        let when = DispatchTime.now() + 5 // change number to set seconds
        DispatchQueue.main.asyncAfter(deadline: when) {
            if (self.medicines.count == 0) {
                self.stopLoading()
                self.showAlert()
            }
        }

    }
    
    func downLoadJson() {
        guard let downloadURL = url else { return }
        URLSession.shared.dataTask(with: downloadURL) { (data, urlResponse, error) in
            guard let data = data, error == nil, urlResponse != nil else {
                print("Something is wrong")
                return
            }
            print("donwloaded")
            do
            {
                let decoder = JSONDecoder()
                let downloadedMedicines = try decoder.decode([Medicine].self, from: data)
   
                self.medicines = downloadedMedicines

                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            } catch {
                print(error)
            }
           
            }.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //si la busqueda no devuelve resultados paro el indicador de actividades
        return medicines.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var locationString = ""
        //Con esto el tamaño de la celda dependerá del contenido
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MedicineCell") as? MedicineCell else {
            return UITableViewCell()
        }
      
        locationString = medicines[indexPath.row].Description + "\n"
        
        print("El numero de celdas es: " + String(medicines.count))
        print("IndexPath es: " + String(indexPath.row))
        print("El numero de variant es: " + String(medicines[indexPath.row].variant.count))
        
        //recorreo los variant
        for index in 1...medicines[indexPath.row].variant.count {
            locationString = locationString + "- " + medicines[indexPath.row].variant[index-1].City + " " + medicines[indexPath.row].variant[index-1].Name + "\n"
     
        }
  
        //Si es la ultima celda paro el indicador de actividades
        cell.itemLbl.text = locationString
        if (medicines.count - 1 == indexPath.row) {
            stopLoading()
            print("Stop Loading")
        }
        
        
        return cell
    }
    
    func startLoading(){
        activityIndicator.center = self.view.center;
        activityIndicator.hidesWhenStopped = true;
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray;
        view.addSubview(activityIndicator);
        
        activityIndicator.startAnimating();
        //UIApplication.shared.beginIgnoringInteractionEvents();
        
    }
    
    func stopLoading(){
        
        activityIndicator.stopAnimating();
        //UIApplication.shared.endIgnoringInteractionEvents();
    }
    
    func showAlert() {
        let message = "No se encontró el medicamento"
        
        let alert = UIAlertController(title: "Resultado",
                                      message: message,
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default,
                                   handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
    /*
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("Search Bar text changed")
        self.searchBar.showsCancelButton = true;
    }
    */
    




}

