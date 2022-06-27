import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var titleHero: UILabel!
    var heroData: Result?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .blue
        titleHero.text = heroData?.name ?? ""
        //titleLabel.text = HeroDetailConstants.name
        //titleLabel.text = MarvelAPI().fetchHeroesListing().last?.name ?? ""
    }
}

class InitialController: UIViewController{
    
    @IBOutlet var initialTableView: UITableView!    
    
    var dataClass = [Result]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let urlString = "https://demo3937237.mockable.io/heros"
        
        //performRequest(urlString: urlString)

        if let url = URL(string: urlString) {
                if let data = try? Data(contentsOf: url) {
                    parseJSON(json: data)
                }
        }
        //parseJSON(json: jsonData!)
        // Do any additional setup after loading the view.
        initialTableView.delegate = self
        initialTableView.dataSource = self
        
    }
    
    func parseJSON(json: Data) {
        let decoder = JSONDecoder()
        
        if let decodedData = try? decoder.decode(ModalStruct.self, from: json) {
            dataClass = decodedData.data.results
        }
        
    }
    
    func showHero(index: Int) {
        guard let viewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(identifier: "ViewController") as? ViewController else {
            return
        }
        //let indexHero = data.firstIndex(where: {$0.name == name})!
        let heroData = dataClass[index]
        viewController.heroData = heroData
            self.navigationController?.pushViewController(viewController, animated: true)
//            self.present(viewController, animated: true)
    }
    
}

extension InitialController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showHero(index: indexPath.row)
    }
}

extension InitialController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataClass.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let heroInformation = data[indexPath.row]
        let heroData = dataClass[indexPath.row]
        let heroCell = tableView.dequeueReusableCell(withIdentifier: "heroCell", for: indexPath) as! CustomTableViewCell
        
        //heroCell.heroImageView.image = UIImage(named: heroInformation.imageName)
        //heroCell.heroLabel.text = heroInformation.name
        
        var heroImageName = heroData.thumbnail.path+"/landscape_incredible."+heroData.thumbnail.extension
        heroImageName.insert("s", at: heroImageName.index(heroImageName.startIndex, offsetBy: 4))
        
        heroCell.heroImageView.loadFrom(URLAddress: heroImageName)
        heroCell.heroLabel.text = heroData.name
                
        return heroCell
    }
    
}

extension UIImageView {
    func loadFrom(URLAddress: String) {
        guard let url = URL(string: URLAddress) else {
            return
        }
        DispatchQueue.main.async { [weak self] in
            if let imageData = try? Data(contentsOf: url) {
                if let loadedImage = UIImage(data: imageData) {
                        self?.image = loadedImage
                }
            }
        }
    }
}
