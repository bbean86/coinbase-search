shared_examples 'a searchable index' do |endpoint|
  it 'handles an invalid limit parameter' do
    get endpoint, { headers: { Accept: 'application/json' }, params: { limit: -1 } }

    expect(response.status).to eql(422)
    expect(JSON.parse(response.body)).to eql({ 'message' => 'Limit must be greater than 0' })
  end

  it 'handles an invalid sort parameter' do
    get endpoint, { headers: { Accept: 'application/json' }, params: { sort: 'invalid' } }

    expect(response.status).to eql(422)
    expect(JSON.parse(response.body)).to eql({ 'message' => 'Sort is not included in the list' })
  end

  it 'handles a non-Base64 encoded cursor parameter' do
    get endpoint, { headers: { Accept: 'application/json' }, params: { cursor: 'invalid' } }

    expect(response.status).to eql(422)
    expect(JSON.parse(response.body)).to eql({ 'message' => 'Cursor must be Base64 encoded' })
  end

  it 'handles a malformed cursor parameter' do
    get endpoint, { headers: { Accept: 'application/json' }, params: { cursor: Base64.strict_encode64('invalid') } }

    expect(response.status).to eql(422)
    expect(JSON.parse(response.body)).to eql({ 'message' => 'Cursor must start with `before__` or `after__` when decoded' })
  end
end
