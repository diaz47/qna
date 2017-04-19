shared_examples_for 'Api authenticable' do
  context 'unauthorized' do
    it 'return status 401 if call without access_token' do
      do_request
      expect(response.status).to eq 401
    end
    it 'return status 401 if call with wrong access_token' do
      do_request(access_token: '123342342')
      expect(response.status).to eq 401
    end
  end

  context 'authorized' do
    it 'return success status' do
      do_request(access_token: access_token.token)
      expect(response).to be_success
    end
  end
end