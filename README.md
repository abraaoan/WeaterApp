# WeaterApp MVVM

The project is in MVVM architecture and I try to separe things by folders. So there is a folder\layer *Data Service* that is responsible for all data in the project. Another folder that I use in a specific situations was the *factory*, responsible for delivery some objects. And the others are kind obvious, is the *View, ViewModel and Model*.

When I was doing some views I created a few mocks objects and data to facilitate the construction. 

I made two dataService. One responsible for fetch the weather and another responsible for downloading the weather icons. I also did a cache for the icons based on the icon Id.

About navigation I did one view as *present view(.sheet)* and city detail view I did using navigation controller.

I think that’s it. Please let me know if there are some improvements ou issues to make.
Thank you
