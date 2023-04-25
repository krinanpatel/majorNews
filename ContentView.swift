import UIKit
import SwiftUI
import Foundation
struct Article: Identifiable {
    let id = UUID()
    let title: String
    let description: String
}
let favorite_articles = [
    
    Article(title: "NASA Announces Plans for First Manned Mission to Mars", description: "NASA has announced that it plans to send astronauts to Mars by the year 2030, marking the first time that humans will have set foot on the Red Planet."),
    Article(title: "Apple Unveils New iPhone 13 with Improved Camera and Battery Life", description: "At its annual September event, Apple announced the release of the iPhone 13, featuring a new A15 Bionic chip, improved camera system, and longer battery life."),
]
struct ContentView: View {
    
    @State private var articles: [Article] = []
    
    var body: some View {
        TabView {
            // Profile tab
            VStack {
                Image("Image")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 200, height: 200)
                    .clipShape(Circle())
                    .padding(.top, 50)
                
                Text("John Doe")
                    .font(.title)
                    .bold()
                    .padding(.top, 20)
                
                Text("Major: Computer Science ")
                    .font(.headline)
                    .foregroundColor(.gray)
                
            }
            .tabItem {
                Image(systemName: "person.fill")
                Text("Profile")
            }
            
            // Feed tab
            NavigationView {
                List(articles) { article in
                    VStack(alignment: .leading) {
                        Text(article.title)
                            .font(.headline)
                        Text(article.description)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                .navigationTitle("majorNews")
                .onAppear {
                    let urlString = "https://majornewsdata-ezaxlyy7pq-uc.a.run.app/get_articles"
                    if let url = URL(string: urlString) {
                        let session = URLSession.shared
                        let task = session.dataTask(with: url) { (data, response, error) in
                            
                            if let error = error {
                                print("Error fetching data: \(error.localizedDescription)")
                                return
                            }
                            
                            guard let data = data else {
                                print("No data returned from API")
                                return
                            }
                            
                            do {
                                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                                if let articlesData = json?["articles"] as? [[String: Any]] {
                                    var tempArticles: [Article] = []
                                    for articleData in articlesData {
                                        if let title = articleData["title"] as? String,
                                           let description = articleData["description"] as? String {
                                            tempArticles.append(Article(title: title, description: description))
                                        }
                                    }
                                    DispatchQueue.main.async {
                                        articles = tempArticles
                                    }
                                }
                            } catch {
                                print("Error parsing JSON data: \(error.localizedDescription)")
                            }
                        }
                        
                        task.resume()
                    } else {
                        print("Invalid URL: \(urlString)")
                    }
                }
            }
            .tabItem {
                Image(systemName: "square.grid.2x2.fill")
                Text("Feed")
            }
     
            
            
            // Favorites tab
            NavigationView {
                List(favorite_articles) { article in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(article.title)
                                .font(.headline)
                            Text(article.description)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        Image(systemName: "heart.fill")
                    }
                }
                
                .navigationTitle("Favorites")
                
            }
            .tabItem {
                Image(systemName: "heart.fill")
                Text("Favorites")
            }
           
            
        }
        

    }
   

}

struct NewsPage_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
