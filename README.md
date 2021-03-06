# Upgrading OpenWhisk Swift Actions

This repo contains an examples using swift 3.0.2 and swift 3.1.1. it shows the differences
on how to migrate swift actions that are pre-compile.

## Migrating from swift:3 to swift:3.1.1 using single swift file
- Source is forward compatible with 3.1.1
- Specify the new kind swift:3.1.1 for the action when updating
     
    `wsk action update myaction --kind swift:3.1.1`


## Migrating from swift:3 to swift:3.1.1. using pre-compile
- Update Package.swift to use version compatible with 3.1.1 (i.e Kitura-net 1.7.10)
- Compile using the docker image openwhisk/action-swift-v3.1.1
- Specify the new kind swift:3.1.1 for the action when updating

Here is the diff from swift302 to swift311 in this repo
```
$ diff swift302/ swift311/ -r
diff -r swift302/Makefile swift311/Makefile
7c7
< KIND = swift:3
---
> KIND = swift:3.1.1
diff -r swift302/actions/WeatherBot/Package.swift swift311/actions/WeatherBot/Package.swift
7,8c7,8
<         .Package(url: "https://github.com/IBM-Swift/Kitura-net.git", "1.0.1"),
<         .Package(url: "https://github.com/IBM-Swift/SwiftyJSON.git", "14.2.0")
---
>         .Package(url: "https://github.com/IBM-Swift/Kitura-net.git", "1.7.10"),
>         .Package(url: "https://github.com/IBM-Swift/SwiftyJSON.git", "15.0.1"),
```

## Using the sample project with Swift 3.1.1
Checkout the [swift311](./swift311/) directory it contains a sample action, Makefile, and compile.sh
Using the sample project:

- Change directory to project
```
cd swift311
```

- To clean project
```
make clean
```

- To compile, build zip, and deploy action
```
make update
```

- To run action
```
make test
```

To switch CLI from `bx wsk` to `wsk` edit the [swift311/Makefile](swift311/Makefile)
```
# You can set it to wsk
WSK_CLI = bx wsk
```

### Handling errors:
If you get an error message with `error: unsatisfiable` from the `swift build` you need to update the Package.swift to be compatible with swift 3.1.1. For example specify version `1.7.10` for Kitura-net like this:
```swift
import PackageDescription

let package = Package(
    name: "Action",
    dependencies: [
        .Package(url: "https://github.com/IBM-Swift/CCurl.git", "0.2.3"),
        .Package(url: "https://github.com/IBM-Swift/Kitura-net.git", "1.7.10"),
        .Package(url: "https://github.com/IBM-Swift/SwiftyJSON.git", "15.0.1"),
    ]
)
```
If you have your own specification for dependencies, including other swift packages from the ones mentioned above, you would need to look for the right set of versions for your dependencies.
One approach is to specify the `majorVersion` and letting swift package manager pick the correct combination of versions that it satisfy your dependency tree.
For example using a Package.swift file like the following:
```swift
import PackageDescription

let package = Package(
    name: "Action",
    dependencies: [
        .Package(url: "https://github.com/IBM-Swift/Kitura-net.git",   majorVersion: 1),
        .Package(url: "https://github.com/IBM-Swift/SwiftyJSON.git",   majorVersion: 15),
        .Package(url: "https://github.com/IBM-Swift/Kitura-redis.git", majorVersion: 1)
    ]
)
```