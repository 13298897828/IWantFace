//
//  LFNetwork.swift
//  lovek12
//
//  Created by 陆枫 on 15/6/15.
//  Copyright © 2015年 manyi. All rights reserved.
//


import Foundation
import Alamofire

protocol LKNetworkDelegate: NSObjectProtocol {
    func URLSession(session: NSURLSession, task: NSURLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64)
    func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?)
}

class LKNetworkTool: NSObject, NSURLSessionTaskDelegate {
    
    weak var delegate: LKNetworkDelegate?
    
    private static let instance = LKNetworkTool()
    
    class var shareInstance : LKNetworkTool {
        return instance
    }
    
//    lazy var itemList:[RecordModel] = {
//        return self.getupNetWorkItemList() as [RecordModel]
//    }()
//    
//    func getupNetWorkItemList() -> [RecordModel]{
//        
//        var arr :[RecordModel] = []
//        let predicate = NSPredicate(format: "(isUpload = 0) AND (userID =%d)",LKCheckUserID(true))
//        let (data, _) = GGSelectData("Recording", predicate: predicate)
//        if data != nil{
//            for obj in data as! [Recording] {
//                arr.insert(RecordModel(model: obj), atIndex: 0)
//            }
//        }else{
//            LKPrint("查无数据" + __FUNCTION__)
//        }
//        return arr
//    }
//    
//    func upLoadVideo(record:RecordModel?){
//        if record != nil {
//            if LKCheckUserID(false) == 1 {
//                return
//            }
//            let data2 = NSData(contentsOfFile: record!.filePath!)
//            let param: [String: AnyObject] = ["user_id":LKCheckUserID(false), "recite_id" : record!.video_id! , "video_file":record!.video_name!,"video_file_size":record!.size!.integerValue]
//            LKNetworkTool.POST(API_RecordingUploadNew,
//                params: param,
//                completionHandler: {
//                    
//                let data = $0.result.value
//                if let url = data?["data"] as? String{
//                    
//                    LKNetworkTool.UploadWithPOST(url, multipartFormData: {
//                        
//                        $0.appendBodyPart(data: data2!, name: "video_file", fileName: record!.video_name!, mimeType:  "multipart/form-data")
//                        }, encodingCompletion: { (result) -> Void in
//                        
//                    })
//                }
//
//            })
//        }
//    }
//    
    func upLoadsVideo(request: NSURLSession -> ()){
        
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config, delegate: self, delegateQueue: nil)
        //        let url = NSURL(string: "")
        //        let req = NSMutableURLRequest(URL: url!)
        request(session)
    }
    
    /// MARK: - Alamofire
    /// AlamofireGetJSON
    class func GET(URLString: String,
        params: [String: AnyObject]?,
        errorIndicator: Bool = true,
        encoding: ParameterEncoding = .URL,
        headers: [String: String]? = nil,
        completionHandler: Response<AnyObject, NSError> -> Void) {
//            LKNetworkIndicator(true)
            Alamofire.request(.GET, URLString, parameters: params, encoding: encoding, headers: headers).responseJSON {
//                LKNetworkIndicator(false)
                
                if ($0.result.error != nil) && errorIndicator {
                    debugPrint($0.result)
//                    LKProgressHUD.Error.Network.show
                }
                completionHandler($0)
        }
    }
    
    class func GET(URLString: String,
        params: [String: AnyObject]?,
        encoding: ParameterEncoding = .URL,
        headers: [String: String]? = nil) -> Request {
            return Alamofire.request(.GET, URLString, parameters: params, encoding: encoding, headers: headers)
    }
    
    /// AlamofirePostJSON
    class func POST(URLString: String,
        params: [String: AnyObject]?,
        errorIndicator: Bool = true,
        encoding: ParameterEncoding = .URL,
        headers: [String: String]? = nil,
        completionHandler: Response<AnyObject, NSError> -> Void) {
//            LKNetworkIndicator(true)
            Alamofire.request(.POST, URLString, parameters: params, encoding: encoding, headers: headers).responseJSON {
                
//                LKNetworkIndicator(false)
                if ($0.result.error != nil) && errorIndicator {
                    debugPrint($0.result)
//                    LKProgressHUD.Error.Network.show
                }
                completionHandler($0)
        }
    }
    
    class func UploadWithPOST(URLString: URLStringConvertible,
        headers: [String: String]? = nil,
        multipartFormData: MultipartFormData -> Void,
        encodingMemoryThreshold: UInt64 = Manager.MultipartFormDataEncodingMemoryThreshold,
        encodingCompletion: (Manager.MultipartFormDataEncodingResult -> Void)?) {
        
            Alamofire.upload(.POST, URLString, headers: headers, multipartFormData: multipartFormData, encodingMemoryThreshold: encodingMemoryThreshold, encodingCompletion: encodingCompletion)
    }
}

extension LKNetworkTool: NSURLSessionDelegate {
    //NSURLSessionTaskDelegate
    //下载中
    func URLSession(session: NSURLSession, task: NSURLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64){
        self.delegate?.URLSession(session, task: task, didSendBodyData: bytesSent, totalBytesSent: totalBytesSent, totalBytesExpectedToSend: totalBytesExpectedToSend)
    }
    
    //下载完毕
    func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?){
        //清除
//        if error == nil {
//            for i in 0..<itemList.count {
//                if itemList[i].task == task{
//                    //更新数据库信息
//                    let predicate = NSPredicate(format: "md5 == %@", itemList[i].md5!)
//                    
//                    let results = GGSelectData("Recording", predicate: predicate)
//                    if results.0?.count != 0{
//                        let record:Recording = results.0![0] as! Recording
//                        record.isUpload = 1
//                        do {
//                            try results.context.save()
//
//                            itemList.removeAtIndex(i)
//                        } catch _ {
//
//                        }
//                    }
//                    break
//                }
//            }
//        }
        self.delegate?.URLSession(session, task: task, didCompleteWithError: error)
    }
}