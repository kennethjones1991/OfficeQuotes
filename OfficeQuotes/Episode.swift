//
//  Episode.swift
//  OfficeQuotes
//
//  Created by Kenneth Jones on 3/13/21.
//

import Foundation

struct Episode: Codable {
    let title: String
    let description: String
    let airDate: String
    
    enum EpisodeKeys: String, CodingKey {
        case data
        
        enum DataKeys: String, CodingKey {
            case title
            case description
            case airDate
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: EpisodeKeys.self)
        let dataContainer = try container.nestedContainer(keyedBy: EpisodeKeys.DataKeys.self, forKey: .data)
        
        title = try dataContainer.decode(String.self, forKey: .title)
        description = try dataContainer.decode(String.self, forKey: .description)
        airDate = try dataContainer.decode(String.self, forKey: .airDate)
    }
}
