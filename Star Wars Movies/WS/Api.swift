//
// Created by Nicolas Fontaine on 12/10/2018.
// Copyright (c) 2018 Nicolas Fontaine. All rights reserved.
//

import Foundation
import Alamofire

typealias MoviesResponseClosure = (([Movie]?, Error?) -> Void)

enum CustomError: Error {
    case failedToParseData
}

class Api {
    static private var _shared: Api?

    static var shared: Api {
        guard let sharedApi = _shared else {
            let newApi =  Api()
            _shared = newApi
            return newApi
        }
        return sharedApi
    }

    func getAllMovies(completion: @escaping MoviesResponseClosure) {
        Alamofire.request("https://swapi.co/api/films/").response { response in

            if let error = response.error {
                completion(nil, error)
            }

            let decoder = JSONDecoder()
            guard let responseData = response.data,
                  let movies = try? decoder.decode(GetMoviesResponse.self, from: responseData).results else {
                    completion(nil, CustomError.failedToParseData)
                    return
            }

            completion(movies, nil)
        }
    }
}
