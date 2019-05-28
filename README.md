
# Rinstapkg<img src="man/figures/Rinstapkg.png" width="120px" align="right" />

[![Build
Status](https://travis-ci.org/eric88tchong/Rinstapkg.svg?branch=master)](https://travis-ci.org/eric88tchong/Rinstapkg)
[![AppVeyor Build
Status](https://ci.appveyor.com/api/projects/status/github/eric88tchong/Rinstapkg?branch=master&svg=true)](https://ci.appveyor.com/project/eric88tchong/Rinstapkg)
[![CRAN\_Status\_Badge](http://www.r-pkg.org/badges/version/Rinstapkg)](https://CRAN.R-project.org/package=Rinstapkg)
[![Coverage
Status](https://codecov.io/gh/eric88tchong/Rinstapkg/branch/master/graph/badge.svg)](https://codecov.io/gh/eric88tchong/Rinstapkg?branch=master)

**Rinstapkg** is an R package that connects to the Instagram API using
tidy principles. Rinstapkg is short for the <b>R</b>eal <b>Insta</b>gram
<b>P</b>ac<b>k</b>a<b>g</b>e. With this package you can like, comment,
follow, and slide into some DMs just like the real Instagram. You can
also get tons of feed data: user feeds, timeline feeds, location feeds
and more\! All this comes without the need to register for an
application. Here are some of the package highlights:

  - OAuth 2.0 (Single Sign On) and Basic (Username-Password)
    Authentication methods (`ig_auth()`)
  - Retrieve Feeds of different types:
      - `ig_my_timeline()`, `ig_get_user_feed()`,
        `ig_get_hashtag_feed()`, and more\!
  - Retrieve Users, Tags, Comments, and Perform Searches:
      - `ig_get_followers()`, `ig_get_user_tags()`,
        `ig_get_media_comments()`, `ig_search_users()`, etc.

**NOTE:** With great power comes great responsibility. Use of this
package means that you will not use it to spam, harass, or perform other
nefarious acts.

## Table of Contents

  - [Installation](#installation)
  - [Usage](#usage)
      - [Authenticate](#authenticate)
      - [Timeline Feed](#timeline-feed)
      - [Get Followers](#get-followers)
      - [Search Users](#search-users)
  - [Future](#future)
  - [Credits](#credits)
  - [More Information](#more-information)

## Installation

``` r
# install from CRAN
install.packages("Rinstapkg")

# get the latest version available on GitHub using the devtools package
# install.packages("devtools")
devtools::install_github("eric88tchong/Rinstapkg")
```

If you encounter a bug or issue, please file a minimal reproducible
example on [GitHub](https://github.com/eric88tchong/Rinstapkg/issues).

## Usage

### Authenticate

First, load the **Rinstapkg** package and log in. There are two ways to
authenticate:

1.  OAuth 2.0
2.  Basic Username-Password

It is recommended to use OAuth 2.0 if you apply for and are approved for
an Instagram App. This way multiple users can use your app without
having to explicity share their credentials with you. If you do not have
an approved app, you can still use this package by providing your
username and password.

``` r
library(Rinstapkg)

# Using OAuth 2.0 authentication
ig_auth()

# Using Basic Username-Password authentication
ig_auth(username = "YOUR_USERNAME_OR_EMAIL_HERE", 
        password = "YOUR_PASSWORD_HERE")
```

After logging in with `ig_auth()`, you can check your connectivity by
looking at the information returned about your timeline
(`ig_my_timeline()`), inbox (`ig_my_inbox()`), or recent activity
(`ig_my_recent_activity()`). It should be information about you\!

### Timeline Feed

A simple function to start with is verifying that you can retrieve your
timeline as it would appear in the Instagramm app or online. This
function returns data that would appear in the authenticated user’s
timeline feed. By default, the data is returned as a tidy `tbl_df` where
each row represents one post from the feed. If you prefer to work with a
list format, then just specify `return_df=FALSE` as an argument.

``` r
timeline_results <- ig_my_timeline()
timeline_results
#> # A tibble: 16 x 37
#>    taken_at      pk id    device_timestamp media_type code 
#>       <int>   <dbl> <chr>            <dbl>      <int> <chr>
#>  1   1.56e9 2.03e18 2034…  155676208810893          1 Bw8V…
#>  2   1.56e9 2.02e18 2024…  155552010984491          1 BwXT…
#>  3   1.55e9 2.01e18 2012… 1554147789723231          1 Bvua…
#>  4   1.55e9 1.99e18 1994… 1551925346931404          1 BusL…
#>  5   1.55e9 1.99e18 1991… 1551641044183919          1 Bujt…
#>  6   1.55e9 1.99e18 1985… 1550918831604424          1 BuOL…
#>  7   1.55e9 1.98e18 1982… 1550540314361522          1 BuC6…
#>  8   1.55e9 1.98e18 1981…  155045410572131          1 BuAV…
#>  9   1.55e9 1.98e18 1981… 1550455167737230          1 BuAW…
#> 10   1.55e9 1.98e18 1976… 1549857235614429          1 Btui…
#> 11   1.55e9 1.97e18 1973… 1549464013913359          1 Bti0…
#> 12   1.55e9 1.97e18 1972… 1549402375783967          1 Btg_…
#> 13   1.55e9 1.97e18 1968… 1548890866357063          1 BtRv…
#> 14   1.55e9 1.97e18 1969… 1548970299424940          1 BtUG…
#> 15   1.55e9 1.97e18 1969… 1548961006833604          1 BtT0…
#> 16   1.55e9 1.97e18 1969… 1548955131255990          1 BtTp…
#> # … with 31 more variables: client_cache_key <chr>, filter_type <int>,
#> #   image_versions2 <list>, original_width <int>, original_height <int>,
#> #   location <list>, lat <dbl>, lng <dbl>, user <list>,
#> #   can_viewer_reshare <lgl>, caption_is_edited <lgl>,
#> #   direct_reply_to_author_enabled <lgl>, comment_likes_enabled <lgl>,
#> #   comment_threading_enabled <lgl>, has_more_comments <lgl>,
#> #   max_num_visible_preview_comments <int>,
#> #   can_view_more_preview_comments <lgl>, comment_count <int>,
#> #   inline_composer_display_condition <chr>, like_count <int>,
#> #   has_liked <lgl>, likers <list>, photo_of_you <lgl>, caption <list>,
#> #   can_viewer_save <lgl>, organic_tracking_token <chr>, preview <chr>,
#> #   next_max_id <dbl>, preview_comments <list>, usertags <list>,
#> #   has_viewer_saved <lgl>
```

### Get Followers

With the `ig_get_followers()` function you can retrieve a `tbl_df` of
all the users that follow a particular user. Just provide the `user_id`
of the account whose followers you would like to get. **NOTE**: The
Instagram APIs use Ids to retrieve information so instead of giving the
account’s username (typically starting with an @symbol), you need to
first grab the `user_id` of that account using the username, then supply
it to the `ig_get_followers()` function.

``` r
# Get Justin's Biebers beliebers!
# Side Note: A belieber is a HUGE Justin Bieber fan.
bieber_user_id <- ig_get_user_id("justinbieber")
follower_results <- ig_get_followers(bieber_user_id)
follower_results
#> # A tibble: 2,196 x 9
#>         pk username full_name is_private profile_pic_url is_verified
#>      <dbl> <chr>    <chr>     <lgl>      <chr>           <lgl>      
#>  1 1.42e10 joaooos… j@        TRUE       https://instag… FALSE      
#>  2 1.41e10 shevele… Шевелев … FALSE      https://sconte… FALSE      
#>  3 7.16e 9 microbi… Ashish D… FALSE      https://sconte… FALSE      
#>  4 6.95e 9 __its_p… 👑 ਪ੍ਰੀਤ … FALSE      https://sconte… FALSE      
#>  5 5.88e 9 malicia… MALÍCIA … FALSE      https://sconte… FALSE      
#>  6 2.00e 9 atul_sa… ATUL SAG… FALSE      https://sconte… FALSE      
#>  7 1.56e 9 myrella… MYRELLA   FALSE      https://sconte… FALSE      
#>  8 6.36e 8 mandari… HASSAN M… TRUE       https://sconte… FALSE      
#>  9 4.03e 7 marciod… ΜΔŘĆƗØ Đ… FALSE      https://sconte… FALSE      
#> 10 1.42e10 princer… Prince R… FALSE      https://sconte… FALSE      
#> # … with 2,186 more rows, and 3 more variables:
#> #   has_anonymous_profile_picture <lgl>, profile_pic_id <chr>,
#> #   latest_reel_media <int>
```

In the example above you’ll notice that we didn’t retrieve all 100M+
followers that Justin Bieber has. By default the function only returns
the top 10 pages of followers, but you can set the `max_pages` argument
equal to `Inf` to return all of them. Caution: This might take awhile\!

``` r
# return all 100M+ followers of Justin Bieber
follower_results <- ig_get_followers(bieber_user_id, max_pages = Inf)
```

### Get Following

With the `ig_get_following()` function you can retrieve a `tbl_df` of
all the users that a particular user is following. For example, Justin
Bieber follows \~100 users. Who are those lucky few?

``` r
following_results <- ig_get_following(bieber_user_id)
following_results
#> # A tibble: 181 x 10
#>         pk username full_name is_private profile_pic_url profile_pic_id
#>      <dbl> <chr>    <chr>     <lgl>      <chr>           <chr>         
#>  1 2.69e 8 zachcla… Zach Cla… FALSE      https://sconte… 2048480207787…
#>  2 2.16e 8 officia… Brandon … FALSE      https://sconte… 2027136821162…
#>  3 2.91e 7 nickcan… NICK CAN… FALSE      https://sconte… 1896844691930…
#>  4 4.28e 7 bertsho… Bert Wei… FALSE      https://sconte… <NA>          
#>  5 5.50e 8 benjami… Business… FALSE      https://sconte… 2028127917154…
#>  6 1.89e 8 nickjon… Nick Jon… FALSE      https://sconte… 2041658194653…
#>  7 8.01e 9 lalalal… LISA      FALSE      https://sconte… 2017225651148…
#>  8 1.86e 8 teddysp… Ed Sheer… FALSE      https://sconte… 2050041949683…
#>  9 1.11e10 hdwg1    ""        TRUE       https://sconte… <NA>          
#> 10 2.98e 7 kriskli… Kristin … FALSE      https://sconte… 1698661949418…
#> # … with 171 more rows, and 4 more variables: is_verified <lgl>,
#> #   has_anonymous_profile_picture <lgl>, latest_reel_media <int>,
#> #   is_favorite <lgl>
```

## Future

Future methods to support:

  - Profile Functions:
      - `ig_profile_picture_change()`
      - `ig_profile_picture_remove()`
      - `ig_profile_set_private()`
      - `ig_profile_set_public()`
      - `ig_profile_get()`
      - `ig_profile_edit()`
      - `ig_remove_self_tag()`
      - `ig_approve_friendship()`
      - `ig_ignore_friendship()`
      - `ig_ignore_friendship()`
  - Creation Functions:
      - `ig_upload_photo()`
      - `ig_upload_video()`
      - `ig_upload_album()`
  - More In-App Functions
      - `ig_direct_message()`
      - `ig_direct_share()`
      - `ig_follow()`
      - `ig_unfollow()`
      - `ig_block()`
      - `ig_unblock()`

## Credits

This application uses other open source software components. The
authentication components are mostly verbatim copies of the routines
established in the **googlesheets** package
(<https://github.com/jennybc/googlesheets>). Methods are inspired by the
**Instagram-API-python** library
(<https://github.com/LevPasha/Instagram-API-python>) and
**Instagram-API** library (<https://github.com/mgp25/Instagram-API>). We
acknowledge and are grateful to these developers for their contributions
to open source.

## More Information

Use of this package means that you will not use it to spam, harass, or
perform other nefarious acts. For more details on how to use the API
please see this package’s website at
<https://eric88tchong.github.io/Rinstapkg>.

[Top](#rinstapkg)

-----

Please note that this project is released with a [Contributor Code of
Conduct](https://github.com/eric88tchong/Rinstapkg/blob/master/CONDUCT.md).
By participating in this project you agree to abide by its terms.
