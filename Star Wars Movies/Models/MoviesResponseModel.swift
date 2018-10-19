//
// Created by Nicolas Fontaine on 12/10/2018.
// Copyright (c) 2018 Nicolas Fontaine. All rights reserved.
//

import Foundation


struct GetMoviesResponse: Codable {
    let count: Int
    let results: [Movie]
}

struct Movie: Codable {
    let title: String?
    let episode_id: Int?
    let opening_crawl: String?
    let director: String?
    let producer: String?
    let release_date: String?
}
