module MapReduced
  class Config
    class << self
      
      attr_reader :db
      
      def database(string)
        @db = Mongo::Connection.new.db(string)
      end
      
      def template_path
        defined?(Rails) ? Rails.root + "app/functions" : Pathname.new(File.expand_path("./functions"))
      end
      
    end
  end
end