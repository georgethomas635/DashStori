# DashStrori iOS
==================

Qburst Project

## Main Branches

`master` - production branch
`development` - active development branch

## master
```
master branch should always contains following values:
`Utilities/Constants.swift` -->
    var BASE_URL:String = "https://www.dashstori.com/dashstori/api/v1/"
    var BASE: String = "https://www.dashstori.com/"
    
Make sure to check app certificate to production before deployment
Make sure to increment app version before deployment

```

## development
```
development branch should always contains following values:
`Utilities/Constants.swift` -->
    var BASE_URL:String = "http://10.7.60.12:8080/api/v1/"
    var BASE: String = "http://34.223.236.107/"

**Note: IP can be varied according to developer's ip address **
```
