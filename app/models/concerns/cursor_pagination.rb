module CursorPagination
  extend ActiveSupport::Concern

  included do |klass|
    raise 'Must be included in ApplicationRecord class' unless klass.ancestors.include?(ApplicationRecord)

    klass.extend ClassMethods
  end

  module ClassMethods
    # Exposes cursor pagination for a given field via the .paginated method
    def paginate_on(field)
      scope :paginated, lambda { |cursor|
                          return unless cursor.present?

                          direction, value = Base64.decode64(cursor).split('__')

                          operators = {
                            'after' => '>',
                            'before' => '<'
                          }

                          where("#{field} #{operators[direction]} '#{block_given? ? yield(value) : value}'")
                        }
    end
  end
end
