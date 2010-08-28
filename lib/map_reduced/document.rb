module MapReduced
  module Document
    module ClassMethods

      def map_reduce(*names)
        names.each do |name|
          self.class_eval %Q{            
            def self.run_#{name}
              begin
                setup_functions
                collection.map_reduce(map("#{name}"), reduce("#{name}"))
              ensure
                teardown_functions
              end
            end
          }
        end
      end
      
      def db
        MapReduced::Config.db
      end

      def collection
        db.collection(collection_name)
      end

      private

      def collection_name
        "#{self.to_s.downcase}s"
      end
      
      def collection_name=(name)
        @@collection_name = name
      end
      
      def map(function)
        function_string("#{function}_map")
      end

      def reduce(function)
        function_string("#{function}_reduce")
      end

      def functions(*names)
        @@functions = names
      end

      def setup_functions
        @@functions.each do |function_name|
          db.add_stored_function(function_name.to_s, function_string(function_name))
        end
      end

      def teardown_functions
        @@functions.each {|name| db.remove_stored_function(name.to_s)}
      end

      def function_string(name)
        template = File.read(path_to_function(name)).gsub(/[\n\t\s]+/, " ")
        ERB.new(template).result(binding)
      end

      def path_to_function(function)
        MapReduced::Config.template_path.to_s + "/#{self.name.split('::').last.underscore}/#{function}.js.erb"
      end
    end

    module InstanceMethods

    end

    def self.included(receiver)
      receiver.class_eval %Q{
        @@functions = []
      }
      receiver.extend         ClassMethods
      receiver.send :include, InstanceMethods
    end
  end
end