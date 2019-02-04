//
//  CocoaLumberjackFormatter.swift
//  CherryBlossoms
//
//  Created by JosephNK on 2018. 10. 26..
//  Copyright © 2018년 JosephNK. All rights reserved.
//

import UIKit
import CocoaLumberjack

class CocoaLumberjackFormatter: NSObject, DDLogFormatter {
    /**
     * Formatters may optionally be added to any logger.
     * This allows for increased flexibility in the logging environment.
     * For example, log messages for log files may be formatted differently than log messages for the console.
     *
     * For more information about formatters, see the "Custom Formatters" page:
     * Documentation/CustomFormatters.md
     *
     * The formatter may also optionally filter the log message by returning nil,
     * in which case the logger will not log the message.
     **/
    
    func format(message logMessage: DDLogMessage) -> String? {
        var logLevel: String = ""
        switch logMessage.flag {
        case DDLogFlag.error:
            logLevel = "E"
            break
        case DDLogFlag.warning:
            logLevel = "W"
            break
        case DDLogFlag.info:
            logLevel = "I"
            break
        case DDLogFlag.debug:
            logLevel = "D"
            break
        case DDLogFlag.verbose:
            logLevel = "V"
            break
        default:
            break
        }
        
        let fileName = logMessage.fileName
        let line = logMessage.line
        let message = logMessage.message
        let timestamp = logMessage.timestamp
        let threadID = logMessage.threadID
        
        return String(format: "\(timestamp) <\(threadID)> [\(logLevel)] (\(fileName) : %lu) \(message)", line)
    }
    
}

