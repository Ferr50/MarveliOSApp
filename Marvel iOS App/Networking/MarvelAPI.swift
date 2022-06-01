import Foundation

class MarvelAPI {

    func fetchHeroesListing() -> [HeroInformation] {
        var heroListing = [HeroInformation]()
        for index in 0..<10 {
            let heroInformation = HeroInformation(name: "name\(index)", description: "description\(index)")
            heroListing.append(heroInformation)
        }
        return heroListing
    }
}
