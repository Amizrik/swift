//===--- CxxVectorSum.swift -----------------------------------------------===//
//
// This source file is part of the Swift.org open source project
//
// Copyright (c) 2014 - 2012 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See https://swift.org/LICENSE.txt for license information
// See https://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
//
//===----------------------------------------------------------------------===//

// This is a benchmark that tracks how quickly Swift can sum up a C++ vector
// as compared to the C++ implementation of such sum.

import TestsUtils
import CxxStdlibPerformance
import Cxx

public let benchmarks = [
  BenchmarkInfo(
      name: "CxxVecU32.Sum.Cxx.RangedForLoop",
      runFunction: run_CxxVectorOfU32_Sum_Cxx_RangedForLoop,
      tags: [.validation, .bridging, .cxxInterop]),
  BenchmarkInfo(
    name: "CxxVecU32.Sum.Swift.ForInLoop",
    runFunction: run_CxxVectorOfU32_Sum_Swift_ForInLoop,
    tags: [.validation, .bridging, .cxxInterop]),
  BenchmarkInfo(
    name: "CxxVecU32.Sum.Swift.IteratorLoop",
    runFunction: run_CxxVectorOfU32_Sum_Swift_RawIteratorLoop,
    tags: [.validation, .bridging, .cxxInterop]),
  BenchmarkInfo(
    name: "CxxVecU32.Sum.Swift.SubscriptLoop",
    runFunction: run_CxxVectorOfU32_Sum_Swift_IndexAndSubscriptLoop,
    tags: [.validation, .bridging, .cxxInterop]),
  BenchmarkInfo(
    name: "CxxVecU32.Sum.Swift.Reduce",
    runFunction: run_CxxVectorOfU32_Sum_Swift_Reduce,
    tags: [.validation, .bridging, .cxxInterop])
]

// FIXME: compare CxxVectorOfU32SumInCxx to CxxVectorOfU32SumInSwift and
// establish an expected threshold of performance, which when exceeded should
// fail the benchmark.

let vectorSize = 25_000
let iterRepeatFactor = 5

@inline(never)
public func run_CxxVectorOfU32_Sum_Cxx_RangedForLoop(_ n: Int) {
  let sum = testVector32Sum(vectorSize, n * iterRepeatFactor)
  blackHole(sum)
}

@inline(never)
public func run_CxxVectorOfU32_Sum_Swift_ForInLoop(_ n: Int) {
    let vectorOfU32 = makeVector32(vectorSize)
    var sum: UInt32 = 0
    for _ in 0..<(n * iterRepeatFactor) {
      for x in vectorOfU32 {
        sum = sum &+ x
      }
    }
    blackHole(sum)
}

// This function should have comparable performance to
// `run_CxxVectorOfU32_Sum_Cxx_RangedForLoop`.
@inline(never)
public func run_CxxVectorOfU32_Sum_Swift_RawIteratorLoop(_ n: Int) {
  let vectorOfU32 = makeVector32(vectorSize)
  var sum: UInt32 = 0
  for _ in 0..<(n * iterRepeatFactor) {
    var b = vectorOfU32.__beginUnsafe()
    let e = vectorOfU32.__endUnsafe()
    while b != e {
        sum = sum &+ b.pointee
        b = b.successor()
    }
  }
  blackHole(sum)
}

@inline(never)
public func run_CxxVectorOfU32_Sum_Swift_IndexAndSubscriptLoop(_ n: Int) {
  let vectorOfU32 = makeVector32(vectorSize)
  var sum: UInt32 = 0
  for _ in 0..<(n * iterRepeatFactor) {
    for i in 0..<vectorOfU32.size() {
      sum = sum &+ vectorOfU32[i]
    }
  }
  blackHole(sum)
}

@inline(never)
public func run_CxxVectorOfU32_Sum_Swift_Reduce(_ n: Int) {
    let vectorOfU32 = makeVector32(vectorSize)
    var sum: UInt32 = 0
    for _ in 0..<(n * iterRepeatFactor) {
      sum = vectorOfU32.reduce(sum, &+)
    }
    blackHole(sum)
}

extension VectorOfU32.const_iterator : Equatable, UnsafeCxxInputIterator { }

extension VectorOfU32: CxxSequence {}
