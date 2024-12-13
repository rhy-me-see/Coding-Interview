# Table of Contents

  - [Lists](#lists)
  - [Set](#Set)

## Queue

We could use list as queue
```swift
var q = [(Int, Int)]().    //intialize an tuple 
q.isEmpty                  //error if not initialized
q.count
q = append((i, j)).        // append the tuple to the end 
cur = q.removeFirst().     // error if the list is empty
```


## Set

```swift

```


Swift Cheatsheet

inout parameters
```swift
func swap(_ nums : inout [Int], _ first: Int, _ second: Int) {
	let temp = nums[first]
	nums[first] = nums[second]
	nums[second] = temp
}
swap(&nums, i, num[i])
