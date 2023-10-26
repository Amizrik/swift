// RUN: %target-swift-frontend(mock-sdk: %clang-importer-sdk) -emit-sil %s -verify -parse-as-library -o /dev/null
// RUN: %target-swift-frontend(mock-sdk: %clang-importer-sdk) -emit-sil %s -verify -parse-as-library -o /dev/null -strict-concurrency=targeted
// RUN: %target-swift-frontend(mock-sdk: %clang-importer-sdk) -emit-sil %s -verify -parse-as-library -o /dev/null -strict-concurrency=complete
// RUN: %target-swift-frontend(mock-sdk: %clang-importer-sdk) -emit-sil %s -verify -parse-as-library -o /dev/null -strict-concurrency=complete -enable-experimental-feature TransferNonSendable

// REQUIRES: objc_interop
// REQUIRES: concurrency
// REQUIRES: asserts

import Foundation

@objc protocol P: Sendable { }
