//
//  ConsoleDestination.swift
//  SwiftyBeaver
//
//  Created by Sebastian Kreutzberger on 05.12.15.
//  Copyright © 2015 Sebastian Kreutzberger
//  Some rights reserved: http://opensource.org/licenses/MIT
//

import Foundation

public class ConsoleDestination: BaseDestination {

    public var useNSLog = false

    override public var defaultHashValue: Int { return 1 }

    public override init() {
        super.init()

        // use colored Emojis for better visual distinction 
        // of log level for Xcode 8
        levelColor.Verbose = "💜 "     // silver
        levelColor.Debug = "💚 "        // green
        levelColor.Info = "💙 "         // blue
        levelColor.Warning = "💛 "     // yellow
        levelColor.Error = "❤️ "       // red
    }

    // print to Xcode Console. uses full base class functionality
    override public func send(_ level: SwiftyBeaver.Level, msg: String, thread: String,
        file: String, function: String, line: Int) -> String? {
        let formattedString = super.send(level, msg: msg, thread: thread, file: file, function: function, line: line)

        if let str = formattedString {
            if useNSLog {
                NSLog("%@", str)
            } else {
                print(str)
            }
        }
        return formattedString
    }

}
