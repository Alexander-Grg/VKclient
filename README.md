# VKclient
The iOS project was initially developed in 2021 as a client for the VK.com social network. Improvements are periodically added.
UIkit clean code MVP architecture + reactive COMBINE for the network layer + REALM for data persistence + natively created custom Dependency injector to handle DI. Everything is made entirely programmatically.

You can try it by signing up on the website https://vk.com/ 
Data source open VK API https://dev.vk.com

Current functional:
1) Authentification to the VK services via OAuth 2.0;
2) Review friends added to the account;
3) Review the user wall for every friend, check their comments, and set likes;
4) Review the photo album of each friend;
5) Review groups where the user is participating;
6) Find new groups;
7) Join/leave groups;
8) Use the search bar to search over different communities;
9) News feed that reflects added communities and friend's posts, showing likes, comments, reposts, and the number of total views;
10) To the news feed added an infinite scrolling function that constantly updates data from the VK servers;
11) Watch videos in the newsfeed;
12) Groups, Friends, and Photos are saved to the Realm database;
13) The Keychain safely manages the user's token.

## License  
This project is proprietary. See [LICENSE.txt](LICENSE.txt) for details.  
