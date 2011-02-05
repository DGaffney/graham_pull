$settings = {"host" => "deebee.yourdefaulthomepage.com", "username" => "gonkclub", "password" => "cakebread", "database" => "140kit"}
class Database
  require "mysql"
  require "site_data"
  require "sql_parser"

  def self.spooled_result(query)
    puts query
    connection = Mysql.real_connect($settings["host"], $settings["username"], $settings["password"], $settings["database"])
    connection.query_with_result = false
    sync = connection.real_query(query)
    return sync.use_result
  end
  
  def self.terminate_spooling
    connection = Mysql.real_connect($settings["host"], $settings["username"], $settings["password"], $settings["database"])
    connection.query_with_result = true
  end
end
