import Foundation
import XCTest
import Combine

//  >>>> DID NOT WRITE THIS MY SELF! SOURCE IS INCLUDED <<<<

extension XCTestCase {
    /// Test publishers, taken from;
    /// https://www.swiftbysundell.com/articles/unit-testing-combine-based-swift-code/
    /// - Parameters:
    ///   - publisher:
    ///   - timeout:
    ///   - file:
    ///   - line:
    /// - Returns: the output
    /// - Throws: when an error occurs
    func awaitPublisher<T: Publisher>(
        _ publisher: T,
        timeout: TimeInterval = 1,
        execute: (() -> Void)? = nil,
        file: StaticString = #file,
        line: UInt = #line
    ) throws -> T.Output {
        // This time, we use Swift's Result type to keep track
        // of the result of our Combine pipeline:
        var result: Result<T.Output, Error>?
        let expectation = self.expectation(description: "Awaiting publisher")

        let cancellable = publisher.sink(
            receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    result = .failure(error)
                case .finished:
                    break
                }

                expectation.fulfill()
            },
            receiveValue: { value in
                result = .success(value)
                expectation.fulfill()
            }
        )
        
        // Execute some statement, nice for PassthroughSubjects
        execute?()

        // Just like before, we await the expectation that we
        // created at the top of our test, and once done, we
        // also cancel our cancellable to avoid getting any
        // unused variable warnings:
        waitForExpectations(timeout: timeout)
        cancellable.cancel()

        // Here we pass the original file and line number that
        // our utility was called at, to tell XCTest to report
        // any encountered errors at that original call site:
        let unwrappedResult = try XCTUnwrap(
            result,
            "Awaited publisher did not produce any output",
            file: file,
            line: line
        )

        return try unwrappedResult.get()
    }
}
