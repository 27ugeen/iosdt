//
//  Post.swift
//  Navigation
//
//  Created by GiN Eugene on 20.07.2021.
//

import Foundation
import UIKit

struct Post {
    var title: String
    let author: String?
    let image: UIImage
    let description: String?
    let likes: Int
    let views: Int
}

struct PostSection {
    var title: String?
    let posts: [Post]
}

struct PostsStorage {
    
    static let tableModel = [
        PostSection(posts: [
            Post(title: "Tesla profit surge driven by record car deliveries",
                 author: "Elon Mask",
                 image: #imageLiteral(resourceName: "tesla-model_y"),
                 description: "Sales rose to $12bn (£8.6bn) in the three months to the end of June, up from $6bn a year ago, when its US factory was shut down. The electric carmaker said it delivered a record 200,000 cars to customers in the same period. It added that public support for greener cars was greater than ever. The company, led by billionaire entrepreneur Elon Musk, reported on Monday that profits soared off the back of strong sales. Profits for the second three months of the year were $1.1bn, up from $104m last year, bolstered by sales of its cheaper Model 3 sedan and Model Y.",
                 likes: 42424,
                 views: 304598),
            Post(title: "The Suicide Squad: James Gunn taps into DC lore with new trailer starring Idris Elba, Margot Robbie, John Cena",
                 author: "James Gunn",
                 image: #imageLiteral(resourceName: "Margot_Robbie"),
                 description: "Get ready to watch this team of super-villains including Bloodsport, Peacemaker, Captain Boomerang, Ratcatcher 2, Savant, King Shark, Blackguard, Javelin and Harley Quinn band together to destroy every trace of something known only as \"Project Starfish.\" \"If anyone’s laying down bets, the smart money is against them—all of them,\" read line in the description. \"The Suicide Squad' is something of a sideways sequel to the 2016 film 'Suicide Squad'. This is Gunn's first feature since 2017's 'Guardians of the Galaxy Vol. 2'. He is expected to begin production on a third 'Guardians' film in London later this year. 'The Suicide Squad', which promises to be a fun, icky, and very chaotic good time, sMargot Robbie, Idris Elba, John Cena, Joel Kinnaman, Jai Courtney, Peter Capaldi, David Dastmalchian, Daniela Melchior, Michael Rooker, Alice Braga, Pete Davidson, Joaquín Cosio, Juan Diego Botto, Storm Reid, Nathan Fillion, Steve Agee, Sean Gunn, Mayling Ng, Flula Borg, Jennifer Holland and Tinashe Kajese, with Sylvester Stallone, and Viola Davis. It is slated to release on August 6 in theatres and on an OTT platform.",
                 likes: 2424,
                 views: 3453),
            Post(title: "SpaceX lifts huge Super Heavy rocket onto launch stand",
                 author: "Elon Mask",
                 image: #imageLiteral(resourceName: "Super_heavy_rocket"),
                 description: "Super Heavy is the first stage of SpaceX's two-stage, fully reusable Starship system, which the company is developing to send people and cargo to Mars and other distant destinations. The upper stage is a 165-foot-tall (50 m) spacecraft known as Starship. Starship spacecraft prototypes have flown before. This past May, for instance, a vehicle known as SN15 aced a 6.2-mile-high (10 kilometers) test flight into the South Texas sky. Super Heavy has yet to fly, but SpaceX aims to change that soon. The recently moved Super Heavy, known as Booster 4, is being prepped for an orbital test flight, which will also feature the SN20 Starship prototype. (On Tuesday, Musk tweeted a photo of SN20's six Raptor engines, which technicians had just installed.)  ",
                 likes: 35555,
                 views: 65464),
            Post(title: "BMW M3 Competition Takes on the Alfa Romeo Giulia Quadrifoglio Again",
                 author: "Nico DeMattia",
                 image: #imageLiteral(resourceName: "G80-BMW-M3-vs-Alfa-Romeo-Giulia-Quadrifoglio-4-of-4"),
                 description: "When reviews for the G80 BMW M3 Competition first began to trickle out, and showed very impressive results, my first thought was whether it could take down the Alfa Romeo Giulia Quadrifoglio. Prior to driving the G80 M3 Comp, the Giulia Quadrifoglio was the best sedan I’d ever driven. In fact, even after driving the M3 Comp, that still might be the case. However, I can say with confidence that they’re both absolutely brilliant. Yet, due to scheduling issues, I’ve yet to be able to test them back-to-back, to truly determine a winner. Thankfully, Car and Driver was. Admittedly, C&D wasn’t the first publication to put this comparison test together. We’ve already seen a few other pubs do it, with each car winning more than once. Which proves there’s yet to be a stand-out winner. Still, let’s see what C&D thinks of these two cars. One the spec sheet, the two cars are incredibly similar. They both have twin-turbo six-cylinder engines (3.0 I6 for the BMW and 2.9 V6 for the Alfa), both use the same eight-speed ZF automatic, both are rear-wheel drive only (an all-wheel drive M3 is on the way), and both have clever rear diffs. Even their power figures are similar; the M3 makes 503 horsepower and 479 lb-ft, while the Alfa makes 505 horsepower and 443 lb-ft. They also both get to 60 mph in around three and a half seconds. The real question, though, is which car is actually better to drive? Both are seriously fun cars but in very different ways. The BMW M3 Competition is the sharper car, with scalpel-like steering combined with an impossibly grippy front end. While the Alfa Romeo Giulia Quadrifoglio’s steering is lighter and a bit less extreme, it’s far more communicative, with better feed back. It’s been about a year since I last drove a Giulia Quadrifoglio but each and I’ve driven one every couple of years or so since it was released and each time it reminds me of how much I love it. The BMW M3 Competition is also a sensational machine, one that I love to drive and one I’d buy tomorrow if I could. But since I can’t get them back-to-back, I’ll have to take the word of C&D. What is that word? Read the comparison to find out.",
                 likes: 405,
                 views: 987)
        ])
    ]
}
