* The 'Pods-Runner' target has transitive dependencies that include statically linked binaries
```
[!] The 'Pods-Runner' target has transitive dependencies that include statically linked binaries: (/Users/xx/mywork/my/flutter_tencentad/example/ios/Pods/GDTMobSDK/lib/libGDTMobSDK.a)
```
打开iOS目录下的Podfile，删除掉use_frameworks!,重新build