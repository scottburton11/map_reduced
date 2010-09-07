module MapReduced
  module Document
    module ClassMethods
      attr_reader :receiver_binding
      def map_reduce(*names)
        names.each do |name|
          self.class_eval %Q{            
            def self.run_#{name}(opts = {})
              begin
                setup_functions
                collection.map_reduce(map("#{name}"), reduce("#{name}"), opts)
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

      def collection_name=(name)
        @collection_name = name
      end
      
      def use_functions(*names)
        @added_functions = names
      end

      private

      def added_functions
        @added_functions ||= []
      end

      def collection_name
        @collection_name ||= "#{self.to_s.downcase}s"
      end
      
      def map(function)
        function_string("#{function}_map")
      end

      def reduce(function)
        function_string("#{function}_reduce")
      end

      def setup_functions
        added_functions.each do |function_name|
          db.add_stored_function(function_name.to_s, function_string(function_name))
        end
      end

      def teardown_functions
        added_functions.each {|name| db.remove_stored_function(name.to_s)}
      end

      def function_string(name)
        template = File.read(path_to_function(name)).gsub(/[\n\t\s]+/, " ")
        ERB.new(template).result(receiver_binding)
      end

      def path_to_function(function)
        MapReduced::Config.template_path.to_s + "/#{self.name.split('::').last.underscore}/#{function}.js.erb"
      end
    end

    module InstanceMethods

    end

    def self.included(receiver)
      receiver.extend         ClassMethods
      receiver.send :include, InstanceMethods
      receiver.instance_variable_set(:@receiver_binding, receiver.send(:binding))
    end
  end
end