//
//  osLog.swift
//  Exposure
//
//  Created by Jonathan Amburgy on 12/5/24.
//

import OSLog

extension Logger {
    // Using your bundle identifier is a great way to ensure a unique identifier.
    private static var subsystem = Bundle.main.bundleIdentifier!

    // Logs the view cycles like a view that appeared.
    static let viewCycle = Logger(subsystem: subsystem, category: "viewcycle")

    // All logs related to tracking and analytics.
    static let statistics = Logger(subsystem: subsystem, category: "statistics")
}

/* All Commands
 
 Logger.viewCycle.notice("Notice example")
 Logger.viewCycle.info("Info example")
 Logger.viewCycle.debug("Debug example")
 Logger.viewCycle.trace("Notice example")
 Logger.viewCycle.warning("Warning example")
 Logger.viewCycle.error("Error example")
 Logger.viewCycle.fault("Fault example")
 Logger.viewCycle.critical("Critical example")
 
 
 default (notice): The default log level, which is not really telling anything about the logging. It’s better to be specific by using the other log levels.
 info: Call this function to capture information that may be helpful, but isn’t essential, for troubleshooting.
 debug: Debug-level messages to use in a development environment while actively debugging.
 trace: Equivalent of the debug method.
 warning: Warning-level messages for reporting unexpected non-fatal failures.
 error: Error-level messages for reporting critical errors and failures.
 fault: Fault-level messages for capturing system-level or multi-process errors only.
 critical: Functional equivalent of the fault method.

 */
