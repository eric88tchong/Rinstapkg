## Rinstapkg 0.1.0

This is the first versioned release of the **Rinstapkg**. It includes a basic set of 
functions to pull feeds and interact with media on Instagram.

### Features

  * OAuth 2.0 and Basic authentication methods (`ig_auth()`)
  * Retrieve Feed Data: 
    * `ig_get_user_id()`
    * `ig_get_user_profile()`
    * `ig_get_user_feed()`
    * `ig_get_user_tags()`
    * `ig_get_hashtag_feed()`
    * `ig_get_location_feed()`
    * `ig_get_popular_feed()`
    * `ig_get_liked_feed()`
    * `ig_get_saved_feed()`
    * `ig_get_followers()`
    * `ig_get_following()`
  * Search functions:
    * `ig_search_users()`
    * `ig_search_tags()`
  * Media interaction functions: 
    * `ig_like()`
    * `ig_unlike()`
    * `ig_save()`
    * `ig_unsave()`    
    * `ig_comment()`
    * `ig_comment_delete()`
    * `ig_comment_delete_bulk()`
    * `ig_get_media_info()`
    * `ig_get_media_comments()`
    * `ig_get_media_likers()`
    * `ig_edit_media_caption()`
    * `ig_delete_media()`
  * Profile functions: 
    * `ig_my_timeline()`
    * `ig_my_inbox()`
    * `ig_my_recent_activity()`
    * `ig_following_recent_activity()`
    * `ig_autocomplete_userlist()`
    