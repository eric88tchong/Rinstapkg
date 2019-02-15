## Rinstapkg 0.0.0.9000

This is the first versioned release of the Rinstapkg. It includes a basic set of 
functions to With this package you can like, comment, follow, and slide into some DMs just like the 
real Instagram. You can also get tons of feed data: user feeds, timeline feeds, location 
feeds and more!

### Features

  * OAuth 2.0 and Basic authentication methods (`ig_auth()`)
  * Retrieve Feed Data: 
    * `ig_get_user_id()`
    * `ig_get_user_feed()`
    * `ig_get_hashtag_feed()`
    * `ig_get_location_feed()`
    * `ig_get_popular_feed()`
    * `ig_get_liked_feed()`
    * `ig_get_saved_feed()`
    * `ig_get_followers()`
    * `ig_get_following()`
    * `ig_get_user_tags()`
    * `ig_get_geomedia()`
    * `ig_get_media_comments()`
  * Search functions:
    * `ig_search_users()`
    * `ig_search_username()`
    * `ig_search_tags()`
  * Media interaction functions: 
    * `ig_like()`
    * `ig_unlike()`
    * `ig_comment()`
    * `ig_comment_delete()`
  * Profile functions: 
    * `ig_my_timeline()`
    * `ig_my_inbox()`
    * `ig_my_recent_activity()`
    * `ig_following_recent_activity()`
    * `ig_autocomplete_userlist()`
    