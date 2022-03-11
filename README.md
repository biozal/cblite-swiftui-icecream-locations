# Sharing SQL queries between Server and Mobile databases 

## Overview 
As we all know, code is expensive to maintain, and the more complex the code, the more cost associated with maintaining it.  Since the beginning of time, software developers have worked very hard to achieve the goal of code reusability. 

Couchbase Mobile 3.0 introduces support for SQL++ queries. As a developer, the first thought that came to mind was sharing queries used in REST API projects and mobile applications. But, is this a good idea? Let’s explore this question using sample data and a proof of concept mobile application.

For full information please read the blog post here.

## Prerequisites

* This sample assumes familiarity with building SwiftUI apps with Xcode and with the basics of Couchbase Lite.

* This sample assumes familiarity with running Couchbase Server either on your computer or inside of docker.

* If you are unfamiliar with the basics of Couchbase Lite, it is recommended that you walk through the <a target="_blank" rel="noopener noreferrer" href="https://developer.couchbase.com/tutorial-quickstart-ios-uikit-basic">Quickstart in Couchbase Lite with iOS, Swift, and UIKit</a> on using Couchbase Lite as a standalone database

* iOS (Xcode 12/13) - Download latest version from the <a target="_blank" rel="noopener noreferrer" href="https://itunes.apple.com/us/app/xcode/id497799835?mt=12">Mac App Store</a> or via <a target="_blank" rel="noopener noreferrer" href="https://github.com/RobotsAndPencils/XcodesApp">Xcodes</a>
> **Note**: If you are using an older version of Xcode, which you need to retain for other development needs, make a copy of your existing version of Xcode and install the latest Xcode version.  That way you can have multiple versions of Xcode on your Mac.  More information can be found in [Apple's Developer Documentation](https://developer.apple.com/library/archive/technotes/tn2339/_index.html#//apple_ref/doc/uid/DTS40014588-CH1-I_HAVE_MULTIPLE_VERSIONS_OF_XCODE_INSTALLED_ON_MY_MACHINE__WHAT_VERSION_OF_XCODE_DO_THE_COMMAND_LINE_TOOLS_CURRENTLY_USE_).

## Installation


* To clone the project from GitHub, type the following command in your terminal

```bash
git clone https://github.com/biozal/cblite-swiftui-icecream-locations.git
```
### Try it Out

* Open the `IceCreamLocator.xcodeproj`. The project would be located at ` /path/to/cblite-swiftui-icecream-locations/src`

```bash
open IceCreamLocator.xcodeproj
```

* Build and run the project using the _simulator_ in Xcode. While you can run the app on a real device, we recommend the Simulator so you can see the debug logs in the output console.

## Data Model

The sample data used for the following tests comes from the [OpenStreetMap](https://www.openstreetmap.org/#map=5/38.007/-95.844) project and is licensed under the [Open Data Commons Open Database License](https://wiki.osmfoundation.org/wiki/Terms_of_Use) (ODbL) by the OpenStreetMap Foundation.  

The data set contains all the shops that sell Ice Cream in the United States.  An example JSON document is listed below:

```json
{
  "type": "Feature",
  "id": "node/472242349",
  "properties": {
    "addrCity": "Austin",
    "addrHousenumber": "4477",
    "addrPostcode": "78745",
    "addrState": "TX",
    "addrStreet": "South Lamar Boulevard",
    "addrUnit": "#790",
    "amenity": "ice_cream",
    "cuisine": "ice_cream",
    "name": "Amy's Ice Creams",
    "phone": "+1-512-891-0573",
    "id": "node/472242349"
  },
  "geometry": {
    "type": "Point",
    "coordinates": [
      -97.7998856,
      30.230688
    ]
  }
}
```

As you can see, this is a versatile data set for testing because it has properties embedded into the documents.

## Importing Data into a bucket in Couchbase Server

I assume you already have Couchbase Server running.  If you do not, directions on how to get it setup can be found on the [Couchbase Developer Portal](https://developer.couchbase.com/tutorial-couchbase-installation-options).

From the Coucbhase Web Console create a bucket called `icecream`.  Take the default stats as the documents you will import don't take a lot of space.  If you don't know how to create a bucket, you can follow the documentation [here](https://docs.couchbase.com/server/current/manage/manage-buckets/create-bucket.html).  

The Couchbase documentation on [importing documents](https://docs.couchbase.com/server/current/manage/import-documents/import-documents.html) can be used to walk you through importing the sample data found in the data folder named us-south-ice-cream-cbserver.json.  

Once you have imported the data, you can use the SQL statements in the [create-indexes-couchbase-server.sql](data/create-indexes-couchbase-server.sql) file found in the data folder to create the indexes I used in the blog article.  All the queries used in the blog article can be found in the [article-cbserver-sql-statements.sql](data/article-cbserver-sql-statements.sql) file.

## SwiftUI Application 

The application is based on SwiftUI which targets iOS, iPadOS, and MacOS.  The application uses Apple's Combine framework for binding information between the View and the ViewModel.  The application structure is:

- **Shared folder**:  All the shared code between iOS and MacOS so that the app can run on either platform
  - **Data folder**:  This is the location of the Repository protocol and IceCreamLocationRepository class that is used to communicate with the Couchbase Lite database.  All functions that open and retrieve information are located here.
  - **prebuild folder**:  This is where the prebuild database icecream.cblite2 is located and used in the demo.   This database has all the JSON documents pre-imported into it.
  - **ViewModels folder**: this is the location of where the IceCreamListViewModel is located.  This communicates with the IceCreamLocationRepository and handles state of information that will be displayed in the application.
  - **Views folder**:  The views folder is the location of the IceCreamLocationListView which contains the SwiftUI code that renders the UI on the screen in the mobile application. 

## More Information 

For more information about [Couchbase Mobile](https://www.couchbase.com/products/mobile) head over to the [Couchbase Developer Portal](https://developer.couchbase.com/mobile/).
