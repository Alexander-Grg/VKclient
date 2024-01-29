# VKclient
UIkit clean code MVP architecture + COMBINE for the network layer + REALM for data persistence + natively created custom Dependency injector to handle DI. Everything is created entirely programmatically.
**_Video demonstration of the app:_**
https://drive.google.com/file/d/16zBZS8E_mrlsjcHuxBYRbAiHgBDGZ5nB/view?usp=sharing

You can try it by signing up on the website https://vk.com/ 
Data source https://dev.vk.com

Current functional:
1) Authentification to the VK services via OAuth 2.0;
2) Review friends added to the account;
3) Review the photo album of each friend;
4) Review groups where the user participating;
5) Use the search bar to search over different communities;
6) News feed that reflects added communities and friend's posts, showing likes, comments, reposts, and the number of total views;
7) To the news feed added an infinite scrolling function that constantly updates data from the VK servers;
8) Everything is added to the Realm database;
9) The user's token is safely added to the Keychain.
