import ArgumentParser
import SwiftJava

@main
struct JavaMath: ParsableCommand {
  @Argument(help: "The number to check for primality")
  var number: String
  @Option(help: "The certainty to require in the prime check")
  var certainty: Int32 = 10

  func run() throws {

    let bigInt = BigInteger(number)
    let total = plusOne(bigInt)
    print("Total: \(total)")
    print(probablyPrime(BigInteger("\(total)")))

    // Static Method in Java
    let javaVirtualMachine = try JavaVirtualMachine.shared()
    let jniEnvironment = try javaVirtualMachine.environment()

    let bigIntClass = try JavaClass<BigInteger>(environment: jniEnvironment)
    let rand = Random(environment: jniEnvironment)
    if let isPrime = bigIntClass.probablePrime(total, rand) {
      print("It is prime! \(isPrime.intValue())")
    } else {
      print("Not Prime")
    }

  }

  func plusOne(_ bigInt: BigInteger) -> Int32 {
    let bigTwo = bigInt.add(BigInteger("1"))
    guard let result = bigTwo else {
      return bigInt.intValue()
    }
    return result.intValue()
  }

  func probablyPrime(_ bigInt: BigInteger) -> Bool {
    return bigInt.isProbablePrime(certainty)
  }

}
