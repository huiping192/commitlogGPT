//
//  File.swift
//  
//
//  Created by 郭 輝平 on 2023/03/30.
//

import Foundation

@Sendable
@discardableResult
func runShellCommand(_ command: String, arguments: [String]) -> String {
  let process = Process()
  process.executableURL = URL(fileURLWithPath: command)
  process.arguments = arguments
  
  let outputPipe = Pipe()
  process.standardOutput = outputPipe
  
  do {
    try process.run()
  } catch {
    print("Failed to run \(command) \(arguments.joined(separator: " "))")
    exit(1)
  }
  
  let outputData = outputPipe.fileHandleForReading.readDataToEndOfFile()
  return String(data: outputData, encoding: .utf8) ?? ""
}
