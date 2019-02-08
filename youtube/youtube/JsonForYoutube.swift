
import Foundation

struct JsonForYoutube:Codable{
	let kind:String?
	let etag:String?
	let nextPageToken:String?
	let prevPageToken:String?
	let regionCode:String?
	let pageInfo:PageInfo?
	var items:[Item]?
}

struct PageInfo:Codable{
	let totalResults:Int?
	let resultsPerPage:Int?
}

struct Item:Codable{
	let kind:String?
	let etag:String?
	let id:Id?
	let snippet:Snippet?
	let thumbnails:Thumbnails?
}

struct Id:Codable{
	let kind:String?
	let videoId:String?
	let channelId:String?
	let playlistId:String?
}
struct Snippet:Codable{
	let publishedAt:String?
	let channelId:String?
	let title:String?
	let description:String?
	let thumbnails:Thumbnails?
	let channelTitle:String?
	let liveBroadcastContent:String?
}
struct Thumbnails:Codable{
	let _default:Quarity?
	let medium:Quarity?
	let high:Quarity?
	private enum CodingKeys:String,CodingKey{
		case _default = "default"
		case medium = "medium"
		case high = "high"
	}
}

struct Quarity:Codable{
	let url:String?
	let width:Int?
	let height:Int?
}
