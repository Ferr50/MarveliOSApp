import UIKit
import CommonCrypto

class ViewController: UIViewController {
    
    @IBOutlet weak var titleHero: UILabel!
    @IBOutlet weak var heroImg: UIImageView!
    @IBOutlet weak var nameComics: UILabel!
    @IBOutlet weak var descriptionComics: UILabel!
    @IBOutlet weak var nameStories: UILabel!
    @IBOutlet weak var descriptionStories: UILabel!
    
    var heroData: Result?
    var dataComicClass = [ResultComics]()
    var dataStoriesClass = [ResultStories]()
    var brain = Brain()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let heroData = heroData {
            
            let path = heroData.thumbnail.path
            let ext = heroData.thumbnail.extension
            let heroImgName = brain.changeImgName(path: path,type:"standard_fantastic", ext: ext)
            
            heroImg.loadFrom(URLAddress: heroImgName)
            titleHero.text = heroData.name
            
            let heroId = heroData.id
            let urlComic = brain.createURL(heroId: heroId, type: "comics")
            request(urlString: urlComic)
            
            let urlStories = brain.createURL(heroId: heroId, type: "stories")
            requestStories(urlString: urlStories)
        }
        
    }
    
    func request(urlString: String) {
        if let url = URL(string: urlString) {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url) {
                    self.parseComicJSON(json: data)
                }
            }
            
        }
    }
    
    func requestStories(urlString: String) {
        if let url = URL(string: urlString) {
            
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url) {
                    self.parseStoriesJSON(json: data)
                }
            }
        }
    }
    
    
    
    
    func parseComicJSON(json: Data) {
        do {
            
            let decoder = JSONDecoder()
            let decodedDataComic = try decoder.decode(ComicStruct.self, from: json)
            DispatchQueue.main.async {
                self.dataComicClass = decodedDataComic.data.results
                
                if let title = self.dataComicClass.object(at: 0)?.title {
                    self.nameComics.text = title
                    self.descriptionComics.text = self.dataComicClass[0].description
                    
                }else {
                    self.nameComics.text = "-"
                    self.descriptionComics.text = "No Information"
                }
            }
            
            // }
            
        }
        catch {
            print(error)
        }
    }
    
    func parseStoriesJSON(json: Data) {
        do {
            
            let decoder = JSONDecoder()
            let decodedDataComic = try decoder.decode(StoriesStruct.self, from: json)
            self.dataStoriesClass = decodedDataComic.data.results
            DispatchQueue.main.async {
                if let title = self.dataStoriesClass.object(at: 0)?.title {
                    
                    self.nameStories.text = title
                    self.descriptionStories.text = self.dataStoriesClass[0].description
                    
                    
                } else {
                    self.nameStories.text = "-"
                    self.descriptionStories.text = "No Information"
                }
            }
        } catch {
            print(error)
        }
        
    }
    
}



class InitialController: UIViewController{
    
    @IBOutlet var initialTableView: UITableView!
    
    var brain = Brain()
    var dataClass = [Result]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let urlString = "https://demo3937237.mockable.io/heros"
        //let urlString = brain.createUrlAPI()
        performRequest(urlString: urlString)
        print("didLoad")
        
        
        // Do any additional setup after loading the view.
        initialTableView.delegate = self
        initialTableView.dataSource = self
    }
    
    func performRequest(urlString: String) {
        print("performing request")
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                print("request done")
                if error != nil {
                    print(error!)
                    return
                }
                if let safeData = data {
                    self.parseJSON(json: safeData)
                }
            }
            task.resume()
        }
    }
    
    
    
    func parseJSON(json: Data) {
        let decoder = JSONDecoder()
        if let decodedData = try? decoder.decode(ModalStruct.self, from: json) {
            DispatchQueue.main.async {
                self.dataClass = decodedData.data.results
                self.initialTableView.reloadData()
            }
        }
    }
    
    
    
    func showHero(index: Int) {
        guard let viewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(identifier: "ViewController") as? ViewController else {
            return
        }
        let heroData = self.dataClass[index]
        viewController.heroData = heroData
        self.navigationController?.pushViewController(viewController, animated: true)
        
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
        let heroData = dataClass[indexPath.row]
        let heroCell = tableView.dequeueReusableCell(withIdentifier: "heroCell", for: indexPath) as! CustomTableViewCell
        
        let heroImageName = brain.changeImgName(path: heroData.thumbnail.path,type:"landscape_incredible" ,ext: heroData.thumbnail.extension)
        
        heroCell.heroImageView.loadFrom(URLAddress: heroImageName)
        heroCell.heroLabel.text = heroData.name
        
        return heroCell
    }
    
}




