module MapReduced
  class Config
    class << self

      attr_writer :template_path
      
      def database=(string)
        @db = Mongo::Connection.new.db(string)
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