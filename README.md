
# Rinstapkg<img src="man/figures/Rinstapkg.png" width="120px" align="right" />

[![Build
Status](https://travis-ci.org/eric88tchong/Rinstapkg.svg?branch=master)](https://travis-ci.org/eric88tchong/Rinstapkg)
[![AppVeyor Build
Status](https://ci.appveyor.com/api/projects/status/github/eric88tchong/Rinstapkg?branch=master&svg=true)](https://ci.appveyor.com/project/eric88tchong/Rinstapkg)
[![CRAN\_Status\_Badge](http://www.r-pkg.org/badges/version/Rinstapkg)](http://cran.r-project.org/package=Rinstapkg)
[![Coverage
Status](https://codecov.io/gh/eric88tchong/Rinstapkg/branch/master/graph/badge.svg)](https://codecov.io/gh/eric88tchong/Rinstapkg?branch=master)

**Rinstapkg** is an R package that connects to the Instagram API using
tidy principles. Rinstapkg is short for The <b>R</b>eal <b>Insta</b>gram
<b>P</b>ac<b>k</b>a<b>g</b>e. With this package you can like, comment,
follow, and slide into some DMs just like the real Instagram. You can
also get tons of feed data: user feeds, timeline feeds, location feeds
and more\! All this comes without the need to register for an
application. Here are some of the package highlights:

  - OAuth 2.0 (Single Sign On) and Basic (Username-Password)
    Authentication methods (`ig_auth()`)
  - Retrieve Feeds of different types:
      - `ig_get_user_feed()`, `ig_get_timeline_feed()`,
        `ig_get_hashtag_feed()`, and more\!
  - Retrieve Users, Tags, Comments, and Perform Searches:
      - `ig_get_followers()`, `ig_get_user_tags()`,
        `ig_get_media_comments()`, `ig_search_users()`, etc.
  - Utility calls (`ig_change_password()`, `ig_sync_features()`)

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
# cannot yet be installed from CRAN
#install.packages("Rinstapkg")

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
suppressWarnings(suppressMessages(library(dplyr)))
suppressWarnings(suppressMessages(library(purrr)))
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
#> # A tibble: 80 x 45
#>    taken_at       pk id    device_timestamp media_type code 
#>       <int>    <dbl> <chr>            <dbl>      <int> <chr>
#>  1   1.55e9  1.98e18 1982… 1550540314361522          1 BuC6…
#>  2  NA      NA       2797…               NA         NA <NA> 
#>  3  NA      NA       <NA>                NA         NA <NA> 
#>  4   1.55e9  1.98e18 1981…  155045410572131          1 BuAV…
#>  5   1.55e9  1.98e18 1981… 1550455167737230          1 BuAW…
#>  6   1.55e9  1.98e18 1976… 1549857235614429          1 Btui…
#>  7   1.55e9  1.97e18 1973… 1549464013913359          1 Bti0…
#>  8   1.55e9  1.97e18 1972… 1549402375783967          1 Btg_…
#>  9   1.55e9  1.98e18 1982… 1550540314361522          1 BuC6…
#> 10  NA      NA       <NA>                NA         NA <NA> 
#> # … with 70 more rows, and 39 more variables: client_cache_key <chr>,
#> #   filter_type <int>, comment_likes_enabled <lgl>,
#> #   comment_threading_enabled <lgl>, has_more_comments <lgl>,
#> #   max_num_visible_preview_comments <int>,
#> #   can_view_more_preview_comments <lgl>, comment_count <int>,
#> #   inline_composer_display_condition <chr>, image_versions2 <list>,
#> #   original_width <int>, original_height <int>, location <list>,
#> #   lat <dbl>, lng <dbl>, user <list>, can_viewer_reshare <lgl>,
#> #   caption <list>, caption_is_edited <lgl>, like_count <int>,
#> #   has_liked <lgl>, likers <list>, photo_of_you <lgl>, usertags <list>,
#> #   can_viewer_save <lgl>, organic_tracking_token <chr>, preview <chr>,
#> #   type <int>, suggestions <list>, landing_site_type <chr>, title <chr>,
#> #   view_all_text <chr>, landing_site_title <chr>, netego_type <chr>,
#> #   upsell_fb_pos <chr>, auto_dvance <chr>, tracking_token <chr>,
#> #   end_of_feed_demarcator <list>, has_viewer_saved <lgl>
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
#> # A tibble: 200 x 10
#>        pk username full_name is_private profile_pic_url profile_pic_id
#>     <dbl> <chr>    <chr>     <lgl>      <chr>           <chr>         
#>  1 1.99e9 joshuaf… Joshuafr… FALSE      https://sconte… 1623206444616…
#>  2 8.97e9 klevers… ҝℓενεяรØ… FALSE      https://sconte… 1950468542487…
#>  3 8.45e9 ivabrat… "\U0001f… TRUE       https://sconte… 1976367343223…
#>  4 7.87e9 barosh.… بـږۆﺷ̲ﮬ̌…   FALSE      https://sconte… 1983692001187…
#>  5 4.12e9 its.azz… ♠❎ROYALE… FALSE      https://sconte… 1966544156159…
#>  6 9.79e9 __aman_… Pahadi_b… FALSE      https://sconte… 1975401294970…
#>  7 8.57e9 cha.hr_… ◥(ฅº👅ºฅ)… TRUE       https://sconte… 1965669765175…
#>  8 6.53e9 mrifkiq… M.Rifki … FALSE      https://sconte… 1944716363672…
#>  9 4.52e9 kn.i9    Kholod A… FALSE      https://sconte… 1979897482515…
#> 10 4.21e9 amaan.k7 ÀmåAñ Kh… FALSE      https://sconte… 1978220904561…
#> # … with 190 more rows, and 4 more variables: is_verified <lgl>,
#> #   has_anonymous_profile_picture <lgl>, reel_auto_archive <chr>,
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
#> # A tibble: 106 x 11
#>        pk username full_name is_private profile_pic_url is_verified
#>     <dbl> <chr>    <chr>     <lgl>      <chr>           <lgl>      
#>  1 1.87e8 davidbe… David Be… FALSE      https://sconte… TRUE       
#>  2 7.69e6 jasperr  J a s p … FALSE      https://sconte… TRUE       
#>  3 7.72e6 arianag… Ariana G… FALSE      https://sconte… TRUE       
#>  4 2.88e7 sean_wo… Sean Wot… FALSE      https://sconte… TRUE       
#>  5 7.49e9 mightyp… Mighty P… FALSE      https://sconte… FALSE      
#>  6 1.56e9 brookly… bb🌷      FALSE      https://sconte… TRUE       
#>  7 7.81e6 jerrylo… jerrylor… FALSE      https://sconte… TRUE       
#>  8 1.11e9 klondik… BIG GANG… FALSE      https://sconte… FALSE      
#>  9 1.44e8 alesso   Alesso    FALSE      https://sconte… TRUE       
#> 10 2.32e8 therock  therock   FALSE      https://sconte… TRUE       
#> # … with 96 more rows, and 5 more variables:
#> #   has_anonymous_profile_picture <lgl>, reel_auto_archive <chr>,
#> #   is_favorite <lgl>, profile_pic_id <chr>, latest_reel_media <int>
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
Conduct](CONDUCT.md). By participating in this project you agree to
abide by its terms.
