# Table of Contents

  - [List](#list)
  - [Set](#Set)

## List

```swift
var result = [Int](repeating: 0, count: 10)  // init arr with repeated default values
var arr = [1,2,3,4]
arr.reverse()    // revere the array inline
arr.swapAt(i, j) // swap the arr with indexes
arr.insert(newElement, i)
```
## Queue

```swift
var q = [(Int, Int)]()    //intialize an tuple 
q.isEmpty                  //error if not initialized
q.count
q.append((i, j)).        // append the tuple to the end 
var rmvd = q.removeFirst() // error if the list is empty, return element
```

## Dict

```swift
var dict = [String:Double]()
dict["a"] = 0.2
let b = dict["a"]       // dict will return Optional<Double>
// Iterating through dict
for (key, value) in dict {}
for k in dict.keys {}
// Sort 
dict.sorted(by: { $0.1 < $1.0 })    //sorted by key -> ascending order
// Dict Index

```

## Stack

```swift
var stack:[Character] = []     //intialize an tuple 
stack.append("a").             // append the tuple to the end 
var rmvd = stack.removeLast()  // err if the list is empty, return element
```

## Set

```swift
var set = Set<Int>()         //initialize a Set for Int
set.insert(1)
set.insert(1).inserted
                             //(true, newMember) if `newMember` was not contained in the set.  
                             //(false, oldMember) if an element equal to `newMember` was already contained in the set
if set.contains(1) {}            
var rmvd = set.remove(2)     //remove element, return nil if not exist (no err)
```

## Heap

```swift
import HeapModule
var heap = Heap<Person>()
heap.insert(Person("Anthony"))
var min = heap.min
var max = heap.max
var popMax = heap.popMax()
var popMin = heap.popMin()
```

## Comparable

```swift
class Person: Comparable {
	let name: String
	init(name: String) {
		self.name = name
	}
	func < (lhs: Person, rhs: Person) -> Bool {
		return lhs.name < rhs.name
	}
	func < (lhs: Person, rhs: Person) -> Bool {
		return lhs.name == rhs.name
	}
}
```


## Iteration

```swift
// Integer
for i in (1...3).reversed() {}
for i in stride(from:3,through:1,by:-1) {} // 3,2,1
for i in stride(from:3,to:1,by:-1) {} // 3,2
// Double
for i in stride(from: 0.5, through: -0.1, by: -0.2) { print(i) } // this is not reliable :thinking
```

## Math

```swift
let total = numbers.reduce(0, +)         // calculate sum

```

## Bit Operations

[Bit Operations](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/advancedoperators/)

```swift

```

## String Integer Conversion

```swift
// String to Int conversion
var a = Int("-11")   // returned as Optional<Int>
let b = Int("abc") ?? 0  // returned as 
```


## Function

```swift
func swap(_ nums : inout [Int], _ first: Int, _ second: Int) {
	let temp = nums[first]
	nums[first] = nums[second]
	nums[second] = temp
}
swap(&nums, i, num[i])
```


## Others

```swift
print(type(of: a))      // print type of object

// Nil-Coalescing Operator
let defaultColorName = "red"
var userDefinedColorName: String?
var colorNameToUse = userDefinedColorName ?? defaultColorName
```

## Character & String

```swift
let s = "abc"
var chars = Array(s)      // convert to char array
// Iterate char in a string
for char in s {}
for i in 0..<s.count {
	var char = s[s.index(s.startIndex, offsetBy: i)]  // char is Character type
}
// Substring
let range = s.startIndex..<s.index(s.startIndex, offsetBy: i)
let subStr = s[range] 

// char at index 
let charAt = s[s.index(s.startIndex, offsetBy: i)] // this will return Character

// Stirng Parsing
var arr = string.components(separatedBy: ",")
```
