# Project 2 - *HotFlix*

**HotFlix** is a movies app using the [The Movie Database API](http://docs.themoviedb.apiary.io/#).

Time spent: **~17** hours spent in total

## User Stories

The following **required** functionality is complete:

- [X] User sees an app icon on the home screen and a styled launch screen.
- [X] User can view a list of movies currently playing in theaters from The Movie Database.
- [X] Poster images are loaded using the UIImageView category in the AFNetworking library.
- [X] User can tap a cell to see a detail view (backdrop image, poster image, title, release date, overview)
- [X] User sees a loading state while waiting for the movies API.
- [X] User can pull to refresh the movie list.
- [X] User sees an error message when there's a networking error.
- [X] User can tap a tab bar button to view a grid layout of Movie Posters using a CollectionView.

The following **optional** features are implemented:

- [X] User can tap a poster in the collection view to see a detail screen of that movie
- [X] User can search for a movie.
- [ ] All images fade in as they are loading.
- [ ] User can view the large movie poster by tapping on a cell.
- [ ] For the large poster, load the low resolution image first and then switch to the high resolution image when complete.
- [ ] Customize the selection effect of the cell.
- [ ] Customize the navigation bar.
- [X] Customize the UI.

The following **additional** features are implemented:

- [X] Users can view movie trailer by tapping the backdrop in the detail screen of the movie.
- [X] Users can see a movie's rating inside the detail view.

Please list two areas of the assignment you'd like to **discuss further with your peers** during the next class (examples include better ways to implement something, how to extend your app in certain ways, etc):

1. How to better structure the code such that code does not need to be repeated/copied and pasted across many view controllers
2. Better ways to implement scroll views

## Video Walkthrough

Here's a walkthrough of implemented user stories:

<img src='http://i.imgur.com/link/to/your/gif/file.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />

GIF created with [Recordit](https://recordit.co/).

## Notes

I had issues with the app crashing due to null posters or backdrops, so I started checking them, but I ran into issues with different types of null (e.g. [NSNull null] versus nil, etc.). I am still curious about these different kinds of null - I would not have known which kind to check for if I didn't use a breakpoint to figure it out.

I also had issues with the UIScrollView functionality; I couldn't actually scroll down to view long descriptions because the UI would bounce me back up if I attempted to do so.

## Credits

List an 3rd party libraries, icons, graphics, or other assets you used in your app.

- [AFNetworking](https://github.com/AFNetworking/AFNetworking) - networking task library
- [MBProgressHUD] (https://github.com/jdg/MBProgressHUD) - loading HUD

## License

    Copyright [2020] [Mercy Bickell]

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
