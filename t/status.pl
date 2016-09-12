use 5.018;
use Test::More;
use App::Socialdump::Status;
use JSON;

my $normal_status = q|
{
      "contributors" : null,
      "coordinates" : null,
      "truncated" : false,
      "retweeted" : false,
      "id" : 774603991841898496,
      "favorite_count" : 0,
      "in_reply_to_user_id" : null,
      "text" : "If #Trump should win the US election I am seriously going to reconsider my position on the literal truth of ancient Greek god myths.",
      "source" : "<a href=\"https://about.twitter.com/products/tweetdeck\" rel=\"nofollow\">TweetDeck</a>",
      "lang" : "en",
      "geo" : null,
      "in_reply_to_screen_name" : null,
      "entities" : {
         "urls" : [],
         "hashtags" : [
            {
               "indices" : [
                  3,
                  9
               ],
               "text" : "Trump"
            }
         ],
         "user_mentions" : [],
         "symbols" : []
      },
      "created_at" : "Sat Sep 10 13:42:37 +0000 2016",
      "in_reply_to_status_id" : null,
      "in_reply_to_status_id_str" : null,
      "in_reply_to_user_id_str" : null,
      "is_quote_status" : false,
      "retweet_count" : 0,
      "user" : {
         "has_extended_profile" : false,
         "entities" : {
            "description" : {
               "urls" : []
            },
            "url" : {
               "urls" : [
                  {
                     "indices" : [
                        0,
                        22
                     ],
                     "expanded_url" : "http://gellyfish.co.uk/",
                     "url" : "http://t.co/KurNls4VfI",
                     "display_url" : "gellyfish.co.uk"
                  }
               ]
            }
         },
         "created_at" : "Mon Mar 12 12:32:21 +0000 2007",
         "profile_sidebar_border_color" : "181A1E",
         "geo_enabled" : true,
         "id_str" : "1005541",
         "following" : true,
         "utc_offset" : 3600,
         "listed_count" : 51,
         "profile_image_url_https" : "https://pbs.twimg.com/profile_images/27500802/craxydog_normal.jpg",
         "default_profile_image" : false,
         "profile_sidebar_fill_color" : "252429",
         "screen_name" : "gellyfish",
         "lang" : "en",
         "favourites_count" : 249,
         "profile_background_image_url_https" : "https://abs.twimg.com/images/themes/theme9/bg.gif",
         "default_profile" : false,
         "url" : "http://t.co/KurNls4VfI",
         "description" : "I'm a computer programmer  and a musician.  If you are more interested in the music check @RabidGravy",
         "name" : "Jonathan Stowe",
         "is_translation_enabled" : false,
         "verified" : false,
         "time_zone" : "London",
         "profile_link_color" : "2FC2EF",
         "profile_image_url" : "http://pbs.twimg.com/profile_images/27500802/craxydog_normal.jpg",
         "friends_count" : 520,
         "statuses_count" : 8961,
         "location" : "Belvedere, Greater London",
         "is_translator" : false,
         "profile_background_color" : "1A1B1F",
         "profile_background_tile" : false,
         "id" : 1005541,
         "followers_count" : 469,
         "profile_use_background_image" : true,
         "follow_request_sent" : false,
         "profile_text_color" : "666666",
         "notifications" : false,
         "contributors_enabled" : false,
         "profile_background_image_url" : "http://abs.twimg.com/images/themes/theme9/bg.gif",
         "protected" : false
      },
      "place" : null,
      "favorited" : false,
      "id_str" : "774603991841898496"
   }
|;

my $o = App::Socialdump::Status->from_twitter(decode_json $normal_status);
ok $o->isa('App::Socialdump::Status');
ok $o->oc;

my $pure_retweet = q|
{
  "place" : null,
  "favorited" : false,
  "id_str" : "774602173833416704",
  "retweet_count" : 6479,
  "user" : {
     "id_str" : "1005541",
     "following" : true,
     "geo_enabled" : true,
     "listed_count" : 51,
     "utc_offset" : 3600,
     "profile_image_url_https" : "https://pbs.twimg.com/profile_images/27500802/craxydog_normal.jpg",
     "created_at" : "Mon Mar 12 12:32:21 +0000 2007",
     "entities" : {
        "description" : {
           "urls" : []
        },
        "url" : {
           "urls" : [
              {
                 "url" : "http://t.co/KurNls4VfI",
                 "display_url" : "gellyfish.co.uk",
                 "expanded_url" : "http://gellyfish.co.uk/",
                 "indices" : [
                    0,
                    22
                 ]
              }
           ]
        }
     },
     "has_extended_profile" : false,
     "profile_sidebar_border_color" : "181A1E",
     "favourites_count" : 249,
     "lang" : "en",
     "profile_background_image_url_https" : "https://abs.twimg.com/images/themes/theme9/bg.gif",
     "default_profile_image" : false,
     "profile_sidebar_fill_color" : "252429",
     "screen_name" : "gellyfish",
     "time_zone" : "London",
     "verified" : false,
     "profile_image_url" : "http://pbs.twimg.com/profile_images/27500802/craxydog_normal.jpg",
     "profile_link_color" : "2FC2EF",
     "friends_count" : 520,
     "is_translator" : false,
     "location" : "Belvedere, Greater London",
     "statuses_count" : 8961,
     "url" : "http://t.co/KurNls4VfI",
     "description" : "I'm a computer programmer  and a musician.  If you are more interested in the music check @RabidGravy",
     "default_profile" : false,
     "is_translation_enabled" : false,
     "name" : "Jonathan Stowe",
     "contributors_enabled" : false,
     "profile_background_image_url" : "http://abs.twimg.com/images/themes/theme9/bg.gif",
     "notifications" : false,
     "protected" : false,
     "profile_background_color" : "1A1B1F",
     "profile_use_background_image" : true,
     "profile_background_tile" : false,
     "id" : 1005541,
     "followers_count" : 469,
     "follow_request_sent" : false,
     "profile_text_color" : "666666"
  },
  "in_reply_to_status_id_str" : null,
  "in_reply_to_user_id_str" : null,
  "is_quote_status" : false,
  "in_reply_to_screen_name" : null,
  "created_at" : "Sat Sep 10 13:35:24 +0000 2016",
  "entities" : {
     "user_mentions" : [
        {
           "id_str" : "249395206",
           "indices" : [
              3,
              14
           ],
           "id" : 249395206,
           "name" : "Caleb Wilde",
           "screen_name" : "CalebWilde"
        }
     ],
     "hashtags" : [],
     "urls" : [],
     "symbols" : []
  },
  "retweeted_status" : {
     "id" : 401535817585131520,
     "retweeted" : false,
     "truncated" : false,
     "contributors" : null,
     "coordinates" : null,
     "geo" : null,
     "lang" : "en",
     "source" : "<a href=\"http://twitter.com\" rel=\"nofollow\">Twitter Web Client</a>",
     "in_reply_to_user_id" : null,
     "text" : "As a mortician, I always tie the shoelaces together of the dead. Cause if there is ever a zombie apocalypse, it will be hilarious.",
     "favorite_count" : 3651,
     "is_quote_status" : false,
     "in_reply_to_user_id_str" : null,
     "in_reply_to_status_id_str" : null,
     "in_reply_to_status_id" : null,
     "created_at" : "Sat Nov 16 02:22:53 +0000 2013",
     "entities" : {
        "urls" : [],
        "hashtags" : [],
        "user_mentions" : [],
        "symbols" : []
     },
     "in_reply_to_screen_name" : null,
     "id_str" : "401535817585131520",
     "place" : null,
     "favorited" : false,
     "user" : {
        "followers_count" : 20454,
        "id" : 249395206,
        "profile_use_background_image" : true,
        "profile_background_tile" : false,
        "profile_background_color" : "131516",
        "profile_text_color" : "333333",
        "follow_request_sent" : false,
        "protected" : false,
        "notifications" : false,
        "contributors_enabled" : false,
        "profile_background_image_url" : "http://pbs.twimg.com/profile_background_images/378800000137506721/9Puh5CBm.jpeg",
        "name" : "Caleb Wilde",
        "is_translation_enabled" : false,
        "default_profile" : false,
        "url" : "https://t.co/zVVOKRYk6l",
        "description" : "Funeral director. Blogger. I'm the last person to let you down in Parkesburg, PA.",
        "profile_link_color" : "009999",
        "profile_image_url" : "http://pbs.twimg.com/profile_images/770806658901549056/-1M2frs8_normal.jpg",
        "verified" : false,
        "time_zone" : "Eastern Time (US & Canada)",
        "statuses_count" : 5305,
        "location" : "Parkesburg, PA",
        "is_translator" : false,
        "friends_count" : 4038,
        "default_profile_image" : false,
        "screen_name" : "CalebWilde",
        "profile_sidebar_fill_color" : "EFEFEF",
        "lang" : "en",
        "favourites_count" : 612,
        "profile_background_image_url_https" : "https://pbs.twimg.com/profile_background_images/378800000137506721/9Puh5CBm.jpeg",
        "profile_sidebar_border_color" : "FFFFFF",
        "profile_banner_url" : "https://pbs.twimg.com/profile_banners/249395206/1398886547",
        "entities" : {
           "url" : {
              "urls" : [
                 {
                    "display_url" : "calebwilde.com",
                    "url" : "https://t.co/zVVOKRYk6l",
                    "expanded_url" : "http://www.calebwilde.com",
                    "indices" : [
                       0,
                       23
                    ]
                 }
              ]
           },
           "description" : {
              "urls" : []
           }
        },
        "created_at" : "Tue Feb 08 23:39:38 +0000 2011",
        "has_extended_profile" : false,
        "geo_enabled" : true,
        "following" : false,
        "id_str" : "249395206",
        "profile_image_url_https" : "https://pbs.twimg.com/profile_images/770806658901549056/-1M2frs8_normal.jpg",
        "utc_offset" : -14400,
        "listed_count" : 361
     },
     "retweet_count" : 6479
  },
  "in_reply_to_status_id" : null,
  "lang" : "en",
  "geo" : null,
  "favorite_count" : 0,
  "in_reply_to_user_id" : null,
  "text" : "RT @CalebWilde: As a mortician, I always tie the shoelaces together of the dead. Cause if there is ever a zombie apocalypse, it will be hil…",
  "source" : "<a href=\"https://about.twitter.com/products/tweetdeck\" rel=\"nofollow\">TweetDeck</a>",
  "truncated" : false,
  "retweeted" : false,
  "id" : 774602173833416704,
  "coordinates" : null,
  "contributors" : null
}
|;

$o = App::Socialdump::Status->from_twitter(decode_json $pure_retweet);
ok $o->isa('App::Socialdump::Status');
ok !$o->oc;

done_testing;
