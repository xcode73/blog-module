# Blog module

This module is reponsible for providing a simple blog platform.

## Installation

You can use the Swift Package Manager to integrate this module.

```swift
// add to your dependencies 
.package(url: "https://github.com/FeatherCMS/system-module", from: "1.0.0-beta"),

// add to your target
.product(name: "SystemModule", package: "system-module"),
```

## Blog module hooks

### blog-post-install

You can add your own blog posts by implementing this hook. 

```swift
app.hooks.register("blog-post-install", use: blogPostInstallHook)

func blogPostVariablesInstallHook(args: HookArguments) -> [[String: Any]] {
    [
        [
            "title": "[custom title]",
            "imageKey": "[custom image key]",
            "excerpt": "[custom excerpt]",
            "content": "[custom content]",
        ],
    ]
}
```

## Blog Module API

### Authentication

```sh
# login
curl -X POST \
-H "Content-Type: application/json" \
-d '{"email": "root@feathercms.com", "password": "FeatherCMS"}' \
"http://localhost:8080/api/user/login/"
```
The response is a `UserTokenObject`, you can use the token value from the response as a `Bearer` token or a `vapor-session` cookie to perform authenticated API calls.

cURL header value examples: 
- using the session cookie: `-H "Cookie: vapor-session=[session]"`
- using the API token value: `-H "Authorization: Bearer [token]"`


### Blog post API

```sh
# list
curl -X GET \
"http://localhost:8080/api/blog/posts/"

```
