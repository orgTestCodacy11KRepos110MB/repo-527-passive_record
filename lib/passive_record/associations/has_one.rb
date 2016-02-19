module PassiveRecord
  module Associations
    class HasOneAssociation < Struct.new(:parent_class, :child_class_name, :child_name_sym)

      def to_relation(parent_model)
        HasOneRelation.new(self, parent_model)
      end

      def target_name_symbol
        child_name_sym
      end
    end

    class HasOneRelation < Struct.new(:association, :parent_model)
      def lookup
        child_class.find_by(parent_model_id_field => parent_model.id)
      end

      def create(*args)
        model = child_class.create(*args)
        model.send(parent_model_id_field + "=", parent_model.id)
        model
      end

      def parent_model_id_field
        parent_class_name + "_id"
      end

      def parent_class_name
        association.parent_class.name.underscore
      end

      def child_class
        Object.const_get(association.child_class_name.singularize)
      end
    end
  end
end
