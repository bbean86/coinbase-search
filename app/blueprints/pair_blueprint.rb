class PairBlueprint < Blueprinter::Base
  identifier :symbols

  fields :status

  field :base_currency do |pair|
    pair.base_currency&.name
  end

  field :quote_currency do |pair|
    pair.quote_currency&.name
  end
end
