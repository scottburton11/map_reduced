module MapReduced
  class Config
    class << self

      attr_writer :template_path
      
      def database=(string)
        begin
          if string.match /^.+\:\/\/.+/
            uri = URI.parse(string)
            connection = Mongo::Connection.new(uri.host, uri.port)
            database = uri.path.gsub(/^\//, "")
            connection.add_auth(database, uri.user, uri.password)
            connection.apply_saved_authentication
            @db = connection.db(database)
          else
            @db = Mongo::Connection.new.db(string)
          end
        rescue Mongo::ConnectionFailure => e
          raise Mongo::ConnectionFailure, "#{e}\nIt is possible that your database string is badly formed.\nIt should either be a database name (for localhost connections), or a fully-formed remote connection like mongodb://user:pass@host:port/database"
        end
        
      end
      
      def db
        warn "Tell MapReduced which database to use, like this:\nMapReduced::Config.database = 'my_awesome_database'" unless defined? @db
        @db
      end
      
      def template_path
        return @template_path if defined?(@template_path)
        defined?(Rails) ? Rails.root + "app/functions" : Pathname.new(File.expand_path("./functions"))
      end
      
    end
  end
end