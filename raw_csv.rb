require 'rubygems'
require 'extensions'
require 'database'
def raw_csv(conditional)
  require 'fastercsv'
  `mkdir datasets`
  tweet_query = "select screen_name,location,language,lat,in_reply_to_status_id,created_at,lon,in_reply_to_user_id,text,source,favorited,twitter_id,truncated,user_id,in_reply_to_screen_name from tweets "
  user_query = "select profile_background_image_url,screen_name,location,profile_image_url,utc_offset,contributors_enabled,profile_sidebar_fill_color,url,profile_background_tile,profile_sidebar_border_color,created_at,followers_count,notifications,friends_count,protected,description,geo_enabled,profile_background_color,twitter_id,favourites_count,following,profile_text_color,verified,name,lang,time_zone,statuses_count,profile_link_color from users "
  spool_dataset_to_csv(tweet_query, "tweets.csv")
  spool_dataset_to_csv(user_query, "users.csv")
end

def spool_dataset_to_csv(query, filename, path='datasets')
  objects = Database.spooled_result(query)
  first_result = objects.fetch_hash
  keys, values = first_result.keys, first_result.values
  num = 1
  FasterCSV.open(path+filename, "w") do |csv|
    csv << keys
    csv << values
    while row = objects.fetch_hash do
      num+=1
      csv << keys.collect{|key| row[key].to_s}
    end
    objects.free
  end
  Database.terminate_spooling
end