import UIKit
import WebKit
class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    
    var myTable:UITableView!
    var myTextField:UITextField!
    var json:JsonForYoutube!
    
    let key="anything"/*取得したAPIKeyを入力する*/
    var thumbnails:[UIImage]!
    var titles:[String]!
    var channelTitles:[String]!
    var url:[URL]!
    override func viewDidLoad() {
        super.viewDidLoad()
        myTable=UITableView(frame:view.frame)
        myTable.rowHeight=view.frame.height/7
        myTable.delegate=self
        myTable.dataSource=self/*上の２つのfunc tableViewが呼び出されるように設定*/
        myTable.register(MyCell.self,forCellReuseIdentifier:"MyCell")
        view.addSubview(myTable)
        thumbnails=[]
        url=[]
        titles=[]
        channelTitles=[]
        setTextField()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 40/*セクションの数を返す*/
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier:"MyCell",for: indexPath)as! MyCell/*インデックスパスに対応したセルを返す。*/
        let index=indexPath.row
        if thumbnails.count>index{
            cell.set(title:titles[index], channelTitle: channelTitles[index], image: thumbnails[index], url: url[index])
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index=indexPath.row
        let urlRequest=NSURLRequest(url:url[index])as URLRequest
        let webView=WKWebView()
        webView.frame=self.view.frame
        webView.load(urlRequest)
        self.view.addSubview(webView)
    }

}

extension ViewController:UITextFieldDelegate{
    func setTextField(){
        myTextField=UITextField(frame: CGRect(x:10,y:10,width:view.frame.width,height:50))
        myTextField.delegate=self
        view.addSubview(myTextField)
    }
    func textFieldShouldReturn(_ textField:UITextField)->Bool{
        textField.resignFirstResponder()
        if let text=textField.text{/*text!=nil*/
            searchVideos(for:text)
        }
        return true
    }
}
extension ViewController{
    func searchVideos(for searchWord:String){
        var urlString:String = "https://www.googleapis.com/youtube/v3/search?key="
            + key +
            "&q="
            + searchWord +
        "&part=snippet&maxResults=40&order=viewCount"
        urlString = urlString.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        let url=URL(string:urlString)
        let urlRequest:URLRequest = NSURLRequest(url:url!) as URLRequest
        let task = URLSession.shared.dataTask(with:urlRequest,completionHandler:{(data,response,error) -> Void in
            self.json=try! JSONDecoder().decode(JsonForYoutube.self,from:data!)
            self.setData()
            })
        
        task.resume()
    }
    func setData(){
        for i in (0..<(json?.items!.count)!).reversed(){
            if json?.items![i].id?.kind != "youtube#video"{
                json?.items!.remove(at:i)
            }
        }
        url=[]
        titles=[]
        channelTitles=[]
        for item in (json?.items)!{
            let id=(item.id?.videoId)!
            url.append(URL(string:"https://www.youtube/com/embed/"+id+"?playersinlie=1")!)
            let snippet=item.snippet!
            titles.append(snippet.title!)
            channelTitles.append(snippet.channelTitle!)
        }
        getImage()
    }
    func getImage(){
        thumbnails=[]
        for _ in url{
            thumbnails.append(UIImage())
        }
        for i in 0..<(json?.items?.count)!{
            let item=json?.items![i]
            let urlString=item!.snippet?.thumbnails?.medium?.url!
            let url=URL(string:urlString!)
            let urlRequest=URLRequest(url:url!)
            let task=URLSession.shared.dataTask(with:urlRequest,completionHandler:{(data,response,error)->Void in
                self.thumbnails[i]=UIImage(data:data!)!
     //           self.thumbnails.append(UIImage(data:data!)!)
                self.myTable.reloadData()
            })
            task.resume()
        }
    }
}
