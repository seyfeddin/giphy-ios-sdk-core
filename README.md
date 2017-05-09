# Giphy Core SDK for Swift


The **Giphy Core SDK** is a wrapper around [Giphy API](https://github.com/Giphy/GiphyAPI).

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![CocoaPods](https://img.shields.io/cocoapods/v/Giphy.svg)]()
[![](https://img.shields.io/badge/OS%20X-10.9%2B-lightgrey.svg)]()
[![](https://img.shields.io/badge/iOS-7.0%2B-lightgrey.svg)]()

[Giphy](https://www.giphy.com) is the best way to search, share, and discover GIFs on the Internet. Similar to the way other search engines work, the majority of our content comes from indexing based on the best and most popular GIFs and search terms across the web. We organize all those GIFs so you can find the good content easier and share it out through your social channels. We also feature some of our favorite GIF artists and work with brands to create and promote their original GIF content.

[![](https://media.giphy.com/media/5xaOcLOqNmWHaLeB14I/giphy.gif)]()

# Getting Started

## Supported platforms

**iOS**, **macOS**, **tvOS** and **watchOS**,

## Supported languages

**Swift** and **Objective-C**.

## Supported End-points

* Search Gifs/Stickers
* Trending Gifs/Stickers
* Translate Gifs/Stickers
* Random Gifs/Stickers
* GIF by ID(s)
* Categories for Gifs
* Subcategories for Gifs
* GIFs by Category
* Query Suggestions


# Setup

## CocoaPods Setup

Add the GiphyCoreSDK entry to your Podfile

```
pod 'GiphyCoreSDK'
```

Run pods to grab the GiphyCoreSDK framework

```bash
pod install
```

## Initialize Giphy SDK

```swift
let client = GPHClient(apiKey: "YOUR_API_KEY")
```

## Search Gifs / Stickers

You can now search for contacts using firstname, lastname, company, etc. (even with typos):

```swift
/// Simple Gif Search
let _ = client.search("ryan gosling") { (response, error) in

    if let error = error as NSError? {
        // Do what you want to do with the error
    }

    if let response = response, let data = response.data, let pagination = response.pagination {
        print(response.meta)
        print(pagination)
        for result in data {
            print(result)
        }
    } else {
        print("No Result Found")
    }
}
```

# CONTRIBUTING

Managing git repositories can be hard, so we've laid out a few simple guidelines to help keep things organized.

### Guidelines

1. Create a **Pull Request**; instead of pushing directly to `master`.

2. Give your branch a **descriptive name** like `dh-network-fix` instead of something ambiguous like `my-branch`.

3. Write a **descriptive summary** in the comment section on Github.

4. **Don't merge your own Pull Request**; send it to your teammate for review.

5. If you think something could be improved: **write a comment on the Pull Request** and send it to the author.

6. Make sure your branch is based off `master`, and not some other outdated branch.

7. **Don't reuse branches.** Once they're merged to `master` you should consider deleting them.

8. Prefer **squash** when doing a **Pull Request**, as it simplifies the commit history.
