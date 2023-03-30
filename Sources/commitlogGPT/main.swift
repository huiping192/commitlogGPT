//
//  File.swift
//  
//
//  Created by 郭 輝平 on 2023/03/30.
//

import Foundation
import ArgumentParser

struct CLG: ParsableCommand {
  @Flag(name: .shortAndLong, help: "Enable debug mode.")
  var debug: Bool = false
  
  mutating func run() async throws {
    await Client().run()
  }
}

CLG.main()

