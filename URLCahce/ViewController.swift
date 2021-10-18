//
//  ViewController.swift
//  URLCahce
//
//  Created by Чистяков Василий Александрович on 17.10.2021.
//

import UIKit

class ViewController: UIViewController {
    
//    let urlIphone13 = "https://store.storeimages.cdn-apple.com/4668/as-images.apple.com/is/iphone-13-pro-family-hero?wid=940&hei=1112&fmt=png-alpha&.v=1631220221000"
    
    let urlIphone13 = "https://store.storeimages.cdn-apple.com/4668/as-images.apple.com/is/MHKK3?wid=2000&hei=2000&fmt=jpeg&qlt=95&.v=1603649004000"
    
    @IBOutlet weak var image: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchImage(url: urlIphone13)
    }
    
    func fetchImage(url:String) {
        
        guard let url = URL(string: url) else { return }
        
        if let cahceImage = getCacheImage(url: url) {
            self.image.image = cahceImage
            print("Cache")
        } else {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let response = response , let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.image.image = image
                        print("Response")
                        self.saveImageToCache(data: data, response: response)
                    }
                }
            }.resume()
        }
    }
    
    private func saveImageToCache(data: Data, response: URLResponse) {
        guard let responseUrl = response.url else { return }
        let cacheResponse = CachedURLResponse(response: response, data: data)
        URLCache.shared.storeCachedResponse(cacheResponse, for: URLRequest(url: responseUrl))
    }
    
    func getCacheImage(url: URL)-> UIImage? {
        if let cacheResponse = URLCache.shared.cachedResponse(for: URLRequest(url: url)) {
            return UIImage(data: cacheResponse.data)
        }
        return nil
    }
}
