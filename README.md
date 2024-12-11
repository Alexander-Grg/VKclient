# VKclient
The first iOS project was developed in 2021, minor improvements are periodically added.
UIkit clean code MVP architecture + COMBINE for the network layer + REALM for data persistence + natively created custom Dependency injector to handle DI. Everything is created entirely programmatically.

You can try it by signing up on the website https://vk.com/ 
Data source open VK API https://dev.vk.com

Current functional:
1) Authentification to the VK services via OAuth 2.0;
2) Review friends added to the account;
3) Review the photo album of each friend;
4) Review groups where the user is participating;
5) Find new groups;
6) Join/leave groups;
7) Use the search bar to search over different communities;
8) News feed that reflects added communities and friend's posts, showing likes, comments, reposts, and the number of total views;
9) To the news feed added an infinite scrolling function that constantly updates data from the VK servers;
10) Groups, Friends, and Photos are saved to the Realm database;
11) The Keychain safely manages the user's token.
