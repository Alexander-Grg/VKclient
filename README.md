# VKclient
**_The very first pet project was developed in 2021._**
UIkit clean code MVP architecture + COMBINE for the network layer + REALM for data persistence + natively created custom Dependency injector to handle DI. Everything is created entirely programmatically.

You can try it by signing up on the website https://vk.com/ 
Data source open VK API https://dev.vk.com

Current functional:
1) Authentification to the VK services via OAuth 2.0;
2) Review friends added to the account;
3) Review the photo album of each friend;
4) Review groups where the user is participating;
5) Join / leave groups
6) Use the search bar to search over different communities;
7) News feed that reflects added communities and friend's posts, showing likes, comments, reposts, and the number of total views;
8) To the news feed added an infinite scrolling function that constantly updates data from the VK servers;
9) Everything is added to the Realm database;
10) The user's token is safely added to the Keychain.
