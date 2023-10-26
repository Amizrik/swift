// RUN: %target-swift-frontend -disable-availability-checking %s -emit-sil -o /dev/null -verify
// RUN: %target-swift-frontend -disable-availability-checking %s -emit-sil -o /dev/null -verify -strict-concurrency=targeted
// RUN: %target-swift-frontend -disable-availability-checking %s -emit-sil -o /dev/null -verify -strict-concurrency=complete
// RUN: %target-swift-frontend -disable-availability-checking %s -emit-sil -o /dev/null -verify -strict-concurrency=complete -enable-experimental-feature TransferNonSendable

// REQUIRES: concurrency
// REQUIRES: asserts

actor A1: Comparable {}
// expected-error@-1 {{type 'A1' does not conform to protocol 'Comparable'}}
// expected-error@-2 {{type 'A1' does not conform to protocol 'Equatable'}}
// expected-note@-3 {{automatic synthesis of 'Comparable' is not supported for actor declarations}}
// expected-note@-4 {{automatic synthesis of 'Equatable' is not supported for actor declarations}}

actor A2: Equatable {}
// expected-error@-1 {{type 'A2' does not conform to protocol 'Equatable'}}
// expected-note@-2 {{automatic synthesis of 'Equatable' is not supported for actor declarations}}

actor A3: Hashable {}
// expected-error@-1 {{type 'A3' does not conform to protocol 'Hashable'}}
// expected-error@-2 {{type 'A3' does not conform to protocol 'Equatable'}}
// expected-note@-3 {{automatic synthesis of 'Hashable' is not supported for actor declarations}}
// expected-note@-4 {{automatic synthesis of 'Equatable' is not supported for actor declarations}}
