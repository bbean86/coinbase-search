class ExecuteSearch
  def self.call(params)
    instance = new(params)
    instance.execute
  end

  def initialize(params); end

  def execute
    {
      data: [],
      cursor: {}
    }
  end
end
