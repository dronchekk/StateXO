//
//  LoggerInvoker.swift
//  XO-game
//
//  Created by Alexander Rubtsov on 17.02.2022.
//  Copyright © 2022 plasmon. All rights reserved.
//

import Foundation

class LoggerInvoker {
    
    // MARK: - Singleton
    
    static let shared = LoggerInvoker()
    
    // MARK: - Private Properties
    
    private let logger = Logger()
    private let batchSize = 10
    private var commands: [LogCommand] = []
    
    // MARK: - Functions
    
    func addLogCommand(_ command: LogCommand) {
        commands.append(command)
        executeCommandsIfNeeded()
    }
    
    // MARK: - Private Functions
    
    private func executeCommandsIfNeeded() {
        guard commands.count >= batchSize else {
            return
        }
        
        commands.forEach { self.logger.writeMessageToLog($0.logMessage) }
        
        commands = []
    }
}
