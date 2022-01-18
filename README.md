# DashboardCalculator


![alt text](https://github.com/elunico/DashboardCalculator/blob/main/icon.png?raw=true)


This is a re-creation of the Calculator widget in Dashboard on Mac OS X. This was inspired by [a tweet](https://twitter.com/BasicAppleGuy/status/1482524358958469124). I had really been looking to poke around in SwiftUI a little beyond the basic buttons and labels and I thought this would be a fun way to try. Also I really miss Dashboard <code>o7</code>


![alt text](https://github.com/elunico/DashboardCalculator/blob/main/sample.png?raw=true)



Anyway this whole app was written in 2 days (as its more of a pet project) so I cannot guarantee it is a totally bug free calculator :grimacing:.

It was written in SwiftUI in Xcode 12 and was a very fun project, even though I still find declarative UI programming a little frustrating.

## Requirements
- macOS 11.0 (Big Sur) or greater
- Mouse/pointer support (keyboard support might be coming later)

## Known Issues
- Buttons do not animate when pressed like they do on the original widget
- If you follow the steps
  - Input a number
  - Press an operation
  - Input the second number
  - Press an operation

    At this point, you will get an answer but, if you press another operation you would expect the calculator to do nothing but switch the operation it is *about to perform* but instead it will first perform the previous operation and then switch the operations. In other words, <code>5 + 6 + \*</code>  will result in 17 instead of the expected 11. This happens because going from <code>+</code> to <code>\*</code> results in performing the <code>+</code> operation when it shouldn't.
- Sometimes all the operator buttons break and I am not sure why. Usually happens after you hit clear
