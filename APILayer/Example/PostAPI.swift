//
//  PostAPI.swift
//  Network
//
//  Created by YOO on 2025/11/08.
//

import Foundation

enum PostAPI {
    case fetchAll
}

extension PostAPI: APIRouter {
    var baseURL: String {
        "https://jsonplaceholder.typicode.com/posts"
    }

    var path: String {
        ""
    }

    var method: HTTPMethod {
        .GET
    }

    var headers: [String : String]? {
        nil
    }

    var body: Encodable? {
        nil
    }
}
