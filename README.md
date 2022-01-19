# DashboardCalculator

## Release 1.0!
Check releases to download an app (not signed)



![alt text](https://github.com/elunico/DashboardCalculator/blob/main/icon.png?raw=true)


This is a re-creation of the Calculator widget in Dashboard on Mac OS X. This was inspired by [a tweet](https://twitter.com/BasicAppleGuy/status/1482524358958469124). I had really been looking to poke around in SwiftUI a little beyond the basic buttons and labels and I thought this would be a fun way to try. Also I really miss Dashboard <code>o7</code>


![alt text](https://github.com/elunico/DashboardCalculator/blob/main/sample.png?raw=true)



Anyway this whole app was written in 2 days (as its more of a pet project) so I cannot guarantee it is a totally bug free calculator :grimacing:.

It was written in SwiftUI in Xcode 12 and was a very fun project, even though I still find declarative UI programming a little frustrating.

## Requirements
- macOS 11.0 (Big Sur) or greater
- Mouse/pointer support (keyboard support might be coming later)

## Known Issues
- Sometimes all the operator buttons break and I am not sure why. Usually happens after you hit clear
- Order of operations is... not quite right. It is up to you to do order of operations. If you type <code>5 + 6 \* 5</code> you will get 55 not the expected 30 (please don't sue me, I'm trying)
- Switching operators is not supported. In other words, if you hit <code>5</code> then <code>+</code> then <code>÷</code>, it will perform the addition of <code>5 + 5</code> and be ready to to <code>10 ÷ </code> rather than hold 5 and switch the operation to <code>5 ÷ </code>

