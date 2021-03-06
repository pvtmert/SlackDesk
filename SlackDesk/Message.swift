//
//  Message.swift
//  SlackDesk
//
//  Created by Rob Harings on 07/07/2017.
//  Copyright © 2017 Rob Harings. All rights reserved.
//

import Cocoa
import Down
import Regex

class Message {
    
    var message:String
    var userId:String
    var ts:String
    
    public var connection:Connection
    public var messageAttributeString:NSAttributedString
    
    var messageView:MessageListItem!
    
    init(message: String, userId: String, ts: String, connection: Connection) {
        self.ts = ts
        self.message = message
        
        let replaced:String = ("<@([A-Z]\\w+){1}(\\|.+)?>".r?.replaceAll(in: message) { match in
            if match.group(at: 1) != nil {
                return "@" + (connection.users?.findUserForId(id: match.group(at: 1)!).name)!
            }
            return nil
        })!
        
        self.messageAttributeString = try! Down(markdownString: replaced.emojiUnescapedString).toAttributedString()
        
        self.userId = userId
        self.connection = connection
    }
    
    public func getTextView() -> String {
        return (self.connection.users?.findUserForId(id: self.userId).name)! + ": " + self.message
    }
    
    public func getRowSize() -> CGFloat {
        self.getView().layoutSubtreeIfNeeded()
        return self.getView().frame.size.height
    }
    
    public func getView() -> NSView {
        if self.messageView == nil {
            self.messageView = MessageListItem.init(nibName: "MessageListItem", bundle: nil, message: self)!
        }
        return self.messageView.view
    }

}
